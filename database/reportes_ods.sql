-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 27-02-2026 a las 20:49:16
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `reportes_ods`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `areas`
--

CREATE TABLE `areas` (
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `delivery_media`
--

CREATE TABLE `delivery_media` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `employee_levels`
--

CREATE TABLE `employee_levels` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `employee_profiles`
--

CREATE TABLE `employee_profiles` (
  `user_id` int(11) NOT NULL,
  `external_employee_id` varchar(50) DEFAULT NULL,
  `full_name` varchar(200) NOT NULL,
  `corporate_email` varchar(150) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `profession` varchar(120) DEFAULT NULL,
  `job_title` varchar(120) DEFAULT NULL,
  `contract_type` varchar(120) DEFAULT NULL,
  `hire_date` date DEFAULT NULL,
  `contract_end_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `employee_profiles`
--

INSERT INTO `employee_profiles` (`user_id`, `external_employee_id`, `full_name`, `corporate_email`, `phone`, `profession`, `job_title`, `contract_type`, `hire_date`, `contract_end_date`, `created_at`, `updated_at`) VALUES
(1, '1100954344', 'CAMILA FERNANDA MEDINA SANDOVAL', 'camila.medina@meridianecp.com', '3155257550', 'Quimica', 'Profesional Junior para la ejecución de actividades de la ODS No. 90045724 del contrato Matriz No. 3037132', 'MER-ODS-90045724-40-2025', '2024-09-02', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(2, '1095786398', 'AURA MARIA TRASLAVIÑA PRADA', 'aura.traslavina@meridianecp.com', '3132028099', 'Geólogo', 'Profesional Junior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132', 'MER-ODS-9770807-159', '2024-10-25', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(3, '83042295', 'WILLIAM CABRERA CASTRO', 'wcabrera@meridianecp.com', '3147301063', 'Ingeniero Electrónico', 'Profesional Senior para la ejecución de actividades de la ODS No. 90049330 del contrato Matriz No. 3037132', 'MER-ODS-90049330-44-2025', '2025-01-16', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(4, '1075284985', 'SEBASTIAN LLANOS GALLO', 'sebastian.llanos@meridianecp.com', '3203210974', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecucion de actividades de la ODS No. 90049330 del contrato Matriz No.3037132', 'MER-ODS-90049330-48-2025', '2025-01-16', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(5, '80883010', 'OVEIMAR SANTAMARIA TORRES', 'oveimar.santamaria@meridianecp.com', '3017227315', 'Ingeniero de Petróleos', 'Profesional Senior para la ejecución de actividades de la ODS No. 90049330 del contrato Matriz No. 3037132', 'MER-ODS-90049330-49-2025', '2025-01-16', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(6, '1100950373', 'LADY MILENA LOPEZ ROJAS', 'lady.lopez@meridian.com.co', '3112450500', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecucion de actividades de la ODS No. 90049330 del contrato Matriz No.3037132', 'MER-ODS-90049330-54-2025', '2025-01-16', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(7, '1075286613', 'JULLY ALEXANDRA VARGAS QUINTERO', 'jully.vargas@meridianecp.com', '3223424156', 'Ingeniero de petróleos', 'Profesional Junior para la ejecucion de actividades de la ODS No. 90049330 del contrato Matriz No.3037132', 'MER-ODS-90049330-53-2025', '2025-01-16', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(8, '40936668', 'ESPERANZA DE JESUS COTES LEON', 'esperanza.cotes@meridianecp.com', '3183728370', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecucion de actividades de la ODS No. 90049330 del contrato Matriz No.3037132', 'MER-ODS-90049330-46-2025', '2025-01-16', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(9, '1010056001', 'EMELI YOHANA YACELGA CHITAN', 'Emeli.yacelga@meridianecp.com', '3223594580', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecucion de actividades de la ODS No. 90049330 del contrato Matriz No.3037132', 'MER-ODS-90049330-50-2025', '2025-01-16', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(10, '1152210959', 'CARLOS JOSE URZOLA EBRATT', 'carlos.urzola@meridianecp.com', '3182840175', 'Ingeniero de Petróleos', 'Profesional Básico para la ejecución de actividades de la ODS No. 90049330 del contrato Matriz No. 3037132', 'MER-ODS-90049330-51-2025', '2025-01-16', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(11, '7729979', 'LEONARDO   FRANCO GRAJALES', 'leonardo.franco@meridianecp.com', '3012641268', 'Ingeniero Electrónico', 'Profesional Senior para la ejecución de actividades de la ODS No. 90049330 del contrato Matriz No. 3037132', 'MER-ODS-90049330-55-2025', '2025-01-20', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(12, '1095918218', 'WILMAR ANDRES DE LA HOZ GAMBOA', 'wilmar.delahoz@meridianecp.com', '3184960345', 'Geólogo', 'Profesional Senior para la ejecución de actividades de la ODS No. 90049330 del contrato Matriz No. 3037132', 'MER-ODS-90049330-69-2025', '2025-01-22', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(13, '1075292422', 'OLMER ANDRES MORALES MORA', 'andres.morales@meridianecp.com', '3232847716', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecución de actividades de la ODS No. 90141005 del contrato Matriz No. 3037132', 'MER-ODS-90141005-84-2025', '2025-04-01', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(14, '53103915', 'MONICA DEL PILAR MARTINEZ VERA', 'monica.martinez@meridianecp.com', '3028018043', 'Ingeniero de Petróleos', 'Profesional Senior para la ejecución de actividades de la ODS No. 90141005 del contrato Matriz No. 3037132', 'MER-ODS-90141005-104-2025', '2025-04-01', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(15, '1098758681', 'MILTON JULIAN GUALTEROS QUIROGA', 'milton.gualteros@meridianecp.com', '3002755299', 'Ingeniero de Petróleos', 'Profesional Senior para la ejecución de actividades de la ODS No. 90141005 del contrato Matriz No. 3037132', 'MER-ODS-90141005-98-2025', '2025-04-01', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(16, '1095826986', 'LIZETH DAYANA BAUTISTA RICO', 'lizeth.bautista@meridianecp.com', '3138678621', 'Ingeniera de Petróleos', 'Profesional Junior para la ejecución de actividades de la ODS No. 90141005 del contrato Matriz No. 3037132', 'MER-ODS-90141005-82-2025', '2025-04-01', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(17, '1098706838', 'JULIÁN ANDRÉS HERNÁNDEZ PINTO', 'julian.hernandez@meridianecp.com', '3174478283', 'Geólogo', 'Profesional Junior para la ejecución de actividades de la ODS No. 90141005 del contrato Matriz No. 3037132', 'MER-ODS-90141005-97-2025', '2025-04-01', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(18, '1098681773', 'JHON HARVEY CARREÑO HERNANDEZ', 'jhon.carreno@meridianecp.com', '3114976619', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecución de actividades de la ODS No. 90141005 del contrato Matriz No. 3037132', 'MER-ODS-90141005-96-2025', '2025-04-01', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(19, '1056709240', 'IVAN DARIO MOZO MORENO', 'ivan.mozo@meridianecp.com', '3174236296', 'Ingeniero de Petróleos', 'Profesional Senior para la ejecución de actividades de la ODS No. 90141005 del contrato Matriz No. 3037132', 'MER-ODS-90141005-86-2025', '2025-04-01', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(20, '1100961505', 'GEISSON RENÉ ZAFRA URREA', 'geisson.zafra@meridianecp.com', '3163677407', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecución de actividades de la ODS No. 90141005 del contrato Matriz No. 3037132', 'MER-ODS-90141005-93-2025', '2025-04-01', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(21, '13959717', 'DIEGO FERNANDO GALEANO BARRERA', 'diego.galeano@meridianecp.com', '3212060755', 'Ingeniero de Petróleos', 'Profesional Senior para la ejecución de actividades de la ODS No. 90141005 del contrato Matriz No. 3037132', 'MER-ODS-90141005-91-2025', '2025-04-01', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(22, '1140847297', 'DAVID ALEJANDRO GARCIA CORONADO', 'david.garcia@meridianecp.com', '3005751696', 'Ingeniero de Petróleos', 'Profesional Senior para la ejecución de actividades de la ODS No. 90141005 del contrato Matriz No. 3037132', 'MER-ODS-90141005-83-2025', '2025-04-01', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(23, '1082981742', 'CHRISTIAN DAVID MENDOZA RAMIREZ', 'christian.mendoza@meridianecp.com', '3006036245', 'Ingeniero Químico', 'Profesional Básico para la ejecución de actividades de la ODS No. 90141005 del contrato Matriz No. 3037132', 'MER-ODS-90141005-106-2025', '2025-04-01', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(24, '1101693549', 'CESAR EDUARDO GARNICA GOMEZ', 'cesar.garnica@meridianecp.com', '3173374883', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecución de actividades de la ODS No. 90141005 del contrato Matriz No. 3037132', 'MER-ODS-90141005-101-2025', '2025-04-01', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(25, '1098692205', 'BRIGGITE SUSEC CAMACHO JEREZ', 'briggite.camacho@meridianecp.com', '3186506670', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecución de actividades de la ODS No. 90141005 del contrato Matriz No. 3037132', 'MER-ODS-90141005-100-2025', '2025-04-01', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(26, '1121941649', 'ALEJANDRO DUVAN LOPEZ ROJAS', 'alejandro.lopez@meridianecp.com', '3214472738', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecución de actividades de la ODS No. 90141005 del contrato Matriz No. 3037132', 'MER-ODS-90141005-89-2025', '2025-04-01', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(27, '1098639151', 'CARLOS ESPINOSA LEON', 'carlos.espinosa@meridianecp.com', '3007761534', 'Ingeniero de petróleos', 'Profesional Senior para la ejecución de actividades de la ODS No. 90172266 del contrato Matriz No. 3037132', 'MER-ODS-90172266-111-2025', '2025-04-22', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(28, '80243783', 'DIEGO MAURICIO MARTINEZ BRAVO', 'diego.martinez@meridianecp.com', '3103012637', 'Ingeniero de Petróleos', 'Profesional Senior para la ejecución de actividades de la ODS No. 90227898 del contrato Matriz No. 3037132', 'MER-ODS-90227898-120-2025', '2025-06-13', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(29, '1014181943', 'ANDRES MAURICIO GONZALEZ HERRERA', 'amaogh@gmail.com', '3007406165', 'Ingeniera De Petróleos', 'INGENIERO DE INTERVENCION A POZOS TIPO III', 'MER-COM-ODS GRM-02-07 2025-08-2025', '2025-09-01', '2026-03-04', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(30, '63501053', 'MARYLUZ SANTAMARIA BECERRA', 'maryluzsantamaria@hotmail.com', '3164170322', 'Ingeniera De Sistemas', 'SERVICIO ESPECIALIZADO EN COSTOS DE INTERVENCION DE POZOS TIPO I', 'MER-COM-ODS GRM-02-07 2025-03-2025', '2025-09-01', '2026-03-04', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(31, '1115914145', 'VIANI YORELY RUIZ GALINDO', 'VIANIRUIZ@GMAIL.COM', '3108677402', 'Ingenieria Ambiental', 'SERVICIO ESPECIALIZADO EN COSTOS DE INTERVENCION DE POZOS TIPO II', 'MER-COM-ODS GSS-01-06-2025-02-2025', '2025-09-01', '2026-03-04', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(32, '1101695749', 'JULIO CESAR RODRIGUEZ APARICIO', 'cesarjuliocesar1997@gmail.com', '3143955091', 'Ingeniera De Petróleos', 'SERVICIO ESPECIALIZADO EN INTERVENCIONES A POZO TIPO II', 'MER-COM-ODS GRM-02-07 2025-10-2025', '2025-09-01', '2026-03-04', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(33, '1096202008', 'JHONATAN ALEXANDER TORRES RODRIGUEZ', 'jhonatantorresrdr@gmail.com', '3214781178', 'Ingeniera De Petróleos', 'SERVICIO ESPECIALIZADO EN INTERVENCIONES A POZO TIPO II', 'MER-COM-ODS GRM-02-07 2025-07-2025', '2025-09-01', '2026-03-04', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(34, '1015475289', 'MIGUEL ANGEL RIAÑO MOLINA', 'miguelmolinave@gmail.com', '3046737943', 'Ingeniera De Petróleos', 'INGENIERO ASISTENTE DE SUPERVISION INTEGRAL DE POZOS TIPO II', 'MER-COM-ODS GSS-01-06-2025-03-2025', '2025-09-01', '2026-03-04', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(35, '1143388273', 'LAURA VANESSA CASTRO CARMONA', 'laucastro212011@gmail.com', '3024614380', 'Ingeniera De Petróleos', 'SERVICIO ESPECIALIZADO EN INTERVENCIONES A POZO TIPO II', 'MER-COM-ODS GRM-02-07 2025-01-2025', '2025-09-01', '2026-03-04', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(36, '88278069', 'EDGARD MAURICIO ALVAREZ FRANCO', 'GENIOALV@GMAIL.COM', '3162502207', 'Ingeniero De Sistemas', 'SERVICIO ESPECIALIZADO EN COSTOS DE INTERVENCION DE POZOS TIPO II', 'MER-COM-ODS GRM-02-07 2025-06-2025', '2025-09-01', '2026-03-04', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(37, '1002465061', 'DIANIS CHAVEZ CAMPUZANO', '01dianischavez@gmail.com', '3014063067', 'Ingeniera De Petróleos', 'SERVICIO ESPECIALIZADO EN INTEGRIDAD DE POZOS TIPO II', 'MER-COM-ODS GRM-02-07 2025-18-2025', '2025-09-01', '2026-03-04', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(38, '1098681142', 'LAURA MARCELA ARENAS PEREZ', 'lamarcela1289@gmail.com', '3144749142', 'Ingeniera De Petróleos', 'INGENIERO DE INTERVENCION A POZOS TIPO IV', 'MER-COM-ODS GRM-02-07 2025-09-2025', '2025-09-01', '2026-03-04', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(39, '7317575', 'YORGUIN DANIEL PEÑA LUGO', 'yorguinp@hotmail.com', '3204927512', 'Ingeniera De Petróleos', 'SUPERVISOR INTEGRAL EN INTERVENCIONES A POZO TIPO II', 'MER-COM-ODS GSS-01-06-2025-06-2025', '2025-09-01', '2026-03-04', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(40, '1037580568', 'ANGELA MARIA TORO PATERNINA', 'amtorop90@hotmail.com', '3155140472', 'Ingeniera De Petróleos', 'SERVICIO SOPORTE EN ABANDONO DE POZOS TIPO II', 'MER-COM-ODS GRM-02-07 2025-04-2025', '2025-09-01', '2026-03-04', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(41, '1042212691', 'YOJAN GIL GONZALEZ', 'yojan35@hotmail.com', '3173759350', 'Ingeniera De Petróleos', 'INGENIERO DE INTERVENCION A POZOS TIPO IV', 'MER-COM-ODS GRM-02-07 2025-17-2025', '2025-09-01', '2026-03-04', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(42, '1096245598', 'MAIRA ALEJANDRA VASQUEZ CORREA', 'aleja.2017@outlook.es', '3178787627', 'Ingeniera De Petróleos', 'SERVICIO SOPORTE EN ABANDONO DE POZOS TIPO II', 'MER-COM-ODS GRM-02-07 2025-14-2025', '2025-09-01', '2026-03-04', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(43, '1064838225', 'JORGE ENRIQUE NIÑO SANTOS', 'datolo90@hotmail.com', '3013058326', 'Ingeniera De Petróleos', 'SERVICIO ESPECIALIZADO EN COSTOS DE INTERVENCION DE POZOS TIPO I', 'MER-COM-ODS GRM-02-07 2025-12-2025', '2025-09-01', '2026-03-04', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(44, '1115914517', 'CAMILO ANRES IBAÑEZ ROZO', 'ingcamilo.ibanez@gmail.com', '3138609005', 'Ingeniera De Petróleos', 'INGENIERO DE INTERVENCION A POZOS TIPO IV', 'MER-COM-ODS GSS-01-06-2025-10-2025', '2025-09-01', '2026-03-04', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(45, '1096208135', 'YESSICA VANESSA ALBA BELEÑO', 'yessica.alba19@gmail.com', '3159266614', 'Ingeniera De Petróleos', 'SERVICIO ESPECIALIZADO EN COSTOS DE INTERVENCION DE POZOS TIPO I', 'MER-COM-ODS GRM-02-07 2025-15-2025', '2025-09-01', '2026-03-04', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(46, '80076686', 'ALEX JHOAN GONZALEZ MORA', 'ing.alexgonzalez@hotmail.com', '3052918714', 'Ingeniera De Petróleos', 'INGENIERO DE INTERVENCION A POZOS TIPO II', 'MER-COM-ODS GSS-01-06-2025-11-2025', '2025-09-01', NULL, '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(47, '1020427784', 'JUAN SEBASTIAN VALENCIA ORTEGA', 'Juanseb89@hotmail.com', '3128352851', 'Ingeniero Industrial', 'SERVICIO ESPECIALIZADO EN INTEGRIDAD DE POZOS TIPO I', 'MER-COM-ODS GRM-02-07 2025-05-2025', '2025-09-01', '2026-03-04', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(48, '1098727333', 'PERLA MELISSA PINZÓN AGUDELO', 'perlameli_92@hotmail.com', '3177227050', 'Ingeniera De Petróleos', 'INGENIERO DE INTERVENCION A POZOS TIPO III', 'MER-COM-ODS GRM-02-07 2025-13-2025', '2025-09-01', '2026-03-04', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(49, '1077173073', 'ESTEBAN GARCIA ROJAS', 'estebangr1987@gmail.com', '3233969196', 'Ingenieria Mecanica', 'SUPERVISOR INTEGRAL EN INTERVENCIONES A POZO TIPO III', 'MER-COM-ODS GSS-01-06-2025-01-2025', '2025-08-30', '2026-03-01', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(50, '13871188', 'PEDRO RAFAEL CADENA ORDOÑEZ', 'pedro.cadena@outlook.com', '3013630130', 'Ingeniero De Software Y Telecomunicaciones', 'SUPERVISOR INTEGRAL EN INTERVENCIONES A POZO TIPO I', 'MER-COM-ODS GSS-01-06-2025-05-2025', '2025-08-30', '2026-03-01', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(51, '7161987', 'CARLOS SAUL CELIS ACERO', 'celiscarloss@gmail.com', '3102699509', 'Técnico profesional en procesos industriales', 'SUPERVISOR INTEGRAL EN INTERVENCIONES A POZO TIPO I', 'MER-COM-ODS GSS-01-06-2025-07-2025', '2025-08-30', '2026-03-01', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(52, '18760161', 'RICARDO JOSÉ CORREA CERRO', 'ricardocorreacerro@gmail.com', '3167443534', 'Ingeniera De Petróleos', 'SUPERVISOR INTEGRAL EN INTERVENCIONES A POZO TIPO II', 'MER-COM-ODS GSS-01-06-2025-04-2025', '2025-09-10', '2026-03-04', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(53, '88281896', 'JULIO CESAR  ROMERO AREVALO', 'julioromeroar@hotmail.com', '3164420135', 'Ingeniero Mecánico', 'Supervisor Integral En Intervenciones A Pozo Tipo I', 'MER-COM-ODS GSS-01-06-2025-08-2025', '2025-09-16', '2026-03-03', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(54, '73188189', 'CARLOS ANTONIO FONTALVO CARRASCAL', 'carlosfontalvocarrascal@hotmail.com', '3183476222', 'Ingeniero de Petroleos', 'SUPERVISOR INTEGRAL EN INTERVENCIONES A POZO TIPO II', 'MER-COM-ODS GGS-01-062025-14-2025', '2025-09-23', '2026-03-03', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(55, '1091668633', 'DAYAN EDUARDO SUAREZ HIGUERA', 'Dayansuarezh11@gmail.com', '3102619194', 'Ingeniero Mecánico', 'SERVICIO ESPECIALIZADO EN COSTOS DE INTERVENCION DE POZOS TIPO I', 'MER-COM-ODS GRM-02-07 2025-19-2025', '2025-12-10', '2026-03-03', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(56, '1032467291', 'CHRISTIAN MAURICIO  PARDO CARRANZA', 'christian.pardo@meridianecp.com', '3166969988', 'Ingeniero de Petróleos', 'Profesional Senior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132', 'MER-ODS-90578295-01-2026', '2026-01-01', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(57, '1098725794', 'JOSE GABRIEL NASSAR DIAZ', 'jose.nassar@meridianecp.com', '3166233088', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132', 'MER-ODS-90578295-02-2026', '2026-01-01', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(58, '1098755426', 'JAIME JOSÉ MARTÍNEZ VERTEL', 'jaime.martinez@meridianecp.com', '3102376098', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132', 'MER-ODS-90578295-03-2026', '2026-01-01', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(59, '52455261', 'ANA MARÍA CASTELLANOS BARRETO', 'ana.castellanos@meridianecp.com', '3219970758', 'Ingeniero de Petróleos', 'Profesional Senior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132', 'MER-ODS-90578295-04-2026', '2026-01-01', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(60, '1101692935', 'DIEGO FERNANDO PINTO HERNÁNDEZ', 'diego.pinto@meridianecp.com', '3143794371', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132', 'MER-ODS-90578295-05-2026', '2026-01-01', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(61, '51781946', 'GLORIA FERNANDA VIDAL GONZÁLEZ', 'gloria.vidal@meridianecp.com', '3157805737', 'Geólogo', 'Profesional Senior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132', 'MER-ODS-90578295-06-2026', '2026-01-01', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(62, '1091668362', 'JESÚS IVÁN PACHECO ROMERO', 'jesus.pacheco@meridianecp.com', '3006213973', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132', 'MER-ODS-90578295-07-2026', '2026-01-01', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(63, '1065599609', 'CESAR ELIECER RODRIGUEZ CAMELO', 'cesar.rodriguez@meridianecp.com', '3005462735', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132', 'MER-ODS-90578295-08-2026', '2026-01-01', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(64, '1016037506', 'PAOLA ANDREA GOMEZ CABRERA', 'paola.gomez@meridianecp.com', '3168735316', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132', 'MER-ODS-90578295-09-2026', '2026-01-01', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(65, '1098683077', 'LUIS CARLOS MONSALVE PARRA', 'luis.monsalve@meridianecp.com', '3187441574', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132', 'MER-ODS-90578295-10-2026', '2026-01-01', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(66, '1047451443', 'CARLOS RAFAEL OLMOS CARVAL', 'carlos.olmos@meridianecp.com', '3012392187', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132', 'MER-ODS-90578295-11-2026', '2026-01-01', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(67, '52423689', 'NUBIA SOLANLLY REYES ÁVILA', 'nubia.reyes@meridianecp.com', '3158130358', 'Ingeniera de petróleos', 'Profesional Senior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132', 'MER-ODS-90578295-12-2026', '2026-01-01', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(68, '1026255124', 'MARIA ALEJANDRA MOJICA ARCINIEGAS', 'maria.mojica@meridianecp.com', '3166215115', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132', 'MER-ODS-90578295-13-2026', '2026-01-01', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(69, '30405867', 'DIANA MARCELA CACERES SALINAS', 'diana.caceres@meridianecp.com', '3203003436', 'Geóloga', 'Profesional Junior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132', 'MER-ODS-90578295-14-2026', '2026-01-01', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(70, '80417936', 'RAFAEL ALBERTO GUATAME APONTE', 'rafael.guatame@meridianecp.com', '3157317066', 'Geólogo', 'Profesional Junior para la ejecución de actividades de la ODS No. 90578295 del contrato Matriz No. 3037132', 'MER-ODS-90578295-15-2026', '2026-01-01', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(71, '63527981', 'INA YADITH SERRANO LASTRE', 'ina.serrano@meridianecp.com', '3134023172', 'Ingeniero Químico', 'Profesional Senior para la ejecución de actividades de la ODS No. 90577837 del contrato Matriz No. 3037132', 'MER-ODS-90577837-16-2026', '2026-01-01', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(72, '1013633604', 'GUSTAVO ANDRES  BAUTISTA VELANDIA', 'andres.bautista@meridianecp.com', '3134217276', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecucion de actividades de la ODS No. 90577770 del contrato Matriz No.3037132', 'MER-ODS-90577770-19-2026', '2026-01-05', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(73, '1003934174', 'JHON ABELARDO CUESTA ASPRILLA', 'jhon.cuesta@meridianecp.com', '3218467737', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecucion de actividades de la ODS No. 90577770 del contrato Matriz No.3037132', 'MER-ODS-90577770-20-2026', '2026-01-05', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(74, '1045706790', 'JOSE CARLOS GARCIA RUEDA', 'jose.garcia@meridianecp.com', '3114156922', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecucion de actividades de la ODS No. 90577770 del contrato Matriz No.3037132', 'MER-ODS-90577770-21-2026', '2026-01-05', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(75, '1098726424', 'EMMANUEL ROBLES ALBARRACÍN', 'emmanuel.robles@meridianecp.com', '3163835735', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecucion de actividades de la ODS No. 90577770 del contrato Matriz No.3037132', 'MER-ODS-90577770-22-2026', '2026-01-05', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(76, '1098709932', 'ANDRES FABIÁN AMAYA HERNANDEZ', 'andres.amaya@meridianecp.com', '3008669991', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecucion de actividades de la ODS No. 90577770 del contrato Matriz No.3037132', 'MER-ODS-90577770-24-2026', '2026-01-05', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(77, '1014262113', 'MARÍA ANGÉLICA PRADA FONSECA', 'angelica.prada@meridianecp.com', '3144498741', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecucion de actividades de la ODS No. 90577770 del contrato Matriz No.3037132', 'MER-ODS-90577770-17-2026', '2026-01-05', '2026-07-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(78, '1098745210', 'ESTEFANY LIZETH  VELANDIA JAIMES', 'estefany.velandia@meridianecp.com', '3154045354', 'Geóloga', 'Profesional Junior para la ejecucion de actividades de la ODS No. 90577770 del contrato Matriz No.3037132', 'MER-ODS-90577770-18-2026', '2026-01-05', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(79, '1075242729', 'XIMENA ALEJANDRA  RODRIGUEZ FLOREZ', 'ximena.rodriguez@meridianecp.com', '3002492506', 'Ingeniera geóloga', 'Profesional Senior para la ejecucion de actividades de la ODS No. 90577770 del contrato Matriz No.3037132', 'MER-ODS-90577770-23-2026', '2026-01-05', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(80, '1022380991', 'DIEGO FERNANDO CASTILLO BAYONA', 'diego.castillo@meridianecp.com', '3192191632', 'Ingeniero de petróleos', 'Profesional Senior para la ejecucion de actividades de la ODS No. 90594501 del contrato Matriz No.3037132', 'MER-ODS-90594501-25-2026', '2026-01-08', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(81, '13481943', 'JUAN CARLOS DURAN ZAPATA', 'juducaza@hotmail.com', '3104499919', 'Ingeniero de petróleos', 'SUPERVISOR INTEGRAL EN INTERVENCIONES A POZO TIPO II', 'MER-COM-ODS GGS-01-062025-18-2025', '2026-01-08', '2026-03-03', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(82, '1014216060', 'CARLOS ALEJANDRO  FORERO PEÑA', 'carlos.forero@meridianecp.com', '3175768857', 'Ingeniero de Petróleos', 'Profesional Senior para la ejecución de actividades de la ODS No. 90590325 del contrato Matriz No. 3037132', 'MER-ODS-90590325-30-2026', '2026-01-13', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(83, '43728382', 'ALEXANDRA ISABEL  MESA CARDENAS', 'alexandra.mesa@meridianecp.com', '3102046026', 'Ingeniero de Petróleos', 'Profesional Especialista para la ejecución de actividades de la ODS No. 90590325 del contrato Matriz No. 3037132', 'MER-ODS-90590325-32-2026', '2026-01-13', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(84, '52844528', 'EDNA MILED  NIÑO OROZCO', 'edna.nino@meridianecp.com', '3112978636', 'Geóloga', 'Profesional Especialista para la ejecución de actividades de la ODS No. 90590325 del contrato Matriz No. 3037132', 'MER-ODS-90590325-33-2026', '2026-01-13', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(85, '52967140', 'DIANA PAOLA  SOLANO SUA', 'diana.solano@meridianecp.com', '3015808137', 'Ingeniero de Petróleos', 'Profesional Senior para la ejecución de actividades de la ODS No. 90590325 del contrato Matriz No. 3037132', 'MER-ODS-90590325-34-2026', '2026-01-13', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(86, '91524899', 'JOSÉ ANDRÉS  ANAYA MANCIPE', 'andres.anaya@meridianecp.com', '3158608522', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecucion de actividades de la ODS No.90600752  del contrato Matriz No.3037132', 'MER-ODS-90600752-28-2026', '2026-01-13', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(87, '1115069820', 'GABRIEL EDUARDO VÉLEZ BARRERA', 'gabriel.velez@meridianecp.com', '3007087857', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecucion de actividades de la ODS No. 90600752 del contrato Matriz No.3037132', 'MER-ODS-90600752-27-2026', '2026-01-13', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(88, '1151954545', 'JUAN MATEO  CORDOBA WAGNER', 'juanmateo.cordoba@meridianecp.com', '3185323857', 'Ingeniero de Petróleos', 'Profesional Senior para la ejecucion de actividades de la ODS No. 90600752 del contrato Matriz No.3037132', 'MER-ODS-90600752-26-2026', '2026-01-13', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(89, '37546080', 'MARIA HIMELDA MURILLO LOPEZ', 'maria.murillo@meridianecp.com', '3108586179', 'Geóloga', 'Profesional Senior para la ejecucion de actividades de la ODS No. 90600752 del contrato Matriz No.3037132', 'MER-ODS-90600752-29-2026', '2026-01-13', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(90, '63540751', 'ADRIANA PATRICIA DUEÑES GARCES', 'adriana.duenes@meridianecp.com', '3168691669', 'Geólogo', 'Profesional Especialista para la ejecución de actividades de la ODS No. 90560321 del contrato Matriz No. 3037132', 'MER-ODS-90560321-53-2026', '2026-01-16', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(91, '13720871', 'MARIO AUGUSTO MORENO CASTELLANOS', 'mario.moreno@meridianecp.com', '3208889081', 'Geólogo', 'Profesional Especialista para la ejecución de actividades de la ODS No. 90560321 del contrato Matriz No. 3037132', 'MER-ODS-90560321-54-2026', '2026-01-16', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(92, '1007555164', 'SERGIO FERNANDO POVEDA SALAZAR', 'sergio.poveda@meridianecp.com', '3015198066', 'Geólogo', 'Profesional Básico para la ejecución de actividades de la ODS No. 90560321 del contrato Matriz No. 3037132', 'MER-ODS-90560321-46-2026', '2026-01-16', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(93, '13740129', 'JULIO CESAR  FIGUEROA VEGA', 'julio.figueroa@meridianecp.com', '3022586566', 'Geólogo', 'Profesional Senior para la ejecucion de actividades de la ODS No. 90560321 del contrato Matriz No.3037132', 'MER-ODS-90560321-47-2026', '2026-01-16', '2026-06-30', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(94, '75101511', 'JORGE EDUARDO PAIBA ALZATE', 'jorge.paiba@meridianecp.com', '3155056633', 'Biológo', 'Profesional Senior para la ejecución de actividades de la ODS No. 90560321 del contrato Matriz No. 3037132', 'MER-ODS-90560321-48-2026', '2026-01-16', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(95, '63536247', 'JULLY MARCELA ORTEGON BARRERA', 'jully.ortegon@meridianecp.com', '3167194344', 'Geólogo', 'Profesional Senior para la ejecución de actividades de la ODS No. 90560321 del contrato Matriz No. 3037132', 'MER-ODS-90560321-49-2026', '2026-01-16', '2026-06-30', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(96, '1013634120', 'EDWIN FABIAN MAYORGA LOPEZ', 'edwin.mayorga@meridianecp.com', '3114985755', 'Licenciado en Física - MSc Geofísica', 'Profesional Junior para la ejecución de actividades de la ODS No. 90560321 del contrato Matriz No. 3037132', 'MER-ODS-90560321-50-2026', '2026-01-16', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(97, '91532360', 'MAURICIO ANDRES VASQUEZ PINTO', 'mauricio.vasquez@meridianecp.com', '3003044721', 'Geologo', 'Profesional Senior para la ejecución de actividades de la ODS No. 90560321 del contrato Matriz No. 3037132', 'MER-ODS-90560321-51-2026', '2026-01-16', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(98, '1098733967', 'OSCAR FABIAN SUAREZ SUAREZ', 'oscar.suarez@meridianecp.com', '3161567895', 'Ingeniero de Petróleos', 'Profesional Senior para la ejecucion de actividades de la ODS No. 90560321 del contrato Matriz No.3037132', 'MER-ODS-90560321-52-2026', '2026-01-16', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(99, '1026267749', 'JUAN DAVID ARISTIZABAL MARULANDA', 'juandavid.aristizabal@meridianecp.com', '3156168706', 'Ingeniero Químico', 'Profesional Junior para la ejecucion de actividades de la ODS No. 90598918 del contrato Matriz No.3037132', 'MER-ODS-90598918-35-2026', '2026-01-16', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(100, '1023961699', 'NICOLAS AVENDAÑO VASQUEZ', 'nicolas.avendano@meridianecp.com', '3166181606', 'Ingeniero de Petróleos', 'Profesional Básico para la ejecución de actividades de la ODS No. 90598918 del contrato Matriz No. 3037132', 'MER-ODS-90598918-36-2026', '2026-01-16', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(101, '1026292916', 'CAMILO ANDRES SANTANA OTALORA', 'camilo.santana@meridianecp.com', '3108526871', 'Ingeniero de Petróleos / Ingeniero Químico', 'Profesional Básico para la ejecución de actividades de la ODS No. 90598918 del contrato Matriz No. 3037132', 'MER-ODS-90598918-37-2026', '2026-01-16', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(102, '1098663190', 'YESSICA DEL CARMEN  MATEUS TARAZONA', 'yessica.tarazona@meridianecp.com', '3228437251', 'Ingeniero de Petróleos', 'Profesional Senior para la ejecución de actividades de la ODS No. 90598918 del contrato Matriz No. 3037132', 'MER-ODS-90598918-38-2026', '2026-01-16', '2026-07-15', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(103, '1020792684', 'JORGE FELIPE ALARCON TORRES', 'jorge.alarcon@meridianecp.com', '3022867803', 'Ingeniero de petróleos', 'Profesional Junior para la ejecución de actividades de la ODS No. 90598918 del contrato Matriz No. 3037132', 'MER-ODS-90598918-39-2026', '2026-01-16', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(104, '91520047', 'JESUS DAVID ARENAS NAVARRO', 'jesus.arenas@meridianecp.com', '3183544282', 'Geólogo', 'Profesional Junior para la ejecucion de actividades de la ODS No. 90598918 del contrato Matriz No.3037132', 'MER-ODS-90598918-40-2026', '2026-01-16', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(105, '43578774', 'ALEJANDRA ARBELAEZ LONDOÑO', 'alejandra.arbelaez@meridianecp.com', '3006163730', 'Ingeniero de Petróleos', 'Profesional Senior para la ejecución de actividades de la ODS No. 90598918 del contrato Matriz No. 3037132', 'MER-ODS-90598918-41-2026', '2026-01-16', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(106, '1143327261', 'GIOVANNI MARTINEZ LEONES', 'giovanni.martinez@meridianecp.com', '3016620595', 'Ingeniero de Sistemas', 'Profesional Junior para la ejecución de actividades de la ODS No. 90598918 del contrato Matriz No. 3037132', 'MER-ODS-90598918-42-2026', '2026-01-16', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(107, '1098719174', 'OSCAR IVAN JIMENEZ BARANDICA', 'oscar.jimenez@meridianecp.com', '3157059227', 'Ingeniero Electrónico', 'Profesional Junior para la ejecución de actividades de la ODS No. 90598918 del contrato Matriz No. 3037132', 'MER-ODS-90598918-43-2026', '2026-01-16', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(108, '1072699593', 'RUBEN DARIO ORTIZ MURCIA', 'ruben.ortiz@meridianecp.com', '3144574949-3156600881', 'Ingeniero de Petróleos', 'Profesional Senior para la ejecución de actividades de la ODS No. 90599358 del contrato Matriz No. 3037132', 'MER-ODS-90599358-44-2026', '2026-01-16', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(109, '1098782789', 'JUAN SEBASTIAN AVILA PARRA', 'juan.avila@meridianecp.com', '3105854019', 'Ing. de Petróleos - Geólogo', 'Profesional Junior para la ejecucion de actividades de la ODS No. 90599358 del contrato Matriz No.3037132', 'MER-ODS-90599358-45-2026', '2026-01-16', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(110, '24332450', 'LILIANA MARTINEZ URIBE', 'liliana.martinez@meridianecp.com', '3102553497', 'Geólogo', 'Profesional Senior para la ejecución de actividades de la ODS No. 90599358 del contrato Matriz No. 3037132', 'MER-ODS-90599358-55-2026', '2026-01-16', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(111, '1010167959', 'FRANKLIN ALEJANDRO BOTERO RIVERA', 'alejandro.botero@meridianecp.com', '3046364482', 'Ingeniero de Petróleos', 'Profesional Senior para la ejecución de actividades de la ODS No. 90599924 del contrato Matriz No. 3037132', 'MER-ODS-90599924-56-2026', '2026-01-16', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(112, '1075293846', 'DANIELA MOLINA LANDINEZ', 'daniela.molina@meridianecp.com', '3123109391', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecucion de actividades de la ODS No. 90599924 del contrato Matriz No.3037132', 'MER-ODS-90599924-57-2026', '2026-01-16', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(113, '1075263195', 'JESUS ERNESTO COQUECO VARGAS', 'jesus.coqueco@meridianecp.com', '3209113396', 'Ingeniero de Petróleos', 'Profesional Senior para la ejecución de actividades de la ODS No. 90599924 del contrato Matriz No. 3037132', 'MER-ODS-90599924-58-2026', '2026-01-16', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(114, '1098761186', 'ALEXANDRA KATHERINE LONDOÑO CAMACHO', 'alexandra.londono@meridianecp.com', '3162343563', 'Ingeniera de petróleos', 'Profesional Junior para la ejecución de actividades de la ODS No. 90599924 del contrato Matriz No. 3037132', 'MER-ODS-90599924-59-2026', '2026-01-16', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(115, '1017211010', 'MARIA ALEJANDRA  GIRALDO MUÑOZ', 'maria.giraldo@meridianecp.com', '3017742634', 'Ingeniera de petróleos', 'Profesional Senior para la ejecución de actividades de la ODS No. 90599924 del contrato Matriz No. 3037132', 'MER-ODS-90599924-60-2026', '2026-01-16', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(116, '1075239408', 'LENIN  CORDOBA RIVAS', 'lenin.cordoba@meridianecp.com', '3214568903', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecución de actividades de la ODS No. 90599924 del contrato Matriz No. 3037132', 'MER-ODS-90599924-61-2026', '2026-01-16', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(117, '1081820719', 'JAVIER ENRIQUE GUERRERO ARRIETA', 'javier.guerrero@meridianecp.com', '3004958242', 'Ingeniero de petróleos', 'Profesional Senior para la ejecución de actividades de la ODS No. 90599924 del contrato Matriz No. 3037132', 'MER-ODS-90599924-62-2026', '2026-01-16', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(118, '52556069', 'YOHANEY LUCIA GOMEZ GALARZA', 'yohaney.gomez@meridianecp.com', '3153934777', 'Ingeniera de Petroleos', 'Profesional Senior para la ejecucion de actividades de la ODS No. 1661981  del contrato Matriz No.3037132', 'MER-ODS-1661981-63-2026', NULL, '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(119, '1032414423', 'LAURA MARIA  HERNANDEZ RIVEROS', 'laura.hernandez@meridianecp.com', '3235904772', 'Ingeniero de Petróleos', 'Profesional Senior para la ejecución de actividades de la ODS No. 90590325 del contrato Matriz No. 3037132', 'MER-ODS-90590325-31-2026', '2026-01-19', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(120, '1128452509', 'CINDY NATALIA ISAZA TORO', 'cindy.isaza@meridianecp.com', '3053271677', 'Ingeniero de Petróleos', 'Profesional Senior para la ejecución de actividades de la ODS No. 90612258 del contrato Matriz No. 3037132', 'MER-ODS-90612258-64-2026', '2026-01-20', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(121, '1013629348', 'CHRISTIAN CAMILO RIVERA SANCHEZ', 'christian.rivera@meridianecp.com', '3115546422', 'Ingeniero de Petróleos', 'Profesional Senior para la ejecución de actividades de la ODS No. 90612258 del contrato Matriz No. 3037132', 'MER-ODS-90612258-65-2026', '2026-01-20', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(122, '1098697791', 'MARIA ALEJANDRA JOYA RINCON', 'alejandra.joya@meridianecp.com', '3158471823', 'Geólogo', 'Profesional Senior para la ejecución de actividades de la ODS No. 90045724 del contrato Matriz No. 3037132', 'MER-ODS-90599358-66-2026', '2026-01-20', '2026-04-19', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(123, '1039448281', 'CRISTINA CARO VELEZ', 'cristina.caro@meridianecp.com', '3187120087', 'Ingeniero de Petróleos', 'Profesional Senior para la ejecución de actividades de la ODS No. 90049330 del contrato Matriz No. 3037132', 'MER-ODS-90049330-67-2026', '2026-01-26', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(124, '1075215815', 'MELINA ANDREA  RIVERA MANRIQUE', 'melina.rivera@meridianecp.com', '3134024281', 'Ingeniero de Petróleos', 'Profesional Senior para la ejecución de actividades de la ODS No. 90049330 del contrato Matriz No. 3037132', 'MER-ODS-90049330-68-2026', '2026-01-26', '2026-03-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(125, '1075212439', 'MARIANN LISSETTE MAHECHA LAVERDE', 'mariann.mahecha@meridianecp.com', '3164987258', 'Ingeniera de Petróleos', 'Profesional Senior para la ejecución de actividades de la ODS No. 90632454 del contrato Matriz No. 3037132', 'MER-ODS-90632454-69-2026', '2026-01-27', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(126, '478731', 'ZENAIDA DEL VALLE MARCANO DE VILLARROEL', 'zenaida.marcano@meridianecp.com', '3057684591', 'Ingeniero en Petróleo', 'Profesional Senior para la ejecución de actividades de la ODS No. 90598546 del contrato Matriz No. 3037132', 'MER-ODS-90598546-70-2026', '2026-01-28', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(127, '91514446', 'GERMAN DARIO OREJARENA ESCOBAR', 'german.orejarena@meridianecp.com', '3164954753', 'Geólogo', 'Profesional Senior para la ejecucion de actividades de la ODS No. 90642057 del contrato Matriz No.3037132', 'MER-ODS-90642057-71-2026', '2026-02-02', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(128, '79686130', 'RICARDO GAVIRIA GARCIA', 'ricardo.gaviria@meridianecp.com', '3243242116', 'Ingeniero de Petróleos', 'Profesional Senior para la ejecucion de actividades de la ODS No. 90642057 del contrato Matriz No.3037132', 'MER-ODS-90642057-72-2026', '2026-02-02', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(129, '71787712', 'HUGO QUIROGA CRUZ', 'hugo.quiroga@meridianecp.com', '3187401374', 'Ingeniero de Petróleos', 'Profesional Senior para la ejecución de actividades de la ODS No. 90577770 del contrato Matriz No. 3037132', 'MER-ODS-90577770-73-2026', '2026-02-02', '2026-08-01', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(130, '1016597', 'JEAN PABLO CEDEÑO ORFILA', 'jean.cedeno@meridianecp.com', '3015428536', 'Ingeniero de Petróleos', 'Profesional Senior para la ejecución de actividades de la ODS No. 90658180 del contrato Matriz No. 3037132', 'MER-ODS-90658180-74-2026', '2026-02-05', '2026-05-04', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(131, '1087047704', 'YUBER RODRIGUEZ ARTURO', 'yuber.rodriguez@meridianecp.com', '3128357827', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecucion de actividades de la ODS No. 90658180 del contrato Matriz No. 3037132', 'MER-ODS-90658180-75-2026', '2026-02-05', '2026-05-04', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(132, '1040746072', 'KELLY LORENA DIEZ HERNANDEZ', 'kelly.diez@meridianecp.com', '3053189327', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecucion de actividades de la ODS No. 90658180 del contrato Matriz No. 3037132', 'MER-ODS-90658180-76-2026', '2026-02-05', '2026-05-04', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(133, '1098802405', 'LUIS ALBERTO CHINOMES GUALDRON', 'luis.chinomes@meridianecp.com', '3246306301', 'Ingeniero de Petróleos', 'Profesional Junior para la ejecución de actividades de la ODS No. 90599924 del contrato Matriz No. 3037132', 'MER-ODS-90599924-77-2026', '2026-02-13', '2026-08-31', '2026-02-23 20:35:49', '2026-02-23 20:35:49');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `import_batches`
--

CREATE TABLE `import_batches` (
  `id` bigint(20) NOT NULL,
  `source_name` varchar(255) NOT NULL,
  `imported_by` int(11) NOT NULL,
  `imported_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('Procesando','Exitoso','Con errores') NOT NULL DEFAULT 'Procesando',
  `summary` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`summary`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `import_errors`
--

CREATE TABLE `import_errors` (
  `id` bigint(20) NOT NULL,
  `batch_id` bigint(20) NOT NULL,
  `row_ref` varchar(50) DEFAULT NULL,
  `message` text NOT NULL,
  `raw_payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`raw_payload`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permissions`
--

CREATE TABLE `permissions` (
  `id` int(11) NOT NULL,
  `code` varchar(80) NOT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `permissions`
--

INSERT INTO `permissions` (`id`, `code`, `description`) VALUES
(1, 'REPORT_CREATE', 'Crear reportes'),
(2, 'REPORT_EDIT_OWN', 'Editar reportes propios'),
(3, 'REPORT_VIEW_OWN', 'Ver reportes propios'),
(4, 'REPORT_VIEW_ALL', 'Ver todos los reportes'),
(5, 'REPORT_APPROVE', 'Aprobar/rechazar reportes'),
(6, 'REPORT_EXPORT', 'Exportar reportes'),
(7, 'ODS_MANAGE', 'Crear/editar ODS y asignaciones');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reports`
--

CREATE TABLE `reports` (
  `id` bigint(20) NOT NULL,
  `service_order_id` bigint(20) NOT NULL,
  `period_id` int(11) NOT NULL,
  `reported_by` int(11) NOT NULL,
  `report_date` date NOT NULL,
  `service_classification_id` int(11) DEFAULT NULL,
  `status` enum('Borrador','Enviado','En revision','Aprobado','Rechazado','Anulado') NOT NULL DEFAULT 'Borrador',
  `month_contracted_days` int(11) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `report_approvals`
--

CREATE TABLE `report_approvals` (
  `id` bigint(20) NOT NULL,
  `report_id` bigint(20) NOT NULL,
  `approver_id` int(11) NOT NULL,
  `decision` enum('Pendiente','Aprobado','Rechazado') NOT NULL DEFAULT 'Pendiente',
  `decision_message` text DEFAULT NULL,
  `decided_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `report_attachments`
--

CREATE TABLE `report_attachments` (
  `id` bigint(20) NOT NULL,
  `report_id` bigint(20) NOT NULL,
  `report_line_id` bigint(20) DEFAULT NULL,
  `uploaded_by` int(11) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `storage_path` text NOT NULL,
  `mime_type` varchar(120) DEFAULT NULL,
  `file_size` bigint(20) DEFAULT NULL,
  `sha256` char(64) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `report_comments`
--

CREATE TABLE `report_comments` (
  `id` bigint(20) NOT NULL,
  `report_id` bigint(20) NOT NULL,
  `report_line_id` bigint(20) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `comment` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `report_events`
--

CREATE TABLE `report_events` (
  `id` bigint(20) NOT NULL,
  `report_id` bigint(20) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `event_type` enum('CREATED','UPDATED','SUBMITTED','APPROVED','REJECTED','STATUS_CHANGED','IMPORTED','DELETED') NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`payload`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `report_item_catalog`
--

CREATE TABLE `report_item_catalog` (
  `id` bigint(20) NOT NULL,
  `item_general` varchar(20) NOT NULL,
  `item_activity` varchar(20) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `report_lines`
--

CREATE TABLE `report_lines` (
  `id` bigint(20) NOT NULL,
  `report_id` bigint(20) NOT NULL,
  `item_catalog_id` bigint(20) DEFAULT NULL,
  `item_general` varchar(20) DEFAULT NULL,
  `item_activity` varchar(20) DEFAULT NULL,
  `activity_description` text NOT NULL,
  `support_text` text DEFAULT NULL,
  `support_type_id` int(11) DEFAULT NULL,
  `delivery_medium_id` int(11) DEFAULT NULL,
  `contracted_days` int(11) DEFAULT NULL,
  `days_month` decimal(10,2) NOT NULL DEFAULT 0.00,
  `progress_percent` decimal(6,4) NOT NULL DEFAULT 0.0000,
  `accumulated_days` decimal(10,2) NOT NULL DEFAULT 0.00,
  `accumulated_progress` decimal(6,4) NOT NULL DEFAULT 0.0000,
  `observations` text DEFAULT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `report_periods`
--

CREATE TABLE `report_periods` (
  `id` int(11) NOT NULL,
  `year` smallint(6) NOT NULL,
  `month` tinyint(3) UNSIGNED NOT NULL,
  `label` varchar(20) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id`, `name`, `description`, `is_active`) VALUES
(1, 'colaborador', 'Diligencia reportes propios', 1),
(2, 'profesional_proyectos', 'Visualiza todo y genera reportes/dashboards', 1),
(3, 'interventoria', 'Revisa, comenta y puede aprobar/rechazar', 1),
(4, 'gerencia', 'Visualiza todo (lectura)', 1),
(5, 'admin', 'Administra todo el sistema', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `role_permissions`
--

CREATE TABLE `role_permissions` (
  `role_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `role_permissions`
--

INSERT INTO `role_permissions` (`role_id`, `permission_id`) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 4),
(2, 6),
(3, 4),
(3, 5),
(3, 6),
(4, 4),
(4, 6),
(5, 1),
(5, 4),
(5, 5),
(5, 6),
(5, 7);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `service_classifications`
--

CREATE TABLE `service_classifications` (
  `id` int(11) NOT NULL,
  `name` varchar(120) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `service_orders`
--

CREATE TABLE `service_orders` (
  `id` bigint(20) NOT NULL,
  `ods_code` varchar(50) NOT NULL,
  `project_name` varchar(200) DEFAULT NULL,
  `area_id` int(11) DEFAULT NULL,
  `object_text` text DEFAULT NULL,
  `term_text` varchar(200) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `status` enum('Activa','Suspendida','Cerrada') NOT NULL DEFAULT 'Activa',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `service_orders`
--

INSERT INTO `service_orders` (`id`, `ods_code`, `project_name`, `area_id`, `object_text`, `term_text`, `start_date`, `end_date`, `status`, `created_at`, `updated_at`) VALUES
(1, '90045724', 'PETROSERVICIOS', NULL, 'ervicio para la elaboración de entregables petrotécnicos para la disciplina de CCUS, a ejecutar por la Gerencia Centro Técnico De\r\nDesarrollo (GET) en la vigencia 2024', '4,5 meses', NULL, NULL, 'Activa', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(2, '90578295', 'PETROSERVICIOS', NULL, 'Entregables de proyectos en maduración y ejecución para incorporación de reservas del plan de inversiones 2026-2028 y monitoreo de yacimientos y producción, de los campos de la Gerencia de Operación y Mantenimiento Castilla – Apiay (GAA) que soporta la Gerencia de Desarrollo Orinoquia', 'de 3 meses contados a partir de la fecha de firma del Acta de Inicio de la Orden de Servicio, o de la fecha que en esta se indique, ó hasta el 31 de diciembre de 2025, lo que primero ocurra.', NULL, NULL, 'Activa', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(3, '90049330', 'PETROSERVICIOS', NULL, 'Servicio para la elaboración de entregables Petrotécnicos para la caracterización y gestión del yacimiento, y/o la construcción de escenarios de subsuelo y/o la planeación integrada del desarrollo, y/o la integración y análisis de oportunidades de desarrollo y el análisis de resultados y acciones de mejora al plan integrado de desarrollo de activos gor rubiales y caño sur este y gpa dina t – palogrande y río ceibas', 'de 11,5 meses contados a partir de la fecha de firma del Acta de Inicio de la Orden de Servicio, ó hasta el 31 de diciembre de 2025, lo que primero ocurra.', NULL, NULL, 'Activa', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(4, '90141005', 'PETROSERVICIOS', NULL, 'Servicio para monitoreo de yacimientos, análisis de resultados y acciones de mejora en producción, planeación integrada del desarrollo, análisis de oportunidades de desarrollo, y/o acciones de mejora a proyectos nuevos, en maduración y ejecución para la incorporación de reservas, que soporta la Gerencia de Desarrollo Orinoquía en los campos de la Gerencia de Operación y Mantenimiento Chichimene – CPO-9 (GLH) y la Gerencia de Operación y Mantenimiento Castilla – Apiay (GAA)', 'de 9 meses contados a partir de la fecha de firma del Acta de Inicio de la Orden de Servicio, o de la fecha que en esta se indique, ó hasta el 31 de diciembre de 2025, lo que primero ocurra.', NULL, NULL, 'Activa', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(5, '90172266', 'PETROSERVICIOS', NULL, 'Construcción de escenarios de subsuelo y/o la integración y análisis de oportunidades de desarrollo y el análisis de resultados y acciones de mejora al plan integrado de desarrollo en maduración y ejecución para la incorporación de reservas, que soporta la Gerencia de Desarrollo Andina Oriente en los campos de la Gerencia de Operación y Mantenimiento Andina para los activos de la GPA', 'de 8,3 meses contados a partir de la fecha de firma del Acta de Inicio de la Orden de Servicio, o de la fecha que en esta se indique, ó hasta el 31 de diciembre de 2025, lo que primero ocurra.', NULL, NULL, 'Activa', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(6, '90227898', 'PETROSERVICIOS', NULL, 'Ejecución para la incorporación de reservas, análisis de resultados y acciones de mejora al plan integrado de desarrollo, construcción de escenarios de subsuelo y la integración, análisis de oportunidades de desarrollo, que soportan la Gerencia de Desarrollo Andina Oriente en los campos de la Gerencia de Operación y Mantenimiento Oriente para los activos de la GOR', 'de 7 meses contados a partir de la fecha de firma del Acta de Inicio de la Orden de Servicio, o de la fecha que en esta se indique, ó hasta el 31 de diciembre de 2025, lo que primero ocurra.', NULL, NULL, 'Activa', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(7, 'GRM-02-07-202', 'COMPANY CW281880 - CANTAGALLO', NULL, '\"Servicio de ingeniería, planeación y supervisión integral de pozos en perforación, completamiento e intervenciones a pozo en ECOPETROL S.A.\"', '184 días', NULL, NULL, 'Activa', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(8, 'GSS-01-06-2025', 'COMPANY CW281880 - PIEDEMONTE', NULL, '\"Servicio de ingeniería, planeación y supervisión integral de pozos en perforación, completamiento e intervenciones a pozo en ECOPETROL S.A.\"', '184 días', NULL, NULL, 'Activa', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(9, 'GGS-01-062025', 'COMPANY CW281880 - Provincia', NULL, '\"Servicio de ingeniería, planeación y supervisión integral de pozos en perforación, completamiento e intervenciones a pozo en ECOPETROL S.A.\"', '184 días', NULL, NULL, 'Activa', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(10, 'GRM-02-07 2025', 'COMPANY CW281880 - YONDO', NULL, '\"Servicio de ingeniería, planeación y supervisión integral de pozos en perforación, completamiento e intervenciones a pozo en ECOPETROL S.A.\"', '184 días', NULL, NULL, 'Activa', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(11, '90577837', 'PETROSERVICIOS', NULL, 'Servicio para la elaboración de entregables petrotécnicos relacionados con la disciplina de Ingeniería de Facilidades para las actividades de visualización de facilidades y estimación de capex y costos operativos a ejecutar por la Gerencia de Servicios de Exploración que pertenece a la Gerencia General Costa Afuera y exploración durante la vigencia 2026', 'de 8 meses contados a partir de la fecha de firma del Acta de Inicio de la Orden de Servicio, o de la fecha que en esta se indique, ó hasta el 31 de diciembre de 2025, lo que primero ocurra.', NULL, NULL, 'Activa', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(12, '90577770', 'PETROSERVICIOS', NULL, 'Servicio para la caracterización y gestión del yacimiento que soporten estudios para la implementación de tecnologías de recobro en el área Teca - Nare, proyectos de WO en los campos de la Gerencia Río Mares y el proyecto integral de crecimiento en el campo Yariguí; así como la integración y análisis de oportunidades de desarrollo de campos pertenecientes a la Gerencia General de Desarrollo y la Gerencia de Desarrollo Central (GCE)', 'de 7,9 meses contados a partir de la fecha de firma del Acta de Inicio de la Orden de Servicio, o de la fecha que en esta se indique, ó hasta el 31 de diciembre de 2025, lo que primero ocurra.', NULL, NULL, 'Activa', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(13, '90594501', 'PETROSERVICIOS', NULL, 'Servicio para la caracterización y gestión del yacimiento, de la Gerencia de Desarrollo Activos No Operados GNO en la disciplina de ingeniería de yacimientos activos Capachos - Andina - Arauca - GNO', 'de 7,83 meses a partir de la fecha que se indique en el Acta de Inicio de la Orden de Servicio, ó hasta el 31 de agosto de 2026, lo que primero ocurra.', NULL, NULL, 'Activa', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(14, 'GGS-01-06-2025 PROVINCIA', 'COMPANY CW281880 - PROVINCIA', NULL, '\"Servicio de ingeniería, planeación y supervisión integral de pozos en perforación, completamiento e intervenciones a pozo en ECOPETROL S.A.\"', '184 días', NULL, NULL, 'Activa', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(15, '90590325', 'PETROSERVICIOS', NULL, 'Servicio en las disciplinas especializadas de geomodelamiento, petrofísica, ingeniería de yacimientos y data analytics para la evaluación integral y desarrollo de las oportunidades de negocio estratégicas a nivel nacional y/o internacional, la elaboración de planes de desarrollo conceptuales e integrados, y/o identificación de alternativas optimas de desarrollo, y/o evaluación técnico económica de las oportunidades, y la toma de decisiones robustas en procesos de inversión, desinversión y/o dilución de activos para el departamento de análisis técnico de nuevos negocios DAT', 'de 7,6 meses a partir de la fecha que se indique en el Acta de Inicio de la Orden de Servicio, ó hasta el 31 de agosto de 2026, lo que primero ocurra.', NULL, NULL, 'Activa', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(16, '90600752', 'PETROSERVICIOS', NULL, 'Servicio para la caracterización y gestión del yacimiento, y/o la construcción de escenarios de subsuelo y/o la planeación integrada del desarrollo, y/o la integración y análisis de oportunidades de desarrollo y el análisis de resultados y acciones de mejora al Plan Integrado de Desarrollo (PID) para la Gerencia de Desarrollo de Gas (GDG) 2026', 'de 7,6 meses a partir de la fecha que se indique en el Acta de Inicio de la Orden de Servicio, ó hasta el 31 de agosto de 2026, lo que primero ocurra.', NULL, NULL, 'Activa', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(17, '90560321', 'PETROSERVICIOS', NULL, 'Servicio para la elaboración de entregables petrotécnicos para estudios transversales de Geoquímica, Geomática y Sismología a ejecutar por la Gerencia Técnico de Desarrollo y Produccion (GET) 2026', 'de 7,5 meses a partir de la fecha que se indique en el Acta de Inicio de la Orden de Servicio, ó hasta el 31 de agosto de 2026, lo que primero ocurra.', NULL, NULL, 'Activa', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(18, '90598918', 'PETROSERVICIOS', NULL, 'Servicio para la elaboración de entregables petrotécnicos para estudios transversales de Geotermia, Analítica de datos, PVT, CCUS y Optimización de producción – GOP a ejecutar por la Gerencia Técnico de Desarrollo y Produccion (GET) 2026', 'de 7,5 meses a partir de la fecha que se indique en el Acta de Inicio de la Orden de Servicio, ó hasta el 31 de agosto de 2026, lo que primero ocurra.', NULL, NULL, 'Activa', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(19, '90599358', 'PETROSERVICIOS', NULL, 'Servicio para la elaboración de entregables petrotécnicos para estudios transversales de Geología y Geofísica G&G a ejecutar por la Gerencia Técnica de Desarrollo y Producción (GET) 2026', 'de 7,5 meses a partir de la fecha que se indique en el Acta de Inicio de la Orden de Servicio, ó hasta el 31 de agosto de 2026, lo que primero ocurra.', NULL, NULL, 'Activa', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(20, '90599924', 'PETROSERVICIOS', NULL, 'Servicio para la elaboración de entregables petrotécnicos para estudios transversales asociados con Seguimiento a Optimización y Producción, Recobro Mejorado, Nanotecnología y Prueba de Pozos a ejecutar por la Gerencia Técnica de Desarrollo y Producción (GET) 2026', 'de 7,5 meses a partir de la fecha que se indique en el Acta de Inicio de la Orden de Servicio, ó hasta el 31 de agosto de 2026, lo que primero ocurra.', NULL, NULL, 'Activa', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(21, '1661981', 'PETROSERVICIOS', NULL, 'Servicio para la caracterización y gestión del yacimiento, y/o la construcción de escenarios de subsuelo y/o la planeación integral y desarrollo, en las disciplinas de ingeniería de yacimientos y modelador PID para el departamento de análisis técnico de nuevos negocios - DAT, atendiendo oportunidades estratégicas a nivel nacional y/o internacional', 'de 7,5 meses a partir de la fecha que se indique en el Acta de Inicio de la Orden de Servicio, ó hasta el 31 de agosto de 2026, lo que primero ocurra.', NULL, NULL, 'Activa', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(22, '90612258', 'PETROSERVICIOS', NULL, 'Servicio para la caracterización y gestión del yacimiento, y/o la construcción de escenarios de subsuelo y/o la planeación integrada del desarrollo, plan integrado de desarrollo para Marsella - GNO 2026', 'de 7,4 meses a partir de la fecha que se indique en el Acta de Inicio de la Orden de Servicio, ó hasta el 31 de agosto de 2026, lo que primero ocurra.', NULL, NULL, 'Activa', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(23, '90632454', 'PETROSERVICIOS', NULL, 'Servicio para la caracterización y gestión del yacimiento, y/o la construcción de escenarios de subsuelo y/o la planeación integrada del desarrollo, y/o la integración y análisis de oportunidades de desarrollo y el análisis de resultados y acciones de mejora al plan integrado de desarrollo en la disciplina de ingeniería de yacimientos foco Offshore en la Gerencia de Desarrollo de Gas GDG, para vigencia 2026', 'de 7,5 meses contados a partir de la fecha de firma del Acta de Inicio de la Orden de Servicio, o de la fecha que en esta se indique, ó hasta el 31 de agosto de 2026, lo que primero ocurra.', NULL, NULL, 'Activa', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(24, '90598546', 'PETROSERVICIOS', NULL, 'Servicio para la caracterización y gestión del yacimiento, de la Gerencia de Desarrollo de Activos con Socios GNO en la disciplina petrofísica desarrollo 2026', 'de 7,1 meses contados a partir de la fecha de firma del Acta de Inicio de la Orden de Servicio, o de la fecha que en esta se indique, ó hasta el 31 de agosto de 2026, lo que primero ocurra.', NULL, NULL, 'Activa', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(25, '90642057', 'PETROSERVICIOS', NULL, 'Servicio para la caracterización y gestión del yacimiento, y/o la construcción de escenarios de subsuelo y/o la planeación integrada del desarrollo, y/o la integración y análisis de oportunidades de desarrollo y el análisis de resultados y acciones de mejora al plan integrado de desarrollo para la Gerencia de Desarrollo de Activos con Socios GNO 2026', 'de 6.97 meses contados a partir de la fecha de firma del Acta de Inicio de la Orden de Servicio, o de la fecha que en esta se indique, ó hasta el 31 de agosto de 2026, lo que primero ocurra.', NULL, NULL, 'Activa', '2026-02-23 20:35:49', '2026-02-23 20:35:49'),
(26, '90658180', 'PETROSERVICIOS', NULL, 'Servicios para la planeación integrada del Desarrollo y soporte al proyecto incremental Desarrollo Yariguí Módulo 2 Etapa 2', 'de 3 meses a partir de la fecha que se indique en el Acta de Inicio de la Orden de Servicio, ó hasta el 31 de agosto de 2026, lo que primero ocurra.', NULL, NULL, 'Activa', '2026-02-23 20:35:49', '2026-02-23 20:35:49');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `service_order_employees`
--

CREATE TABLE `service_order_employees` (
  `id` bigint(20) NOT NULL,
  `service_order_id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `level_id` int(11) DEFAULT NULL,
  `assignment_start` date DEFAULT NULL,
  `assignment_end` date DEFAULT NULL,
  `contracted_days` int(11) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `service_order_employees`
--

INSERT INTO `service_order_employees` (`id`, `service_order_id`, `user_id`, `level_id`, `assignment_start`, `assignment_end`, `contracted_days`, `is_active`, `created_at`) VALUES
(1, 1, 1, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(2, 2, 2, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(3, 3, 3, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(4, 3, 4, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(5, 3, 5, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(6, 3, 6, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(7, 3, 7, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(8, 3, 8, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(9, 3, 9, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(10, 3, 10, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(11, 3, 11, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(12, 3, 12, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(13, 4, 13, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(14, 4, 14, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(15, 4, 15, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(16, 4, 16, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(17, 4, 17, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(18, 4, 18, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(19, 4, 19, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(20, 4, 20, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(21, 4, 21, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(22, 4, 22, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(23, 4, 23, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(24, 4, 24, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(25, 4, 25, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(26, 4, 26, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(27, 5, 27, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(28, 6, 28, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(29, 7, 29, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(30, 7, 30, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(31, 8, 31, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(32, 7, 32, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(33, 7, 33, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(34, 8, 34, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(35, 7, 35, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(36, 7, 36, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(37, 7, 37, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(38, 7, 38, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(39, 8, 39, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(40, 7, 40, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(41, 7, 41, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(42, 7, 42, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(43, 7, 43, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(44, 8, 44, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(45, 7, 45, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(46, 8, 46, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(47, 7, 47, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(48, 7, 48, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(49, 8, 49, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(50, 8, 50, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(51, 8, 51, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(52, 8, 52, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(53, 8, 53, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(54, 9, 54, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(55, 10, 55, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(56, 2, 56, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(57, 2, 57, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(58, 2, 58, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(59, 2, 59, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(60, 2, 60, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(61, 2, 61, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(62, 2, 62, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(63, 2, 63, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(64, 2, 64, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(65, 2, 65, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(66, 2, 66, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(67, 2, 67, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(68, 2, 68, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(69, 2, 69, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(70, 2, 70, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(71, 11, 71, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(72, 12, 72, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(73, 12, 73, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(74, 12, 74, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(75, 12, 75, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(76, 12, 76, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(77, 12, 77, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(78, 12, 78, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(79, 12, 79, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(80, 13, 80, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(81, 14, 81, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(82, 15, 82, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(83, 15, 83, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(84, 15, 84, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(85, 15, 85, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(86, 16, 86, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(87, 16, 87, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(88, 16, 88, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(89, 16, 89, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(90, 17, 90, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(91, 17, 91, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(92, 17, 92, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(93, 17, 93, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(94, 17, 94, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(95, 17, 95, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(96, 17, 96, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(97, 17, 97, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(98, 17, 98, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(99, 18, 99, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(100, 18, 100, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(101, 18, 101, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(102, 18, 102, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(103, 18, 103, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(104, 18, 104, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(105, 18, 105, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(106, 18, 106, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(107, 18, 107, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(108, 19, 108, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(109, 19, 109, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(110, 19, 110, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(111, 20, 111, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(112, 20, 112, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(113, 20, 113, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(114, 20, 114, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(115, 20, 115, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(116, 20, 116, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(117, 20, 117, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(118, 21, 118, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(119, 15, 119, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(120, 22, 120, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(121, 22, 121, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(122, 19, 122, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(123, 3, 123, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(124, 3, 124, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(125, 23, 125, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(126, 24, 126, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(127, 25, 127, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(128, 25, 128, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(129, 12, 129, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(130, 26, 130, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(131, 26, 131, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(132, 26, 132, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(133, 20, 133, NULL, NULL, NULL, NULL, 1, '2026-02-23 20:35:49'),
(134, 1, 134, NULL, NULL, NULL, NULL, 1, '2026-02-27 19:47:21');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `support_types`
--

CREATE TABLE `support_types` (
  `id` int(11) NOT NULL,
  `name` varchar(120) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tasks`
--

CREATE TABLE `tasks` (
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `task_report_links`
--

CREATE TABLE `task_report_links` (
  `id` bigint(20) NOT NULL,
  `task_id` int(11) NOT NULL,
  `report_line_id` bigint(20) NOT NULL,
  `linked_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `email`, `password_hash`) VALUES
(1, 'camila.medina@meridianecp.com', '$2y$10$4LKvvYK2UVh7DfnDxkbr8.xOZLtkWLzcRt/GPy2S8x/7QXgveNZMq'),
(2, 'aura.traslavina@meridianecp.com', '$2y$10$v5mxfc/.rKgJaA0In6FWWOtGEpuPLG/RFjlbSP37uJB3Mcb.zgxZa'),
(3, 'wcabrera@meridianecp.com', '$2y$10$Tl7I3rTr1A6AON4dRWPc8uxomPJdLVupp/wFtlfzb.6irqzGKrc6W'),
(4, 'sebastian.llanos@meridianecp.com', '$2y$10$F5wbb92170/UPtOVIanUzeU7iAMUMqODWTbRcB3tfTaXpUDX0KHGe'),
(5, 'oveimar.santamaria@meridianecp.com', '$2y$10$R0PZrQZEa8dfYns24Pzk7u0K1c8.nlOw92Kccgsw6OcVq3b14rsIO'),
(6, 'lady.lopez@meridian.com.co', '$2y$10$tNugsFF2KO31/wRjnQNUaO7zExjXhFX38Zf8fgJmX5R6tfGZCAPPW'),
(7, 'jully.vargas@meridianecp.com', '$2y$10$GzlSvCKn74zuxvzPMca61.opzaB91VSmN35SEOnXINN73CM9D0fiK'),
(8, 'esperanza.cotes@meridianecp.com', '$2y$10$/eYQpfSj6BYXlErgm1Z0b.EvVMOyRiHQJSvMCDNgrCwE68Ly9LXrK'),
(9, 'Emeli.yacelga@meridianecp.com', '$2y$10$auj2lZ6Q10QXWRyHBqCRi.gLb6VFQNDcqcJBMnI1ZT2/Lfww5pT6C'),
(10, 'carlos.urzola@meridianecp.com', '$2y$10$dkLm01tZvkJN49IrAO8ruOZZ0JBCiO.SFpKhBYmkMK735rjqmGi/O'),
(11, 'leonardo.franco@meridianecp.com', '$2y$10$/9DIqhlcfdnwm4CotrMWSO2SZ8joBUMwP6YYl9r08hTYxso9ltBS6'),
(12, 'wilmar.delahoz@meridianecp.com', '$2y$10$XxMzlB/bMdE57mblKTlY9OhE7BxvMkjvE1HjSX92dyn5WQ6ckqIAq'),
(13, 'andres.morales@meridianecp.com', '$2y$10$ze/eh7QgNd67VGwYXa/5xefxZ/BYkz.0S6bUzjK/Rcdp34dJpPKT.'),
(14, 'monica.martinez@meridianecp.com', '$2y$10$4x8dpWa5yfs0wjUtW8f9bu9qpvYzcRV5aHgwE7EMvZn.Csl6sQT7G'),
(15, 'milton.gualteros@meridianecp.com', '$2y$10$9fNh.tqelbTIxerr0ZguMeuRnJ68NKOAFjv5cy0eKg46g4EI23fhu'),
(16, 'lizeth.bautista@meridianecp.com', '$2y$10$rvNByw6ab1xyIrMLaRhpAOElTyDNWb8y1/GLyLhWUiyajEdHepZPy'),
(17, 'julian.hernandez@meridianecp.com', '$2y$10$hlL1AhjKbznhwJD4/7VaoOPA72sJvhOmOSye4eA5dVF1YwAQWkrd6'),
(18, 'jhon.carreno@meridianecp.com', '$2y$10$TthfdS4z7BKRSYRW2z.fHemsHsRVy4A/VC/KNVydwBmNlczTa8jSi'),
(19, 'ivan.mozo@meridianecp.com', '$2y$10$O5Bg.csFyX/6RTeCrshxquXcvYqHkxYo3wlGb.YgwnCRyEb1iz7uu'),
(20, 'geisson.zafra@meridianecp.com', '$2y$10$iMAPS20T2Hk/HFFkB6XUjeX/kpen1yDQox3sldsu3DHxfUExVXXwS'),
(21, 'diego.galeano@meridianecp.com', '$2y$10$CXz2rP75NNdGo339rMoBce725Ox1D4rRGmuNe.e9XlwYnCBi5Q7Ma'),
(22, 'david.garcia@meridianecp.com', '$2y$10$hLWR5gzv93iFRTbpCAN49ebhWmnWdb.ZUNWHrKH2pJLoWRxOh3bdi'),
(23, 'christian.mendoza@meridianecp.com', '$2y$10$.v0kzJ9X3Gjho.fGUW2fJeDDOt9lgaYAHDjX8e7B1asZU5ld/Zy8y'),
(24, 'cesar.garnica@meridianecp.com', '$2y$10$KA4nZ5qLXTjwoyg14c8AqeHB/kVV51X3m50N.cyr4h3yB3qZpRUSG'),
(25, 'briggite.camacho@meridianecp.com', '$2y$10$RrNu3VjyxMBs4Zhe0XJiW.fNB28uwwE2AxDp5455fODu83YALo5eK'),
(26, 'alejandro.lopez@meridianecp.com', '$2y$10$WttQ3wdvx/esDPFJpvXG0edCQvkszItEXcEYcSngBp1YFoG0rQ47W'),
(27, 'carlos.espinosa@meridianecp.com', '$2y$10$iaIYddHEnnhFgc7asIwtbe161QFn8Sa9yOCf/oUj3Ia/ihZRJ9yca'),
(28, 'diego.martinez@meridianecp.com', '$2y$10$8bbxlXZXwObOQoHUq7KhJ.0MlxIwl/ao8VhYl1cTihlYysY/2b5qi'),
(29, 'amaogh@gmail.com', '$2y$10$StEi.0laqWB3w12HiUtmBOAc8QAyh2xLwl5gGg2fLChd5/OtpvvbO'),
(30, 'maryluzsantamaria@hotmail.com', '$2y$10$UnwMYVXNs1mT.F5xjwKf4uWrbJry4IxpC7oPD2udLM0rZBM9V.d2e'),
(31, 'VIANIRUIZ@GMAIL.COM', '$2y$10$UP6LEFz.VoSBhMgQkm1OWe8gS3/H3wX8BySSMtbnYEbWbPUVmSL5m'),
(32, 'cesarjuliocesar1997@gmail.com', '$2y$10$SwpH8lTGdXQzibGizPcFmODER3XmSrMhsQYgTNz0E1i/3CB9BhOcG'),
(33, 'jhonatantorresrdr@gmail.com', '$2y$10$/FkTM1c.aqDKPxUTELZF4.M2sZb7gFXOWlVD0xXwKFhkyaKz/xLDe'),
(34, 'miguelmolinave@gmail.com', '$2y$10$fPyBvMENu/9WKQwB2VyN3erDqwNj75Mt4KQoNLtJ8mlAfnSHNKVJq'),
(35, 'laucastro212011@gmail.com', '$2y$10$d9CoqRBOYXZ75HbheYE6fuU4378oN6/ZnXAr7RMXPDgq9QRE2z7/u'),
(36, 'GENIOALV@GMAIL.COM', '$2y$10$/I61XfXOIMAy68S.eMUILemfLJsQ/BGCqrqrE2ErI9qLCV7fW7j4C'),
(37, '01dianischavez@gmail.com', '$2y$10$bVUACxu4Fn9n29iFmX0gjeNJa84RWOAJt9fehcVzJP82qXaRhg6n2'),
(38, 'lamarcela1289@gmail.com', '$2y$10$dl/0XTWZCfrBZXKJ0U1hqehs7GOq0hmd3uESxL3ygAeOnF40pCIHK'),
(39, 'yorguinp@hotmail.com', '$2y$10$jB3GYasYSGEQVwi2YsoKjuM4sl1wVJlKGwGMOqVOF4ZXS3A0Dz3ES'),
(40, 'amtorop90@hotmail.com', '$2y$10$cNKsF.v.z9HNXTcgc5xve.j805OmmDUsYBcQmNxshN8wmWDYb.p8u'),
(41, 'yojan35@hotmail.com', '$2y$10$jIdPkw6LHHpRW.h9IAyY2uevr0bE.7XwCCfNhRuHWitqOIL.ZQLca'),
(42, 'aleja.2017@outlook.es', '$2y$10$beZ7oiywrMXvNi2jCkcri.5qWYQLbsc.i5VCoEHy6RhEnp0EItTD.'),
(43, 'datolo90@hotmail.com', '$2y$10$aOMf13nwayik0LH4vsBsbeBmuDBwcSvdy96O6wNiVLb8W90cxTiji'),
(44, 'ingcamilo.ibanez@gmail.com', '$2y$10$/45jjRw6tErVSujDIkFb9O46sPdOe6dnc7PDwxfYZjo0hlp2IGgsG'),
(45, 'yessica.alba19@gmail.com', '$2y$10$1I0UA68QyhCgwRkBEI1yke0H70cjKwZUQa9NajfVhLTmfEnKpp3TG'),
(46, 'ing.alexgonzalez@hotmail.com', '$2y$10$Ww8rCcts5ybKiSh5rMBndux32l7NLoRkEyDaYrRUe6yES9LS1uy/m'),
(47, 'Juanseb89@hotmail.com', '$2y$10$eiXCy9lpi0aHLhxS3vN0UONuWw8Kl0NkhJm4HNz9T5cw53oVdu3ky'),
(48, 'perlameli_92@hotmail.com', '$2y$10$xY1yhTJC/x.urcLpEVWzS.nofWkJt7IPSMsl0hb/gGToODMSSN3J2'),
(49, 'estebangr1987@gmail.com', '$2y$10$hcUEDVd/kCBMZ2nF/K9Hk.BntvbCRmmhavbAwSrj5lBQ.LiwBIOAy'),
(50, 'pedro.cadena@outlook.com', '$2y$10$YSfs7Tm.nLerImXBHvqGyexvn3KUY5.yOWRQT8trJfO0Ui8iuUBn6'),
(51, 'celiscarloss@gmail.com', '$2y$10$B1HYnlkyF5ZK41AwPna0t.hNjBFCHsYQxnUoUTvRz7Avo0CDuH4W.'),
(52, 'ricardocorreacerro@gmail.com', '$2y$10$WdepyuI0bpbsB1TqnOUSRuuPzH.ooAxk4PB/l8h57Zlie9pinnLWq'),
(53, 'julioromeroar@hotmail.com', '$2y$10$DPmi2kEt2CdGe0yN4H3oPuyMI3KnXm4v6TIzahdIkvbyHc9ci1c6K'),
(54, 'carlosfontalvocarrascal@hotmail.com', '$2y$10$vWr10ioy1wQawLppYDcw/eEx6HwUsBT4BZspHzz/vw1q1c8zGDmlm'),
(55, 'Dayansuarezh11@gmail.com', '$2y$10$wSAYZ1Od1jf0LvR3KQvwEuQZncZGJuQFIOdeeZNSKxWU.XWD3vOoG'),
(56, 'christian.pardo@meridianecp.com', '$2y$10$EzYve/l8gfRiJf3Q4866IueR6hZTCZ9ofvuvR.yhrW8F6jGUiOD..'),
(57, 'jose.nassar@meridianecp.com', '$2y$10$BOF75LaAuzT7mDz/csVfwu9bqQqz9Egf2Afc7ZXlfXPoW8FZQrbwe'),
(58, 'jaime.martinez@meridianecp.com', '$2y$10$AJUrYTilh52aNMZoDAsiT.bqHapTwXPeaALkBXXTbx2dHT6QhqYyy'),
(59, 'ana.castellanos@meridianecp.com', '$2y$10$9zRVzcs3mbZILwDPCqK8dudwR5/6tLwLgd5p6KE4Qab.JTh.eJip.'),
(60, 'diego.pinto@meridianecp.com', '$2y$10$K/qIwKt6MH2hr9gK14X/gOya5L7YHN00epEE1K9bMkMxGL0upPy5e'),
(61, 'gloria.vidal@meridianecp.com', '$2y$10$d8OFCDQlOShIo.YS8aiXT.ur48UphXQWCj6E3TEPjIoTk9F1VvoM.'),
(62, 'jesus.pacheco@meridianecp.com', '$2y$10$kGmeGZszhI3Tuakt/dNW1uIWAtbkzzv6WOxv222g1cLvBwLlgb56i'),
(63, 'cesar.rodriguez@meridianecp.com', '$2y$10$eT1QB8FsNRUmjjvnwMSKwu.zbbY2JjMJr1gApPLKPKgy0x8UUH7OK'),
(64, 'paola.gomez@meridianecp.com', '$2y$10$hNSegLCrDJNpH/cNj838QOXrDoj78oj9ajSXLERcTyb71Fi.pjlmG'),
(65, 'luis.monsalve@meridianecp.com', '$2y$10$RJwDWCkvsVnb4.8M7HfCe.8vUAx9ayIRqgT0OkUXi96TrDPsT0V3y'),
(66, 'carlos.olmos@meridianecp.com', '$2y$10$XYtKibrJ6vd/Q3p3RnqTKunthR9tqiui3C9Xp3VKopmlVyUnc40Fq'),
(67, 'nubia.reyes@meridianecp.com', '$2y$10$Oz9C8E75VBxnQDcfKUAW4OvkFshAXHuDWYU5cAvJwy9tjIQHka11i'),
(68, 'maria.mojica@meridianecp.com', '$2y$10$9H3Mb1h9eoRFSfddiir7MOpI7yiKXwlSva1PARkmHVojU/FruVvZ.'),
(69, 'diana.caceres@meridianecp.com', '$2y$10$pz4WayvlBKHdRoVyM8ojJ.GNNT2Op06LpQgQZ/WtfgC9ytVa8/jlq'),
(70, 'rafael.guatame@meridianecp.com', '$2y$10$iXpL/2c2oe/tEQ9suhe6v..skPk7IpSCVE4clgvzJijV.3YxicGUq'),
(71, 'ina.serrano@meridianecp.com', '$2y$10$SPEc9I.GK584obKcLi6gbued2.6DSBZu0YIGK8C..CUa9NaPCWL1y'),
(72, 'andres.bautista@meridianecp.com', '$2y$10$5BUVx3Kq2mpHzFL1KyG69e72/8ALI3aa8Ge3ojmzVE1GNTBgsJDNm'),
(73, 'jhon.cuesta@meridianecp.com', '$2y$10$WAg2NlIimNYYN0QhyUvyCeFJiDPRS6l8Jbqu2omq.lb9FRJgaiUA.'),
(74, 'jose.garcia@meridianecp.com', '$2y$10$B8fPqh2on9eQQszRVncvB.4G.aI2OtdAKEMPonf2Mwdi86hvmnzau'),
(75, 'emmanuel.robles@meridianecp.com', '$2y$10$boacwlAueUukVofZK6n32OLw0iLgRemLOiQxSLQfgUVTsYbkDdts6'),
(76, 'andres.amaya@meridianecp.com', '$2y$10$rUfBH4pBT9BP0I7/Lctz..kYUGe14jAbRgyem58BerSWGTXiZY9Qm'),
(77, 'angelica.prada@meridianecp.com', '$2y$10$lherxGD5PymVrjjgCowfOu359T1AtlbNcxUOMg8iPvCEux/vg/8wq'),
(78, 'estefany.velandia@meridianecp.com', '$2y$10$d3.tEY/PoHPX7we8uiZfQeKH/hqXcELoP0NIbZTgjrTCDCDcv2mdK'),
(79, 'ximena.rodriguez@meridianecp.com', '$2y$10$US2T9SDOsNBP.020r0V8V./4LCa8.B//s3PCe7MVHnlx2NtxzDvmy'),
(80, 'diego.castillo@meridianecp.com', '$2y$10$8HcJP4By.fp9fcEYVFa2KeXgbdYzQ49Sp20XcAgz6kpAO.3VMnZq2'),
(81, 'juducaza@hotmail.com', '$2y$10$NBdohezfnYrb6KB41fQ46OxtdEDsxis4Ice.gMYDGDlycVmBQDEnS'),
(82, 'carlos.forero@meridianecp.com', '$2y$10$3lYA4Z6EE2m0Wc2g1WH5XOoFsMfqqMdeEbQ8msiSFU9OFbke0l/gi'),
(83, 'alexandra.mesa@meridianecp.com', '$2y$10$Dp3ns2xlpALyr4pd01xk5u4gnRRUZmsMA8shp.U.FZuv1uvnBjxgm'),
(84, 'edna.nino@meridianecp.com', '$2y$10$c.4Gx5GNeOwkeNu.gDQeTu6B1c5lvV4oHRS47wRD6fmns93jrTLvy'),
(85, 'diana.solano@meridianecp.com', '$2y$10$OkM0Djcp1Yi2CGXfRbLd6uv5996zidpo6o7JorYOba8UJDgJgU636'),
(86, 'andres.anaya@meridianecp.com', '$2y$10$/LC1AkiwWIQC5ETHn5sUpuSMLdpc440ObWZG9UtGlyZaO/snS5Q1C'),
(87, 'gabriel.velez@meridianecp.com', '$2y$10$TS/3avJ.XOiQJK5qiuEdH.S3O.SvDy9IatTXCNGcX4hDcSD2.rh1u'),
(88, 'juanmateo.cordoba@meridianecp.com', '$2y$10$/oQjGVXGckxGu1.8LwLMVe0AOq2Hz3RcdqTM1YLx3zFNvuz7CUTUC'),
(89, 'maria.murillo@meridianecp.com', '$2y$10$083v9veBsG0pUPaSufVHmeB3e6e0DGJ4z5NHInPlxEon.3VmwFHCm'),
(90, 'adriana.duenes@meridianecp.com', '$2y$10$ykkyqKM.9.2LxDtGjcvXxurfqk91BgeMq5ZkwTCZYKsxVgXgAFdcC'),
(91, 'mario.moreno@meridianecp.com', '$2y$10$QzdBI5mY/ClLxGcG0Plj8.P3VLBJ.UTL4dm18JSTvW0HXp9VUkSZ6'),
(92, 'sergio.poveda@meridianecp.com', '$2y$10$VKadfUN7bhbp/mdW1OBrDO9kaY60U5oV1G.4Po7QHK/cmvK6QjyCW'),
(93, 'julio.figueroa@meridianecp.com', '$2y$10$qbX4LH7kxfcutVDjb4bp3.b90x6GrZ7KmAOIME.8fCPcoIR9hZGGK'),
(94, 'jorge.paiba@meridianecp.com', '$2y$10$nCx0y4Jz3TnJocAjHcjeAe1r.jKZYyCFqjOniWuh3RYrX/frknBVm'),
(95, 'jully.ortegon@meridianecp.com', '$2y$10$1a/eR6OiJPEkNl5ef9yfM.CZhl93Hd3eHh/r4UeeKhz2hOLCv5sNe'),
(96, 'edwin.mayorga@meridianecp.com', '$2y$10$efRMO4mih4OaOlqUnajwB.0V5eygytfZAvRpaUNdnNEVWpZcUEuMG'),
(97, 'mauricio.vasquez@meridianecp.com', '$2y$10$PGwnQWVtQ0hCuhq7Xa5jNuNOIV3MRZsbvbadpjZw.msgI75.0qV1y'),
(98, 'oscar.suarez@meridianecp.com', '$2y$10$DitCxq7CFkDGKdcXADBKuOn.Rtt9mwnPHZfe57UZI/F7mMwYNLvJG'),
(99, 'juandavid.aristizabal@meridianecp.com', '$2y$10$RN.0GDu6EtrQ6HwBKmXhPO5hScvhTrJJVBRdxeQYX.6ii4flQWD0K'),
(100, 'nicolas.avendano@meridianecp.com', '$2y$10$E.oSHClXq2esROmWB9RPg.c3tqmEv6Ojs9SjZAkCFK17mHPnwRccO'),
(101, 'camilo.santana@meridianecp.com', '$2y$10$RNXDDpAyXEmWH/QRD5zmJOY9IsZWJbxAsD7xUhMTQ1/CJAdv6ubaS'),
(102, 'yessica.tarazona@meridianecp.com', '$2y$10$mutcVBRnPLgvwgg9p/xkYOG0sBZm2ZzUPpZAgtENiy9vewPdnIiB6'),
(103, 'jorge.alarcon@meridianecp.com', '$2y$10$EEVvwtHdMchjdlOIJEi9l.JuW6.qG0.yZ3tnN65dEzNjY9BG/IzCK'),
(104, 'jesus.arenas@meridianecp.com', '$2y$10$ZPofmRW0O827oeqNRd58h.tuAaLKatNGPmD9Ih3PWJ.VVmWcV4SGO'),
(105, 'alejandra.arbelaez@meridianecp.com', '$2y$10$HaLOyTTgWdbugLzVGW77v.yWZzqT6RfPa102mnUOcXJO5Mr/8rdy6'),
(106, 'giovanni.martinez@meridianecp.com', '$2y$10$GNF7G/4IjRDXUXpHz4aty.MFFhKJQyrfEAB7EFRZe6HzmOlBNjTHG'),
(107, 'oscar.jimenez@meridianecp.com', '$2y$10$MKiwsVQwe5BElEOKhLJI3.VkCmkNg4KDNtI/8OqRN.QlhwNEO2CI2'),
(108, 'ruben.ortiz@meridianecp.com', '$2y$10$zKjmtaUogWXhhYq8JgK4BOe5HRNpn46cmcoMCWW6LQ1q5ocPI2Uea'),
(109, 'juan.avila@meridianecp.com', '$2y$10$LRL.LiqXgFjK5jzyQ72SJuN4iQ4YPiZwlrZ70BpBHMh9k8IoVfaUO'),
(110, 'liliana.martinez@meridianecp.com', '$2y$10$J.kr/vWcIgM2KQLGAEyoWeWrdUSiUbcbWUE2fGCL9DY97kg5fQjVm'),
(111, 'alejandro.botero@meridianecp.com', '$2y$10$4vSaqKxTQDAZIna9PZXw5OXC/y7rXo/xH1C4hffaMz2eD6DzQYvai'),
(112, 'daniela.molina@meridianecp.com', '$2y$10$7JebldbEh1x2LKreoyjhge5eNQpiCYktOvIhAseKYYvKdPXgB1dd2'),
(113, 'jesus.coqueco@meridianecp.com', '$2y$10$Swmz.7akBNGpYX9jq6EQP.oLOhTY7oirrF.6qcA12UhhW/VPCkp9G'),
(114, 'alexandra.londono@meridianecp.com', '$2y$10$YVsNNQt7p9.eFnn2K6Yv9ebib2QhrSnIGbytHKNW3.TnVw2BX6v/O'),
(115, 'maria.giraldo@meridianecp.com', '$2y$10$EN5UR34ZqfgrDxXFdZGmUOjgVMupt4Op28KQnrl.ru74y61q1gWHC'),
(116, 'lenin.cordoba@meridianecp.com', '$2y$10$FMW3VP3Q.ZT3qolnzQcOy.v9w1k20lQENLK2jG4WhslGv6QvjQlaG'),
(117, 'javier.guerrero@meridianecp.com', '$2y$10$xK5uviHeiVj.QgU22.c97uy/geSFqsLz/.KB0587/BK6luNuFSftS'),
(118, 'yohaney.gomez@meridianecp.com', '$2y$10$WCtBXdhBygIamoZFZa/9zuHLCdz5XTLY.YB9cY2LViqU/PlsBIR9a'),
(119, 'laura.hernandez@meridianecp.com', '$2y$10$tPx0gz8dvDrxrp3kKpxZYe0WzKWTynzAOsvf7UzbZ7/qx77K/3gHm'),
(120, 'cindy.isaza@meridianecp.com', '$2y$10$NzDr60AnGmBN5bJm6c8UOumFSxT3lZdNgMcri4A1XM8AkI4gQ.pbG'),
(121, 'christian.rivera@meridianecp.com', '$2y$10$ENApKkyRRDjUdaH7Q87DSOCiAFpTZq19hkv1TPW6NR56Ta49xwitS'),
(122, 'alejandra.joya@meridianecp.com', '$2y$10$FJngQozhowi9GL3vPwyU9udFaL7VSRSs9shkg5shZEzDILK/jlvfK'),
(123, 'cristina.caro@meridianecp.com', '$2y$10$OohrBUHcwPaBih.ndaAx7.XlHIH8fwPk64bnlK8fZE7MA7V6MEj6S'),
(124, 'melina.rivera@meridianecp.com', '$2y$10$ZSjaTWF0ThnXk3xkHVQFJ.79xBqiQWQlxf/kLyh9la7Eu2pZz6f0i'),
(125, 'mariann.mahecha@meridianecp.com', '$2y$10$YWnuWxPdFG/ZGGsuY.9ATe8kuY/Zj5FODGA9QjuiWsHkCTYGJPfIm'),
(126, 'zenaida.marcano@meridianecp.com', '$2y$10$d4G3rOlFBKrclZAwJtqpPeu0Sc7/s6aD46e0giu1wi8rOsv7OdFxi'),
(127, 'german.orejarena@meridianecp.com', '$2y$10$KsLbCEuQ/7Ca0wFFVuIlG.FLqsusVXfXQYwmlyEBKq39BuYT1JQNm'),
(128, 'ricardo.gaviria@meridianecp.com', '$2y$10$iH2MGQ3vOec5Drdd.e6YR.DofSeJlas8BY32Y9EYr/8kA6ukGcFEu'),
(129, 'hugo.quiroga@meridianecp.com', '$2y$10$9IxYWbQcWHuM2oosohGjq.Hgrw8uPQaOrXady3ALqlljEK2jrJyBW'),
(130, 'jean.cedeno@meridianecp.com', '$2y$10$rIPPs960Vr8nfXr6AD7nNOSTce13Y/c3nMV95CeSxozKMyXPmxVBG'),
(131, 'yuber.rodriguez@meridianecp.com', '$2y$10$gebxMG6dpFrmU.d4RnpnweVAKF.FUTp/iqrAANQeW9/9PuJD8JLcS'),
(132, 'kelly.diez@meridianecp.com', '$2y$10$CHPnjs9P/YYBdEK.WEaHCuOlhV7zpSOGvj0W/lh9BaYOkmeWmapu.'),
(133, 'luis.chinomes@meridianecp.com', '$2y$10$o5vewpHDC5YwoVTxZDq75.zjzoEHZfj10UeS2xhlIS5fbmHKNqW32'),
(134, 'admin@reportes.local', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_roles`
--

CREATE TABLE `user_roles` (
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `user_roles`
--

INSERT INTO `user_roles` (`user_id`, `role_id`, `created_at`) VALUES
(1, 1, '2026-02-23 20:35:50'),
(2, 1, '2026-02-23 20:35:50'),
(3, 1, '2026-02-23 20:35:50'),
(4, 1, '2026-02-23 20:35:50'),
(5, 1, '2026-02-23 20:35:50'),
(6, 1, '2026-02-23 20:35:50'),
(7, 1, '2026-02-23 20:35:50'),
(8, 1, '2026-02-23 20:35:50'),
(9, 1, '2026-02-23 20:35:50'),
(10, 1, '2026-02-23 20:35:50'),
(11, 1, '2026-02-23 20:35:50'),
(12, 1, '2026-02-23 20:35:50'),
(13, 1, '2026-02-23 20:35:50'),
(14, 1, '2026-02-23 20:35:50'),
(15, 1, '2026-02-23 20:35:50'),
(16, 1, '2026-02-23 20:35:50'),
(17, 1, '2026-02-23 20:35:50'),
(18, 1, '2026-02-23 20:35:50'),
(19, 1, '2026-02-23 20:35:50'),
(20, 1, '2026-02-23 20:35:50'),
(21, 1, '2026-02-23 20:35:50'),
(22, 1, '2026-02-23 20:35:50'),
(23, 1, '2026-02-23 20:35:50'),
(24, 1, '2026-02-23 20:35:50'),
(25, 1, '2026-02-23 20:35:50'),
(26, 1, '2026-02-23 20:35:50'),
(27, 1, '2026-02-23 20:35:50'),
(28, 1, '2026-02-23 20:35:50'),
(29, 1, '2026-02-23 20:35:50'),
(30, 1, '2026-02-23 20:35:50'),
(31, 1, '2026-02-23 20:35:50'),
(32, 1, '2026-02-23 20:35:50'),
(33, 1, '2026-02-23 20:35:50'),
(34, 1, '2026-02-23 20:35:50'),
(35, 1, '2026-02-23 20:35:50'),
(36, 1, '2026-02-23 20:35:50'),
(37, 1, '2026-02-23 20:35:50'),
(38, 1, '2026-02-23 20:35:50'),
(39, 1, '2026-02-23 20:35:50'),
(40, 1, '2026-02-23 20:35:50'),
(41, 1, '2026-02-23 20:35:50'),
(42, 1, '2026-02-23 20:35:50'),
(43, 1, '2026-02-23 20:35:50'),
(44, 1, '2026-02-23 20:35:50'),
(45, 1, '2026-02-23 20:35:50'),
(46, 1, '2026-02-23 20:35:50'),
(47, 1, '2026-02-23 20:35:50'),
(48, 1, '2026-02-23 20:35:50'),
(49, 1, '2026-02-23 20:35:50'),
(50, 1, '2026-02-23 20:35:50'),
(51, 1, '2026-02-23 20:35:50'),
(52, 1, '2026-02-23 20:35:50'),
(53, 1, '2026-02-23 20:35:50'),
(54, 1, '2026-02-23 20:35:50'),
(55, 1, '2026-02-23 20:35:50'),
(56, 1, '2026-02-23 20:35:50'),
(57, 1, '2026-02-23 20:35:50'),
(58, 1, '2026-02-23 20:35:50'),
(59, 1, '2026-02-23 20:35:50'),
(60, 1, '2026-02-23 20:35:50'),
(61, 1, '2026-02-23 20:35:50'),
(62, 1, '2026-02-23 20:35:50'),
(63, 1, '2026-02-23 20:35:50'),
(64, 1, '2026-02-23 20:35:50'),
(65, 1, '2026-02-23 20:35:50'),
(66, 1, '2026-02-23 20:35:50'),
(67, 1, '2026-02-23 20:35:50'),
(68, 1, '2026-02-23 20:35:50'),
(69, 1, '2026-02-23 20:35:50'),
(70, 1, '2026-02-23 20:35:50'),
(71, 1, '2026-02-23 20:35:50'),
(72, 1, '2026-02-23 20:35:50'),
(73, 1, '2026-02-23 20:35:50'),
(74, 1, '2026-02-23 20:35:50'),
(75, 1, '2026-02-23 20:35:50'),
(76, 1, '2026-02-23 20:35:50'),
(77, 1, '2026-02-23 20:35:50'),
(78, 1, '2026-02-23 20:35:50'),
(79, 1, '2026-02-23 20:35:50'),
(80, 1, '2026-02-23 20:35:50'),
(81, 1, '2026-02-23 20:35:50'),
(82, 1, '2026-02-23 20:35:50'),
(83, 1, '2026-02-23 20:35:50'),
(84, 1, '2026-02-23 20:35:50'),
(85, 1, '2026-02-23 20:35:50'),
(86, 1, '2026-02-23 20:35:50'),
(87, 1, '2026-02-23 20:35:50'),
(88, 1, '2026-02-23 20:35:50'),
(89, 1, '2026-02-23 20:35:50'),
(90, 1, '2026-02-23 20:35:50'),
(91, 1, '2026-02-23 20:35:50'),
(92, 1, '2026-02-23 20:35:50'),
(93, 1, '2026-02-23 20:35:50'),
(94, 1, '2026-02-23 20:35:50'),
(95, 1, '2026-02-23 20:35:50'),
(96, 1, '2026-02-23 20:35:50'),
(97, 1, '2026-02-23 20:35:50'),
(98, 1, '2026-02-23 20:35:50'),
(99, 1, '2026-02-23 20:35:50'),
(100, 1, '2026-02-23 20:35:50'),
(101, 1, '2026-02-23 20:35:50'),
(102, 1, '2026-02-23 20:35:50'),
(103, 1, '2026-02-23 20:35:50'),
(104, 1, '2026-02-23 20:35:50'),
(105, 1, '2026-02-23 20:35:50'),
(106, 1, '2026-02-23 20:35:50'),
(107, 1, '2026-02-23 20:35:50'),
(108, 1, '2026-02-23 20:35:50'),
(109, 1, '2026-02-23 20:35:50'),
(110, 1, '2026-02-23 20:35:50'),
(111, 1, '2026-02-23 20:35:50'),
(112, 1, '2026-02-23 20:35:50'),
(113, 1, '2026-02-23 20:35:50'),
(114, 1, '2026-02-23 20:35:50'),
(115, 1, '2026-02-23 20:35:50'),
(116, 1, '2026-02-23 20:35:50'),
(117, 1, '2026-02-23 20:35:50'),
(118, 1, '2026-02-23 20:35:50'),
(119, 1, '2026-02-23 20:35:50'),
(120, 1, '2026-02-23 20:35:50'),
(121, 1, '2026-02-23 20:35:50'),
(122, 1, '2026-02-23 20:35:50'),
(123, 1, '2026-02-23 20:35:50'),
(124, 1, '2026-02-23 20:35:50'),
(125, 1, '2026-02-23 20:35:50'),
(126, 1, '2026-02-23 20:35:50'),
(127, 1, '2026-02-23 20:35:50'),
(128, 1, '2026-02-23 20:35:50'),
(129, 1, '2026-02-23 20:35:50'),
(130, 1, '2026-02-23 20:35:50'),
(131, 1, '2026-02-23 20:35:50'),
(132, 1, '2026-02-23 20:35:50'),
(133, 1, '2026-02-23 20:35:50'),
(134, 5, '2026-02-27 19:47:21');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `areas`
--
ALTER TABLE `areas`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `delivery_media`
--
ALTER TABLE `delivery_media`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_delivery_media_name` (`name`);

--
-- Indices de la tabla `employee_levels`
--
ALTER TABLE `employee_levels`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_employee_levels_name` (`name`);

--
-- Indices de la tabla `employee_profiles`
--
ALTER TABLE `employee_profiles`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `uq_employee_profiles_email` (`corporate_email`),
  ADD KEY `idx_employee_profiles_name` (`full_name`);

--
-- Indices de la tabla `import_batches`
--
ALTER TABLE `import_batches`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_import_batches_imported_by` (`imported_by`);

--
-- Indices de la tabla `import_errors`
--
ALTER TABLE `import_errors`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_import_errors_batch` (`batch_id`);

--
-- Indices de la tabla `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_permissions_code` (`code`);

--
-- Indices de la tabla `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_reports_active` (`service_order_id`,`period_id`,`reported_by`,`is_active`),
  ADD KEY `idx_reports_service_order` (`service_order_id`),
  ADD KEY `idx_reports_period` (`period_id`),
  ADD KEY `idx_reports_reported_by` (`reported_by`),
  ADD KEY `idx_reports_status` (`status`),
  ADD KEY `idx_reports_deleted` (`deleted_at`),
  ADD KEY `idx_reports_so_period_status` (`service_order_id`,`period_id`,`status`),
  ADD KEY `fk_reports_classification` (`service_classification_id`);

--
-- Indices de la tabla `report_approvals`
--
ALTER TABLE `report_approvals`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_report_approver` (`report_id`,`approver_id`),
  ADD KEY `idx_report_approvals_decision` (`decision`),
  ADD KEY `fk_report_approvals_approver` (`approver_id`);

--
-- Indices de la tabla `report_attachments`
--
ALTER TABLE `report_attachments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_report_attachments_report` (`report_id`),
  ADD KEY `idx_report_attachments_line` (`report_line_id`),
  ADD KEY `idx_report_attachments_uploaded_by` (`uploaded_by`);

--
-- Indices de la tabla `report_comments`
--
ALTER TABLE `report_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_report_comments_report` (`report_id`),
  ADD KEY `idx_report_comments_line` (`report_line_id`),
  ADD KEY `idx_report_comments_user` (`user_id`);

--
-- Indices de la tabla `report_events`
--
ALTER TABLE `report_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_report_events_report` (`report_id`),
  ADD KEY `idx_report_events_type` (`event_type`),
  ADD KEY `idx_report_events_created_at` (`created_at`),
  ADD KEY `fk_report_events_user` (`user_id`);

--
-- Indices de la tabla `report_item_catalog`
--
ALTER TABLE `report_item_catalog`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_item_codes` (`item_general`,`item_activity`),
  ADD KEY `idx_item_activity` (`item_activity`);

--
-- Indices de la tabla `report_lines`
--
ALTER TABLE `report_lines`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_report_lines_report` (`report_id`),
  ADD KEY `idx_report_lines_report_item` (`report_id`,`item_activity`),
  ADD KEY `idx_report_lines_item` (`item_general`,`item_activity`),
  ADD KEY `idx_report_lines_support_type` (`support_type_id`),
  ADD KEY `idx_report_lines_delivery` (`delivery_medium_id`),
  ADD KEY `fk_report_lines_item_catalog` (`item_catalog_id`);

--
-- Indices de la tabla `report_periods`
--
ALTER TABLE `report_periods`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_report_periods_year_month` (`year`,`month`),
  ADD UNIQUE KEY `uq_report_periods_label` (`label`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_roles_name` (`name`);

--
-- Indices de la tabla `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD PRIMARY KEY (`role_id`,`permission_id`),
  ADD KEY `idx_role_permissions_perm` (`permission_id`);

--
-- Indices de la tabla `service_classifications`
--
ALTER TABLE `service_classifications`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_service_classifications_name` (`name`);

--
-- Indices de la tabla `service_orders`
--
ALTER TABLE `service_orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_service_orders_ods` (`ods_code`),
  ADD KEY `idx_service_orders_area` (`area_id`),
  ADD KEY `idx_service_orders_status` (`status`);

--
-- Indices de la tabla `service_order_employees`
--
ALTER TABLE `service_order_employees`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_ods_user_active` (`service_order_id`,`user_id`,`is_active`),
  ADD KEY `idx_soe_user` (`user_id`),
  ADD KEY `idx_soe_level` (`level_id`);

--
-- Indices de la tabla `support_types`
--
ALTER TABLE `support_types`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_support_types_name` (`name`);

--
-- Indices de la tabla `tasks`
--
ALTER TABLE `tasks`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `task_report_links`
--
ALTER TABLE `task_report_links`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_task_report_line` (`task_id`,`report_line_id`),
  ADD KEY `idx_trl_task` (`task_id`),
  ADD KEY `idx_trl_report_line` (`report_line_id`),
  ADD KEY `fk_trl_user` (`linked_by`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_users_email` (`email`);

--
-- Indices de la tabla `user_roles`
--
ALTER TABLE `user_roles`
  ADD PRIMARY KEY (`user_id`,`role_id`),
  ADD KEY `idx_user_roles_role` (`role_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `areas`
--
ALTER TABLE `areas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `delivery_media`
--
ALTER TABLE `delivery_media`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `employee_levels`
--
ALTER TABLE `employee_levels`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `import_batches`
--
ALTER TABLE `import_batches`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `import_errors`
--
ALTER TABLE `import_errors`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `reports`
--
ALTER TABLE `reports`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `report_approvals`
--
ALTER TABLE `report_approvals`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `report_attachments`
--
ALTER TABLE `report_attachments`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `report_comments`
--
ALTER TABLE `report_comments`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `report_events`
--
ALTER TABLE `report_events`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `report_item_catalog`
--
ALTER TABLE `report_item_catalog`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `report_lines`
--
ALTER TABLE `report_lines`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `report_periods`
--
ALTER TABLE `report_periods`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `service_classifications`
--
ALTER TABLE `service_classifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `service_orders`
--
ALTER TABLE `service_orders`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT de la tabla `service_order_employees`
--
ALTER TABLE `service_order_employees`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=135;

--
-- AUTO_INCREMENT de la tabla `support_types`
--
ALTER TABLE `support_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tasks`
--
ALTER TABLE `tasks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `task_report_links`
--
ALTER TABLE `task_report_links`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=136;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `employee_profiles`
--
ALTER TABLE `employee_profiles`
  ADD CONSTRAINT `fk_employee_profiles_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `import_batches`
--
ALTER TABLE `import_batches`
  ADD CONSTRAINT `fk_import_batches_user` FOREIGN KEY (`imported_by`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `import_errors`
--
ALTER TABLE `import_errors`
  ADD CONSTRAINT `fk_import_errors_batch` FOREIGN KEY (`batch_id`) REFERENCES `import_batches` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `reports`
--
ALTER TABLE `reports`
  ADD CONSTRAINT `fk_reports_classification` FOREIGN KEY (`service_classification_id`) REFERENCES `service_classifications` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_reports_period` FOREIGN KEY (`period_id`) REFERENCES `report_periods` (`id`),
  ADD CONSTRAINT `fk_reports_reported_by` FOREIGN KEY (`reported_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `fk_reports_service_order` FOREIGN KEY (`service_order_id`) REFERENCES `service_orders` (`id`);

--
-- Filtros para la tabla `report_approvals`
--
ALTER TABLE `report_approvals`
  ADD CONSTRAINT `fk_report_approvals_approver` FOREIGN KEY (`approver_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `fk_report_approvals_report` FOREIGN KEY (`report_id`) REFERENCES `reports` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `report_attachments`
--
ALTER TABLE `report_attachments`
  ADD CONSTRAINT `fk_report_attachments_line` FOREIGN KEY (`report_line_id`) REFERENCES `report_lines` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_report_attachments_report` FOREIGN KEY (`report_id`) REFERENCES `reports` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_report_attachments_uploaded_by` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `report_comments`
--
ALTER TABLE `report_comments`
  ADD CONSTRAINT `fk_report_comments_line` FOREIGN KEY (`report_line_id`) REFERENCES `report_lines` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_report_comments_report` FOREIGN KEY (`report_id`) REFERENCES `reports` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_report_comments_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `report_events`
--
ALTER TABLE `report_events`
  ADD CONSTRAINT `fk_report_events_report` FOREIGN KEY (`report_id`) REFERENCES `reports` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_report_events_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `report_lines`
--
ALTER TABLE `report_lines`
  ADD CONSTRAINT `fk_report_lines_delivery_medium` FOREIGN KEY (`delivery_medium_id`) REFERENCES `delivery_media` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_report_lines_item_catalog` FOREIGN KEY (`item_catalog_id`) REFERENCES `report_item_catalog` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_report_lines_report` FOREIGN KEY (`report_id`) REFERENCES `reports` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_report_lines_support_type` FOREIGN KEY (`support_type_id`) REFERENCES `support_types` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD CONSTRAINT `fk_rp_perm` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rp_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `service_orders`
--
ALTER TABLE `service_orders`
  ADD CONSTRAINT `fk_service_orders_area` FOREIGN KEY (`area_id`) REFERENCES `areas` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `service_order_employees`
--
ALTER TABLE `service_order_employees`
  ADD CONSTRAINT `fk_soe_level` FOREIGN KEY (`level_id`) REFERENCES `employee_levels` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_soe_service_order` FOREIGN KEY (`service_order_id`) REFERENCES `service_orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_soe_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `task_report_links`
--
ALTER TABLE `task_report_links`
  ADD CONSTRAINT `fk_trl_report_line` FOREIGN KEY (`report_line_id`) REFERENCES `report_lines` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_trl_task` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_trl_user` FOREIGN KEY (`linked_by`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `user_roles`
--
ALTER TABLE `user_roles`
  ADD CONSTRAINT `fk_user_roles_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_user_roles_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
