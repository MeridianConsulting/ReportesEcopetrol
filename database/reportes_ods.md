# Base de Datos: **reportes_ods** (MySQL/MariaDB)

Este documento describe la estructura y el uso de la base de datos **reportes_ods**, pensada para un sistema web de **gestión de reportes de avance** por **ODS** (Orden de Servicio), con RBAC, actividades, evidencias, revisiones y auditoría.

> **Objetivo:** permitir que cada profesional registre su reporte mensual (cabecera + actividades), adjunte evidencias, pase por revisión/aprobación y generar consolidados por ODS, periodo y profesional. El control de acceso se basa en **roles/permisos** y en el **alcance por ODS** (`service_order_employees`).

**Esquema de creación:** `reportes_ods.sql` (o `database/base/reportes_ods.sql`). Carga inicial de datos desde Excel: script `generar_sql_reportes.py` → `migration_reportes_ods.sql`.

---

## 1) Alcance funcional (qué resuelve)

Con **reportes_ods** puedes:

- Gestionar **roles y permisos** (RBAC): colaborador, profesional_proyectos, interventoria, gerencia, admin.
- Registrar empleados (perfil extendido ligado a `users`) y **asignar rol por defecto** (ej. colaborador).
- Registrar ODS y **asociar profesionales a cada ODS** (scope de reportes).
- Crear reportes por **ODS + periodo + profesional** con **unicidad de reporte activo** (`is_active` + borrado lógico).
- Registrar actividades detalladas por reporte (ítems, descripción, días, **avance 0..1**, acumulados).
- **Vincular tareas con líneas de reporte** (`task_report_links`) para trazabilidad.
- Adjuntar evidencias (archivos) al reporte o a una actividad.
- Manejar revisión/aprobación (workflow) con comentarios y estados.
- Mantener auditoría de eventos (bitácora).
- Importar datos desde Excel con control de lotes y errores.

---

## 2) Conceptos principales (modelo mental)

### 2.1 Tablas de apoyo (stubs)
- **users**: en este esquema mínimo tiene `id` y `email` (para enlace con correo corporativo). En un sistema real puede vivir en otra BD o ampliarse (password_hash, is_active, created_at, etc.).
- **areas**: stub con `id` (para FK de `service_orders`). En sistema real: name, code, type.
- **tasks**: stub con `id` (para `task_report_links`). En sistema real: title, status, responsible_id, fechas.

> Si `users`, `areas` o `tasks` viven en otra BD (ej. sistema de tareas), no duplicar: referenciar las reales o unificar en un solo esquema.

### 2.2 RBAC (roles y permisos)
- **roles**: colaborador, profesional_proyectos, interventoria, gerencia, admin.
- **permissions**: códigos (REPORT_CREATE, REPORT_VIEW_OWN, REPORT_VIEW_ALL, REPORT_APPROVE, REPORT_EXPORT, ODS_MANAGE, etc.).
- **role_permissions**: qué permiso tiene cada rol.
- **user_roles**: qué roles tiene cada usuario (N:M).

El **alcance por ODS** no va en roles sino en **service_order_employees**: un colaborador solo puede crear/ver reportes de ODS donde esté asignado. Interventoria/gerencia/profesional_proyectos “ven todo” (según permisos).

### 2.3 Empleado / Usuario
- **employee_profiles**: información laboral (cargo, profesión, teléfono, fechas de contrato) ligada a `users.id`.

### 2.4 ODS (Orden de Servicio)
- **service_orders**: cabecera del ODS (código, proyecto, objeto, plazo, estado).
- **service_order_employees**: asignación usuario ↔ ODS (N:M). Define **qué ODS puede reportar cada usuario** (scope).

**Regla en backend:** un colaborador solo puede crear reporte si existe fila activa (`is_active = 1`) en `service_order_employees` para ese `user_id` y ese `service_order_id`.

### 2.5 Periodo y Reporte
- **report_periods**: periodos (ej. 2026-01) con fechas inicio/fin.
- **reports**: cabecera (ODS, periodo, profesional, fecha, estado, **is_active**, deleted_at).
- Unicidad de reporte activo: **UNIQUE(service_order_id, period_id, reported_by, is_active)**. Al borrar de forma lógica se pone `is_active = 0` y `deleted_at = NOW()`.

### 2.6 Actividades e ítems
- **report_item_catalog**: catálogo de ítems (item_general, item_activity, title).
- **report_lines**: actividades del reporte; **progress_percent** en escala **0..1** (ej. 0.25 = 25%); en frontend mostrar ×100.

### 2.7 Tareas ↔ Reportes
- **task_report_links**: tabla puente (task_id, report_line_id, linked_by). Permite “esta tarea quedó soportada en el reporte de Enero” e indicadores tipo % tareas reportadas.

### 2.8 Evidencias y revisión
- **report_attachments**, **report_comments**, **report_approvals**, **report_events** (auditoría).

---

## 3) Tablas y propósito (resumen)

### 3.1 Tablas de apoyo (stubs)
| Tabla    | Uso en reportes_ods |
|----------|----------------------|
| users    | id, email (enlace con employee_profiles y user_roles) |
| areas    | id (FK en service_orders) |
| tasks    | id (FK en task_report_links) |

### 3.2 RBAC
| Tabla             | Propósito |
|-------------------|-----------|
| roles             | colaborador, profesional_proyectos, interventoria, gerencia, admin |
| permissions       | REPORT_CREATE, REPORT_EDIT_OWN, REPORT_VIEW_OWN, REPORT_VIEW_ALL, REPORT_APPROVE, REPORT_EXPORT, ODS_MANAGE |
| role_permissions  | Asignación rol → permisos |
| user_roles        | Asignación usuario → roles |

### 3.3 Catálogos
- **employee_levels**, **service_classifications**, **delivery_media**, **support_types**

### 3.4 Empleados y ODS
- **employee_profiles** (user_id, datos laborales).
- **service_orders** (ODS maestro; area_id opcional).
- **service_order_employees** (scope: qué usuario puede reportar qué ODS; is_active).

### 3.5 Reportes
- **report_periods**, **reports** (con is_active, uq_reports_active), **report_item_catalog**, **report_lines** (progress_percent 0..1, idx report_id+item_activity).
- **task_report_links** (task_id, report_line_id, linked_by).

### 3.6 Evidencias y workflow
- **report_attachments**, **report_comments**, **report_approvals**, **report_events**.

### 3.7 Importación
- **import_batches**, **import_errors**.

---

## 4) Flujos operativos típicos

### 4.1 Alta de ODS y asignación de personal
1. Admin crea `service_orders`.
2. Admin asigna profesionales en `service_order_employees` (is_active = 1).
3. El backend habilita “crear reporte” solo si el usuario tiene rol con REPORT_CREATE y existe asignación activa a ese ODS.

### 4.2 Creación y envío de reporte mensual
1. Profesional (colaborador) crea `reports` en estado Borrador (solo para ODS donde está en `service_order_employees`).
2. Ingresa actividades en `report_lines` (avance en 0..1).
3. Opcional: vincula tareas en `task_report_links`.
4. Adjunta evidencias en `report_attachments`.
5. Envía: status → Enviado, registro en `report_events`.

### 4.3 Revisión y aprobación
1. Interventor/revisor comenta en `report_comments`.
2. Registra decisión en `report_approvals`.
3. Se actualiza `reports.status` a Aprobado/Rechazado y se registra en `report_events`.

### 4.4 Consolidados
- Por ODS/mes: usar índice `reports(service_order_id, period_id, status)` y `report_lines(report_id, item_activity)`.
- Totales: `SUM(report_lines.days_month)`, avance ponderado según `progress_percent` (0..1).

---

## 5) Integridad, rendimiento y seguridad

### 5.1 Integridad referencial
- FKs entre reportes, ODS, periodos, usuarios, roles, tareas y líneas de reporte.
- Unicidad: uq_reports_active, uq_task_report_line, uq_service_orders_ods, etc.

### 5.2 Índices clave
- **reports**: idx_reports_so_period_status (service_order_id, period_id, status) para dashboards.
- **report_lines**: idx_report_lines_report_item (report_id, item_activity) para filtros por ítem.
- Índices por report_id, period_id, reported_by, status, deleted_at.

### 5.3 Borrado lógico en reportes
- `reports.is_active = 0` y `reports.deleted_at = NOW()` para “eliminar” sin perder auditoría.
- Unicidad con `is_active` evita múltiples reportes activos por (ODS, periodo, usuario).

### 5.4 Control de acceso (en backend)
- **Colaborador:** solo reportes propios y solo en ODS donde existe `service_order_employees` activo.
- **Profesional_proyectos / Interventoria / Gerencia:** según permisos (REPORT_VIEW_ALL, REPORT_APPROVE, REPORT_EXPORT).
- **Admin:** ODS_MANAGE, REPORT_*, etc.
- La BD almacena roles/permisos; la aplicación aplica las reglas.

### 5.5 Alcance opcional futuro
Si se necesita “ver solo ciertos ODS por rol/usuario”, se pueden añadir tablas como **role_service_orders** o **user_service_orders_view**. Con el RBAC actual (interventoria/gerencia/profesional_proyectos ven todo) no es necesario.

---

## 6) Reglas recomendadas (estándar)

1. **Un reporte activo por (ODS, periodo, profesional):** garantizado por `uq_reports_active` e `is_active`.
2. **Avance en BD en escala 0..1** (`report_lines.progress_percent`); en frontend mostrar ×100.
3. **Colaborador solo crea reporte** si existe fila activa en `service_order_employees` para ese usuario y ese ODS.
4. **Catalogar ítems** con `report_item_catalog` cuando aplique.
5. **Evidencias** preferiblemente asociadas a actividad (`report_line_id`) cuando sea posible.

---

## 7) Resumen de módulos

| Módulo           | Tablas |
|------------------|--------|
| Stubs            | users, areas, tasks |
| RBAC             | roles, permissions, role_permissions, user_roles |
| Catálogos        | employee_levels, service_classifications, delivery_media, support_types |
| Empleados        | employee_profiles |
| ODS y scope      | service_orders, service_order_employees |
| Reportes         | report_periods, reports, report_lines, report_item_catalog |
| Tareas ↔ reportes| task_report_links |
| Evidencias/workflow | report_attachments, report_comments, report_approvals, report_events |
| Importación      | import_batches, import_errors |

---

## 8) Dependencias externas y scripts

- **Esquema:** crear la BD y tablas con `reportes_ods.sql` (en `database/` o `database/base/`). Ejecutable en phpMyAdmin (pestaña SQL) sin cambios.
- **Datos iniciales desde Excel:** ejecutar `generar_sql_reportes.py` (requiere `database.xlsx`) para generar `migration_reportes_ods.sql`, que inserta usuarios (email), asigna rol colaborador por defecto, ODS, perfiles y asignaciones. Ejecutar la migración en la BD `reportes_ods` después de crear la estructura.
- Si las tablas **users**, **areas** o **tasks** reales viven en otro esquema, unificar referencias o usar el mismo esquema para evitar duplicar datos.
