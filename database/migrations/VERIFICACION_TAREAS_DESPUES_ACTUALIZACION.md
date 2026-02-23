# Verificación de Tareas Después de Actualizar Nombres de KPIs

## ✅ ¿Por qué las tareas NO se ven afectadas?

Las tareas **NO se ven afectadas** porque el sistema usa **IDs numéricos**, no nombres, para las relaciones:

### 🔗 Cómo funcionan las relaciones:

1. **Tabla `tasks`** tiene el campo `kpi_category_id` (un número, ej: 41, 42, 43, 44, 45)
2. **Tabla `kpi_categories`** tiene el campo `id` (el mismo número) y `name` (el nombre que se muestra)
3. **Tabla `kpis`** tiene el campo `id` (número) y `name` (nombre base del KPI)

### 📊 Ejemplo práctico:

**ANTES de actualizar:**
- Tarea tiene `kpi_category_id = 41`
- `kpi_categories.id = 41` tiene `name = 'Disponibilidad de Servidores y Servicios Críticos'`
- `kpis.id = 26` tiene `name = 'Disponibilidad de Servidores y Servicios Críticos'`

**DESPUÉS de actualizar:**
- Tarea sigue teniendo `kpi_category_id = 41` ✅ (NO cambia)
- `kpi_categories.id = 41` ahora tiene `name = 'Continuidad Operativa de Servicios Críticos (Disponibilidad)'` ✅
- `kpis.id = 26` ahora tiene `name = 'Continuidad Operativa de Servicios Críticos (Disponibilidad)'` ✅

**Resultado:** La tarea sigue funcionando perfectamente, solo se actualiza el nombre que se muestra.

## 🔍 Consultas SQL para Verificar

### 1. Ver tareas de IT con sus KPIs (antes y después)

```sql
-- Ver todas las tareas de IT con sus categorías KPI
SELECT 
    t.id AS tarea_id,
    t.title AS titulo_tarea,
    t.status AS estado,
    t.kpi_category_id,
    kc.name AS nombre_kpi_categoria,
    k.code AS codigo_kpi,
    k.name AS nombre_kpi_base
FROM tasks t
LEFT JOIN kpi_categories kc ON t.kpi_category_id = kc.id
LEFT JOIN kpis k ON kc.kpi_id = k.id
WHERE t.area_id = 1  -- Área IT
  AND t.deleted_at IS NULL
  AND t.kpi_category_id IS NOT NULL
ORDER BY t.id;
```

### 2. Verificar que todas las tareas de IT siguen vinculadas correctamente

```sql
-- Verificar que no hay tareas huérfanas (sin categoría válida)
SELECT 
    COUNT(*) AS tareas_sin_categoria_valida
FROM tasks t
LEFT JOIN kpi_categories kc ON t.kpi_category_id = kc.id
WHERE t.area_id = 1
  AND t.deleted_at IS NULL
  AND t.kpi_category_id IS NOT NULL
  AND kc.id IS NULL;
```

**Resultado esperado:** `0` (cero tareas huérfanas)

### 3. Ver tareas por cada KPI de IT

```sql
-- Contar tareas por cada KPI de IT
SELECT 
    k.code AS codigo_kpi,
    k.name AS nombre_kpi,
    kc.name AS nombre_categoria,
    COUNT(t.id) AS total_tareas,
    SUM(CASE WHEN t.status = 'Completada' THEN 1 ELSE 0 END) AS tareas_completadas,
    SUM(CASE WHEN t.status = 'En progreso' THEN 1 ELSE 0 END) AS tareas_en_progreso
FROM kpis k
JOIN kpi_categories kc ON kc.kpi_id = k.id
LEFT JOIN tasks t ON t.kpi_category_id = kc.id AND t.deleted_at IS NULL
WHERE k.code IN ('IT_01', 'IT_02', 'IT_03', 'IT_04', 'IT_05')
  AND kc.area_id = 1
GROUP BY k.code, k.name, kc.name
ORDER BY k.code;
```

### 4. Verificar cálculos de KPIs (task_kpi_facts)

```sql
-- Verificar que los cálculos de KPIs siguen funcionando
SELECT 
    tkf.id AS fact_id,
    tkf.task_id,
    t.title AS titulo_tarea,
    k.code AS codigo_kpi,
    k.name AS nombre_kpi,
    tkf.period_key,
    tkf.numerator,
    tkf.denominator,
    tkf.is_applicable,
    tkf.computed_at
FROM task_kpi_facts tkf
JOIN tasks t ON tkf.task_id = t.id
JOIN kpis k ON tkf.kpi_id = k.id
WHERE k.code IN ('IT_01', 'IT_02', 'IT_03', 'IT_04', 'IT_05')
  AND t.deleted_at IS NULL
ORDER BY tkf.task_id, tkf.period_key;
```

## ✅ Checklist de Verificación Post-Actualización

Después de ejecutar el script de actualización, verifica:

- [ ] **Todas las tareas siguen teniendo su `kpi_category_id`** (no cambió)
- [ ] **Los nombres se actualizaron en `kpis` y `kpi_categories`**
- [ ] **Las tareas muestran los nuevos nombres en la interfaz**
- [ ] **Los cálculos de KPIs (`task_kpi_facts`) siguen funcionando**
- [ ] **No hay tareas huérfanas** (sin categoría válida)

## 🎯 Resumen

**Las tareas existentes:**
- ✅ **Siguen funcionando** porque usan IDs, no nombres
- ✅ **Mostrarán los nuevos nombres** automáticamente cuando se carguen desde la BD
- ✅ **No necesitan actualización manual**
- ✅ **Los cálculos de KPIs no se ven afectados**

**Lo único que cambia:**
- ✅ El nombre que se muestra en la interfaz
- ✅ El nombre en reportes y visualizaciones
- ✅ El nombre en la base de datos

**Lo que NO cambia:**
- ❌ Los IDs de las tareas
- ❌ Los `kpi_category_id` de las tareas
- ❌ Los `kpi_id` en los cálculos
- ❌ Los datos de las tareas
- ❌ Las relaciones entre tablas

## 📝 Consulta Rápida de Verificación

Ejecuta esta consulta después de actualizar para verificar que todo está bien:

```sql
-- Verificación rápida: Tareas de IT con nuevos nombres
SELECT 
    t.id,
    t.title,
    t.status,
    k.code,
    k.name AS nombre_kpi_actualizado,
    kc.name AS nombre_categoria_actualizado
FROM tasks t
JOIN kpi_categories kc ON t.kpi_category_id = kc.id
JOIN kpis k ON kc.kpi_id = k.id
WHERE t.area_id = 1
  AND t.deleted_at IS NULL
  AND k.code IN ('IT_01', 'IT_02', 'IT_03', 'IT_04', 'IT_05')
LIMIT 10;
```

Deberías ver los **nuevos nombres** en las columnas `nombre_kpi_actualizado` y `nombre_categoria_actualizado`.
