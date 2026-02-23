# Base de Datos: **reportes_ods** (MySQL/MariaDB)

Este documento describe el funcionamiento y la estructura de la base de datos **reportes_ods**, diseñada para soportar un sistema web de **gestión de reportes de avance** por **ODS** (Orden de Servicio), con actividades, evidencias, revisiones y auditoría.

> **Objetivo:** permitir que cada profesional registre su reporte mensual (cabecera + actividades), adjunte evidencias, pase por revisión/aprobación y genere consolidados por ODS, por periodo y por profesional.

---

## 1) Alcance funcional (qué resuelve)

Con **reportes_ods** puedes:

- Registrar empleados (perfil extendido ligado a usuarios del sistema).
- Registrar ODS (órdenes de servicio) y asociar profesionales a cada ODS.
- Crear reportes por **ODS + periodo + profesional**.
- Registrar actividades detalladas por reporte (ítems, descripción, días, avance, acumulados).
- Adjuntar evidencias (archivos) al reporte o a una actividad específica.
- Manejar revisión/aprobación (workflow) con comentarios y estados.
- Mantener auditoría de eventos (bitácora).
- Importar datos desde Excel con control de lotes y errores.

---

## 2) Conceptos principales (modelo mental)

### 2.1 Empleado / Usuario
- **users**: tabla existente del sistema (login/rol). Esta BD **referencia** `users.id`.
- **employee_profiles**: información laboral (cargo, profesión, teléfono, fechas de contrato).

> Un usuario puede existir sin perfil, pero un perfil siempre pertenece a un usuario.

### 2.2 ODS (Orden de Servicio)
- **service_orders**: cabecera del ODS (código ODS, proyecto, objeto, plazo, fechas, estado).
- **service_order_employees**: asignación de profesionales a un ODS (N:M) con nivel y días contratados.

> Un ODS puede tener varios profesionales y un profesional puede participar en varios ODS.

### 2.3 Periodo y Reporte
- **report_periods**: periodos (ej. 2026-01) con fechas inicio/fin.
- **reports**: cabecera del reporte (ODS, periodo, profesional, fecha de reporte, estado).
- **report_lines**: detalle del reporte (actividades).

> La regla típica de negocio es: **1 reporte por ODS + periodo + profesional** (salvo que el sistema permita duplicados usando borrado lógico).

### 2.4 Actividades e Ítems
- **report_item_catalog** (recomendado): catálogo oficial de ítems (ej: 1 / 1.1 / 1.15).
- **report_lines**: guarda actividades; opcionalmente referencia al catálogo.

> Esto ayuda a estandarizar los reportes y que el consolidado sea consistente.

### 2.5 Evidencias y revisión
- **report_attachments**: adjuntos del reporte o de una actividad específica.
- **report_comments**: comentarios por reporte o por actividad.
- **report_approvals**: decisiones de aprobación por usuario revisor.
- **report_events**: auditoría de eventos (creación, edición, envío, aprobación, rechazo, importación).

---

## 3) Tablas y propósito

### 3.1 Catálogos (parametrización)
- **employee_levels**
  - Niveles contratados (Junior/Senior/etc.)
- **service_classifications**
  - Clasificación del servicio del reporte (según tu formato).
- **delivery_media**
  - Medio de entrega (Digital, Físico, Link, etc.)
- **support_types**
  - Tipo de soporte (Informe, Código, Presentación, etc.)

**Beneficio:** evitan valores inconsistentes en texto libre y facilitan filtros/reportes.

---

### 3.2 Empleados
- **employee_profiles**
  - `user_id` (PK, FK a `users.id`)
  - Datos de empleado: nombre, correo corporativo, teléfono, cargo, profesión, tipo contrato, fechas.

**Uso típico:**
- Al crear el usuario en el sistema, se crea/actualiza también el perfil.
- El módulo de reportes muestra automáticamente los datos del profesional.

---

### 3.3 ODS
- **service_orders**
  - Registro maestro del ODS.
  - `ods_code` único.
  - Opcional: `area_id` (si lo integras con la tabla `areas` del sistema).

- **service_order_employees**
  - Asigna profesionales a ODS.
  - Puede almacenar `contracted_days` por profesional y estado activo.

**Uso típico:**
- Un admin crea el ODS.
- Asigna uno o varios profesionales al ODS.
- El sistema usa estas asignaciones para habilitar “crear reporte” y validar permisos.

---

### 3.4 Periodos y reportes
- **report_periods**
  - Control de periodos. Evita que cada reporte invente “mes/año” como texto.
  - Garantiza integridad de filtros (por año/mes).

- **reports**
  - Cabecera del reporte:
    - `service_order_id` (ODS)
    - `period_id` (mes)
    - `reported_by` (usuario/profesional)
    - `status` (workflow)
    - `deleted_at` (borrado lógico)
  - Índices para consulta rápida por ODS/periodo/usuario/estado.

**Estados sugeridos (por flujo):**
1. **Borrador**: el profesional edita.
2. **Enviado**: lo envía a revisión.
3. **En revision**: revisor(es) revisan.
4. **Aprobado** / **Rechazado**: decisión final.
5. **Anulado**: cancelado administrativamente.

---

### 3.5 Detalle del reporte (actividades)
- **report_item_catalog**
  - Catálogo de ítems para estandarizar.
  - Campos: `item_general`, `item_activity`, `title`, `is_active`.

- **report_lines**
  - Una fila por actividad reportada.
  - Campos clave:
    - `report_id` (FK)
    - `item_catalog_id` (opcional)
    - `activity_description`
    - `support_text` / `support_type_id`
    - `delivery_medium_id`
    - `days_month` (días del mes ejecutados)
    - `progress_percent` (avance: 0..1 o 0..100, según estándar)
    - `accumulated_days`, `accumulated_progress`
    - `sort_order` para mantener el orden del formato

**Notas de diseño:**
- Se guarda `item_general` y `item_activity` como respaldo para imports legacy.
- Se recomienda definir un estándar:
  - Avance en escala **0..1** (ej. 0.25 = 25%) **o** 0..100.
  - El backend valida y normaliza.

---

### 3.6 Evidencias (archivos)
- **report_attachments**
  - Adjuntos a nivel reporte o por actividad (`report_line_id` opcional).
  - Guarda metadatos: nombre, ruta, hash, tamaño, mime.

**Buenas prácticas:**
- Guardar archivos en storage (S3/MinIO/servidor) y en DB solo `storage_path`.
- Usar `sha256` para deduplicación y verificación.

---

### 3.7 Comentarios, aprobaciones y auditoría
- **report_comments**
  - Comentarios por reporte o por actividad.
  - Útil para revisión detallada.

- **report_approvals**
  - Tabla para decisiones por revisor.
  - Permite múltiples revisores por reporte.

- **report_events**
  - Bitácora de cambios:
    - `event_type` (CREATED/UPDATED/SUBMITTED/etc.)
    - `payload` JSON con detalles (antes/después, metadatos)
  - Útil para auditoría y cumplimiento.

---

### 3.8 Importación desde Excel
- **import_batches**
  - Control de cada importación: archivo origen, quién importó, resumen y estado.

- **import_errors**
  - Errores por lote: fila, mensaje y payload.

**Flujo recomendado de importación:**
1. Crear `import_batches` con estado **Procesando**.
2. Validar y cargar catálogos si aplica.
3. Insertar/actualizar ODS, asignaciones, reportes y líneas.
4. Registrar errores en `import_errors`.
5. Finalizar lote: **Exitoso** o **Con errores**.

---

## 4) Flujos operativos típicos

### 4.1 Alta de ODS y asignación de personal
1. Admin crea `service_orders`.
2. Admin asigna profesionales en `service_order_employees`.
3. El sistema habilita el acceso a reportar sobre ese ODS.

### 4.2 Creación y envío de reporte mensual
1. Profesional crea `reports` en estado **Borrador**.
2. Ingresa actividades en `report_lines`.
3. Adjunta evidencias en `report_attachments`.
4. Envía el reporte: cambia a **Enviado** y se registra evento en `report_events`.

### 4.3 Revisión y aprobación
1. Revisor comenta en `report_comments` (opcional).
2. Registra decisión en `report_approvals`.
3. El sistema actualiza `reports.status` a **Aprobado** o **Rechazado**.
4. Registra evento en `report_events`.

### 4.4 Consolidado por ODS
- El consolidado se obtiene consultando `reports` + `report_lines` por ODS y periodo.
- Se pueden generar:
  - Totales de días del mes: `SUM(report_lines.days_month)`
  - Avance promedio o ponderado (según regla definida)

---

## 5) Integridad, rendimiento y robustez

### 5.1 Integridad referencial (FK)
- Se usan claves foráneas para asegurar:
  - Reporte pertenece a ODS y periodo.
  - Actividades pertenecen a un reporte.
  - Evidencias pertenecen a reporte/actividad.
  - Asignaciones de personal pertenecen a ODS.

### 5.2 Índices clave
- Consultas más comunes:
  - Por `service_order_id`, `period_id`, `reported_by`, `status`.
  - Por `report_id` en líneas y adjuntos.
  - Por `event_type` y `created_at` en auditoría.

### 5.3 Borrado lógico
- `reports.deleted_at` permite “eliminar” sin perder auditoría.
- Las líneas se eliminan físicamente cuando se elimina el reporte (por `ON DELETE CASCADE`), pero esto puede ajustarse si quieres retención total.

### 5.4 Seguridad y permisos (a nivel app)
- La base soporta permisos por:
  - Asignación ODS-profesional (`service_order_employees`).
  - Roles del sistema (tabla `roles` existente en tu sistema).
- El backend debe validar:
  - Que el usuario esté asignado al ODS antes de crear/editar reportes.
  - Que solo revisores/admin puedan aprobar.

---

## 6) Reglas recomendadas (para estandarizar)

1. **Un reporte por ODS + periodo + profesional** (salvo borrado lógico).
2. Definir estándar de **avance**:
   - Recomendado: **0..1** en DB (`0.25`=25%).
3. Catalogar y bloquear ítems oficiales:
   - Usar `report_item_catalog` como fuente.
4. Evidencias:
   - Adjuntar a nivel actividad siempre que sea posible (`report_line_id`).

---

## 7) Resumen de módulos

- **Catálogos:** employee_levels, service_classifications, delivery_media, support_types
- **Empleados:** employee_profiles
- **ODS y asignación:** service_orders, service_order_employees
- **Reportes:** report_periods, reports, report_lines, report_item_catalog
- **Evidencias y workflow:** report_attachments, report_comments, report_approvals, report_events
- **Importación:** import_batches, import_errors

---

## 8) Dependencias externas
Esta base de datos se integra con tablas del sistema (existentes):
- `users` (usuarios del sistema)
- `areas` (áreas/proyectos)

> Si esas tablas viven en otro esquema, debes ajustar los FKs o manejarlo a nivel aplicación.

---