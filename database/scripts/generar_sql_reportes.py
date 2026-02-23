import pandas as pd
import math
from pathlib import Path
from datetime import datetime, date

# Ruta relativa al directorio del script (funciona en Windows y Linux)
SCRIPT_DIR = Path(__file__).resolve().parent
EXCEL_PATH = SCRIPT_DIR / "database.xlsx"
OUTPUT_SQL = SCRIPT_DIR / "migration_reportes_ods.sql"

# Config: ajusta si tu tabla users usa otro campo (ej: corporate_email)
USERS_EMAIL_FIELD = "email"  # users.email

# -------------- Helpers --------------

def is_nan(x):
    return x is None or (isinstance(x, float) and math.isnan(x))

def normalize_str(x):
    if is_nan(x):
        return None
    s = str(x).strip()
    return s if s != "" else None

def normalize_date(x):
    """
    Devuelve 'YYYY-MM-DD' o None.
    Soporta datetime/date, pandas Timestamp, NaT, strings.
    """
    if is_nan(x) or pd.isna(x):
        return None
    try:
        ts = pd.to_datetime(x, errors="coerce")
        if pd.isna(ts):
            return None
        return ts.strftime("%Y-%m-%d")
    except Exception:
        return None

def sql_literal(val):
    """
    Convierte Python -> literal SQL seguro (básico).
    """
    if val is None or is_nan(val):
        return "NULL"
    if isinstance(val, bool):
        return "1" if val else "0"
    if isinstance(val, (int, float)):
        if isinstance(val, float) and (math.isnan(val) or math.isinf(val)):
            return "NULL"
        # evita .0 innecesario si es entero
        if isinstance(val, float) and val.is_integer():
            return str(int(val))
        return str(val)
    if isinstance(val, (datetime, date)):
        return f"'{val.strftime('%Y-%m-%d')}'"
    s = str(val)
    s = s.replace("\\", "\\\\").replace("'", "''")
    return f"'{s}'"

def sql_comment(text):
    if text is None:
        return ""
    s = str(text).replace("\n", " ").replace("\r", " ")
    return f"-- {s}\n"


# -------------- Main --------------

def generate_sql_from_employees(excel_path: str, output_sql: str):
    # Lee la primera hoja (en tu archivo viene como "database" usualmente)
    df = pd.read_excel(excel_path)

    # Normaliza nombres de columnas (por si hay espacios)
    df.columns = [c.strip() for c in df.columns]

    required = [
        "Id", "Nombre", "Proyecto", "Cargo", "Fecha_contrato", "Contrato",
        "Telefono", "Correo_corporativo", "Profesion",
        "Ods", "Objeto_ods", "Plazo_ods", "Terminacion_contrato"
    ]
    missing = [c for c in required if c not in df.columns]
    if missing:
        raise ValueError(f"Faltan columnas en el Excel: {missing}")

    lines = []
    lines.append("-- =========================================================\n")
    lines.append("-- Migración generada desde database.xlsx\n")
    lines.append("-- Compatible con reportes_ods.sql (reports.is_active, task_report_links, tasks, índices)\n")
    lines.append("-- Pobla: users (email), service_orders, employee_profiles, service_order_employees.\n")
    lines.append("-- Ejecutar en la BD reportes_ods (estructura creada con reportes_ods.sql).\n")
    lines.append("-- =========================================================\n\n")

    lines.append("USE reportes_ods;\n\n")

    # Transacción para atomicidad
    lines.append("START TRANSACTION;\n\n")
    lines.append("SET @NOW := CURRENT_TIMESTAMP;\n\n")

    # 1) UPSERT ODS (service_orders)
    # Tomamos ODS únicos por código
    ods_rows = (
        df[["Ods", "Proyecto", "Objeto_ods", "Plazo_ods"]]
        .copy()
    )
    ods_rows["Ods"] = ods_rows["Ods"].apply(normalize_str)
    ods_rows = ods_rows[ods_rows["Ods"].notna()].drop_duplicates(subset=["Ods"])

    lines.append("-- =========================================================\n")
    lines.append("-- 1) service_orders (ODS)\n")
    lines.append("-- =========================================================\n\n")

    for _, r in ods_rows.iterrows():
        ods_code = normalize_str(r["Ods"])
        project_name = normalize_str(r["Proyecto"])
        object_text = normalize_str(r["Objeto_ods"])
        term_text = normalize_str(r["Plazo_ods"])

        # UPSERT por uq_service_orders_ods(ods_code)
        stmt = f"""
INSERT INTO service_orders (ods_code, project_name, object_text, term_text, status, created_at, updated_at)
VALUES ({sql_literal(ods_code)}, {sql_literal(project_name)}, {sql_literal(object_text)}, {sql_literal(term_text)},
        'Activa', @NOW, @NOW)
ON DUPLICATE KEY UPDATE
  project_name = VALUES(project_name),
  object_text  = VALUES(object_text),
  term_text    = VALUES(term_text),
  updated_at   = @NOW;
""".strip() + "\n\n"
        lines.append(stmt)

    # 1.5) Asegurar que existan usuarios en users (por email) para poder enlazar employee_profiles
    lines.append("-- =========================================================\n")
    lines.append("-- 1.5) users (correos del Excel; se insertan si no existen)\n")
    lines.append("--    Necesario para que employee_profiles y service_order_employees encuentren user_id.\n")
    lines.append("-- =========================================================\n\n")
    distinct_emails = df["Correo_corporativo"].dropna().map(lambda x: normalize_str(x)).dropna().unique()
    for corporate_email in distinct_emails:
        if corporate_email is None:
            continue
        lines.append(f"INSERT IGNORE INTO users (email) VALUES ({sql_literal(corporate_email)});\n")
    lines.append("\n")

    # 2) employee_profiles (perfil)
    lines.append("-- =========================================================\n")
    lines.append("-- 2) employee_profiles (perfil de empleado)\n")
    lines.append("--    Inserta usando users.email como llave. Si el usuario no existe, NO insertará.\n")
    lines.append("-- =========================================================\n\n")

    for _, r in df.iterrows():
        external_id = normalize_str(r["Id"])
        full_name = normalize_str(r["Nombre"])
        corporate_email = normalize_str(r["Correo_corporativo"])
        phone = normalize_str(r["Telefono"])
        profession = normalize_str(r["Profesion"])
        job_title = normalize_str(r["Cargo"])
        contract_type = normalize_str(r["Contrato"])
        hire_date = normalize_date(r["Fecha_contrato"])
        contract_end_date = normalize_date(r["Terminacion_contrato"])

        if corporate_email is None or full_name is None:
            continue

        # Usamos INSERT...SELECT para obtener user_id
        stmt = f"""
{sql_comment(f"Empleado: {full_name} | Email: {corporate_email}")}
INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  {sql_literal(external_id)},
  {sql_literal(full_name)},
  {sql_literal(corporate_email)},
  {sql_literal(phone)},
  {sql_literal(profession)},
  {sql_literal(job_title)},
  {sql_literal(contract_type)},
  {sql_literal(hire_date)},
  {sql_literal(contract_end_date)},
  @NOW, @NOW
FROM users u
WHERE u.{USERS_EMAIL_FIELD} = {sql_literal(corporate_email)}
ON DUPLICATE KEY UPDATE
  external_employee_id = VALUES(external_employee_id),
  full_name            = VALUES(full_name),
  phone                = VALUES(phone),
  profession           = VALUES(profession),
  job_title            = VALUES(job_title),
  contract_type        = VALUES(contract_type),
  hire_date            = VALUES(hire_date),
  contract_end_date    = VALUES(contract_end_date),
  updated_at           = @NOW;
""".strip() + "\n\n"
        lines.append(stmt)

    # 3) Asignación ODS ↔ Empleado
    lines.append("-- =========================================================\n")
    lines.append("-- 3) service_order_employees (asignación empleado ↔ ODS)\n")
    lines.append("--    Inserta por ODS (service_orders.ods_code) y user por email.\n")
    lines.append("-- =========================================================\n\n")

    for _, r in df.iterrows():
        ods_code = normalize_str(r["Ods"])
        corporate_email = normalize_str(r["Correo_corporativo"])
        full_name = normalize_str(r["Nombre"])

        if ods_code is None or corporate_email is None:
            continue

        stmt = f"""
{sql_comment(f"Asignación: {full_name} | {corporate_email} -> ODS {ods_code}")}
INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.{USERS_EMAIL_FIELD} = {sql_literal(corporate_email)}
WHERE so.ods_code = {sql_literal(ods_code)}
ON DUPLICATE KEY UPDATE
  is_active = 1;
""".strip() + "\n\n"
        lines.append(stmt)

    lines.append("COMMIT;\n")

    with open(output_sql, "w", encoding="utf-8") as f:
        f.writelines(lines)

    print(f"✅ Migración generada: {output_sql}")
    print("Siguiente paso: ejecuta el archivo en phpMyAdmin (pestaña SQL). Asegúrate de tener la estructura con reportes_ods.sql.")


if __name__ == "__main__":
    generate_sql_from_employees(EXCEL_PATH, OUTPUT_SQL)