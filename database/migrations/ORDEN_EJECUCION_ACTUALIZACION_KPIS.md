# Orden de Ejecución para Actualizar Nombres de KPIs de IT

## 📋 Situación Actual

Tu base de datos está como el archivo `database/tareas.sql` que contiene:
- ✅ Estructura completa de tablas
- ✅ KPIs de IT con nombres **ANTIGUOS**:
  - IT_01: 'Disponibilidad de Servidores y Servicios Críticos'
  - IT_02: 'Cumplimiento de Mantenimiento de Infraestructura'
  - IT_03: 'Cumplimiento en Desarrollo y Automatización'
  - IT_04: 'Actualización de Documentación Técnica'
  - IT_05: 'Atención y Cierre de Incidentes de Soporte'

## 🎯 Objetivo

Actualizar los nombres de los KPIs de IT a los nuevos nombres:
- IT_01: 'Continuidad Operativa de Servicios Críticos (Disponibilidad)'
- IT_02: 'Cumplimiento del Plan de Mantenimiento Tecnológico (Infraestructura)'
- IT_03: 'Entrega de Desarrollo y Automatización (Software)'
- IT_04: 'Actualización de Documentación y Control de Activos IT'
- IT_05: 'Eficiencia en Atención y Cierre de Soporte IT'

## 📝 Orden de Ejecución

### ⚠️ IMPORTANTE: Antes de Ejecutar

1. **Hacer BACKUP de la base de datos**
   ```sql
   -- Ejemplo con mysqldump
   mysqldump -u usuario -p nombre_base_datos > backup_antes_actualizacion_kpis.sql
   ```

2. **Verificar estado actual** (opcional, pero recomendado)
   ```sql
   SELECT code, name FROM kpis WHERE code IN ('IT_01', 'IT_02', 'IT_03', 'IT_04', 'IT_05');
   SELECT kc.id, kc.name, k.code FROM kpi_categories kc 
   JOIN kpis k ON kc.kpi_id = k.id 
   WHERE k.code IN ('IT_01', 'IT_02', 'IT_03', 'IT_04', 'IT_05') AND kc.area_id = 1;
   ```

### ✅ Paso 1: Ejecutar Script de Actualización

**Ejecutar UNO de los siguientes scripts:**

#### Opción A: Script de Producción (RECOMENDADO)
```bash
# Desde línea de comandos MySQL
mysql -u usuario -p nombre_base_datos < database/migrations/006_update_it_kpi_names_production.sql
```

O ejecutar directamente el contenido del archivo:
- **Archivo:** `database/migrations/006_update_it_kpi_names_production.sql`

#### Opción B: Script Simplificado
```bash
mysql -u usuario -p nombre_base_datos < database/migrations/006_update_it_kpi_names.sql
```

O ejecutar directamente el contenido del archivo:
- **Archivo:** `database/migrations/006_update_it_kpi_names.sql`

### ✅ Paso 2: Verificar Actualización

Después de ejecutar, verificar que los cambios se aplicaron correctamente:

```sql
-- Verificar nombres en tabla kpis
SELECT code, name FROM kpis WHERE code IN ('IT_01', 'IT_02', 'IT_03', 'IT_04', 'IT_05');

-- Verificar nombres en tabla kpi_categories (lo que ve el usuario)
SELECT kc.id, kc.name, k.code, COUNT(t.id) as tareas_asignadas
FROM kpi_categories kc 
JOIN kpis k ON kc.kpi_id = k.id 
LEFT JOIN tasks t ON t.kpi_category_id = kc.id AND t.deleted_at IS NULL
WHERE k.code IN ('IT_01', 'IT_02', 'IT_03', 'IT_04', 'IT_05') AND kc.area_id = 1
GROUP BY kc.id, kc.name, k.code;
```

## 🔄 ¿Qué Hace el Script?

El script actualiza **SOLO** los nombres en dos tablas:

1. **Tabla `kpis`**: Nombres base de los KPIs
2. **Tabla `kpi_categories`**: Nombres visibles en la interfaz

### ✅ NO afecta:
- ❌ Las tareas existentes (usan IDs, no nombres)
- ❌ Los cálculos de KPIs (`task_kpi_facts`)
- ❌ Los datos de las tareas
- ❌ Las relaciones entre tablas

### ✅ SÍ afecta:
- ✅ Los nombres que se muestran en la interfaz
- ✅ Los nombres en reportes y visualizaciones
- ✅ Los nombres en la base de datos

## 🛡️ Características del Script

- ✅ **Idempotente**: Puede ejecutarse múltiples veces sin problemas
- ✅ **Seguro**: Solo actualiza si el nombre es diferente
- ✅ **Transaccional**: Usa TRANSACTION para rollback automático si hay error
- ✅ **Eficiente**: Usa JOINs optimizados

## 📊 Resultado Esperado

Después de ejecutar el script, deberías ver:

| Código | Nombre Anterior | Nombre Nuevo |
|--------|----------------|--------------|
| IT_01 | Disponibilidad de Servidores y Servicios Críticos | Continuidad Operativa de Servicios Críticos (Disponibilidad) |
| IT_02 | Cumplimiento de Mantenimiento de Infraestructura | Cumplimiento del Plan de Mantenimiento Tecnológico (Infraestructura) |
| IT_03 | Cumplimiento en Desarrollo y Automatización | Entrega de Desarrollo y Automatización (Software) |
| IT_04 | Actualización de Documentación Técnica | Actualización de Documentación y Control de Activos IT |
| IT_05 | Atención y Cierre de Incidentes de Soporte | Eficiencia en Atención y Cierre de Soporte IT |

## ⚠️ Si Algo Sale Mal

Si necesitas revertir los cambios:

```sql
-- Revertir IT_01
UPDATE `kpis` SET `name` = 'Disponibilidad de Servidores y Servicios Críticos' WHERE `code` = 'IT_01';
UPDATE `kpi_categories` kc
INNER JOIN `kpis` k ON kc.kpi_id = k.id
SET kc.`name` = 'Disponibilidad de Servidores y Servicios Críticos'
WHERE k.`code` = 'IT_01' AND kc.`area_id` = 1;

-- Repetir para IT_02, IT_03, IT_04, IT_05 con sus nombres antiguos
```

O mejor aún, restaurar desde el backup:
```bash
mysql -u usuario -p nombre_base_datos < backup_antes_actualizacion_kpis.sql
```

## 📌 Resumen Ejecutivo

**Para tu caso específico (base de datos como tareas.sql):**

1. ✅ Hacer backup
2. ✅ Ejecutar: `006_update_it_kpi_names_production.sql` (o `006_update_it_kpi_names.sql`)
3. ✅ Verificar resultados
4. ✅ Listo - Los nombres se actualizarán automáticamente en la interfaz

**NO necesitas ejecutar otras migraciones** porque tu base de datos ya tiene toda la estructura completa.
