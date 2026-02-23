-- =========================================================
-- Migración generada desde database.xlsx
-- Compatible con reportes_ods.sql (reports.is_active, task_report_links, tasks, índices)
-- Pobla: users (email), service_orders, employee_profiles, service_order_employees.
-- Ejecutar en la BD reportes_ods (estructura creada con reportes_ods.sql).
-- =========================================================

USE reportes_ods;

START TRANSACTION;

SET @NOW := CURRENT_TIMESTAMP;

-- =========================================================
-- 1) service_orders (ODS)
-- =========================================================

INSERT INTO service_orders (ods_code, project_name, object_text, term_text, status, created_at, updated_at)
VALUES ('90045724', 'PETROSERVICIOS', 'ervicio para la elaboración de entregables petrotécnicos para la disciplina de CCUS, a ejecutar por la Gerencia Centro Técnico De
Desarrollo (GET) en la vigencia 2024', '4,5 meses',
        'Activa', @NOW, @NOW)
ON DUPLICATE KEY UPDATE
  project_name = VALUES(project_name),
  object_text  = VALUES(object_text),
  term_text    = VALUES(term_text),
  updated_at   = @NOW;

INSERT INTO service_orders (ods_code, project_name, object_text, term_text, status, created_at, updated_at)
VALUES ('90578295', 'PETROSERVICIOS', 'Entregables de proyectos en maduración y ejecución para incorporación de reservas del plan de inversiones 2026-2028 y monitoreo de yacimientos y producción, de los campos de la Gerencia de Operación y Mantenimiento Castilla – Apiay (GAA) que soporta la Gerencia de Desarrollo Orinoquia', 'de 3 meses contados a partir de la fecha de firma del Acta de Inicio de la Orden de Servicio, o de la fecha que en esta se indique, ó hasta el 31 de diciembre de 2025, lo que primero ocurra.',
        'Activa', @NOW, @NOW)
ON DUPLICATE KEY UPDATE
  project_name = VALUES(project_name),
  object_text  = VALUES(object_text),
  term_text    = VALUES(term_text),
  updated_at   = @NOW;

INSERT INTO service_orders (ods_code, project_name, object_text, term_text, status, created_at, updated_at)
VALUES ('90049330', 'PETROSERVICIOS', 'Servicio para la elaboración de entregables Petrotécnicos para la caracterización y gestión del yacimiento, y/o la construcción de escenarios de subsuelo y/o la planeación integrada del desarrollo, y/o la integración y análisis de oportunidades de desarrollo y el análisis de resultados y acciones de mejora al plan integrado de desarrollo de activos gor rubiales y caño sur este y gpa dina t – palogrande y río ceibas', 'de 11,5 meses contados a partir de la fecha de firma del Acta de Inicio de la Orden de Servicio, ó hasta el 31 de diciembre de 2025, lo que primero ocurra.',
        'Activa', @NOW, @NOW)
ON DUPLICATE KEY UPDATE
  project_name = VALUES(project_name),
  object_text  = VALUES(object_text),
  term_text    = VALUES(term_text),
  updated_at   = @NOW;

INSERT INTO service_orders (ods_code, project_name, object_text, term_text, status, created_at, updated_at)
VALUES ('90141005', 'PETROSERVICIOS', 'Servicio para monitoreo de yacimientos, análisis de resultados y acciones de mejora en producción, planeación integrada del desarrollo, análisis de oportunidades de desarrollo, y/o acciones de mejora a proyectos nuevos, en maduración y ejecución para la incorporación de reservas, que soporta la Gerencia de Desarrollo Orinoquía en los campos de la Gerencia de Operación y Mantenimiento Chichimene – CPO-9 (GLH) y la Gerencia de Operación y Mantenimiento Castilla – Apiay (GAA)', 'de 9 meses contados a partir de la fecha de firma del Acta de Inicio de la Orden de Servicio, o de la fecha que en esta se indique, ó hasta el 31 de diciembre de 2025, lo que primero ocurra.',
        'Activa', @NOW, @NOW)
ON DUPLICATE KEY UPDATE
  project_name = VALUES(project_name),
  object_text  = VALUES(object_text),
  term_text    = VALUES(term_text),
  updated_at   = @NOW;

INSERT INTO service_orders (ods_code, project_name, object_text, term_text, status, created_at, updated_at)
VALUES ('90172266', 'PETROSERVICIOS', 'Construcción de escenarios de subsuelo y/o la integración y análisis de oportunidades de desarrollo y el análisis de resultados y acciones de mejora al plan integrado de desarrollo en maduración y ejecución para la incorporación de reservas, que soporta la Gerencia de Desarrollo Andina Oriente en los campos de la Gerencia de Operación y Mantenimiento Andina para los activos de la GPA', 'de 8,3 meses contados a partir de la fecha de firma del Acta de Inicio de la Orden de Servicio, o de la fecha que en esta se indique, ó hasta el 31 de diciembre de 2025, lo que primero ocurra.',
        'Activa', @NOW, @NOW)
ON DUPLICATE KEY UPDATE
  project_name = VALUES(project_name),
  object_text  = VALUES(object_text),
  term_text    = VALUES(term_text),
  updated_at   = @NOW;

INSERT INTO service_orders (ods_code, project_name, object_text, term_text, status, created_at, updated_at)
VALUES ('90227898', 'PETROSERVICIOS', 'Ejecución para la incorporación de reservas, análisis de resultados y acciones de mejora al plan integrado de desarrollo, construcción de escenarios de subsuelo y la integración, análisis de oportunidades de desarrollo, que soportan la Gerencia de Desarrollo Andina Oriente en los campos de la Gerencia de Operación y Mantenimiento Oriente para los activos de la GOR', 'de 7 meses contados a partir de la fecha de firma del Acta de Inicio de la Orden de Servicio, o de la fecha que en esta se indique, ó hasta el 31 de diciembre de 2025, lo que primero ocurra.',
        'Activa', @NOW, @NOW)
ON DUPLICATE KEY UPDATE
  project_name = VALUES(project_name),
  object_text  = VALUES(object_text),
  term_text    = VALUES(term_text),
  updated_at   = @NOW;

INSERT INTO service_orders (ods_code, project_name, object_text, term_text, status, created_at, updated_at)
VALUES ('GRM-02-07-202', 'COMPANY CW281880 - CANTAGALLO', '"Servicio de ingeniería, planeación y supervisión integral de pozos en perforación, completamiento e intervenciones a pozo en ECOPETROL S.A."', '184 días',
        'Activa', @NOW, @NOW)
ON DUPLICATE KEY UPDATE
  project_name = VALUES(project_name),
  object_text  = VALUES(object_text),
  term_text    = VALUES(term_text),
  updated_at   = @NOW;

INSERT INTO service_orders (ods_code, project_name, object_text, term_text, status, created_at, updated_at)
VALUES ('GSS-01-06-2025', 'COMPANY CW281880 - PIEDEMONTE', '"Servicio de ingeniería, planeación y supervisión integral de pozos en perforación, completamiento e intervenciones a pozo en ECOPETROL S.A."', '184 días',
        'Activa', @NOW, @NOW)
ON DUPLICATE KEY UPDATE
  project_name = VALUES(project_name),
  object_text  = VALUES(object_text),
  term_text    = VALUES(term_text),
  updated_at   = @NOW;

INSERT INTO service_orders (ods_code, project_name, object_text, term_text, status, created_at, updated_at)
VALUES ('GGS-01-062025', 'COMPANY CW281880 - Provincia', '"Servicio de ingeniería, planeación y supervisión integral de pozos en perforación, completamiento e intervenciones a pozo en ECOPETROL S.A."', '184 días',
        'Activa', @NOW, @NOW)
ON DUPLICATE KEY UPDATE
  project_name = VALUES(project_name),
  object_text  = VALUES(object_text),
  term_text    = VALUES(term_text),
  updated_at   = @NOW;

INSERT INTO service_orders (ods_code, project_name, object_text, term_text, status, created_at, updated_at)
VALUES ('GRM-02-07 2025', 'COMPANY CW281880 - YONDO', '"Servicio de ingeniería, planeación y supervisión integral de pozos en perforación, completamiento e intervenciones a pozo en ECOPETROL S.A."', '184 días',
        'Activa', @NOW, @NOW)
ON DUPLICATE KEY UPDATE
  project_name = VALUES(project_name),
  object_text  = VALUES(object_text),
  term_text    = VALUES(term_text),
  updated_at   = @NOW;

INSERT INTO service_orders (ods_code, project_name, object_text, term_text, status, created_at, updated_at)
VALUES ('90577837', 'PETROSERVICIOS', 'Servicio para la elaboración de entregables petrotécnicos relacionados con la disciplina de Ingeniería de Facilidades para las actividades de visualización de facilidades y estimación de capex y costos operativos a ejecutar por la Gerencia de Servicios de Exploración que pertenece a la Gerencia General Costa Afuera y exploración durante la vigencia 2026', 'de 8 meses contados a partir de la fecha de firma del Acta de Inicio de la Orden de Servicio, o de la fecha que en esta se indique, ó hasta el 31 de diciembre de 2025, lo que primero ocurra.',
        'Activa', @NOW, @NOW)
ON DUPLICATE KEY UPDATE
  project_name = VALUES(project_name),
  object_text  = VALUES(object_text),
  term_text    = VALUES(term_text),
  updated_at   = @NOW;

INSERT INTO service_orders (ods_code, project_name, object_text, term_text, status, created_at, updated_at)
VALUES ('90577770', 'PETROSERVICIOS', 'Servicio para la caracterización y gestión del yacimiento que soporten estudios para la implementación de tecnologías de recobro en el área Teca - Nare, proyectos de WO en los campos de la Gerencia Río Mares y el proyecto integral de crecimiento en el campo Yariguí; así como la integración y análisis de oportunidades de desarrollo de campos pertenecientes a la Gerencia General de Desarrollo y la Gerencia de Desarrollo Central (GCE)', 'de 7,9 meses contados a partir de la fecha de firma del Acta de Inicio de la Orden de Servicio, o de la fecha que en esta se indique, ó hasta el 31 de diciembre de 2025, lo que primero ocurra.',
        'Activa', @NOW, @NOW)
ON DUPLICATE KEY UPDATE
  project_name = VALUES(project_name),
  object_text  = VALUES(object_text),
  term_text    = VALUES(term_text),
  updated_at   = @NOW;

INSERT INTO service_orders (ods_code, project_name, object_text, term_text, status, created_at, updated_at)
VALUES ('90594501', 'PETROSERVICIOS', 'Servicio para la caracterización y gestión del yacimiento, de la Gerencia de Desarrollo Activos No Operados GNO en la disciplina de ingeniería de yacimientos activos Capachos - Andina - Arauca - GNO', 'de 7,83 meses a partir de la fecha que se indique en el Acta de Inicio de la Orden de Servicio, ó hasta el 31 de agosto de 2026, lo que primero ocurra.',
        'Activa', @NOW, @NOW)
ON DUPLICATE KEY UPDATE
  project_name = VALUES(project_name),
  object_text  = VALUES(object_text),
  term_text    = VALUES(term_text),
  updated_at   = @NOW;

INSERT INTO service_orders (ods_code, project_name, object_text, term_text, status, created_at, updated_at)
VALUES ('GGS-01-06-2025 PROVINCIA', 'COMPANY CW281880 - PROVINCIA', '"Servicio de ingeniería, planeación y supervisión integral de pozos en perforación, completamiento e intervenciones a pozo en ECOPETROL S.A."', '184 días',
        'Activa', @NOW, @NOW)
ON DUPLICATE KEY UPDATE
  project_name = VALUES(project_name),
  object_text  = VALUES(object_text),
  term_text    = VALUES(term_text),
  updated_at   = @NOW;

INSERT INTO service_orders (ods_code, project_name, object_text, term_text, status, created_at, updated_at)
VALUES ('90590325', 'PETROSERVICIOS', 'Servicio en las disciplinas especializadas de geomodelamiento, petrofísica, ingeniería de yacimientos y data analytics para la evaluación integral y desarrollo de las oportunidades de negocio estratégicas a nivel nacional y/o internacional, la elaboración de planes de desarrollo conceptuales e integrados, y/o identificación de alternativas optimas de desarrollo, y/o evaluación técnico económica de las oportunidades, y la toma de decisiones robustas en procesos de inversión, desinversión y/o dilución de activos para el departamento de análisis técnico de nuevos negocios DAT', 'de 7,6 meses a partir de la fecha que se indique en el Acta de Inicio de la Orden de Servicio, ó hasta el 31 de agosto de 2026, lo que primero ocurra.',
        'Activa', @NOW, @NOW)
ON DUPLICATE KEY UPDATE
  project_name = VALUES(project_name),
  object_text  = VALUES(object_text),
  term_text    = VALUES(term_text),
  updated_at   = @NOW;

INSERT INTO service_orders (ods_code, project_name, object_text, term_text, status, created_at, updated_at)
VALUES ('90600752', 'PETROSERVICIOS', 'Servicio para la caracterización y gestión del yacimiento, y/o la construcción de escenarios de subsuelo y/o la planeación integrada del desarrollo, y/o la integración y análisis de oportunidades de desarrollo y el análisis de resultados y acciones de mejora al Plan Integrado de Desarrollo (PID) para la Gerencia de Desarrollo de Gas (GDG) 2026', 'de 7,6 meses a partir de la fecha que se indique en el Acta de Inicio de la Orden de Servicio, ó hasta el 31 de agosto de 2026, lo que primero ocurra.',
        'Activa', @NOW, @NOW)
ON DUPLICATE KEY UPDATE
  project_name = VALUES(project_name),
  object_text  = VALUES(object_text),
  term_text    = VALUES(term_text),
  updated_at   = @NOW;

INSERT INTO service_orders (ods_code, project_name, object_text, term_text, status, created_at, updated_at)
VALUES ('90560321', 'PETROSERVICIOS', 'Servicio para la elaboración de entregables petrotécnicos para estudios transversales de Geoquímica, Geomática y Sismología a ejecutar por la Gerencia Técnico de Desarrollo y Produccion (GET) 2026', 'de 7,5 meses a partir de la fecha que se indique en el Acta de Inicio de la Orden de Servicio, ó hasta el 31 de agosto de 2026, lo que primero ocurra.',
        'Activa', @NOW, @NOW)
ON DUPLICATE KEY UPDATE
  project_name = VALUES(project_name),
  object_text  = VALUES(object_text),
  term_text    = VALUES(term_text),
  updated_at   = @NOW;

INSERT INTO service_orders (ods_code, project_name, object_text, term_text, status, created_at, updated_at)
VALUES ('90598918', 'PETROSERVICIOS', 'Servicio para la elaboración de entregables petrotécnicos para estudios transversales de Geotermia, Analítica de datos, PVT, CCUS y Optimización de producción – GOP a ejecutar por la Gerencia Técnico de Desarrollo y Produccion (GET) 2026', 'de 7,5 meses a partir de la fecha que se indique en el Acta de Inicio de la Orden de Servicio, ó hasta el 31 de agosto de 2026, lo que primero ocurra.',
        'Activa', @NOW, @NOW)
ON DUPLICATE KEY UPDATE
  project_name = VALUES(project_name),
  object_text  = VALUES(object_text),
  term_text    = VALUES(term_text),
  updated_at   = @NOW;

INSERT INTO service_orders (ods_code, project_name, object_text, term_text, status, created_at, updated_at)
VALUES ('90599358', 'PETROSERVICIOS', 'Servicio para la elaboración de entregables petrotécnicos para estudios transversales de Geología y Geofísica G&G a ejecutar por la Gerencia Técnica de Desarrollo y Producción (GET) 2026', 'de 7,5 meses a partir de la fecha que se indique en el Acta de Inicio de la Orden de Servicio, ó hasta el 31 de agosto de 2026, lo que primero ocurra.',
        'Activa', @NOW, @NOW)
ON DUPLICATE KEY UPDATE
  project_name = VALUES(project_name),
  object_text  = VALUES(object_text),
  term_text    = VALUES(term_text),
  updated_at   = @NOW;

INSERT INTO service_orders (ods_code, project_name, object_text, term_text, status, created_at, updated_at)
VALUES ('90599924', 'PETROSERVICIOS', 'Servicio para la elaboración de entregables petrotécnicos para estudios transversales asociados con Seguimiento a Optimización y Producción, Recobro Mejorado, Nanotecnología y Prueba de Pozos a ejecutar por la Gerencia Técnica de Desarrollo y Producción (GET) 2026', 'de 7,5 meses a partir de la fecha que se indique en el Acta de Inicio de la Orden de Servicio, ó hasta el 31 de agosto de 2026, lo que primero ocurra.',
        'Activa', @NOW, @NOW)
ON DUPLICATE KEY UPDATE
  project_name = VALUES(project_name),
  object_text  = VALUES(object_text),
  term_text    = VALUES(term_text),
  updated_at   = @NOW;

INSERT INTO service_orders (ods_code, project_name, object_text, term_text, status, created_at, updated_at)
VALUES ('1661981', 'PETROSERVICIOS', 'Servicio para la caracterización y gestión del yacimiento, y/o la construcción de escenarios de subsuelo y/o la planeación integral y desarrollo, en las disciplinas de ingeniería de yacimientos y modelador PID para el departamento de análisis técnico de nuevos negocios - DAT, atendiendo oportunidades estratégicas a nivel nacional y/o internacional', 'de 7,5 meses a partir de la fecha que se indique en el Acta de Inicio de la Orden de Servicio, ó hasta el 31 de agosto de 2026, lo que primero ocurra.',
        'Activa', @NOW, @NOW)
ON DUPLICATE KEY UPDATE
  project_name = VALUES(project_name),
  object_text  = VALUES(object_text),
  term_text    = VALUES(term_text),
  updated_at   = @NOW;

INSERT INTO service_orders (ods_code, project_name, object_text, term_text, status, created_at, updated_at)
VALUES ('90612258', 'PETROSERVICIOS', 'Servicio para la caracterización y gestión del yacimiento, y/o la construcción de escenarios de subsuelo y/o la planeación integrada del desarrollo, plan integrado de desarrollo para Marsella - GNO 2026', 'de 7,4 meses a partir de la fecha que se indique en el Acta de Inicio de la Orden de Servicio, ó hasta el 31 de agosto de 2026, lo que primero ocurra.',
        'Activa', @NOW, @NOW)
ON DUPLICATE KEY UPDATE
  project_name = VALUES(project_name),
  object_text  = VALUES(object_text),
  term_text    = VALUES(term_text),
  updated_at   = @NOW;

INSERT INTO service_orders (ods_code, project_name, object_text, term_text, status, created_at, updated_at)
VALUES ('90632454', 'PETROSERVICIOS', 'Servicio para la caracterización y gestión del yacimiento, y/o la construcción de escenarios de subsuelo y/o la planeación integrada del desarrollo, y/o la integración y análisis de oportunidades de desarrollo y el análisis de resultados y acciones de mejora al plan integrado de desarrollo en la disciplina de ingeniería de yacimientos foco Offshore en la Gerencia de Desarrollo de Gas GDG, para vigencia 2026', 'de 7,5 meses contados a partir de la fecha de firma del Acta de Inicio de la Orden de Servicio, o de la fecha que en esta se indique, ó hasta el 31 de agosto de 2026, lo que primero ocurra.',
        'Activa', @NOW, @NOW)
ON DUPLICATE KEY UPDATE
  project_name = VALUES(project_name),
  object_text  = VALUES(object_text),
  term_text    = VALUES(term_text),
  updated_at   = @NOW;

INSERT INTO service_orders (ods_code, project_name, object_text, term_text, status, created_at, updated_at)
VALUES ('90598546', 'PETROSERVICIOS', 'Servicio para la caracterización y gestión del yacimiento, de la Gerencia de Desarrollo de Activos con Socios GNO en la disciplina petrofísica desarrollo 2026', 'de 7,1 meses contados a partir de la fecha de firma del Acta de Inicio de la Orden de Servicio, o de la fecha que en esta se indique, ó hasta el 31 de agosto de 2026, lo que primero ocurra.',
        'Activa', @NOW, @NOW)
ON DUPLICATE KEY UPDATE
  project_name = VALUES(project_name),
  object_text  = VALUES(object_text),
  term_text    = VALUES(term_text),
  updated_at   = @NOW;

INSERT INTO service_orders (ods_code, project_name, object_text, term_text, status, created_at, updated_at)
VALUES ('90642057', 'PETROSERVICIOS', 'Servicio para la caracterización y gestión del yacimiento, y/o la construcción de escenarios de subsuelo y/o la planeación integrada del desarrollo, y/o la integración y análisis de oportunidades de desarrollo y el análisis de resultados y acciones de mejora al plan integrado de desarrollo para la Gerencia de Desarrollo de Activos con Socios GNO 2026', 'de 6.97 meses contados a partir de la fecha de firma del Acta de Inicio de la Orden de Servicio, o de la fecha que en esta se indique, ó hasta el 31 de agosto de 2026, lo que primero ocurra.',
        'Activa', @NOW, @NOW)
ON DUPLICATE KEY UPDATE
  project_name = VALUES(project_name),
  object_text  = VALUES(object_text),
  term_text    = VALUES(term_text),
  updated_at   = @NOW;

INSERT INTO service_orders (ods_code, project_name, object_text, term_text, status, created_at, updated_at)
VALUES ('90658180', 'PETROSERVICIOS', 'Servicios para la planeación integrada del Desarrollo y soporte al proyecto incremental Desarrollo Yariguí Módulo 2 Etapa 2', 'de 3 meses a partir de la fecha que se indique en el Acta de Inicio de la Orden de Servicio, ó hasta el 31 de agosto de 2026, lo que primero ocurra.',
        'Activa', @NOW, @NOW)
ON DUPLICATE KEY UPDATE
  project_name = VALUES(project_name),
  object_text  = VALUES(object_text),
  term_text    = VALUES(term_text),
  updated_at   = @NOW;

-- =========================================================
-- 1.5) users (correos del Excel; se insertan si no existen)
--    Necesario para que employee_profiles y service_order_employees encuentren user_id.
-- =========================================================

INSERT IGNORE INTO users (email) VALUES ('camila.medina@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('aura.traslavina@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('wcabrera@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('sebastian.llanos@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('oveimar.santamaria@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('lady.lopez@meridian.com.co');
INSERT IGNORE INTO users (email) VALUES ('jully.vargas@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('esperanza.cotes@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('Emeli.yacelga@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('carlos.urzola@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('leonardo.franco@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('wilmar.delahoz@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('andres.morales@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('monica.martinez@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('milton.gualteros@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('lizeth.bautista@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('julian.hernandez@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('jhon.carreno@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('ivan.mozo@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('geisson.zafra@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('diego.galeano@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('david.garcia@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('christian.mendoza@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('cesar.garnica@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('briggite.camacho@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('alejandro.lopez@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('carlos.espinosa@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('diego.martinez@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('amaogh@gmail.com');
INSERT IGNORE INTO users (email) VALUES ('maryluzsantamaria@hotmail.com');
INSERT IGNORE INTO users (email) VALUES ('VIANIRUIZ@GMAIL.COM');
INSERT IGNORE INTO users (email) VALUES ('cesarjuliocesar1997@gmail.com');
INSERT IGNORE INTO users (email) VALUES ('jhonatantorresrdr@gmail.com');
INSERT IGNORE INTO users (email) VALUES ('miguelmolinave@gmail.com');
INSERT IGNORE INTO users (email) VALUES ('laucastro212011@gmail.com');
INSERT IGNORE INTO users (email) VALUES ('GENIOALV@GMAIL.COM');
INSERT IGNORE INTO users (email) VALUES ('01dianischavez@gmail.com');
INSERT IGNORE INTO users (email) VALUES ('lamarcela1289@gmail.com');
INSERT IGNORE INTO users (email) VALUES ('yorguinp@hotmail.com');
INSERT IGNORE INTO users (email) VALUES ('amtorop90@hotmail.com');
INSERT IGNORE INTO users (email) VALUES ('yojan35@hotmail.com');
INSERT IGNORE INTO users (email) VALUES ('aleja.2017@outlook.es');
INSERT IGNORE INTO users (email) VALUES ('datolo90@hotmail.com');
INSERT IGNORE INTO users (email) VALUES ('ingcamilo.ibanez@gmail.com');
INSERT IGNORE INTO users (email) VALUES ('yessica.alba19@gmail.com');
INSERT IGNORE INTO users (email) VALUES ('ing.alexgonzalez@hotmail.com');
INSERT IGNORE INTO users (email) VALUES ('Juanseb89@hotmail.com');
INSERT IGNORE INTO users (email) VALUES ('perlameli_92@hotmail.com');
INSERT IGNORE INTO users (email) VALUES ('estebangr1987@gmail.com');
INSERT IGNORE INTO users (email) VALUES ('pedro.cadena@outlook.com');
INSERT IGNORE INTO users (email) VALUES ('celiscarloss@gmail.com');
INSERT IGNORE INTO users (email) VALUES ('ricardocorreacerro@gmail.com');
INSERT IGNORE INTO users (email) VALUES ('julioromeroar@hotmail.com');
INSERT IGNORE INTO users (email) VALUES ('carlosfontalvocarrascal@hotmail.com');
INSERT IGNORE INTO users (email) VALUES ('Dayansuarezh11@gmail.com');
INSERT IGNORE INTO users (email) VALUES ('christian.pardo@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('jose.nassar@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('jaime.martinez@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('ana.castellanos@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('diego.pinto@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('gloria.vidal@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('jesus.pacheco@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('cesar.rodriguez@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('paola.gomez@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('luis.monsalve@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('carlos.olmos@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('nubia.reyes@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('maria.mojica@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('diana.caceres@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('rafael.guatame@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('ina.serrano@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('andres.bautista@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('jhon.cuesta@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('jose.garcia@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('emmanuel.robles@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('andres.amaya@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('angelica.prada@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('estefany.velandia@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('ximena.rodriguez@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('diego.castillo@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('juducaza@hotmail.com');
INSERT IGNORE INTO users (email) VALUES ('carlos.forero@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('alexandra.mesa@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('edna.nino@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('diana.solano@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('andres.anaya@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('gabriel.velez@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('juanmateo.cordoba@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('maria.murillo@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('adriana.duenes@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('mario.moreno@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('sergio.poveda@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('julio.figueroa@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('jorge.paiba@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('jully.ortegon@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('edwin.mayorga@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('mauricio.vasquez@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('oscar.suarez@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('juandavid.aristizabal@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('nicolas.avendano@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('camilo.santana@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('yessica.tarazona@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('jorge.alarcon@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('jesus.arenas@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('alejandra.arbelaez@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('giovanni.martinez@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('oscar.jimenez@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('ruben.ortiz@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('juan.avila@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('liliana.martinez@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('alejandro.botero@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('daniela.molina@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('jesus.coqueco@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('alexandra.londono@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('maria.giraldo@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('lenin.cordoba@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('javier.guerrero@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('yohaney.gomez@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('laura.hernandez@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('cindy.isaza@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('christian.rivera@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('alejandra.joya@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('cristina.caro@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('melina.rivera@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('mariann.mahecha@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('zenaida.marcano@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('german.orejarena@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('ricardo.gaviria@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('hugo.quiroga@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('jean.cedeno@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('yuber.rodriguez@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('kelly.diez@meridianecp.com');
INSERT IGNORE INTO users (email) VALUES ('luis.chinomes@meridianecp.com');

-- =========================================================
-- 2) employee_profiles (perfil de empleado)
--    Inserta usando users.email como llave. Si el usuario no existe, NO insertará.
-- =========================================================

-- Empleado: CAMILA FERNANDA MEDINA SANDOVAL | Email: camila.medina@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1100954344',
  'CAMILA FERNANDA MEDINA SANDOVAL',
  'camila.medina@meridianecp.com',
  '3155257550',
  'Quimica',
  'Profesional Junior para la ejecución de actividades de la ODS No. 90045724 del contrato Matriz No. 3037132',
  'MER-ODS-90045724-40-2025',
  '2024-09-02',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'camila.medina@meridianecp.com'
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

-- Empleado: AURA MARIA TRASLAVIÑA PRADA | Email: aura.traslavina@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1095786398',
  'AURA MARIA TRASLAVIÑA PRADA',
  'aura.traslavina@meridianecp.com',
  '3132028099',
  'Geólogo',
  'Profesional Junior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132',
  'MER-ODS-9770807-159',
  '2024-10-25',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'aura.traslavina@meridianecp.com'
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

-- Empleado: WILLIAM CABRERA CASTRO | Email: wcabrera@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '83042295',
  'WILLIAM CABRERA CASTRO',
  'wcabrera@meridianecp.com',
  '3147301063',
  'Ingeniero Electrónico',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90049330 del contrato Matriz No. 3037132',
  'MER-ODS-90049330-44-2025',
  '2025-01-16',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'wcabrera@meridianecp.com'
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

-- Empleado: SEBASTIAN LLANOS GALLO | Email: sebastian.llanos@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1075284985',
  'SEBASTIAN LLANOS GALLO',
  'sebastian.llanos@meridianecp.com',
  '3203210974',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecucion de actividades de la ODS No. 90049330 del contrato Matriz No.3037132',
  'MER-ODS-90049330-48-2025',
  '2025-01-16',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'sebastian.llanos@meridianecp.com'
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

-- Empleado: OVEIMAR SANTAMARIA TORRES | Email: oveimar.santamaria@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '80883010',
  'OVEIMAR SANTAMARIA TORRES',
  'oveimar.santamaria@meridianecp.com',
  '3017227315',
  'Ingeniero de Petróleos',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90049330 del contrato Matriz No. 3037132',
  'MER-ODS-90049330-49-2025',
  '2025-01-16',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'oveimar.santamaria@meridianecp.com'
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

-- Empleado: LADY MILENA LOPEZ ROJAS | Email: lady.lopez@meridian.com.co

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1100950373',
  'LADY MILENA LOPEZ ROJAS',
  'lady.lopez@meridian.com.co',
  '3112450500',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecucion de actividades de la ODS No. 90049330 del contrato Matriz No.3037132',
  'MER-ODS-90049330-54-2025',
  '2025-01-16',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'lady.lopez@meridian.com.co'
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

-- Empleado: JULLY ALEXANDRA VARGAS QUINTERO | Email: jully.vargas@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1075286613',
  'JULLY ALEXANDRA VARGAS QUINTERO',
  'jully.vargas@meridianecp.com',
  '3223424156',
  'Ingeniero de petróleos',
  'Profesional Junior para la ejecucion de actividades de la ODS No. 90049330 del contrato Matriz No.3037132',
  'MER-ODS-90049330-53-2025',
  '2025-01-16',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'jully.vargas@meridianecp.com'
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

-- Empleado: ESPERANZA DE JESUS COTES LEON | Email: esperanza.cotes@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '40936668',
  'ESPERANZA DE JESUS COTES LEON',
  'esperanza.cotes@meridianecp.com',
  '3183728370',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecucion de actividades de la ODS No. 90049330 del contrato Matriz No.3037132',
  'MER-ODS-90049330-46-2025',
  '2025-01-16',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'esperanza.cotes@meridianecp.com'
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

-- Empleado: EMELI YOHANA YACELGA CHITAN | Email: Emeli.yacelga@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1010056001',
  'EMELI YOHANA YACELGA CHITAN',
  'Emeli.yacelga@meridianecp.com',
  '3223594580',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecucion de actividades de la ODS No. 90049330 del contrato Matriz No.3037132',
  'MER-ODS-90049330-50-2025',
  '2025-01-16',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'Emeli.yacelga@meridianecp.com'
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

-- Empleado: CARLOS JOSE URZOLA EBRATT | Email: carlos.urzola@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1152210959',
  'CARLOS JOSE URZOLA EBRATT',
  'carlos.urzola@meridianecp.com',
  '3182840175',
  'Ingeniero de Petróleos',
  'Profesional Básico para la ejecución de actividades de la ODS No. 90049330 del contrato Matriz No. 3037132',
  'MER-ODS-90049330-51-2025',
  '2025-01-16',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'carlos.urzola@meridianecp.com'
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

-- Empleado: LEONARDO   FRANCO GRAJALES | Email: leonardo.franco@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '7729979',
  'LEONARDO   FRANCO GRAJALES',
  'leonardo.franco@meridianecp.com',
  '3012641268',
  'Ingeniero Electrónico',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90049330 del contrato Matriz No. 3037132',
  'MER-ODS-90049330-55-2025',
  '2025-01-20',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'leonardo.franco@meridianecp.com'
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

-- Empleado: WILMAR ANDRES DE LA HOZ GAMBOA | Email: wilmar.delahoz@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1095918218',
  'WILMAR ANDRES DE LA HOZ GAMBOA',
  'wilmar.delahoz@meridianecp.com',
  '3184960345',
  'Geólogo',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90049330 del contrato Matriz No. 3037132',
  'MER-ODS-90049330-69-2025',
  '2025-01-22',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'wilmar.delahoz@meridianecp.com'
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

-- Empleado: OLMER ANDRES MORALES MORA | Email: andres.morales@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1075292422',
  'OLMER ANDRES MORALES MORA',
  'andres.morales@meridianecp.com',
  '3232847716',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecución de actividades de la ODS No. 90141005 del contrato Matriz No. 3037132',
  'MER-ODS-90141005-84-2025',
  '2025-04-01',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'andres.morales@meridianecp.com'
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

-- Empleado: MONICA DEL PILAR MARTINEZ VERA | Email: monica.martinez@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '53103915',
  'MONICA DEL PILAR MARTINEZ VERA',
  'monica.martinez@meridianecp.com',
  '3028018043',
  'Ingeniero de Petróleos',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90141005 del contrato Matriz No. 3037132',
  'MER-ODS-90141005-104-2025',
  '2025-04-01',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'monica.martinez@meridianecp.com'
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

-- Empleado: MILTON JULIAN GUALTEROS QUIROGA | Email: milton.gualteros@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1098758681',
  'MILTON JULIAN GUALTEROS QUIROGA',
  'milton.gualteros@meridianecp.com',
  '3002755299',
  'Ingeniero de Petróleos',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90141005 del contrato Matriz No. 3037132',
  'MER-ODS-90141005-98-2025',
  '2025-04-01',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'milton.gualteros@meridianecp.com'
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

-- Empleado: LIZETH DAYANA BAUTISTA RICO | Email: lizeth.bautista@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1095826986',
  'LIZETH DAYANA BAUTISTA RICO',
  'lizeth.bautista@meridianecp.com',
  '3138678621',
  'Ingeniera de Petróleos',
  'Profesional Junior para la ejecución de actividades de la ODS No. 90141005 del contrato Matriz No. 3037132',
  'MER-ODS-90141005-82-2025',
  '2025-04-01',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'lizeth.bautista@meridianecp.com'
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

-- Empleado: JULIÁN ANDRÉS HERNÁNDEZ PINTO | Email: julian.hernandez@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1098706838',
  'JULIÁN ANDRÉS HERNÁNDEZ PINTO',
  'julian.hernandez@meridianecp.com',
  '3174478283',
  'Geólogo',
  'Profesional Junior para la ejecución de actividades de la ODS No. 90141005 del contrato Matriz No. 3037132',
  'MER-ODS-90141005-97-2025',
  '2025-04-01',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'julian.hernandez@meridianecp.com'
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

-- Empleado: JHON HARVEY CARREÑO HERNANDEZ | Email: jhon.carreno@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1098681773',
  'JHON HARVEY CARREÑO HERNANDEZ',
  'jhon.carreno@meridianecp.com',
  '3114976619',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecución de actividades de la ODS No. 90141005 del contrato Matriz No. 3037132',
  'MER-ODS-90141005-96-2025',
  '2025-04-01',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'jhon.carreno@meridianecp.com'
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

-- Empleado: IVAN DARIO MOZO MORENO | Email: ivan.mozo@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1056709240',
  'IVAN DARIO MOZO MORENO',
  'ivan.mozo@meridianecp.com',
  '3174236296',
  'Ingeniero de Petróleos',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90141005 del contrato Matriz No. 3037132',
  'MER-ODS-90141005-86-2025',
  '2025-04-01',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'ivan.mozo@meridianecp.com'
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

-- Empleado: GEISSON RENÉ ZAFRA URREA | Email: geisson.zafra@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1100961505',
  'GEISSON RENÉ ZAFRA URREA',
  'geisson.zafra@meridianecp.com',
  '3163677407',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecución de actividades de la ODS No. 90141005 del contrato Matriz No. 3037132',
  'MER-ODS-90141005-93-2025',
  '2025-04-01',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'geisson.zafra@meridianecp.com'
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

-- Empleado: DIEGO FERNANDO GALEANO BARRERA | Email: diego.galeano@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '13959717',
  'DIEGO FERNANDO GALEANO BARRERA',
  'diego.galeano@meridianecp.com',
  '3212060755',
  'Ingeniero de Petróleos',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90141005 del contrato Matriz No. 3037132',
  'MER-ODS-90141005-91-2025',
  '2025-04-01',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'diego.galeano@meridianecp.com'
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

-- Empleado: DAVID ALEJANDRO GARCIA CORONADO | Email: david.garcia@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1140847297',
  'DAVID ALEJANDRO GARCIA CORONADO',
  'david.garcia@meridianecp.com',
  '3005751696',
  'Ingeniero de Petróleos',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90141005 del contrato Matriz No. 3037132',
  'MER-ODS-90141005-83-2025',
  '2025-04-01',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'david.garcia@meridianecp.com'
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

-- Empleado: CHRISTIAN DAVID MENDOZA RAMIREZ | Email: christian.mendoza@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1082981742',
  'CHRISTIAN DAVID MENDOZA RAMIREZ',
  'christian.mendoza@meridianecp.com',
  '3006036245',
  'Ingeniero Químico',
  'Profesional Básico para la ejecución de actividades de la ODS No. 90141005 del contrato Matriz No. 3037132',
  'MER-ODS-90141005-106-2025',
  '2025-04-01',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'christian.mendoza@meridianecp.com'
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

-- Empleado: CESAR EDUARDO GARNICA GOMEZ | Email: cesar.garnica@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1101693549',
  'CESAR EDUARDO GARNICA GOMEZ',
  'cesar.garnica@meridianecp.com',
  '3173374883',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecución de actividades de la ODS No. 90141005 del contrato Matriz No. 3037132',
  'MER-ODS-90141005-101-2025',
  '2025-04-01',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'cesar.garnica@meridianecp.com'
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

-- Empleado: BRIGGITE SUSEC CAMACHO JEREZ | Email: briggite.camacho@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1098692205',
  'BRIGGITE SUSEC CAMACHO JEREZ',
  'briggite.camacho@meridianecp.com',
  '3186506670',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecución de actividades de la ODS No. 90141005 del contrato Matriz No. 3037132',
  'MER-ODS-90141005-100-2025',
  '2025-04-01',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'briggite.camacho@meridianecp.com'
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

-- Empleado: ALEJANDRO DUVAN LOPEZ ROJAS | Email: alejandro.lopez@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1121941649',
  'ALEJANDRO DUVAN LOPEZ ROJAS',
  'alejandro.lopez@meridianecp.com',
  '3214472738',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecución de actividades de la ODS No. 90141005 del contrato Matriz No. 3037132',
  'MER-ODS-90141005-89-2025',
  '2025-04-01',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'alejandro.lopez@meridianecp.com'
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

-- Empleado: CARLOS ESPINOSA LEON | Email: carlos.espinosa@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1098639151',
  'CARLOS ESPINOSA LEON',
  'carlos.espinosa@meridianecp.com',
  '3007761534',
  'Ingeniero de petróleos',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90172266 del contrato Matriz No. 3037132',
  'MER-ODS-90172266-111-2025',
  '2025-04-22',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'carlos.espinosa@meridianecp.com'
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

-- Empleado: DIEGO MAURICIO MARTINEZ BRAVO | Email: diego.martinez@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '80243783',
  'DIEGO MAURICIO MARTINEZ BRAVO',
  'diego.martinez@meridianecp.com',
  '3103012637',
  'Ingeniero de Petróleos',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90227898 del contrato Matriz No. 3037132',
  'MER-ODS-90227898-120-2025',
  '2025-06-13',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'diego.martinez@meridianecp.com'
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

-- Empleado: ANDRES MAURICIO GONZALEZ HERRERA | Email: amaogh@gmail.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1014181943',
  'ANDRES MAURICIO GONZALEZ HERRERA',
  'amaogh@gmail.com',
  '3007406165',
  'Ingeniera De Petróleos',
  'INGENIERO DE INTERVENCION A POZOS TIPO III',
  'MER-COM-ODS GRM-02-07 2025-08-2025',
  '2025-09-01',
  '2026-03-04',
  @NOW, @NOW
FROM users u
WHERE u.email = 'amaogh@gmail.com'
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

-- Empleado: MARYLUZ SANTAMARIA BECERRA | Email: maryluzsantamaria@hotmail.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '63501053',
  'MARYLUZ SANTAMARIA BECERRA',
  'maryluzsantamaria@hotmail.com',
  '3164170322',
  'Ingeniera De Sistemas',
  'SERVICIO ESPECIALIZADO EN COSTOS DE INTERVENCION DE POZOS TIPO I',
  'MER-COM-ODS GRM-02-07 2025-03-2025',
  '2025-09-01',
  '2026-03-04',
  @NOW, @NOW
FROM users u
WHERE u.email = 'maryluzsantamaria@hotmail.com'
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

-- Empleado: VIANI YORELY RUIZ GALINDO | Email: VIANIRUIZ@GMAIL.COM

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1115914145',
  'VIANI YORELY RUIZ GALINDO',
  'VIANIRUIZ@GMAIL.COM',
  '3108677402',
  'Ingenieria Ambiental',
  'SERVICIO ESPECIALIZADO EN COSTOS DE INTERVENCION DE POZOS TIPO II',
  'MER-COM-ODS GSS-01-06-2025-02-2025',
  '2025-09-01',
  '2026-03-04',
  @NOW, @NOW
FROM users u
WHERE u.email = 'VIANIRUIZ@GMAIL.COM'
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

-- Empleado: JULIO CESAR RODRIGUEZ APARICIO | Email: cesarjuliocesar1997@gmail.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1101695749',
  'JULIO CESAR RODRIGUEZ APARICIO',
  'cesarjuliocesar1997@gmail.com',
  '3143955091',
  'Ingeniera De Petróleos',
  'SERVICIO ESPECIALIZADO EN INTERVENCIONES A POZO TIPO II',
  'MER-COM-ODS GRM-02-07 2025-10-2025',
  '2025-09-01',
  '2026-03-04',
  @NOW, @NOW
FROM users u
WHERE u.email = 'cesarjuliocesar1997@gmail.com'
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

-- Empleado: JHONATAN ALEXANDER TORRES RODRIGUEZ | Email: jhonatantorresrdr@gmail.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1096202008',
  'JHONATAN ALEXANDER TORRES RODRIGUEZ',
  'jhonatantorresrdr@gmail.com',
  '3214781178',
  'Ingeniera De Petróleos',
  'SERVICIO ESPECIALIZADO EN INTERVENCIONES A POZO TIPO II',
  'MER-COM-ODS GRM-02-07 2025-07-2025',
  '2025-09-01',
  '2026-03-04',
  @NOW, @NOW
FROM users u
WHERE u.email = 'jhonatantorresrdr@gmail.com'
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

-- Empleado: MIGUEL ANGEL RIAÑO MOLINA | Email: miguelmolinave@gmail.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1015475289',
  'MIGUEL ANGEL RIAÑO MOLINA',
  'miguelmolinave@gmail.com',
  '3046737943',
  'Ingeniera De Petróleos',
  'INGENIERO ASISTENTE DE SUPERVISION INTEGRAL DE POZOS TIPO II',
  'MER-COM-ODS GSS-01-06-2025-03-2025',
  '2025-09-01',
  '2026-03-04',
  @NOW, @NOW
FROM users u
WHERE u.email = 'miguelmolinave@gmail.com'
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

-- Empleado: LAURA VANESSA CASTRO CARMONA | Email: laucastro212011@gmail.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1143388273',
  'LAURA VANESSA CASTRO CARMONA',
  'laucastro212011@gmail.com',
  '3024614380',
  'Ingeniera De Petróleos',
  'SERVICIO ESPECIALIZADO EN INTERVENCIONES A POZO TIPO II',
  'MER-COM-ODS GRM-02-07 2025-01-2025',
  '2025-09-01',
  '2026-03-04',
  @NOW, @NOW
FROM users u
WHERE u.email = 'laucastro212011@gmail.com'
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

-- Empleado: EDGARD MAURICIO ALVAREZ FRANCO | Email: GENIOALV@GMAIL.COM

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '88278069',
  'EDGARD MAURICIO ALVAREZ FRANCO',
  'GENIOALV@GMAIL.COM',
  '3162502207',
  'Ingeniero De Sistemas',
  'SERVICIO ESPECIALIZADO EN COSTOS DE INTERVENCION DE POZOS TIPO II',
  'MER-COM-ODS GRM-02-07 2025-06-2025',
  '2025-09-01',
  '2026-03-04',
  @NOW, @NOW
FROM users u
WHERE u.email = 'GENIOALV@GMAIL.COM'
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

-- Empleado: DIANIS CHAVEZ CAMPUZANO | Email: 01dianischavez@gmail.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1002465061',
  'DIANIS CHAVEZ CAMPUZANO',
  '01dianischavez@gmail.com',
  '3014063067',
  'Ingeniera De Petróleos',
  'SERVICIO ESPECIALIZADO EN INTEGRIDAD DE POZOS TIPO II',
  'MER-COM-ODS GRM-02-07 2025-18-2025',
  '2025-09-01',
  '2026-03-04',
  @NOW, @NOW
FROM users u
WHERE u.email = '01dianischavez@gmail.com'
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

-- Empleado: LAURA MARCELA ARENAS PEREZ | Email: lamarcela1289@gmail.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1098681142',
  'LAURA MARCELA ARENAS PEREZ',
  'lamarcela1289@gmail.com',
  '3144749142',
  'Ingeniera De Petróleos',
  'INGENIERO DE INTERVENCION A POZOS TIPO IV',
  'MER-COM-ODS GRM-02-07 2025-09-2025',
  '2025-09-01',
  '2026-03-04',
  @NOW, @NOW
FROM users u
WHERE u.email = 'lamarcela1289@gmail.com'
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

-- Empleado: YORGUIN DANIEL PEÑA LUGO | Email: yorguinp@hotmail.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '7317575',
  'YORGUIN DANIEL PEÑA LUGO',
  'yorguinp@hotmail.com',
  '3204927512',
  'Ingeniera De Petróleos',
  'SUPERVISOR INTEGRAL EN INTERVENCIONES A POZO TIPO II',
  'MER-COM-ODS GSS-01-06-2025-06-2025',
  '2025-09-01',
  '2026-03-04',
  @NOW, @NOW
FROM users u
WHERE u.email = 'yorguinp@hotmail.com'
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

-- Empleado: ANGELA MARIA TORO PATERNINA | Email: amtorop90@hotmail.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1037580568',
  'ANGELA MARIA TORO PATERNINA',
  'amtorop90@hotmail.com',
  '3155140472',
  'Ingeniera De Petróleos',
  'SERVICIO SOPORTE EN ABANDONO DE POZOS TIPO II',
  'MER-COM-ODS GRM-02-07 2025-04-2025',
  '2025-09-01',
  '2026-03-04',
  @NOW, @NOW
FROM users u
WHERE u.email = 'amtorop90@hotmail.com'
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

-- Empleado: YOJAN GIL GONZALEZ | Email: yojan35@hotmail.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1042212691',
  'YOJAN GIL GONZALEZ',
  'yojan35@hotmail.com',
  '3173759350',
  'Ingeniera De Petróleos',
  'INGENIERO DE INTERVENCION A POZOS TIPO IV',
  'MER-COM-ODS GRM-02-07 2025-17-2025',
  '2025-09-01',
  '2026-03-04',
  @NOW, @NOW
FROM users u
WHERE u.email = 'yojan35@hotmail.com'
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

-- Empleado: MAIRA ALEJANDRA VASQUEZ CORREA | Email: aleja.2017@outlook.es

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1096245598',
  'MAIRA ALEJANDRA VASQUEZ CORREA',
  'aleja.2017@outlook.es',
  '3178787627',
  'Ingeniera De Petróleos',
  'SERVICIO SOPORTE EN ABANDONO DE POZOS TIPO II',
  'MER-COM-ODS GRM-02-07 2025-14-2025',
  '2025-09-01',
  '2026-03-04',
  @NOW, @NOW
FROM users u
WHERE u.email = 'aleja.2017@outlook.es'
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

-- Empleado: JORGE ENRIQUE NIÑO SANTOS | Email: datolo90@hotmail.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1064838225',
  'JORGE ENRIQUE NIÑO SANTOS',
  'datolo90@hotmail.com',
  '3013058326',
  'Ingeniera De Petróleos',
  'SERVICIO ESPECIALIZADO EN COSTOS DE INTERVENCION DE POZOS TIPO I',
  'MER-COM-ODS GRM-02-07 2025-12-2025',
  '2025-09-01',
  '2026-03-04',
  @NOW, @NOW
FROM users u
WHERE u.email = 'datolo90@hotmail.com'
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

-- Empleado: CAMILO ANRES IBAÑEZ ROZO | Email: ingcamilo.ibanez@gmail.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1115914517',
  'CAMILO ANRES IBAÑEZ ROZO',
  'ingcamilo.ibanez@gmail.com',
  '3138609005',
  'Ingeniera De Petróleos',
  'INGENIERO DE INTERVENCION A POZOS TIPO IV',
  'MER-COM-ODS GSS-01-06-2025-10-2025',
  '2025-09-01',
  '2026-03-04',
  @NOW, @NOW
FROM users u
WHERE u.email = 'ingcamilo.ibanez@gmail.com'
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

-- Empleado: YESSICA VANESSA ALBA BELEÑO | Email: yessica.alba19@gmail.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1096208135',
  'YESSICA VANESSA ALBA BELEÑO',
  'yessica.alba19@gmail.com',
  '3159266614',
  'Ingeniera De Petróleos',
  'SERVICIO ESPECIALIZADO EN COSTOS DE INTERVENCION DE POZOS TIPO I',
  'MER-COM-ODS GRM-02-07 2025-15-2025',
  '2025-09-01',
  '2026-03-04',
  @NOW, @NOW
FROM users u
WHERE u.email = 'yessica.alba19@gmail.com'
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

-- Empleado: ALEX JHOAN GONZALEZ MORA | Email: ing.alexgonzalez@hotmail.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '80076686',
  'ALEX JHOAN GONZALEZ MORA',
  'ing.alexgonzalez@hotmail.com',
  '3052918714',
  'Ingeniera De Petróleos',
  'INGENIERO DE INTERVENCION A POZOS TIPO II',
  'MER-COM-ODS GSS-01-06-2025-11-2025',
  '2025-09-01',
  NULL,
  @NOW, @NOW
FROM users u
WHERE u.email = 'ing.alexgonzalez@hotmail.com'
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

-- Empleado: JUAN SEBASTIAN VALENCIA ORTEGA | Email: Juanseb89@hotmail.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1020427784',
  'JUAN SEBASTIAN VALENCIA ORTEGA',
  'Juanseb89@hotmail.com',
  '3128352851',
  'Ingeniero Industrial',
  'SERVICIO ESPECIALIZADO EN INTEGRIDAD DE POZOS TIPO I',
  'MER-COM-ODS GRM-02-07 2025-05-2025',
  '2025-09-01',
  '2026-03-04',
  @NOW, @NOW
FROM users u
WHERE u.email = 'Juanseb89@hotmail.com'
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

-- Empleado: PERLA MELISSA PINZÓN AGUDELO | Email: perlameli_92@hotmail.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1098727333',
  'PERLA MELISSA PINZÓN AGUDELO',
  'perlameli_92@hotmail.com',
  '3177227050',
  'Ingeniera De Petróleos',
  'INGENIERO DE INTERVENCION A POZOS TIPO III',
  'MER-COM-ODS GRM-02-07 2025-13-2025',
  '2025-09-01',
  '2026-03-04',
  @NOW, @NOW
FROM users u
WHERE u.email = 'perlameli_92@hotmail.com'
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

-- Empleado: ESTEBAN GARCIA ROJAS | Email: estebangr1987@gmail.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1077173073',
  'ESTEBAN GARCIA ROJAS',
  'estebangr1987@gmail.com',
  '3233969196',
  'Ingenieria Mecanica',
  'SUPERVISOR INTEGRAL EN INTERVENCIONES A POZO TIPO III',
  'MER-COM-ODS GSS-01-06-2025-01-2025',
  '2025-08-30',
  '2026-03-01',
  @NOW, @NOW
FROM users u
WHERE u.email = 'estebangr1987@gmail.com'
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

-- Empleado: PEDRO RAFAEL CADENA ORDOÑEZ | Email: pedro.cadena@outlook.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '13871188',
  'PEDRO RAFAEL CADENA ORDOÑEZ',
  'pedro.cadena@outlook.com',
  '3013630130',
  'Ingeniero De Software Y Telecomunicaciones',
  'SUPERVISOR INTEGRAL EN INTERVENCIONES A POZO TIPO I',
  'MER-COM-ODS GSS-01-06-2025-05-2025',
  '2025-08-30',
  '2026-03-01',
  @NOW, @NOW
FROM users u
WHERE u.email = 'pedro.cadena@outlook.com'
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

-- Empleado: CARLOS SAUL CELIS ACERO | Email: celiscarloss@gmail.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '7161987',
  'CARLOS SAUL CELIS ACERO',
  'celiscarloss@gmail.com',
  '3102699509',
  'Técnico profesional en procesos industriales',
  'SUPERVISOR INTEGRAL EN INTERVENCIONES A POZO TIPO I',
  'MER-COM-ODS GSS-01-06-2025-07-2025',
  '2025-08-30',
  '2026-03-01',
  @NOW, @NOW
FROM users u
WHERE u.email = 'celiscarloss@gmail.com'
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

-- Empleado: RICARDO JOSÉ CORREA CERRO | Email: ricardocorreacerro@gmail.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '18760161',
  'RICARDO JOSÉ CORREA CERRO',
  'ricardocorreacerro@gmail.com',
  '3167443534',
  'Ingeniera De Petróleos',
  'SUPERVISOR INTEGRAL EN INTERVENCIONES A POZO TIPO II',
  'MER-COM-ODS GSS-01-06-2025-04-2025',
  '2025-09-10',
  '2026-03-04',
  @NOW, @NOW
FROM users u
WHERE u.email = 'ricardocorreacerro@gmail.com'
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

-- Empleado: JULIO CESAR  ROMERO AREVALO | Email: julioromeroar@hotmail.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '88281896',
  'JULIO CESAR  ROMERO AREVALO',
  'julioromeroar@hotmail.com',
  '3164420135',
  'Ingeniero Mecánico',
  'Supervisor Integral En Intervenciones A Pozo Tipo I',
  'MER-COM-ODS GSS-01-06-2025-08-2025',
  '2025-09-16',
  '2026-03-03',
  @NOW, @NOW
FROM users u
WHERE u.email = 'julioromeroar@hotmail.com'
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

-- Empleado: CARLOS ANTONIO FONTALVO CARRASCAL | Email: carlosfontalvocarrascal@hotmail.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '73188189',
  'CARLOS ANTONIO FONTALVO CARRASCAL',
  'carlosfontalvocarrascal@hotmail.com',
  '3183476222',
  'Ingeniero de Petroleos',
  'SUPERVISOR INTEGRAL EN INTERVENCIONES A POZO TIPO II',
  'MER-COM-ODS GGS-01-062025-14-2025',
  '2025-09-23',
  '2026-03-03',
  @NOW, @NOW
FROM users u
WHERE u.email = 'carlosfontalvocarrascal@hotmail.com'
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

-- Empleado: DAYAN EDUARDO SUAREZ HIGUERA | Email: Dayansuarezh11@gmail.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1091668633',
  'DAYAN EDUARDO SUAREZ HIGUERA',
  'Dayansuarezh11@gmail.com',
  '3102619194',
  'Ingeniero Mecánico',
  'SERVICIO ESPECIALIZADO EN COSTOS DE INTERVENCION DE POZOS TIPO I',
  'MER-COM-ODS GRM-02-07 2025-19-2025',
  '2025-12-10',
  '2026-03-03',
  @NOW, @NOW
FROM users u
WHERE u.email = 'Dayansuarezh11@gmail.com'
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

-- Empleado: CHRISTIAN MAURICIO  PARDO CARRANZA | Email: christian.pardo@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1032467291',
  'CHRISTIAN MAURICIO  PARDO CARRANZA',
  'christian.pardo@meridianecp.com',
  '3166969988',
  'Ingeniero de Petróleos',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132',
  'MER-ODS-90578295-01-2026',
  '2026-01-01',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'christian.pardo@meridianecp.com'
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

-- Empleado: JOSE GABRIEL NASSAR DIAZ | Email: jose.nassar@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1098725794',
  'JOSE GABRIEL NASSAR DIAZ',
  'jose.nassar@meridianecp.com',
  '3166233088',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132',
  'MER-ODS-90578295-02-2026',
  '2026-01-01',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'jose.nassar@meridianecp.com'
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

-- Empleado: JAIME JOSÉ MARTÍNEZ VERTEL | Email: jaime.martinez@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1098755426',
  'JAIME JOSÉ MARTÍNEZ VERTEL',
  'jaime.martinez@meridianecp.com',
  '3102376098',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132',
  'MER-ODS-90578295-03-2026',
  '2026-01-01',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'jaime.martinez@meridianecp.com'
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

-- Empleado: ANA MARÍA CASTELLANOS BARRETO | Email: ana.castellanos@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '52455261',
  'ANA MARÍA CASTELLANOS BARRETO',
  'ana.castellanos@meridianecp.com',
  '3219970758',
  'Ingeniero de Petróleos',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132',
  'MER-ODS-90578295-04-2026',
  '2026-01-01',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'ana.castellanos@meridianecp.com'
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

-- Empleado: DIEGO FERNANDO PINTO HERNÁNDEZ | Email: diego.pinto@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1101692935',
  'DIEGO FERNANDO PINTO HERNÁNDEZ',
  'diego.pinto@meridianecp.com',
  '3143794371',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132',
  'MER-ODS-90578295-05-2026',
  '2026-01-01',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'diego.pinto@meridianecp.com'
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

-- Empleado: GLORIA FERNANDA VIDAL GONZÁLEZ | Email: gloria.vidal@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '51781946',
  'GLORIA FERNANDA VIDAL GONZÁLEZ',
  'gloria.vidal@meridianecp.com',
  '3157805737',
  'Geólogo',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132',
  'MER-ODS-90578295-06-2026',
  '2026-01-01',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'gloria.vidal@meridianecp.com'
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

-- Empleado: JESÚS IVÁN PACHECO ROMERO | Email: jesus.pacheco@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1091668362',
  'JESÚS IVÁN PACHECO ROMERO',
  'jesus.pacheco@meridianecp.com',
  '3006213973',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132',
  'MER-ODS-90578295-07-2026',
  '2026-01-01',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'jesus.pacheco@meridianecp.com'
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

-- Empleado: CESAR ELIECER RODRIGUEZ CAMELO | Email: cesar.rodriguez@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1065599609',
  'CESAR ELIECER RODRIGUEZ CAMELO',
  'cesar.rodriguez@meridianecp.com',
  '3005462735',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132',
  'MER-ODS-90578295-08-2026',
  '2026-01-01',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'cesar.rodriguez@meridianecp.com'
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

-- Empleado: PAOLA ANDREA GOMEZ CABRERA | Email: paola.gomez@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1016037506',
  'PAOLA ANDREA GOMEZ CABRERA',
  'paola.gomez@meridianecp.com',
  '3168735316',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132',
  'MER-ODS-90578295-09-2026',
  '2026-01-01',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'paola.gomez@meridianecp.com'
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

-- Empleado: LUIS CARLOS MONSALVE PARRA | Email: luis.monsalve@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1098683077',
  'LUIS CARLOS MONSALVE PARRA',
  'luis.monsalve@meridianecp.com',
  '3187441574',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132',
  'MER-ODS-90578295-10-2026',
  '2026-01-01',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'luis.monsalve@meridianecp.com'
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

-- Empleado: CARLOS RAFAEL OLMOS CARVAL | Email: carlos.olmos@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1047451443',
  'CARLOS RAFAEL OLMOS CARVAL',
  'carlos.olmos@meridianecp.com',
  '3012392187',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132',
  'MER-ODS-90578295-11-2026',
  '2026-01-01',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'carlos.olmos@meridianecp.com'
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

-- Empleado: NUBIA SOLANLLY REYES ÁVILA | Email: nubia.reyes@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '52423689',
  'NUBIA SOLANLLY REYES ÁVILA',
  'nubia.reyes@meridianecp.com',
  '3158130358',
  'Ingeniera de petróleos',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132',
  'MER-ODS-90578295-12-2026',
  '2026-01-01',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'nubia.reyes@meridianecp.com'
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

-- Empleado: MARIA ALEJANDRA MOJICA ARCINIEGAS | Email: maria.mojica@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1026255124',
  'MARIA ALEJANDRA MOJICA ARCINIEGAS',
  'maria.mojica@meridianecp.com',
  '3166215115',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132',
  'MER-ODS-90578295-13-2026',
  '2026-01-01',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'maria.mojica@meridianecp.com'
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

-- Empleado: DIANA MARCELA CACERES SALINAS | Email: diana.caceres@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '30405867',
  'DIANA MARCELA CACERES SALINAS',
  'diana.caceres@meridianecp.com',
  '3203003436',
  'Geóloga',
  'Profesional Junior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132',
  'MER-ODS-90578295-14-2026',
  '2026-01-01',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'diana.caceres@meridianecp.com'
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

-- Empleado: RAFAEL ALBERTO GUATAME APONTE | Email: rafael.guatame@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '80417936',
  'RAFAEL ALBERTO GUATAME APONTE',
  'rafael.guatame@meridianecp.com',
  '3157317066',
  'Geólogo',
  'Profesional Junior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132',
  'MER-ODS-90578295-15-2026',
  '2026-01-01',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'rafael.guatame@meridianecp.com'
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

-- Empleado: INA YADITH SERRANO LASTRE | Email: ina.serrano@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '63527981',
  'INA YADITH SERRANO LASTRE',
  'ina.serrano@meridianecp.com',
  '3134023172',
  'Ingeniero Químico',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90577837 del contrato Matriz No. 3037132',
  'MER-ODS-90577837-16-2026',
  '2026-01-01',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'ina.serrano@meridianecp.com'
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

-- Empleado: GUSTAVO ANDRES  BAUTISTA VELANDIA | Email: andres.bautista@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1013633604',
  'GUSTAVO ANDRES  BAUTISTA VELANDIA',
  'andres.bautista@meridianecp.com',
  '3134217276',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecucion de actividades de la ODS No. 90577770 del contrato Matriz No.3037132',
  'MER-ODS-90577770-19-2026',
  '2026-01-05',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'andres.bautista@meridianecp.com'
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

-- Empleado: JHON ABELARDO CUESTA ASPRILLA | Email: jhon.cuesta@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1003934174',
  'JHON ABELARDO CUESTA ASPRILLA',
  'jhon.cuesta@meridianecp.com',
  '3218467737',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecucion de actividades de la ODS No. 90577770 del contrato Matriz No.3037132',
  'MER-ODS-90577770-20-2026',
  '2026-01-05',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'jhon.cuesta@meridianecp.com'
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

-- Empleado: JOSE CARLOS GARCIA RUEDA | Email: jose.garcia@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1045706790',
  'JOSE CARLOS GARCIA RUEDA',
  'jose.garcia@meridianecp.com',
  '3114156922',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecucion de actividades de la ODS No. 90577770 del contrato Matriz No.3037132',
  'MER-ODS-90577770-21-2026',
  '2026-01-05',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'jose.garcia@meridianecp.com'
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

-- Empleado: EMMANUEL ROBLES ALBARRACÍN | Email: emmanuel.robles@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1098726424',
  'EMMANUEL ROBLES ALBARRACÍN',
  'emmanuel.robles@meridianecp.com',
  '3163835735',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecucion de actividades de la ODS No. 90577770 del contrato Matriz No.3037132',
  'MER-ODS-90577770-22-2026',
  '2026-01-05',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'emmanuel.robles@meridianecp.com'
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

-- Empleado: ANDRES FABIÁN AMAYA HERNANDEZ | Email: andres.amaya@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1098709932',
  'ANDRES FABIÁN AMAYA HERNANDEZ',
  'andres.amaya@meridianecp.com',
  '3008669991',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecucion de actividades de la ODS No. 90577770 del contrato Matriz No.3037132',
  'MER-ODS-90577770-24-2026',
  '2026-01-05',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'andres.amaya@meridianecp.com'
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

-- Empleado: MARÍA ANGÉLICA PRADA FONSECA | Email: angelica.prada@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1014262113',
  'MARÍA ANGÉLICA PRADA FONSECA',
  'angelica.prada@meridianecp.com',
  '3144498741',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecucion de actividades de la ODS No. 90577770 del contrato Matriz No.3037132',
  'MER-ODS-90577770-17-2026',
  '2026-01-05',
  '2026-07-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'angelica.prada@meridianecp.com'
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

-- Empleado: ESTEFANY LIZETH  VELANDIA JAIMES | Email: estefany.velandia@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1098745210',
  'ESTEFANY LIZETH  VELANDIA JAIMES',
  'estefany.velandia@meridianecp.com',
  '3154045354',
  'Geóloga',
  'Profesional Junior para la ejecucion de actividades de la ODS No. 90577770 del contrato Matriz No.3037132',
  'MER-ODS-90577770-18-2026',
  '2026-01-05',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'estefany.velandia@meridianecp.com'
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

-- Empleado: XIMENA ALEJANDRA  RODRIGUEZ FLOREZ | Email: ximena.rodriguez@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1075242729',
  'XIMENA ALEJANDRA  RODRIGUEZ FLOREZ',
  'ximena.rodriguez@meridianecp.com',
  '3002492506',
  'Ingeniera geóloga',
  'Profesional Senior para la ejecucion de actividades de la ODS No. 90577770 del contrato Matriz No.3037132',
  'MER-ODS-90577770-23-2026',
  '2026-01-05',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'ximena.rodriguez@meridianecp.com'
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

-- Empleado: DIEGO FERNANDO CASTILLO BAYONA | Email: diego.castillo@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1022380991',
  'DIEGO FERNANDO CASTILLO BAYONA',
  'diego.castillo@meridianecp.com',
  '3192191632',
  'Ingeniero de petróleos',
  'Profesional Senior para la ejecucion de actividades de la ODS No. 90594501 del contrato Matriz No.3037132',
  'MER-ODS-90594501-25-2026',
  '2026-01-08',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'diego.castillo@meridianecp.com'
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

-- Empleado: JUAN CARLOS DURAN ZAPATA | Email: juducaza@hotmail.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '13481943',
  'JUAN CARLOS DURAN ZAPATA',
  'juducaza@hotmail.com',
  '3104499919',
  'Ingeniero de petróleos',
  'SUPERVISOR INTEGRAL EN INTERVENCIONES A POZO TIPO II',
  'MER-COM-ODS GGS-01-062025-18-2025',
  '2026-01-08',
  '2026-03-03',
  @NOW, @NOW
FROM users u
WHERE u.email = 'juducaza@hotmail.com'
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

-- Empleado: CARLOS ALEJANDRO  FORERO PEÑA | Email: carlos.forero@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1014216060',
  'CARLOS ALEJANDRO  FORERO PEÑA',
  'carlos.forero@meridianecp.com',
  '3175768857',
  'Ingeniero de Petróleos',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90590325 del contrato Matriz No. 3037132',
  'MER-ODS-90590325-30-2026',
  '2026-01-13',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'carlos.forero@meridianecp.com'
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

-- Empleado: ALEXANDRA ISABEL  MESA CARDENAS | Email: alexandra.mesa@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '43728382',
  'ALEXANDRA ISABEL  MESA CARDENAS',
  'alexandra.mesa@meridianecp.com',
  '3102046026',
  'Ingeniero de Petróleos',
  'Profesional Especialista para la ejecución de actividades de la ODS No. 90590325 del contrato Matriz No. 3037132',
  'MER-ODS-90590325-32-2026',
  '2026-01-13',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'alexandra.mesa@meridianecp.com'
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

-- Empleado: EDNA MILED  NIÑO OROZCO | Email: edna.nino@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '52844528',
  'EDNA MILED  NIÑO OROZCO',
  'edna.nino@meridianecp.com',
  '3112978636',
  'Geóloga',
  'Profesional Especialista para la ejecución de actividades de la ODS No. 90590325 del contrato Matriz No. 3037132',
  'MER-ODS-90590325-33-2026',
  '2026-01-13',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'edna.nino@meridianecp.com'
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

-- Empleado: DIANA PAOLA  SOLANO SUA | Email: diana.solano@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '52967140',
  'DIANA PAOLA  SOLANO SUA',
  'diana.solano@meridianecp.com',
  '3015808137',
  'Ingeniero de Petróleos',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90590325 del contrato Matriz No. 3037132',
  'MER-ODS-90590325-34-2026',
  '2026-01-13',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'diana.solano@meridianecp.com'
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

-- Empleado: JOSÉ ANDRÉS  ANAYA MANCIPE | Email: andres.anaya@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '91524899',
  'JOSÉ ANDRÉS  ANAYA MANCIPE',
  'andres.anaya@meridianecp.com',
  '3158608522',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecucion de actividades de la ODS No.90600752  del contrato Matriz No.3037132',
  'MER-ODS-90600752-28-2026',
  '2026-01-13',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'andres.anaya@meridianecp.com'
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

-- Empleado: GABRIEL EDUARDO VÉLEZ BARRERA | Email: gabriel.velez@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1115069820',
  'GABRIEL EDUARDO VÉLEZ BARRERA',
  'gabriel.velez@meridianecp.com',
  '3007087857',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecucion de actividades de la ODS No. 90600752 del contrato Matriz No.3037132',
  'MER-ODS-90600752-27-2026',
  '2026-01-13',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'gabriel.velez@meridianecp.com'
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

-- Empleado: JUAN MATEO  CORDOBA WAGNER | Email: juanmateo.cordoba@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1151954545',
  'JUAN MATEO  CORDOBA WAGNER',
  'juanmateo.cordoba@meridianecp.com',
  '3185323857',
  'Ingeniero de Petróleos',
  'Profesional Senior para la ejecucion de actividades de la ODS No. 90600752 del contrato Matriz No.3037132',
  'MER-ODS-90600752-26-2026',
  '2026-01-13',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'juanmateo.cordoba@meridianecp.com'
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

-- Empleado: MARIA HIMELDA MURILLO LOPEZ | Email: maria.murillo@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '37546080',
  'MARIA HIMELDA MURILLO LOPEZ',
  'maria.murillo@meridianecp.com',
  '3108586179',
  'Geóloga',
  'Profesional Senior para la ejecucion de actividades de la ODS No. 90600752 del contrato Matriz No.3037132',
  'MER-ODS-90600752-29-2026',
  '2026-01-13',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'maria.murillo@meridianecp.com'
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

-- Empleado: ADRIANA PATRICIA DUEÑES GARCES | Email: adriana.duenes@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '63540751',
  'ADRIANA PATRICIA DUEÑES GARCES',
  'adriana.duenes@meridianecp.com',
  '3168691669',
  'Geólogo',
  'Profesional Especialista para la ejecución de actividades de la ODS No. 90560321 del contrato Matriz No. 3037132',
  'MER-ODS-90560321-53-2026',
  '2026-01-16',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'adriana.duenes@meridianecp.com'
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

-- Empleado: MARIO AUGUSTO MORENO CASTELLANOS | Email: mario.moreno@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '13720871',
  'MARIO AUGUSTO MORENO CASTELLANOS',
  'mario.moreno@meridianecp.com',
  '3208889081',
  'Geólogo',
  'Profesional Especialista para la ejecución de actividades de la ODS No. 90560321 del contrato Matriz No. 3037132',
  'MER-ODS-90560321-54-2026',
  '2026-01-16',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'mario.moreno@meridianecp.com'
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

-- Empleado: SERGIO FERNANDO POVEDA SALAZAR | Email: sergio.poveda@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1007555164',
  'SERGIO FERNANDO POVEDA SALAZAR',
  'sergio.poveda@meridianecp.com',
  '3015198066',
  'Geólogo',
  'Profesional Básico para la ejecución de actividades de la ODS No. 90560321 del contrato Matriz No. 3037132',
  'MER-ODS-90560321-46-2026',
  '2026-01-16',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'sergio.poveda@meridianecp.com'
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

-- Empleado: JULIO CESAR  FIGUEROA VEGA | Email: julio.figueroa@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '13740129',
  'JULIO CESAR  FIGUEROA VEGA',
  'julio.figueroa@meridianecp.com',
  '3022586566',
  'Geólogo',
  'Profesional Senior para la ejecucion de actividades de la ODS No. 90560321 del contrato Matriz No.3037132',
  'MER-ODS-90560321-47-2026',
  '2026-01-16',
  '2026-06-30',
  @NOW, @NOW
FROM users u
WHERE u.email = 'julio.figueroa@meridianecp.com'
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

-- Empleado: JORGE EDUARDO PAIBA ALZATE | Email: jorge.paiba@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '75101511',
  'JORGE EDUARDO PAIBA ALZATE',
  'jorge.paiba@meridianecp.com',
  '3155056633',
  'Biológo',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90560321 del contrato Matriz No. 3037132',
  'MER-ODS-90560321-48-2026',
  '2026-01-16',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'jorge.paiba@meridianecp.com'
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

-- Empleado: JULLY MARCELA ORTEGON BARRERA | Email: jully.ortegon@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '63536247',
  'JULLY MARCELA ORTEGON BARRERA',
  'jully.ortegon@meridianecp.com',
  '3167194344',
  'Geólogo',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90560321 del contrato Matriz No. 3037132',
  'MER-ODS-90560321-49-2026',
  '2026-01-16',
  '2026-06-30',
  @NOW, @NOW
FROM users u
WHERE u.email = 'jully.ortegon@meridianecp.com'
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

-- Empleado: EDWIN FABIAN MAYORGA LOPEZ | Email: edwin.mayorga@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1013634120',
  'EDWIN FABIAN MAYORGA LOPEZ',
  'edwin.mayorga@meridianecp.com',
  '3114985755',
  'Licenciado en Física - MSc Geofísica',
  'Profesional Junior para la ejecución de actividades de la ODS No. 90560321 del contrato Matriz No. 3037132',
  'MER-ODS-90560321-50-2026',
  '2026-01-16',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'edwin.mayorga@meridianecp.com'
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

-- Empleado: MAURICIO ANDRES VASQUEZ PINTO | Email: mauricio.vasquez@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '91532360',
  'MAURICIO ANDRES VASQUEZ PINTO',
  'mauricio.vasquez@meridianecp.com',
  '3003044721',
  'Geologo',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90560321 del contrato Matriz No. 3037132',
  'MER-ODS-90560321-51-2026',
  '2026-01-16',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'mauricio.vasquez@meridianecp.com'
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

-- Empleado: OSCAR FABIAN SUAREZ SUAREZ | Email: oscar.suarez@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1098733967',
  'OSCAR FABIAN SUAREZ SUAREZ',
  'oscar.suarez@meridianecp.com',
  '3161567895',
  'Ingeniero de Petróleos',
  'Profesional Senior para la ejecucion de actividades de la ODS No. 90560321 del contrato Matriz No.3037132',
  'MER-ODS-90560321-52-2026',
  '2026-01-16',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'oscar.suarez@meridianecp.com'
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

-- Empleado: JUAN DAVID ARISTIZABAL MARULANDA | Email: juandavid.aristizabal@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1026267749',
  'JUAN DAVID ARISTIZABAL MARULANDA',
  'juandavid.aristizabal@meridianecp.com',
  '3156168706',
  'Ingeniero Químico',
  'Profesional Junior para la ejecucion de actividades de la ODS No. 90598918 del contrato Matriz No.3037132',
  'MER-ODS-90598918-35-2026',
  '2026-01-16',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'juandavid.aristizabal@meridianecp.com'
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

-- Empleado: NICOLAS AVENDAÑO VASQUEZ | Email: nicolas.avendano@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1023961699',
  'NICOLAS AVENDAÑO VASQUEZ',
  'nicolas.avendano@meridianecp.com',
  '3166181606',
  'Ingeniero de Petróleos',
  'Profesional Básico para la ejecución de actividades de la ODS No. 90598918 del contrato Matriz No. 3037132',
  'MER-ODS-90598918-36-2026',
  '2026-01-16',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'nicolas.avendano@meridianecp.com'
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

-- Empleado: CAMILO ANDRES SANTANA OTALORA | Email: camilo.santana@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1026292916',
  'CAMILO ANDRES SANTANA OTALORA',
  'camilo.santana@meridianecp.com',
  '3108526871',
  'Ingeniero de Petróleos / Ingeniero Químico',
  'Profesional Básico para la ejecución de actividades de la ODS No. 90598918 del contrato Matriz No. 3037132',
  'MER-ODS-90598918-37-2026',
  '2026-01-16',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'camilo.santana@meridianecp.com'
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

-- Empleado: YESSICA DEL CARMEN  MATEUS TARAZONA | Email: yessica.tarazona@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1098663190',
  'YESSICA DEL CARMEN  MATEUS TARAZONA',
  'yessica.tarazona@meridianecp.com',
  '3228437251',
  'Ingeniero de Petróleos',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90598918 del contrato Matriz No. 3037132',
  'MER-ODS-90598918-38-2026',
  '2026-01-16',
  '2026-07-15',
  @NOW, @NOW
FROM users u
WHERE u.email = 'yessica.tarazona@meridianecp.com'
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

-- Empleado: JORGE FELIPE ALARCON TORRES | Email: jorge.alarcon@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1020792684',
  'JORGE FELIPE ALARCON TORRES',
  'jorge.alarcon@meridianecp.com',
  '3022867803',
  'Ingeniero de petróleos',
  'Profesional Junior para la ejecución de actividades de la ODS No. 90598918 del contrato Matriz No. 3037132',
  'MER-ODS-90598918-39-2026',
  '2026-01-16',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'jorge.alarcon@meridianecp.com'
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

-- Empleado: JESUS DAVID ARENAS NAVARRO | Email: jesus.arenas@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '91520047',
  'JESUS DAVID ARENAS NAVARRO',
  'jesus.arenas@meridianecp.com',
  '3183544282',
  'Geólogo',
  'Profesional Junior para la ejecucion de actividades de la ODS No. 90598918 del contrato Matriz No.3037132',
  'MER-ODS-90598918-40-2026',
  '2026-01-16',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'jesus.arenas@meridianecp.com'
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

-- Empleado: ALEJANDRA ARBELAEZ LONDOÑO | Email: alejandra.arbelaez@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '43578774',
  'ALEJANDRA ARBELAEZ LONDOÑO',
  'alejandra.arbelaez@meridianecp.com',
  '3006163730',
  'Ingeniero de Petróleos',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90598918 del contrato Matriz No. 3037132',
  'MER-ODS-90598918-41-2026',
  '2026-01-16',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'alejandra.arbelaez@meridianecp.com'
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

-- Empleado: GIOVANNI MARTINEZ LEONES | Email: giovanni.martinez@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1143327261',
  'GIOVANNI MARTINEZ LEONES',
  'giovanni.martinez@meridianecp.com',
  '3016620595',
  'Ingeniero de Sistemas',
  'Profesional Junior para la ejecución de actividades de la ODS No. 90598918 del contrato Matriz No. 3037132',
  'MER-ODS-90598918-42-2026',
  '2026-01-16',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'giovanni.martinez@meridianecp.com'
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

-- Empleado: OSCAR IVAN JIMENEZ BARANDICA | Email: oscar.jimenez@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1098719174',
  'OSCAR IVAN JIMENEZ BARANDICA',
  'oscar.jimenez@meridianecp.com',
  '3157059227',
  'Ingeniero Electrónico',
  'Profesional Junior para la ejecución de actividades de la ODS No. 90598918 del contrato Matriz No. 3037132',
  'MER-ODS-90598918-43-2026',
  '2026-01-16',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'oscar.jimenez@meridianecp.com'
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

-- Empleado: RUBEN DARIO ORTIZ MURCIA | Email: ruben.ortiz@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1072699593',
  'RUBEN DARIO ORTIZ MURCIA',
  'ruben.ortiz@meridianecp.com',
  '3144574949-3156600881',
  'Ingeniero de Petróleos',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90599358 del contrato Matriz No. 3037132',
  'MER-ODS-90599358-44-2026',
  '2026-01-16',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'ruben.ortiz@meridianecp.com'
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

-- Empleado: JUAN SEBASTIAN AVILA PARRA | Email: juan.avila@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1098782789',
  'JUAN SEBASTIAN AVILA PARRA',
  'juan.avila@meridianecp.com',
  '3105854019',
  'Ing. de Petróleos - Geólogo',
  'Profesional Junior para la ejecucion de actividades de la ODS No. 90599358 del contrato Matriz No.3037132',
  'MER-ODS-90599358-45-2026',
  '2026-01-16',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'juan.avila@meridianecp.com'
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

-- Empleado: LILIANA MARTINEZ URIBE | Email: liliana.martinez@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '24332450',
  'LILIANA MARTINEZ URIBE',
  'liliana.martinez@meridianecp.com',
  '3102553497',
  'Geólogo',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90599358 del contrato Matriz No. 3037132',
  'MER-ODS-90599358-55-2026',
  '2026-01-16',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'liliana.martinez@meridianecp.com'
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

-- Empleado: FRANKLIN ALEJANDRO BOTERO RIVERA | Email: alejandro.botero@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1010167959',
  'FRANKLIN ALEJANDRO BOTERO RIVERA',
  'alejandro.botero@meridianecp.com',
  '3046364482',
  'Ingeniero de Petróleos',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90599924 del contrato Matriz No. 3037132',
  'MER-ODS-90599924-56-2026',
  '2026-01-16',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'alejandro.botero@meridianecp.com'
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

-- Empleado: DANIELA MOLINA LANDINEZ | Email: daniela.molina@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1075293846',
  'DANIELA MOLINA LANDINEZ',
  'daniela.molina@meridianecp.com',
  '3123109391',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecucion de actividades de la ODS No. 90599924 del contrato Matriz No.3037132',
  'MER-ODS-90599924-57-2026',
  '2026-01-16',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'daniela.molina@meridianecp.com'
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

-- Empleado: JESUS ERNESTO COQUECO VARGAS | Email: jesus.coqueco@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1075263195',
  'JESUS ERNESTO COQUECO VARGAS',
  'jesus.coqueco@meridianecp.com',
  '3209113396',
  'Ingeniero de Petróleos',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90599924 del contrato Matriz No. 3037132',
  'MER-ODS-90599924-58-2026',
  '2026-01-16',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'jesus.coqueco@meridianecp.com'
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

-- Empleado: ALEXANDRA KATHERINE LONDOÑO CAMACHO | Email: alexandra.londono@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1098761186',
  'ALEXANDRA KATHERINE LONDOÑO CAMACHO',
  'alexandra.londono@meridianecp.com',
  '3162343563',
  'Ingeniera de petróleos',
  'Profesional Junior para la ejecución de actividades de la ODS No. 90599924 del contrato Matriz No. 3037132',
  'MER-ODS-90599924-59-2026',
  '2026-01-16',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'alexandra.londono@meridianecp.com'
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

-- Empleado: MARIA ALEJANDRA  GIRALDO MUÑOZ | Email: maria.giraldo@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1017211010',
  'MARIA ALEJANDRA  GIRALDO MUÑOZ',
  'maria.giraldo@meridianecp.com',
  '3017742634',
  'Ingeniera de petróleos',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90599924 del contrato Matriz No. 3037132',
  'MER-ODS-90599924-60-2026',
  '2026-01-16',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'maria.giraldo@meridianecp.com'
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

-- Empleado: LENIN  CORDOBA RIVAS | Email: lenin.cordoba@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1075239408',
  'LENIN  CORDOBA RIVAS',
  'lenin.cordoba@meridianecp.com',
  '3214568903',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecución de actividades de la ODS No. 90599924 del contrato Matriz No. 3037132',
  'MER-ODS-90599924-61-2026',
  '2026-01-16',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'lenin.cordoba@meridianecp.com'
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

-- Empleado: JAVIER ENRIQUE GUERRERO ARRIETA | Email: javier.guerrero@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1081820719',
  'JAVIER ENRIQUE GUERRERO ARRIETA',
  'javier.guerrero@meridianecp.com',
  '3004958242',
  'Ingeniero de petróleos',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90599924 del contrato Matriz No. 3037132',
  'MER-ODS-90599924-62-2026',
  '2026-01-16',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'javier.guerrero@meridianecp.com'
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

-- Empleado: YOHANEY LUCIA GOMEZ GALARZA | Email: yohaney.gomez@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '52556069',
  'YOHANEY LUCIA GOMEZ GALARZA',
  'yohaney.gomez@meridianecp.com',
  '3153934777',
  'Ingeniera de Petroleos',
  'Profesional Senior para la ejecucion de actividades de la ODS No. 1661981  del contrato Matriz No.3037132',
  'MER-ODS-1661981-63-2026',
  NULL,
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'yohaney.gomez@meridianecp.com'
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

-- Empleado: LAURA MARIA  HERNANDEZ RIVEROS | Email: laura.hernandez@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1032414423',
  'LAURA MARIA  HERNANDEZ RIVEROS',
  'laura.hernandez@meridianecp.com',
  '3235904772',
  'Ingeniero de Petróleos',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90590325 del contrato Matriz No. 3037132',
  'MER-ODS-90590325-31-2026',
  '2026-01-19',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'laura.hernandez@meridianecp.com'
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

-- Empleado: CINDY NATALIA ISAZA TORO | Email: cindy.isaza@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1128452509',
  'CINDY NATALIA ISAZA TORO',
  'cindy.isaza@meridianecp.com',
  '3053271677',
  'Ingeniero de Petróleos',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90612258 del contrato Matriz No. 3037132',
  'MER-ODS-90612258-64-2026',
  '2026-01-20',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'cindy.isaza@meridianecp.com'
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

-- Empleado: CHRISTIAN CAMILO RIVERA SANCHEZ | Email: christian.rivera@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1013629348',
  'CHRISTIAN CAMILO RIVERA SANCHEZ',
  'christian.rivera@meridianecp.com',
  '3115546422',
  'Ingeniero de Petróleos',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90612258 del contrato Matriz No. 3037132',
  'MER-ODS-90612258-65-2026',
  '2026-01-20',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'christian.rivera@meridianecp.com'
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

-- Empleado: MARIA ALEJANDRA JOYA RINCON | Email: alejandra.joya@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1098697791',
  'MARIA ALEJANDRA JOYA RINCON',
  'alejandra.joya@meridianecp.com',
  '3158471823',
  'Geólogo',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90045724 del contrato Matriz No. 3037132',
  'MER-ODS-90599358-66-2026',
  '2026-01-20',
  '2026-04-19',
  @NOW, @NOW
FROM users u
WHERE u.email = 'alejandra.joya@meridianecp.com'
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

-- Empleado: CRISTINA CARO VELEZ | Email: cristina.caro@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1039448281',
  'CRISTINA CARO VELEZ',
  'cristina.caro@meridianecp.com',
  '3187120087',
  'Ingeniero de Petróleos',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90049330 del contrato Matriz No. 3037132',
  'MER-ODS-90049330-67-2026',
  '2026-01-26',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'cristina.caro@meridianecp.com'
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

-- Empleado: MELINA ANDREA  RIVERA MANRIQUE | Email: melina.rivera@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1075215815',
  'MELINA ANDREA  RIVERA MANRIQUE',
  'melina.rivera@meridianecp.com',
  '3134024281',
  'Ingeniero de Petróleos',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90049330 del contrato Matriz No. 3037132',
  'MER-ODS-90049330-68-2026',
  '2026-01-26',
  '2026-03-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'melina.rivera@meridianecp.com'
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

-- Empleado: MARIANN LISSETTE MAHECHA LAVERDE | Email: mariann.mahecha@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1075212439',
  'MARIANN LISSETTE MAHECHA LAVERDE',
  'mariann.mahecha@meridianecp.com',
  '3164987258',
  'Ingeniera de Petróleos',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90632454 del contrato Matriz No. 3037132',
  'MER-ODS-90632454-69-2026',
  '2026-01-27',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'mariann.mahecha@meridianecp.com'
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

-- Empleado: ZENAIDA DEL VALLE MARCANO DE VILLARROEL | Email: zenaida.marcano@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '478731',
  'ZENAIDA DEL VALLE MARCANO DE VILLARROEL',
  'zenaida.marcano@meridianecp.com',
  '3057684591',
  'Ingeniero en Petróleo',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90598546 del contrato Matriz No. 3037132',
  'MER-ODS-90598546-70-2026',
  '2026-01-28',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'zenaida.marcano@meridianecp.com'
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

-- Empleado: GERMAN DARIO OREJARENA ESCOBAR | Email: german.orejarena@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '91514446',
  'GERMAN DARIO OREJARENA ESCOBAR',
  'german.orejarena@meridianecp.com',
  '3164954753',
  'Geólogo',
  'Profesional Senior para la ejecucion de actividades de la ODS No. 90642057 del contrato Matriz No.3037132',
  'MER-ODS-90642057-71-2026',
  '2026-02-02',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'german.orejarena@meridianecp.com'
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

-- Empleado: RICARDO GAVIRIA GARCIA | Email: ricardo.gaviria@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '79686130',
  'RICARDO GAVIRIA GARCIA',
  'ricardo.gaviria@meridianecp.com',
  '3243242116',
  'Ingeniero de Petróleos',
  'Profesional Senior para la ejecucion de actividades de la ODS No. 90642057 del contrato Matriz No.3037132',
  'MER-ODS-90642057-72-2026',
  '2026-02-02',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'ricardo.gaviria@meridianecp.com'
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

-- Empleado: HUGO QUIROGA CRUZ | Email: hugo.quiroga@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '71787712',
  'HUGO QUIROGA CRUZ',
  'hugo.quiroga@meridianecp.com',
  '3187401374',
  'Ingeniero de Petróleos',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90577770 del contrato Matriz No. 3037132',
  'MER-ODS-90577770-73-2026',
  '2026-02-02',
  '2026-08-01',
  @NOW, @NOW
FROM users u
WHERE u.email = 'hugo.quiroga@meridianecp.com'
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

-- Empleado: JEAN PABLO CEDEÑO ORFILA | Email: jean.cedeno@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1016597',
  'JEAN PABLO CEDEÑO ORFILA',
  'jean.cedeno@meridianecp.com',
  '3015428536',
  'Ingeniero de Petróleos',
  'Profesional Senior para la ejecución de actividades de la ODS No. 90658180 del contrato Matriz No. 3037132',
  'MER-ODS-90658180-74-2026',
  '2026-02-05',
  '2026-05-04',
  @NOW, @NOW
FROM users u
WHERE u.email = 'jean.cedeno@meridianecp.com'
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

-- Empleado: YUBER RODRIGUEZ ARTURO | Email: yuber.rodriguez@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1087047704',
  'YUBER RODRIGUEZ ARTURO',
  'yuber.rodriguez@meridianecp.com',
  '3128357827',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecucion de actividades de la ODS No. 90658180 del contrato Matriz No. 3037132',
  'MER-ODS-90658180-75-2026',
  '2026-02-05',
  '2026-05-04',
  @NOW, @NOW
FROM users u
WHERE u.email = 'yuber.rodriguez@meridianecp.com'
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

-- Empleado: KELLY LORENA DIEZ HERNANDEZ | Email: kelly.diez@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1040746072',
  'KELLY LORENA DIEZ HERNANDEZ',
  'kelly.diez@meridianecp.com',
  '3053189327',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecucion de actividades de la ODS No. 90658180 del contrato Matriz No. 3037132',
  'MER-ODS-90658180-76-2026',
  '2026-02-05',
  '2026-05-04',
  @NOW, @NOW
FROM users u
WHERE u.email = 'kelly.diez@meridianecp.com'
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

-- Empleado: LUIS ALBERTO CHINOMES GUALDRON | Email: luis.chinomes@meridianecp.com

INSERT INTO employee_profiles (
  user_id, external_employee_id, full_name, corporate_email, phone,
  profession, job_title, contract_type, hire_date, contract_end_date,
  created_at, updated_at
)
SELECT
  u.id,
  '1098802405',
  'LUIS ALBERTO CHINOMES GUALDRON',
  'luis.chinomes@meridianecp.com',
  '3246306301',
  'Ingeniero de Petróleos',
  'Profesional Junior para la ejecución de actividades de la ODS No. 90599924 del contrato Matriz No. 3037132',
  'MER-ODS-90599924-77-2026',
  '2026-02-13',
  '2026-08-31',
  @NOW, @NOW
FROM users u
WHERE u.email = 'luis.chinomes@meridianecp.com'
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

-- =========================================================
-- 3) service_order_employees (asignación empleado ↔ ODS)
--    Inserta por ODS (service_orders.ods_code) y user por email.
-- =========================================================

-- Asignación: CAMILA FERNANDA MEDINA SANDOVAL | camila.medina@meridianecp.com -> ODS 90045724

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'camila.medina@meridianecp.com'
WHERE so.ods_code = '90045724'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: AURA MARIA TRASLAVIÑA PRADA | aura.traslavina@meridianecp.com -> ODS 90578295

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'aura.traslavina@meridianecp.com'
WHERE so.ods_code = '90578295'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: WILLIAM CABRERA CASTRO | wcabrera@meridianecp.com -> ODS 90049330

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'wcabrera@meridianecp.com'
WHERE so.ods_code = '90049330'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: SEBASTIAN LLANOS GALLO | sebastian.llanos@meridianecp.com -> ODS 90049330

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'sebastian.llanos@meridianecp.com'
WHERE so.ods_code = '90049330'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: OVEIMAR SANTAMARIA TORRES | oveimar.santamaria@meridianecp.com -> ODS 90049330

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'oveimar.santamaria@meridianecp.com'
WHERE so.ods_code = '90049330'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: LADY MILENA LOPEZ ROJAS | lady.lopez@meridian.com.co -> ODS 90049330

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'lady.lopez@meridian.com.co'
WHERE so.ods_code = '90049330'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: JULLY ALEXANDRA VARGAS QUINTERO | jully.vargas@meridianecp.com -> ODS 90049330

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'jully.vargas@meridianecp.com'
WHERE so.ods_code = '90049330'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: ESPERANZA DE JESUS COTES LEON | esperanza.cotes@meridianecp.com -> ODS 90049330

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'esperanza.cotes@meridianecp.com'
WHERE so.ods_code = '90049330'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: EMELI YOHANA YACELGA CHITAN | Emeli.yacelga@meridianecp.com -> ODS 90049330

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'Emeli.yacelga@meridianecp.com'
WHERE so.ods_code = '90049330'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: CARLOS JOSE URZOLA EBRATT | carlos.urzola@meridianecp.com -> ODS 90049330

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'carlos.urzola@meridianecp.com'
WHERE so.ods_code = '90049330'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: LEONARDO   FRANCO GRAJALES | leonardo.franco@meridianecp.com -> ODS 90049330

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'leonardo.franco@meridianecp.com'
WHERE so.ods_code = '90049330'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: WILMAR ANDRES DE LA HOZ GAMBOA | wilmar.delahoz@meridianecp.com -> ODS 90049330

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'wilmar.delahoz@meridianecp.com'
WHERE so.ods_code = '90049330'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: OLMER ANDRES MORALES MORA | andres.morales@meridianecp.com -> ODS 90141005

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'andres.morales@meridianecp.com'
WHERE so.ods_code = '90141005'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: MONICA DEL PILAR MARTINEZ VERA | monica.martinez@meridianecp.com -> ODS 90141005

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'monica.martinez@meridianecp.com'
WHERE so.ods_code = '90141005'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: MILTON JULIAN GUALTEROS QUIROGA | milton.gualteros@meridianecp.com -> ODS 90141005

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'milton.gualteros@meridianecp.com'
WHERE so.ods_code = '90141005'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: LIZETH DAYANA BAUTISTA RICO | lizeth.bautista@meridianecp.com -> ODS 90141005

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'lizeth.bautista@meridianecp.com'
WHERE so.ods_code = '90141005'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: JULIÁN ANDRÉS HERNÁNDEZ PINTO | julian.hernandez@meridianecp.com -> ODS 90141005

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'julian.hernandez@meridianecp.com'
WHERE so.ods_code = '90141005'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: JHON HARVEY CARREÑO HERNANDEZ | jhon.carreno@meridianecp.com -> ODS 90141005

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'jhon.carreno@meridianecp.com'
WHERE so.ods_code = '90141005'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: IVAN DARIO MOZO MORENO | ivan.mozo@meridianecp.com -> ODS 90141005

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'ivan.mozo@meridianecp.com'
WHERE so.ods_code = '90141005'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: GEISSON RENÉ ZAFRA URREA | geisson.zafra@meridianecp.com -> ODS 90141005

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'geisson.zafra@meridianecp.com'
WHERE so.ods_code = '90141005'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: DIEGO FERNANDO GALEANO BARRERA | diego.galeano@meridianecp.com -> ODS 90141005

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'diego.galeano@meridianecp.com'
WHERE so.ods_code = '90141005'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: DAVID ALEJANDRO GARCIA CORONADO | david.garcia@meridianecp.com -> ODS 90141005

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'david.garcia@meridianecp.com'
WHERE so.ods_code = '90141005'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: CHRISTIAN DAVID MENDOZA RAMIREZ | christian.mendoza@meridianecp.com -> ODS 90141005

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'christian.mendoza@meridianecp.com'
WHERE so.ods_code = '90141005'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: CESAR EDUARDO GARNICA GOMEZ | cesar.garnica@meridianecp.com -> ODS 90141005

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'cesar.garnica@meridianecp.com'
WHERE so.ods_code = '90141005'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: BRIGGITE SUSEC CAMACHO JEREZ | briggite.camacho@meridianecp.com -> ODS 90141005

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'briggite.camacho@meridianecp.com'
WHERE so.ods_code = '90141005'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: ALEJANDRO DUVAN LOPEZ ROJAS | alejandro.lopez@meridianecp.com -> ODS 90141005

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'alejandro.lopez@meridianecp.com'
WHERE so.ods_code = '90141005'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: CARLOS ESPINOSA LEON | carlos.espinosa@meridianecp.com -> ODS 90172266

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'carlos.espinosa@meridianecp.com'
WHERE so.ods_code = '90172266'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: DIEGO MAURICIO MARTINEZ BRAVO | diego.martinez@meridianecp.com -> ODS 90227898

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'diego.martinez@meridianecp.com'
WHERE so.ods_code = '90227898'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: ANDRES MAURICIO GONZALEZ HERRERA | amaogh@gmail.com -> ODS GRM-02-07-202

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'amaogh@gmail.com'
WHERE so.ods_code = 'GRM-02-07-202'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: MARYLUZ SANTAMARIA BECERRA | maryluzsantamaria@hotmail.com -> ODS GRM-02-07-202

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'maryluzsantamaria@hotmail.com'
WHERE so.ods_code = 'GRM-02-07-202'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: VIANI YORELY RUIZ GALINDO | VIANIRUIZ@GMAIL.COM -> ODS GSS-01-06-2025

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'VIANIRUIZ@GMAIL.COM'
WHERE so.ods_code = 'GSS-01-06-2025'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: JULIO CESAR RODRIGUEZ APARICIO | cesarjuliocesar1997@gmail.com -> ODS GRM-02-07-202

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'cesarjuliocesar1997@gmail.com'
WHERE so.ods_code = 'GRM-02-07-202'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: JHONATAN ALEXANDER TORRES RODRIGUEZ | jhonatantorresrdr@gmail.com -> ODS GRM-02-07-202

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'jhonatantorresrdr@gmail.com'
WHERE so.ods_code = 'GRM-02-07-202'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: MIGUEL ANGEL RIAÑO MOLINA | miguelmolinave@gmail.com -> ODS GSS-01-06-2025

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'miguelmolinave@gmail.com'
WHERE so.ods_code = 'GSS-01-06-2025'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: LAURA VANESSA CASTRO CARMONA | laucastro212011@gmail.com -> ODS GRM-02-07-202

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'laucastro212011@gmail.com'
WHERE so.ods_code = 'GRM-02-07-202'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: EDGARD MAURICIO ALVAREZ FRANCO | GENIOALV@GMAIL.COM -> ODS GRM-02-07-202

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'GENIOALV@GMAIL.COM'
WHERE so.ods_code = 'GRM-02-07-202'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: DIANIS CHAVEZ CAMPUZANO | 01dianischavez@gmail.com -> ODS GRM-02-07-202

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = '01dianischavez@gmail.com'
WHERE so.ods_code = 'GRM-02-07-202'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: LAURA MARCELA ARENAS PEREZ | lamarcela1289@gmail.com -> ODS GRM-02-07-202

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'lamarcela1289@gmail.com'
WHERE so.ods_code = 'GRM-02-07-202'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: YORGUIN DANIEL PEÑA LUGO | yorguinp@hotmail.com -> ODS GSS-01-06-2025

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'yorguinp@hotmail.com'
WHERE so.ods_code = 'GSS-01-06-2025'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: ANGELA MARIA TORO PATERNINA | amtorop90@hotmail.com -> ODS GRM-02-07-202

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'amtorop90@hotmail.com'
WHERE so.ods_code = 'GRM-02-07-202'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: YOJAN GIL GONZALEZ | yojan35@hotmail.com -> ODS GRM-02-07-202

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'yojan35@hotmail.com'
WHERE so.ods_code = 'GRM-02-07-202'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: MAIRA ALEJANDRA VASQUEZ CORREA | aleja.2017@outlook.es -> ODS GRM-02-07-202

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'aleja.2017@outlook.es'
WHERE so.ods_code = 'GRM-02-07-202'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: JORGE ENRIQUE NIÑO SANTOS | datolo90@hotmail.com -> ODS GRM-02-07-202

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'datolo90@hotmail.com'
WHERE so.ods_code = 'GRM-02-07-202'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: CAMILO ANRES IBAÑEZ ROZO | ingcamilo.ibanez@gmail.com -> ODS GSS-01-06-2025

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'ingcamilo.ibanez@gmail.com'
WHERE so.ods_code = 'GSS-01-06-2025'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: YESSICA VANESSA ALBA BELEÑO | yessica.alba19@gmail.com -> ODS GRM-02-07-202

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'yessica.alba19@gmail.com'
WHERE so.ods_code = 'GRM-02-07-202'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: ALEX JHOAN GONZALEZ MORA | ing.alexgonzalez@hotmail.com -> ODS GSS-01-06-2025

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'ing.alexgonzalez@hotmail.com'
WHERE so.ods_code = 'GSS-01-06-2025'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: JUAN SEBASTIAN VALENCIA ORTEGA | Juanseb89@hotmail.com -> ODS GRM-02-07-202

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'Juanseb89@hotmail.com'
WHERE so.ods_code = 'GRM-02-07-202'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: PERLA MELISSA PINZÓN AGUDELO | perlameli_92@hotmail.com -> ODS GRM-02-07-202

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'perlameli_92@hotmail.com'
WHERE so.ods_code = 'GRM-02-07-202'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: ESTEBAN GARCIA ROJAS | estebangr1987@gmail.com -> ODS GSS-01-06-2025

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'estebangr1987@gmail.com'
WHERE so.ods_code = 'GSS-01-06-2025'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: PEDRO RAFAEL CADENA ORDOÑEZ | pedro.cadena@outlook.com -> ODS GSS-01-06-2025

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'pedro.cadena@outlook.com'
WHERE so.ods_code = 'GSS-01-06-2025'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: CARLOS SAUL CELIS ACERO | celiscarloss@gmail.com -> ODS GSS-01-06-2025

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'celiscarloss@gmail.com'
WHERE so.ods_code = 'GSS-01-06-2025'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: RICARDO JOSÉ CORREA CERRO | ricardocorreacerro@gmail.com -> ODS GSS-01-06-2025

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'ricardocorreacerro@gmail.com'
WHERE so.ods_code = 'GSS-01-06-2025'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: JULIO CESAR  ROMERO AREVALO | julioromeroar@hotmail.com -> ODS GSS-01-06-2025

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'julioromeroar@hotmail.com'
WHERE so.ods_code = 'GSS-01-06-2025'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: CARLOS ANTONIO FONTALVO CARRASCAL | carlosfontalvocarrascal@hotmail.com -> ODS GGS-01-062025

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'carlosfontalvocarrascal@hotmail.com'
WHERE so.ods_code = 'GGS-01-062025'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: DAYAN EDUARDO SUAREZ HIGUERA | Dayansuarezh11@gmail.com -> ODS GRM-02-07 2025

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'Dayansuarezh11@gmail.com'
WHERE so.ods_code = 'GRM-02-07 2025'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: CHRISTIAN MAURICIO  PARDO CARRANZA | christian.pardo@meridianecp.com -> ODS 90578295

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'christian.pardo@meridianecp.com'
WHERE so.ods_code = '90578295'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: JOSE GABRIEL NASSAR DIAZ | jose.nassar@meridianecp.com -> ODS 90578295

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'jose.nassar@meridianecp.com'
WHERE so.ods_code = '90578295'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: JAIME JOSÉ MARTÍNEZ VERTEL | jaime.martinez@meridianecp.com -> ODS 90578295

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'jaime.martinez@meridianecp.com'
WHERE so.ods_code = '90578295'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: ANA MARÍA CASTELLANOS BARRETO | ana.castellanos@meridianecp.com -> ODS 90578295

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'ana.castellanos@meridianecp.com'
WHERE so.ods_code = '90578295'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: DIEGO FERNANDO PINTO HERNÁNDEZ | diego.pinto@meridianecp.com -> ODS 90578295

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'diego.pinto@meridianecp.com'
WHERE so.ods_code = '90578295'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: GLORIA FERNANDA VIDAL GONZÁLEZ | gloria.vidal@meridianecp.com -> ODS 90578295

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'gloria.vidal@meridianecp.com'
WHERE so.ods_code = '90578295'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: JESÚS IVÁN PACHECO ROMERO | jesus.pacheco@meridianecp.com -> ODS 90578295

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'jesus.pacheco@meridianecp.com'
WHERE so.ods_code = '90578295'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: CESAR ELIECER RODRIGUEZ CAMELO | cesar.rodriguez@meridianecp.com -> ODS 90578295

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'cesar.rodriguez@meridianecp.com'
WHERE so.ods_code = '90578295'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: PAOLA ANDREA GOMEZ CABRERA | paola.gomez@meridianecp.com -> ODS 90578295

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'paola.gomez@meridianecp.com'
WHERE so.ods_code = '90578295'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: LUIS CARLOS MONSALVE PARRA | luis.monsalve@meridianecp.com -> ODS 90578295

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'luis.monsalve@meridianecp.com'
WHERE so.ods_code = '90578295'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: CARLOS RAFAEL OLMOS CARVAL | carlos.olmos@meridianecp.com -> ODS 90578295

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'carlos.olmos@meridianecp.com'
WHERE so.ods_code = '90578295'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: NUBIA SOLANLLY REYES ÁVILA | nubia.reyes@meridianecp.com -> ODS 90578295

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'nubia.reyes@meridianecp.com'
WHERE so.ods_code = '90578295'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: MARIA ALEJANDRA MOJICA ARCINIEGAS | maria.mojica@meridianecp.com -> ODS 90578295

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'maria.mojica@meridianecp.com'
WHERE so.ods_code = '90578295'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: DIANA MARCELA CACERES SALINAS | diana.caceres@meridianecp.com -> ODS 90578295

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'diana.caceres@meridianecp.com'
WHERE so.ods_code = '90578295'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: RAFAEL ALBERTO GUATAME APONTE | rafael.guatame@meridianecp.com -> ODS 90578295

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'rafael.guatame@meridianecp.com'
WHERE so.ods_code = '90578295'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: INA YADITH SERRANO LASTRE | ina.serrano@meridianecp.com -> ODS 90577837

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'ina.serrano@meridianecp.com'
WHERE so.ods_code = '90577837'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: GUSTAVO ANDRES  BAUTISTA VELANDIA | andres.bautista@meridianecp.com -> ODS 90577770

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'andres.bautista@meridianecp.com'
WHERE so.ods_code = '90577770'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: JHON ABELARDO CUESTA ASPRILLA | jhon.cuesta@meridianecp.com -> ODS 90577770

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'jhon.cuesta@meridianecp.com'
WHERE so.ods_code = '90577770'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: JOSE CARLOS GARCIA RUEDA | jose.garcia@meridianecp.com -> ODS 90577770

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'jose.garcia@meridianecp.com'
WHERE so.ods_code = '90577770'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: EMMANUEL ROBLES ALBARRACÍN | emmanuel.robles@meridianecp.com -> ODS 90577770

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'emmanuel.robles@meridianecp.com'
WHERE so.ods_code = '90577770'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: ANDRES FABIÁN AMAYA HERNANDEZ | andres.amaya@meridianecp.com -> ODS 90577770

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'andres.amaya@meridianecp.com'
WHERE so.ods_code = '90577770'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: MARÍA ANGÉLICA PRADA FONSECA | angelica.prada@meridianecp.com -> ODS 90577770

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'angelica.prada@meridianecp.com'
WHERE so.ods_code = '90577770'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: ESTEFANY LIZETH  VELANDIA JAIMES | estefany.velandia@meridianecp.com -> ODS 90577770

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'estefany.velandia@meridianecp.com'
WHERE so.ods_code = '90577770'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: XIMENA ALEJANDRA  RODRIGUEZ FLOREZ | ximena.rodriguez@meridianecp.com -> ODS 90577770

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'ximena.rodriguez@meridianecp.com'
WHERE so.ods_code = '90577770'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: DIEGO FERNANDO CASTILLO BAYONA | diego.castillo@meridianecp.com -> ODS 90594501

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'diego.castillo@meridianecp.com'
WHERE so.ods_code = '90594501'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: JUAN CARLOS DURAN ZAPATA | juducaza@hotmail.com -> ODS GGS-01-06-2025 PROVINCIA

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'juducaza@hotmail.com'
WHERE so.ods_code = 'GGS-01-06-2025 PROVINCIA'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: CARLOS ALEJANDRO  FORERO PEÑA | carlos.forero@meridianecp.com -> ODS 90590325

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'carlos.forero@meridianecp.com'
WHERE so.ods_code = '90590325'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: ALEXANDRA ISABEL  MESA CARDENAS | alexandra.mesa@meridianecp.com -> ODS 90590325

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'alexandra.mesa@meridianecp.com'
WHERE so.ods_code = '90590325'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: EDNA MILED  NIÑO OROZCO | edna.nino@meridianecp.com -> ODS 90590325

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'edna.nino@meridianecp.com'
WHERE so.ods_code = '90590325'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: DIANA PAOLA  SOLANO SUA | diana.solano@meridianecp.com -> ODS 90590325

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'diana.solano@meridianecp.com'
WHERE so.ods_code = '90590325'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: JOSÉ ANDRÉS  ANAYA MANCIPE | andres.anaya@meridianecp.com -> ODS 90600752

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'andres.anaya@meridianecp.com'
WHERE so.ods_code = '90600752'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: GABRIEL EDUARDO VÉLEZ BARRERA | gabriel.velez@meridianecp.com -> ODS 90600752

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'gabriel.velez@meridianecp.com'
WHERE so.ods_code = '90600752'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: JUAN MATEO  CORDOBA WAGNER | juanmateo.cordoba@meridianecp.com -> ODS 90600752

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'juanmateo.cordoba@meridianecp.com'
WHERE so.ods_code = '90600752'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: MARIA HIMELDA MURILLO LOPEZ | maria.murillo@meridianecp.com -> ODS 90600752

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'maria.murillo@meridianecp.com'
WHERE so.ods_code = '90600752'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: ADRIANA PATRICIA DUEÑES GARCES | adriana.duenes@meridianecp.com -> ODS 90560321

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'adriana.duenes@meridianecp.com'
WHERE so.ods_code = '90560321'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: MARIO AUGUSTO MORENO CASTELLANOS | mario.moreno@meridianecp.com -> ODS 90560321

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'mario.moreno@meridianecp.com'
WHERE so.ods_code = '90560321'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: SERGIO FERNANDO POVEDA SALAZAR | sergio.poveda@meridianecp.com -> ODS 90560321

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'sergio.poveda@meridianecp.com'
WHERE so.ods_code = '90560321'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: JULIO CESAR  FIGUEROA VEGA | julio.figueroa@meridianecp.com -> ODS 90560321

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'julio.figueroa@meridianecp.com'
WHERE so.ods_code = '90560321'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: JORGE EDUARDO PAIBA ALZATE | jorge.paiba@meridianecp.com -> ODS 90560321

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'jorge.paiba@meridianecp.com'
WHERE so.ods_code = '90560321'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: JULLY MARCELA ORTEGON BARRERA | jully.ortegon@meridianecp.com -> ODS 90560321

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'jully.ortegon@meridianecp.com'
WHERE so.ods_code = '90560321'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: EDWIN FABIAN MAYORGA LOPEZ | edwin.mayorga@meridianecp.com -> ODS 90560321

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'edwin.mayorga@meridianecp.com'
WHERE so.ods_code = '90560321'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: MAURICIO ANDRES VASQUEZ PINTO | mauricio.vasquez@meridianecp.com -> ODS 90560321

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'mauricio.vasquez@meridianecp.com'
WHERE so.ods_code = '90560321'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: OSCAR FABIAN SUAREZ SUAREZ | oscar.suarez@meridianecp.com -> ODS 90560321

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'oscar.suarez@meridianecp.com'
WHERE so.ods_code = '90560321'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: JUAN DAVID ARISTIZABAL MARULANDA | juandavid.aristizabal@meridianecp.com -> ODS 90598918

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'juandavid.aristizabal@meridianecp.com'
WHERE so.ods_code = '90598918'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: NICOLAS AVENDAÑO VASQUEZ | nicolas.avendano@meridianecp.com -> ODS 90598918

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'nicolas.avendano@meridianecp.com'
WHERE so.ods_code = '90598918'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: CAMILO ANDRES SANTANA OTALORA | camilo.santana@meridianecp.com -> ODS 90598918

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'camilo.santana@meridianecp.com'
WHERE so.ods_code = '90598918'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: YESSICA DEL CARMEN  MATEUS TARAZONA | yessica.tarazona@meridianecp.com -> ODS 90598918

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'yessica.tarazona@meridianecp.com'
WHERE so.ods_code = '90598918'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: JORGE FELIPE ALARCON TORRES | jorge.alarcon@meridianecp.com -> ODS 90598918

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'jorge.alarcon@meridianecp.com'
WHERE so.ods_code = '90598918'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: JESUS DAVID ARENAS NAVARRO | jesus.arenas@meridianecp.com -> ODS 90598918

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'jesus.arenas@meridianecp.com'
WHERE so.ods_code = '90598918'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: ALEJANDRA ARBELAEZ LONDOÑO | alejandra.arbelaez@meridianecp.com -> ODS 90598918

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'alejandra.arbelaez@meridianecp.com'
WHERE so.ods_code = '90598918'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: GIOVANNI MARTINEZ LEONES | giovanni.martinez@meridianecp.com -> ODS 90598918

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'giovanni.martinez@meridianecp.com'
WHERE so.ods_code = '90598918'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: OSCAR IVAN JIMENEZ BARANDICA | oscar.jimenez@meridianecp.com -> ODS 90598918

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'oscar.jimenez@meridianecp.com'
WHERE so.ods_code = '90598918'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: RUBEN DARIO ORTIZ MURCIA | ruben.ortiz@meridianecp.com -> ODS 90599358

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'ruben.ortiz@meridianecp.com'
WHERE so.ods_code = '90599358'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: JUAN SEBASTIAN AVILA PARRA | juan.avila@meridianecp.com -> ODS 90599358

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'juan.avila@meridianecp.com'
WHERE so.ods_code = '90599358'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: LILIANA MARTINEZ URIBE | liliana.martinez@meridianecp.com -> ODS 90599358

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'liliana.martinez@meridianecp.com'
WHERE so.ods_code = '90599358'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: FRANKLIN ALEJANDRO BOTERO RIVERA | alejandro.botero@meridianecp.com -> ODS 90599924

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'alejandro.botero@meridianecp.com'
WHERE so.ods_code = '90599924'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: DANIELA MOLINA LANDINEZ | daniela.molina@meridianecp.com -> ODS 90599924

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'daniela.molina@meridianecp.com'
WHERE so.ods_code = '90599924'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: JESUS ERNESTO COQUECO VARGAS | jesus.coqueco@meridianecp.com -> ODS 90599924

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'jesus.coqueco@meridianecp.com'
WHERE so.ods_code = '90599924'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: ALEXANDRA KATHERINE LONDOÑO CAMACHO | alexandra.londono@meridianecp.com -> ODS 90599924

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'alexandra.londono@meridianecp.com'
WHERE so.ods_code = '90599924'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: MARIA ALEJANDRA  GIRALDO MUÑOZ | maria.giraldo@meridianecp.com -> ODS 90599924

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'maria.giraldo@meridianecp.com'
WHERE so.ods_code = '90599924'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: LENIN  CORDOBA RIVAS | lenin.cordoba@meridianecp.com -> ODS 90599924

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'lenin.cordoba@meridianecp.com'
WHERE so.ods_code = '90599924'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: JAVIER ENRIQUE GUERRERO ARRIETA | javier.guerrero@meridianecp.com -> ODS 90599924

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'javier.guerrero@meridianecp.com'
WHERE so.ods_code = '90599924'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: YOHANEY LUCIA GOMEZ GALARZA | yohaney.gomez@meridianecp.com -> ODS 1661981

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'yohaney.gomez@meridianecp.com'
WHERE so.ods_code = '1661981'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: LAURA MARIA  HERNANDEZ RIVEROS | laura.hernandez@meridianecp.com -> ODS 90590325

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'laura.hernandez@meridianecp.com'
WHERE so.ods_code = '90590325'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: CINDY NATALIA ISAZA TORO | cindy.isaza@meridianecp.com -> ODS 90612258

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'cindy.isaza@meridianecp.com'
WHERE so.ods_code = '90612258'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: CHRISTIAN CAMILO RIVERA SANCHEZ | christian.rivera@meridianecp.com -> ODS 90612258

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'christian.rivera@meridianecp.com'
WHERE so.ods_code = '90612258'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: MARIA ALEJANDRA JOYA RINCON | alejandra.joya@meridianecp.com -> ODS 90599358

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'alejandra.joya@meridianecp.com'
WHERE so.ods_code = '90599358'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: CRISTINA CARO VELEZ | cristina.caro@meridianecp.com -> ODS 90049330

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'cristina.caro@meridianecp.com'
WHERE so.ods_code = '90049330'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: MELINA ANDREA  RIVERA MANRIQUE | melina.rivera@meridianecp.com -> ODS 90049330

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'melina.rivera@meridianecp.com'
WHERE so.ods_code = '90049330'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: MARIANN LISSETTE MAHECHA LAVERDE | mariann.mahecha@meridianecp.com -> ODS 90632454

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'mariann.mahecha@meridianecp.com'
WHERE so.ods_code = '90632454'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: ZENAIDA DEL VALLE MARCANO DE VILLARROEL | zenaida.marcano@meridianecp.com -> ODS 90598546

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'zenaida.marcano@meridianecp.com'
WHERE so.ods_code = '90598546'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: GERMAN DARIO OREJARENA ESCOBAR | german.orejarena@meridianecp.com -> ODS 90642057

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'german.orejarena@meridianecp.com'
WHERE so.ods_code = '90642057'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: RICARDO GAVIRIA GARCIA | ricardo.gaviria@meridianecp.com -> ODS 90642057

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'ricardo.gaviria@meridianecp.com'
WHERE so.ods_code = '90642057'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: HUGO QUIROGA CRUZ | hugo.quiroga@meridianecp.com -> ODS 90577770

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'hugo.quiroga@meridianecp.com'
WHERE so.ods_code = '90577770'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: JEAN PABLO CEDEÑO ORFILA | jean.cedeno@meridianecp.com -> ODS 90658180

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'jean.cedeno@meridianecp.com'
WHERE so.ods_code = '90658180'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: YUBER RODRIGUEZ ARTURO | yuber.rodriguez@meridianecp.com -> ODS 90658180

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'yuber.rodriguez@meridianecp.com'
WHERE so.ods_code = '90658180'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: KELLY LORENA DIEZ HERNANDEZ | kelly.diez@meridianecp.com -> ODS 90658180

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'kelly.diez@meridianecp.com'
WHERE so.ods_code = '90658180'
ON DUPLICATE KEY UPDATE
  is_active = 1;

-- Asignación: LUIS ALBERTO CHINOMES GUALDRON | luis.chinomes@meridianecp.com -> ODS 90599924

INSERT INTO service_order_employees (
  service_order_id, user_id, is_active, created_at
)
SELECT
  so.id,
  u.id,
  1,
  @NOW
FROM service_orders so
JOIN users u ON u.email = 'luis.chinomes@meridianecp.com'
WHERE so.ods_code = '90599924'
ON DUPLICATE KEY UPDATE
  is_active = 1;

COMMIT;
