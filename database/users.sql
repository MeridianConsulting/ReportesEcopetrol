-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 23-02-2026 a las 14:19:52
-- Versión del servidor: 10.6.24-MariaDB-cll-lve
-- Versión de PHP: 8.3.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `tareas`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role_id` int(11) NOT NULL,
  `area_id` int(11) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password_hash`, `role_id`, `area_id`, `is_active`, `created_at`, `updated_at`) VALUES
(3, 'NORA GISELL MORENO MORENO', 'nmoreno@meridian.com.co', '52030991', 1, 2, 1, '2025-12-22 15:43:24', '2025-12-22 15:43:24'),
(4, 'WILLIAM AUGUSTO FRANCO CASTELLANOS', 'wfranco@meridian.com.co', '79613401', 1, 9, 1, '2025-12-22 15:43:24', '2025-12-26 14:15:09'),
(5, 'CESAR AUGUSTO URREGO AVENDAÑO', 'currego@meridian.com.co', '79490148', 1, 12, 1, '2025-12-22 15:43:24', '2026-02-20 15:01:24'),
(6, 'RUTH MUÑOZ CASTILLO', 'rmunoz@meridian.com.co', '52147279', 3, 2, 1, '2025-12-22 15:43:24', '2025-12-26 13:47:15'),
(7, 'ZANDRA PATRICIA MAYORGA GOMEZ', 'coordinadoracontable@meridian.com.co', '52005033', 3, 7, 1, '2025-12-22 15:43:24', '2025-12-26 14:15:28'),
(8, 'GUSTAVO ADOLFO GIRALDO CORREA', 'ggiraldo@meridian.com.co', '1053788938', 2, 4, 1, '2025-12-22 15:43:24', '2025-12-26 14:15:37'),
(9, 'AURA ALEJANDRA CONTRERAS TORRES', 'asistenteadministrativo1@meridian.com.co', '1014251428', 3, 2, 1, '2025-12-22 15:43:24', '2025-12-26 13:47:15'),
(10, 'MICHAEL STIVEN RUIZ CARO', 'soportehseqproyectos@meridian.com.co', '1007493802', 3, 3, 1, '2025-12-22 15:43:24', '2025-12-26 14:15:46'),
(11, 'LUIS MIGUEL GUEVARA MARLES', 'hseq@meridian.com.co', '1119211830', 1, 3, 1, '2025-12-22 15:43:24', '2026-02-12 21:30:57'),
(12, 'SANDRA MILENA FLOREZ PRADO', 'asistenteadministrativo2@meridian.com.co', '$2y$10$AbpGVEPMFcykXMC2VrTY5uw7WdcRSO4zSlx.uNA46eH2wAWADXeuS', 1, 2, 1, '2025-12-22 15:43:24', '2026-01-27 21:43:54'),
(13, 'ELOY GABRIEL GOMEZ REYES', 'profesionalgh@meridian.com.co', '1020733194', 3, 8, 1, '2025-12-22 15:43:24', '2026-02-12 14:46:23'),
(14, 'DIANA MARCELA JACOBO MANCERA', 'soportehseq@meridian.com.co', '1031145571', 3, 3, 1, '2025-12-22 15:43:24', '2025-12-26 14:16:05'),
(15, 'LAURA DANIELA SEGURA MORERA', 'profesionalhseq@meridian.com.co', '1121936876', 3, 3, 1, '2025-12-22 15:43:24', '2025-12-26 14:16:10'),
(16, 'ANDRES CAMILO CARDENAS REYES', 'soporteit@meridian.com.co', '1007627524', 1, 1, 1, '2025-12-22 15:43:24', '2026-01-26 19:58:28'),
(17, 'SONIA STEPHANIA FONSECA LOPEZ', 'contratacion@meridian.com.co', '1007647736', 3, 8, 1, '2025-12-22 15:43:24', '2026-02-19 12:25:04'),
(18, 'FABRYZCIO ANDRES ORTIZ GARCIA', 'aprendiz.proyectos@meridian.com.co', '1102580512', 3, 4, 1, '2025-12-22 15:43:24', '2026-01-21 14:32:34'),
(19, 'EYMER SANTIAGO MENDEZ HERRERA', '1031649053@meridian.com.co', '1031649053', 3, 2, 1, '2025-12-22 15:43:24', '2026-01-21 15:17:55'),
(20, 'ELIANA IVETH ALARCON RONDON', 'proyectos6@meridian.com.co', '1032446831', 2, 6, 1, '2025-12-22 15:43:24', '2025-12-26 14:16:45'),
(21, 'KAREN JULIETH CARRANZA RODRIGUEZ', 'analistacontable@meridian.com.co', '1000931984', 2, 7, 1, '2025-12-22 15:43:24', '2026-02-12 21:35:44'),
(22, 'VIVIANA DEL PILAR ALFONSO AVENDAÑO', 'proyectos3@meridian.com.co', '1022344726', 3, 5, 1, '2025-12-22 15:43:24', '2026-01-21 15:21:25'),
(23, 'KAROL DANIELA SALCEDO ROMERO', 'noemail+1024478397@meridian.com.co', '1024478397', 3, 2, 1, '2025-12-22 15:43:24', '2025-12-26 13:47:15'),
(24, 'RONALD VASQUEZ ZARATE', 'nomina@meridian.com.co', '79954907', 3, 8, 1, '2025-12-22 15:43:24', '2026-02-12 13:34:13'),
(25, 'DANIEL ANDRES JOYA SAAVEDRA', 'proyectos2@meridian.com.co', '1136888916', 3, 4, 1, '2025-12-22 15:43:24', '2025-12-26 14:17:29'),
(26, 'LUISA FERNANDA PACHECO RUBIO', 'analistagh@meridian.com.co', '$2y$10$nYmd/3aXePB3TiaERk2AH.uUoW3.Y51kf1OBrReWSUsRWVPJj4rCa', 3, 8, 1, '2025-12-22 15:43:24', '2026-02-11 22:00:07'),
(27, 'MIGUEL LEONARDO MARTINEZ SOTO', 'lidergh@meridian.com.co', '1022347823', 1, 8, 1, '2025-12-22 15:43:24', '2025-12-26 14:17:40'),
(29, 'JORGE ARMANDO PACHECO COLLAZOS', 'asistentelogistica@meridian.com.co', '1010174163', 3, 2, 1, '2025-12-22 15:43:24', '2025-12-26 14:14:43'),
(30, 'JESSICA ALEXANDRA ALAVA CHAVEZ', 'noemail+1010222610@meridian.com.co', '1010222610', 3, 7, 1, '2025-12-22 15:43:24', '2025-12-26 14:19:32'),
(31, 'ANA EBELIA GAMEZ FIGUEREDO', 'contador@meridian.com.co', '39949703', 2, 2, 1, '2025-12-22 15:43:24', '2025-12-26 14:18:06'),
(32, 'JOSE MATEO LOPEZ CIFUENTES', 'desarrolloit@meridian.com.co', '$argon2id$v=19$m=65536,t=4,p=1$TlVmTHMuOXR2Mkd2dEJLdg$vINBmjTupl56XOVAwIe8pDot015Ip3PaN1XXTV58r9A', 1, 1, 1, '2025-12-22 15:43:24', '2025-12-26 14:18:13'),
(33, 'LUISA MARIA MELO RODRÍGUEZ', 'auxcontable@meridian.com.co', '1018516821', 3, 7, 1, '2025-12-22 15:43:24', '2026-01-21 14:43:54'),
(34, 'LADY LORENA VINCHERY SOLANO', 'auxiliargh@meridian.com.co', '1019136436', 3, 8, 1, '2025-12-22 15:43:24', '2026-01-21 14:42:40'),
(35, 'CRISTIAN ANDRES MURILLO', 'noemail+1033703338@meridian.com.co', '1033703338', 3, 2, 1, '2025-12-22 15:43:24', '2025-12-26 13:47:15'),
(37, 'PAOLA ADRIANA GIL CHIPATECUA', 'coordinadorproyectos@meridian.com.co', '$2y$10$xH4EuU81RQ.AgaM27x6IcO1zfkBanl1.l3EtD8EEkxme9VJvjG/gu', 2, 5, 1, '2025-12-22 15:43:24', '2026-02-12 12:33:02'),
(38, 'JESSICA ASTRID MAYORGA BARRERA', 'proyectos5@meridian.com.co', '1026301759', 3, 5, 1, '2025-12-22 15:43:24', '2026-01-21 16:29:47'),
(39, 'JUAN ESTEBAN LOPEZ OSORIO', 'noemail+1089599089@meridian.com.co', '1089599089', 3, 2, 1, '2025-12-22 15:43:24', '2025-12-26 13:47:15'),
(40, 'JOSHUA ELIAS MENA VARGAS', 'aprendizhseq@meridian.com.co', '1091966621', 3, 3, 1, '2025-12-22 15:43:24', '2026-01-21 14:43:17'),
(41, 'LAURA KARINA GAMEZ GOMEZ', 'asis.licitaciones@meridian.com.co', '$2y$10$2NjII4UxfauZk72AuL1eK.yKq8WSvgNfMKzdgsLfE0e03i83CYro6', 3, 6, 1, '2025-12-22 15:43:24', '2026-02-13 18:53:36'),
(42, 'JULIAN ANDRES MORALES SEGURA', 'facturacionclientes@meridian.com.co', '$2y$10$x8r/PeH1jTzkAkpx5osS1O1gOx4qjBPJrGRMDrZM9iGuIX6wbspSG', 3, 7, 1, '2025-12-22 15:43:24', '2026-02-11 21:59:21'),
(43, 'LADY JOHANNA AGUIRRE ROMERO', 'facturacionproveedores@meridian.com.co', '1024491663', 3, 7, 1, '2025-12-22 15:43:24', '2026-01-21 16:50:31'),
(44, 'ALISON VANESA GONZALEZ OROZCO', 'auxiliarit@meridian.com.co', '1105465424', 1, 1, 1, '2025-12-22 15:43:24', '2026-02-13 17:29:39'),
(45, 'JUAN ESTEBAN VELASQUEZ ARIAS ', 'aprendizadmin@meridian.com.co', '$2y$10$ij2x2mcOLJ69onU9XMSLFen39b3Y1zJp3c2XQElq2i3FAr.7F/I6O', 3, 2, 1, '2026-01-21 20:51:53', '2026-01-21 20:51:53'),
(46, 'Tatiana Chaparro', 'contadorjr@meridian.com.co', '$2y$10$FBBRvrPwBkd377wfF/Xzn.ysq2G.c2hhcbQAITMIYyHu3BdmMhgwy', 3, 7, 1, '2026-02-11 21:57:16', '2026-02-11 21:57:16'),
(47, 'Diviani Acosta', 'diviani@meridian.com.co', '$2y$10$LYv4AW4WkdEHYCPipq9kn.ouXz/HcndfylCarlJPgPHRMbm5.jOV.', 3, 7, 1, '2026-02-11 21:58:43', '2026-02-11 21:58:43'),
(49, 'JUAN ESTEBAN LOPEZ OSORIO', 'juanesteban@meridian.com.co', '$2y$10$FPaVS59bukqaWxdHQZuNguSDOjWoIg3CZzn.SF7dw8bIdY1ZM0vBu', 3, 2, 1, '2026-02-18 12:46:22', '2026-02-18 12:46:22'),
(50, 'Administrador', 'admin@reportes.local', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, NULL, 1, NOW(), NOW());

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_users_role` (`role_id`),
  ADD KEY `idx_users_area` (`area_id`),
  ADD KEY `idx_users_active` (`is_active`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_area` FOREIGN KEY (`area_id`) REFERENCES `areas` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_users_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
