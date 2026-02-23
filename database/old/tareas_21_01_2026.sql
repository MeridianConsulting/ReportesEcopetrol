-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 21-01-2026 a las 06:24:14
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
-- Estructura de tabla para la tabla `areas`
--

CREATE TABLE `areas` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `code` varchar(50) NOT NULL,
  `type` enum('AREA','PROYECTO') NOT NULL DEFAULT 'AREA',
  `parent_id` int(11) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `areas`
--

INSERT INTO `areas` (`id`, `name`, `code`, `type`, `parent_id`, `is_active`, `created_at`) VALUES
(1, 'IT', 'IT', 'AREA', NULL, 1, '2025-12-15 13:16:00'),
(2, 'ADMINISTRACIÓN', 'ADMIN', 'AREA', NULL, 1, '2025-12-15 13:16:00'),
(3, 'HSEQ', 'HSEQ', 'AREA', NULL, 1, '2025-12-15 13:16:00'),
(4, 'PROYECTO FRONTERA', 'FRONTERA', 'PROYECTO', NULL, 1, '2025-12-15 13:16:00'),
(5, 'CW', 'CW', 'AREA', NULL, 1, '2025-12-15 13:16:00'),
(6, 'PETROSERVICIOS', 'PETROSERVICIOS', 'AREA', NULL, 1, '2025-12-15 13:16:00'),
(7, 'CONTABILIDAD', 'CONTABILIDAD', 'AREA', NULL, 1, '2025-12-15 13:16:00'),
(8, 'GESTIÓN HUMANA', 'GESTION_HUMANA', 'AREA', NULL, 1, '2025-12-15 13:16:00'),
(9, 'GERENCIA', 'GERENCIA', 'AREA', NULL, 1, '2025-12-15 13:16:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `login_attempts`
--

CREATE TABLE `login_attempts` (
  `id` bigint(20) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `email` varchar(150) DEFAULT NULL,
  `success` tinyint(1) NOT NULL DEFAULT 0,
  `user_agent` varchar(255) DEFAULT NULL,
  `attempted_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `login_attempts`
--

INSERT INTO `login_attempts` (`id`, `ip_address`, `email`, `success`, `user_agent`, `attempted_at`) VALUES
(1, '186.80.229.102', 'desarrolloit@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-26 17:00:08'),
(2, '186.80.229.102', 'desarrolloit@meridian.com.co', 1, 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_1_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', '2025-12-26 17:09:11'),
(3, '186.80.229.102', 'lidergh@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-26 17:10:43'),
(4, '186.80.229.102', 'wfranco@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-26 17:22:29'),
(5, '191.104.110.36', 'nmoreno@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-26 19:56:18'),
(6, '186.80.229.102', 'desarrolloit@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-29 19:02:31'),
(7, '186.80.229.102', 'asitenteadministrativo2@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-29 20:13:38'),
(8, '186.80.229.102', 'asitenteadministrativo2@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-29 20:13:53'),
(9, '186.80.229.102', 'asistenteadministrativo2@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-29 20:14:07'),
(10, '186.80.229.102', 'soporteit@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0', '2025-12-30 12:41:57'),
(11, '186.80.229.102', 'soporteit@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0', '2025-12-30 12:42:10'),
(12, '186.80.229.102', 'aprendizadmin@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-30 12:42:22'),
(13, '186.80.229.102', 'soporteit@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0', '2025-12-30 12:42:22'),
(14, '186.80.229.102', 'nmoreno@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-30 12:42:27'),
(15, '186.80.229.102', 'aprendizadmin@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-30 12:42:29'),
(16, '186.80.229.102', 'aprendizadmin@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-30 12:42:32'),
(17, '186.80.229.102', 'aprendizadmin@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-30 12:42:45'),
(18, '186.80.229.102', 'aprendizadmin@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-30 12:42:56'),
(19, '186.80.229.102', 'aprendizadmin@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-30 12:42:57'),
(20, '186.80.229.102', 'aprendizadmin@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-30 12:42:58'),
(21, '186.80.229.102', 'aprendizadmin@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-30 12:42:59'),
(22, '186.80.229.102', 'aprendizadmin@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-30 12:43:00'),
(23, '186.80.229.102', 'aprendizadmin@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-30 12:43:00'),
(24, '186.80.229.102', 'aprendizadmin@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-30 12:43:01'),
(25, '186.80.229.102', 'aprendizadmin@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-30 12:43:01'),
(26, '186.80.229.102', 'auxiliarit@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0', '2025-12-30 12:43:06'),
(27, '186.80.229.102', 'soporteit@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0', '2025-12-30 12:43:09'),
(28, '186.80.229.102', 'asistentelogistica@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-30 12:43:13'),
(29, '186.80.229.102', 'aprendizadmin@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-30 12:43:18'),
(30, '186.80.229.102', 'auxiliarit@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0', '2025-12-30 12:43:22'),
(31, '186.80.229.102', 'auxiliarit@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0', '2025-12-30 12:43:58'),
(32, '186.80.229.102', 'auxiliarit@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0', '2025-12-30 12:43:59'),
(33, '186.80.229.102', 'auxiliarit@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0', '2025-12-30 12:44:42'),
(34, '186.80.229.102', 'auxiliarit@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0', '2025-12-30 12:44:44'),
(35, '186.80.229.102', 'aprendizadmin@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-30 12:44:52'),
(36, '186.80.229.102', 'auxiliarit@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0', '2025-12-30 12:44:55'),
(37, '186.80.229.102', 'auxiliarit@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0', '2025-12-30 12:44:56'),
(38, '186.80.229.102', 'auxiliarit@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0', '2025-12-30 12:44:57'),
(39, '186.80.229.102', 'auxiliarit@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0', '2025-12-30 12:45:08'),
(40, '186.80.229.102', 'auxiliarit@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0', '2025-12-30 12:45:11'),
(41, '186.80.229.102', 'auxiliarit@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0', '2025-12-30 12:45:23'),
(42, '186.80.229.102', 'auxiliarit@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0', '2025-12-30 12:45:52'),
(43, '186.80.229.102', 'aprendizadmin@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-30 13:16:45'),
(44, '186.80.229.102', 'aprendizadmin@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-30 13:17:56'),
(45, '186.80.229.102', 'desarrolloit@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-30 14:32:12'),
(46, '186.80.229.102', 'desarrolloit@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-30 14:36:10'),
(47, '186.80.229.102', 'aprendizadmin@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-30 14:38:08'),
(48, '186.80.229.102', 'desarrolloit@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-30 15:04:39'),
(49, '186.80.229.102', 'aprendizadmin@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-30 15:11:20'),
(50, '186.80.229.102', 'desarrolloit@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-30 15:28:33'),
(51, '186.80.229.102', 'desarrolloit@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-30 16:43:57'),
(52, '186.80.229.102', 'desarrolloit@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-30 19:18:47'),
(53, '186.80.229.102', 'desarrolloit@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-30 19:23:34'),
(54, '181.56.29.244', 'wfranco@meridian.com.co', 1, 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-30 19:25:03'),
(55, '186.85.240.133', 'desarrolloit@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-01-02 13:25:02'),
(56, '186.85.240.133', 'desarrolloit@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-01-02 13:25:29'),
(57, '186.85.240.133', 'desarrolloit@meridian.com.co', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-01-02 13:25:51'),
(58, '186.85.240.133', 'desarrolloit@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-01-02 13:26:35'),
(59, '186.85.240.133', 'desarrolloit@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-01-02 17:22:23'),
(60, '186.80.229.102', 'nmoreno@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-01-02 19:41:26'),
(61, '152.201.118.162', 'proyectos6@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-01-02 19:41:34'),
(62, '191.97.9.169', 'hseq@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-01-02 19:41:34'),
(63, '186.80.229.102', 'ggiraldo@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-01-02 19:41:49'),
(64, '186.80.229.102', 'lidergh@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-01-02 19:42:03'),
(65, '186.85.240.133', 'desarrolloit@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-01-02 19:42:31'),
(66, '186.80.229.102', 'auxiliarit@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0', '2026-01-02 21:25:18'),
(67, '152.203.161.205', 'ggiraldo@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-01-05 12:48:40'),
(68, '186.80.229.102', 'desarrolloit@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-01-13 19:09:09'),
(69, '186.80.229.102', 'desarrolloit@meridian.com.co', 1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2026-01-19 14:34:41');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `password_reset_otps`
--

CREATE TABLE `password_reset_otps` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `otp_hash` char(64) NOT NULL,
  `expires_at` datetime NOT NULL,
  `used_at` datetime DEFAULT NULL,
  `attempts` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `created_ip` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `password_reset_otps`
--

INSERT INTO `password_reset_otps` (`id`, `user_id`, `otp_hash`, `expires_at`, `used_at`, `attempts`, `created_ip`, `user_agent`, `created_at`) VALUES
(1, 32, 'c70720248b790f5973ad3f8940ab3715a8ca84305c9db9e0588a8bf99deb8f67', '2025-12-22 12:57:28', '2025-12-22 12:48:42', 0, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-22 12:47:28'),
(2, 32, 'f5a271cff0b27c304cb52592ecac96d98a44186e8e7a1d447cc4ec955418c3b6', '2025-12-22 12:58:42', '2025-12-22 12:53:01', 0, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-22 12:48:42'),
(3, 32, '745b103c288911c11d84572a64fba3aa6d95c5d8587845a6b6c9edf91bcc6790', '2025-12-22 13:03:01', NULL, 0, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-22 12:53:01'),
(4, 32, '0d53642902b51938b68cf3c72ac66ef35ed18b5a109dd83820e53c725f627153', '2025-12-22 14:36:48', NULL, 0, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-22 14:26:48'),
(5, 32, 'd9071055301b0131364a45479b1c72000c1369a4eee0c07c63d91ff9b3eb8a6b', '2025-12-22 15:02:08', '2025-12-22 14:52:31', 0, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-22 14:52:08'),
(6, 32, 'fd39a211eaca466432ded61b4148e42ede9fae49c44249c9ff4fec3cadd0e5d1', '2025-12-22 15:03:39', '2025-12-22 14:53:52', 0, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-22 14:53:39'),
(7, 32, '6e286972f8f0453eb35e48a0601379c6101aaf3b10cbbd8e4bbec585f749dcc2', '2025-12-22 15:09:07', '2025-12-22 14:59:24', 0, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-22 14:59:07'),
(8, 32, '196633b9b026ef152455f04f58aca1b30423007705714c5605d591150cb35d7e', '2026-01-02 14:52:02', NULL, 0, '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-01-02 12:42:02');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `token_hash` char(64) NOT NULL,
  `expires_at` datetime NOT NULL,
  `used_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `password_reset_tokens`
--

INSERT INTO `password_reset_tokens` (`id`, `user_id`, `token_hash`, `expires_at`, `used_at`, `created_at`) VALUES
(1, 32, '0d930c8dd2caefe896d75fa95c1df15405fffebe1656eae4da15d448719033d5', '2025-12-22 15:07:31', '2025-12-22 14:52:49', '2025-12-22 14:52:31'),
(2, 32, '3c8fa1e1629b89dbd8b115d1d42574cd17d99df4131ca47de5a20e7d182c1aeb', '2025-12-22 15:08:52', '2025-12-22 14:54:03', '2025-12-22 14:53:52'),
(3, 32, 'eabd36bc6e306b23dfa93bdf1458b3d85ab5e176c23007c9548d6d1fb0aefa9a', '2025-12-22 15:14:24', '2025-12-22 14:59:43', '2025-12-22 14:59:24');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `refresh_tokens`
--

CREATE TABLE `refresh_tokens` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `token_hash` varchar(255) NOT NULL,
  `expires_at` datetime NOT NULL,
  `revoked_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `ip` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `refresh_tokens`
--

INSERT INTO `refresh_tokens` (`id`, `user_id`, `token_hash`, `expires_at`, `revoked_at`, `created_at`, `ip`, `user_agent`) VALUES
(1, 32, 'e83eab1b6cf584e0466b1f2e903426dd95be406be26c4a45e6c11e97afd8596e', '2026-01-05 10:50:49', '2025-12-22 10:53:00', '2025-12-22 15:50:49', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(2, 32, '7f0b68ccf746d7f0c044cd693ea19889c2b133a3edf48e763fd098444601ceb8', '2026-01-05 10:53:00', '2025-12-22 10:54:40', '2025-12-22 15:53:00', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(3, 32, '6578f58aace1a764621b4c5eaa5a91a82db91c5eb5941d9fced0fa62d920a341', '2026-01-05 10:54:40', '2025-12-22 11:09:57', '2025-12-22 15:54:40', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(4, 32, 'f4cde21846fa7c7b282891ceacec86f2539fcb9f32d9ed77d574e1a5c7684ad2', '2026-01-05 11:09:57', '2025-12-22 11:25:03', '2025-12-22 16:09:57', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(5, 32, '87ad5fccc727f7e337395dd60d7dd8c7b63724c5fbf4362bad5987f6ebcbc33b', '2026-01-05 11:25:03', '2025-12-22 11:40:03', '2025-12-22 16:25:03', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(6, 32, 'e2965afe16459ab8776d2b83effaf365fd1810f70e6f0bddfbfa9a65e1434e46', '2026-01-05 11:40:03', '2025-12-22 11:55:33', '2025-12-22 16:40:03', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(7, 32, 'b5c5edebf61ba362f44adffc6bea7b308d14a4b9ffa7949533cee06c51a2b7c7', '2026-01-05 11:55:33', '2025-12-22 12:11:02', '2025-12-22 16:55:33', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(8, 32, '83c2ce9651b3becfd15334e573420a07d5c9bbc4a1b977c24543376cc1aa9c3f', '2026-01-05 12:11:02', NULL, '2025-12-22 17:11:02', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(9, 32, 'dce4c95c8ba7581ef0744b60b58024f35065e8374e0db18d406bb0474a886cd3', '2026-01-05 12:20:08', NULL, '2025-12-22 17:20:08', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(10, 32, '6b4137d836f7501a6b3c562dda72126eaabf82164125e331528579627bcde5c3', '2026-01-05 12:20:29', '2025-12-22 12:20:38', '2025-12-22 17:20:29', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(11, 32, '64824471b9af731d1982d824b69e4189e7f3121ab008fa2fea4918c742a626ab', '2026-01-05 12:20:38', '2025-12-22 12:20:38', '2025-12-22 17:20:38', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(12, 32, '64824471b9af731d1982d824b69e4189e7f3121ab008fa2fea4918c742a626ab', '2026-01-05 12:20:38', NULL, '2025-12-22 17:20:38', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(13, 32, '8cc33fc422af09785f5ee47aa5d31a6adef729bc88ffb4ced4fee8271846a96d', '2026-01-05 14:53:03', NULL, '2025-12-22 19:53:03', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(14, 32, 'e205a2bd1a9fd9427885223a99c89a143edeb378366d3c6b3cd855aad7d0f23f', '2026-01-05 14:54:20', NULL, '2025-12-22 19:54:20', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(15, 32, '92a308bc9a2e41b116fb8056723c0366a93b23b57b9b5807b22abb07d41a5cdc', '2026-01-05 15:01:09', '2025-12-22 15:17:01', '2025-12-22 20:01:09', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(16, 32, '2d81047c6c82992e29204df66722274cfc9517aa6c9ee4d4ead5784570367d0d', '2026-01-05 15:17:01', '2025-12-22 15:32:01', '2025-12-22 20:17:01', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(17, 32, '78203ffe653fbaf8572b274e8fbc9773da4908834bae2d3692add77a1bf89115', '2026-01-05 15:32:01', '2025-12-22 15:47:01', '2025-12-22 20:32:01', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(18, 32, '53797f1c3e4d0b80c6e3722370eb1efb3411865bf6f504ac41e8bed0959ace21', '2026-01-05 15:47:01', '2025-12-22 16:02:01', '2025-12-22 20:47:01', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(19, 32, '54380eeb9075262565c88a0c092181e833c9a76761c338bc13f553610fb951e9', '2026-01-05 16:02:01', '2025-12-22 16:17:11', '2025-12-22 21:02:01', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(20, 32, '9f64f27db53c31b57b1513e25972521ecc15202d91ea944faf124af4d8547ca2', '2026-01-05 16:17:11', '2025-12-22 16:32:11', '2025-12-22 21:17:11', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(21, 32, '9914f6ee1f94e38e900af77631dab6b95782fee27f63994c0a032d67354d099d', '2026-01-05 16:32:11', '2025-12-26 08:13:51', '2025-12-22 21:32:11', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(22, 32, 'a77c64f12585eb23a7657441c09d17b9772e7075fb3f7a48ba7737d0f178d845', '2026-01-09 08:13:51', '2025-12-26 08:29:01', '2025-12-26 13:13:51', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(23, 32, '57d565d67cf7dc1aa55ca372995b680bbb1500f1fc451de371b3dd0498df5e69', '2026-01-09 08:29:01', NULL, '2025-12-26 13:29:01', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(24, 32, '9cd5b265e211f6e1fc20a71cbdebd69dadb4ef52dcfc089e755e5d96e0f97342', '2026-01-09 08:51:25', '2025-12-26 09:10:33', '2025-12-26 13:51:25', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(25, 32, 'a1bb66c6df57a4133c2c4321e1ccd2fa3076bae8d60d3d0e040466e8bba61bdc', '2026-01-09 09:10:33', '2025-12-26 09:25:46', '2025-12-26 14:10:33', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(26, 32, 'a1bb66c6df57a4133c2c4321e1ccd2fa3076bae8d60d3d0e040466e8bba61bdc', '2026-01-09 09:10:33', '2025-12-26 09:25:46', '2025-12-26 14:10:33', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(27, 32, '7a1087d9c4f25558738ccac9f2f1f81fb3bcd5753f9cb20299055f191b4746d1', '2026-01-09 09:25:46', '2025-12-26 09:40:59', '2025-12-26 14:25:46', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(28, 32, 'fa54d5fcfd56806aa311e50cc35e6698f60ca4fc92db878441a8ac144a964623', '2026-01-09 09:40:59', NULL, '2025-12-26 14:40:59', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(29, 32, 'bd9086dbfdc59529d9282f197c0d08f38d9ed27c9f7af8fe8d8abe8b5e0dab13', '2026-01-09 12:00:08', '2025-12-26 10:15:55', '2025-12-26 17:00:08', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(30, 32, '15d5d139fb41f3dcd84eeb41d9b65a8b9aa3417828a3740ba6a1065cc384f037', '2026-01-09 12:09:11', NULL, '2025-12-26 17:09:11', '186.80.229.102', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_1_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1'),
(31, 27, '840c31263b79138cb4748d3df26fae9a2c6ca3f44be2c5992e53a7a7a8915e4f', '2026-01-09 12:10:43', '2025-12-26 10:26:32', '2025-12-26 17:10:43', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(32, 32, 'bb83057d346ce5c68e7552d6120cb9b60fbad1971dce7354b2ec3113aba2da5d', '2026-01-09 12:15:55', NULL, '2025-12-26 17:15:55', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(33, 4, 'f73dfd8495b28d75b436f5bad13ad849256963901da332a49ff379d24df5dd69', '2026-01-09 12:22:29', '2025-12-26 10:42:04', '2025-12-26 17:22:29', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(34, 27, '2be15f9d37e427ea08f441b012fc8845279901209c712fbdf2292bf703c6049d', '2026-01-09 12:26:32', '2025-12-26 10:41:36', '2025-12-26 17:26:32', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(35, 27, '45a5ace21b91aa5913466736c59c58a83dc4b866a407e553c1321a02aa18135f', '2026-01-09 12:41:36', '2025-12-26 10:56:36', '2025-12-26 17:41:36', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(36, 4, '5f9cf3285ca2d8f348678d0ccc7e46550cad55a7bc6e047e5cf58d5114da631f', '2026-01-09 12:42:04', '2025-12-29 05:51:18', '2025-12-26 17:42:04', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(37, 27, '072e2319998192e8acc1d9ee7cd7f5fdd6aba56202b66ddf514e5e4674449fd8', '2026-01-09 12:56:36', '2025-12-26 11:12:36', '2025-12-26 17:56:36', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(38, 27, '2d5845446974c97099011fceb7602684823d1187afef5b0e3cbca6f647bc4850', '2026-01-09 13:12:36', '2025-12-26 11:28:36', '2025-12-26 18:12:36', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(39, 27, '0c3504726ad382dbc961cce43174715eaf22c5dcb67dd50977a97eb381f4046b', '2026-01-09 13:28:36', '2025-12-26 11:44:36', '2025-12-26 18:28:36', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(40, 27, '876f1ca5599daca484e0878df5c069829fb470bcc116f362d4c33cd34f00fc9e', '2026-01-09 13:44:36', '2025-12-26 12:00:36', '2025-12-26 18:44:36', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(41, 27, '055a3f62ecee2c70d318d45f771160d9e3e0a8f0f9fd7aa61aef4a1b23feb870', '2026-01-09 14:00:36', '2025-12-26 12:16:36', '2025-12-26 19:00:36', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(42, 27, '5b5d1d09d36f11bb5725c40a488657ea10ae10e7a5d539eefe6b407ee91447e9', '2026-01-09 14:16:36', '2025-12-26 12:32:36', '2025-12-26 19:16:36', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(43, 27, '7eb048bb6a317fd93c26759a5e8c3c5e756b18b74a3441d727dd6a50bcdb8822', '2026-01-09 14:32:36', '2025-12-26 12:48:34', '2025-12-26 19:32:36', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(44, 27, 'f77170a9ab80b3c9c622f0ecaa6c61c68b1d33f1037cd6de4cb48685a90c0eaa', '2026-01-09 14:48:34', '2025-12-26 13:04:33', '2025-12-26 19:48:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(45, 3, '130dcd40c884bb64446a432280c542920325738f785c345a8fe8ce5955e4fc37', '2026-01-09 14:56:18', '2025-12-26 13:12:11', '2025-12-26 19:56:18', '191.104.110.36', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(46, 27, '3d91480f2333680a3a90f8fb69435df8c7471c907307eb51bfe952848bc048eb', '2026-01-09 15:04:33', '2025-12-26 13:19:36', '2025-12-26 20:04:33', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(47, 3, 'c96d4238a64f8806dae19d41fb2ea029782eec0996495d8f627b54331fc9acb2', '2026-01-09 15:12:11', '2025-12-26 13:27:11', '2025-12-26 20:12:11', '191.104.110.36', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(48, 27, '0df75998a7ebea294934abe9bb446b46b30455da879bd72bfec9d8e7adf977bb', '2026-01-09 15:19:36', '2025-12-26 13:35:32', '2025-12-26 20:19:36', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(49, 3, '70a9b8661abfa2dd703d4c1e3a9b44f2eef3e8966871bfa91e704b414d20592f', '2026-01-09 15:27:11', '2025-12-26 13:42:11', '2025-12-26 20:27:11', '191.104.110.36', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(50, 27, 'fd9c8ffdb567e6c07912f191fced308b443e76fa6c4a815e28855c8c1a7f6f27', '2026-01-09 15:35:32', '2025-12-26 13:50:36', '2025-12-26 20:35:32', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(51, 3, '04ad829fa951f3a78f280ff43b379489008d407369b01b2e01751d15a2ae16fc', '2026-01-09 15:42:11', '2025-12-26 13:57:11', '2025-12-26 20:42:11', '191.104.110.36', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(52, 27, '843555a2d446e28bfae344400db467e8bf377797c9d13ca076a89560d20d8b2e', '2026-01-09 15:50:36', '2025-12-26 13:52:36', '2025-12-26 20:50:36', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(53, 27, '9792427d6efae09b83d3b80ca23e033f26d462e6deeb4f9fb9e7e35e6fd3a6d9', '2026-01-09 15:52:36', '2025-12-26 14:06:36', '2025-12-26 20:52:36', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(54, 3, '5e8b0ff2d4514add80b5b610d9b9c7fbe4d8f804874da5a68da8e08d493ea17b', '2026-01-09 15:57:11', '2025-12-26 14:12:11', '2025-12-26 20:57:11', '191.104.110.36', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(55, 27, 'f02ea15ae0a26ddd5f09f8a8c489d6c880efd2a5b9e395925260c972082e82ae', '2026-01-09 16:06:36', '2025-12-26 14:07:36', '2025-12-26 21:06:36', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(56, 27, 'da73e16ea1d1be2aa94f87ffc42039ba71a82cbddee558859c800ddc46f18f82', '2026-01-09 16:07:36', '2025-12-26 14:22:36', '2025-12-26 21:07:36', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(57, 3, 'e65afbbe25bcf074c32537811eadbe9f2c12e8f487a1ac8f6dad0109137c364e', '2026-01-09 16:12:11', '2025-12-26 14:27:11', '2025-12-26 21:12:11', '191.104.110.36', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(58, 27, '22aef3e3a91b57c0001a3aa83de6f782a2f231ab76586e860ce21bfa8c69e1ba', '2026-01-09 16:22:36', '2025-12-26 14:23:36', '2025-12-26 21:22:36', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(59, 27, '3ca0049d90fd2792c495bd60649a95651690aa81f28998d7e6f1bcdf8512acea', '2026-01-09 16:23:36', NULL, '2025-12-26 21:23:36', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(60, 3, '6f3e397d1edc2a13e195c5ea1a2328c0fca847931eaa5f821effc7713a8c3169', '2026-01-09 16:27:11', '2025-12-26 14:42:11', '2025-12-26 21:27:11', '191.104.110.36', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(61, 3, '284625f00be500ce3dfe85c6e125f1f70af6614c92fbb5cff5b8f5b77419607e', '2026-01-09 16:42:11', '2025-12-26 14:57:11', '2025-12-26 21:42:11', '191.104.110.36', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(62, 3, 'fb4d3997aa343320850c7e15d62442432d78317b8b27eb243fb43218170aa357', '2026-01-09 16:57:11', '2025-12-26 15:12:11', '2025-12-26 21:57:11', '191.104.110.36', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(63, 3, '7c8912dcd48054366349cda1827b21ea76c3834741105e9e044cb435ae242667', '2026-01-09 17:12:11', '2025-12-27 14:00:06', '2025-12-26 22:12:11', '191.104.110.36', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(64, 3, 'b45d87a198cd8f2f1217498ec4bcf7e44a6374947f381fd8144a9fd343af1613', '2026-01-10 16:00:06', '2025-12-27 14:16:08', '2025-12-27 21:00:06', '191.104.110.36', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(65, 3, 'a3455cdfc053e608ee7934f40785b665844721f37843b33edfda076620f3412b', '2026-01-10 16:16:08', '2025-12-27 14:32:05', '2025-12-27 21:16:08', '191.104.110.36', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(66, 3, 'c0ab1061d2054da8012da21109328ea3d3f9251ba2a2ef513869051e7bf076c4', '2026-01-10 16:32:05', '2025-12-27 14:48:09', '2025-12-27 21:32:05', '191.104.110.36', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(67, 3, '8d46c8156de20957f6eaf85cd57986379235b4ac4dcb91dddc150fbf889e758f', '2026-01-10 16:48:09', '2025-12-27 15:04:09', '2025-12-27 21:48:09', '191.104.110.36', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(68, 3, 'dfadc80d75fecccc3cc9aa706d79139a1cb65d8f1e0bbb300795602421a38d27', '2026-01-10 17:04:09', '2025-12-27 15:19:17', '2025-12-27 22:04:09', '191.104.110.36', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(69, 3, '1735a4950d246919ddbd470f50d0435ed62059ba3e7fdac42a301d626609e9e2', '2026-01-10 17:19:17', '2025-12-27 15:35:15', '2025-12-27 22:19:17', '191.104.110.36', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(70, 3, 'b46f7a6b04d4bef795fbca3e50bb466539c2b5c63f4b84a09e1506506b4325e2', '2026-01-10 17:35:15', '2025-12-27 17:48:52', '2025-12-27 22:35:15', '191.104.110.36', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(71, 3, 'f2ac00d6268fc8dbb84c386dfab5ec3f13f4e85f5dfb1d4a9d2a15dc7ff20517', '2026-01-10 19:48:52', NULL, '2025-12-28 00:48:52', '191.104.110.36', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(72, 4, 'abc2b35be833ab2740c3ad1022300f1aeed9b4364c8b9f52e2e069162c0e9973', '2026-01-12 07:51:18', '2025-12-29 12:01:50', '2025-12-29 12:51:18', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(73, 4, '54d9240e67f7e20412b1c14ef235a54dd5ddd780b14f073adbae640e6b47a62f', '2026-01-12 14:01:50', NULL, '2025-12-29 19:01:50', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(74, 32, '9fea50cd1eb73cedcc2c01034d6b69237562df1e7d194676c966725439ece8a0', '2026-01-12 14:02:31', '2025-12-29 13:24:35', '2025-12-29 19:02:31', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(75, 12, '7051357b1aae073abbb2cdc6e89678fb7c0951f3dbbaa02148adc532c4533297', '2026-01-12 15:14:07', '2025-12-30 05:41:25', '2025-12-29 20:14:07', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(76, 32, '2d5a2bc15daa00a311c0485dcdaa1ef9341196f9c8defe358d4120a932e885c8', '2026-01-12 15:24:35', '2025-12-29 13:39:41', '2025-12-29 20:24:35', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(77, 32, '36397036f6ac812035e845008de49f27c7019e6438de4d72cf23798b3bdcba56', '2026-01-12 15:39:41', '2025-12-29 13:54:41', '2025-12-29 20:39:41', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(78, 32, 'b1e82133ff4b2f183c8d8164ecbd24614617a78c4f4361620a8cd31d300e9ae9', '2026-01-12 15:54:41', '2025-12-29 14:09:41', '2025-12-29 20:54:41', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(79, 32, 'fc90d1f5da21e0ce7d37a3486416779e622018506bc123679a56bed4ae06e58f', '2026-01-12 16:09:41', '2025-12-29 14:24:41', '2025-12-29 21:09:41', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(80, 32, '11f64d651d152f6f616be7ecfb692f99f3050acfc656628cd561f734a44dab4d', '2026-01-12 16:24:41', '2025-12-29 14:39:41', '2025-12-29 21:24:41', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(81, 32, '54b01c8990f395cb55a80823fe2f67f1b394339c6f57fafc51fef86451d47fe2', '2026-01-12 16:39:41', '2025-12-30 05:42:34', '2025-12-29 21:39:41', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(82, 12, '05113c2b6076e7a86f72aae19a00c9459436106638fe69bab8e22d8b9e22b524', '2026-01-13 07:41:25', '2025-12-30 05:57:14', '2025-12-30 12:41:25', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(83, 3, 'e1eec821ed0a88e43ba86e0c2d1f5678b24b247aa680c1052e0407185503eb7f', '2026-01-13 07:42:27', '2025-12-30 05:57:42', '2025-12-30 12:42:27', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(84, 32, '5bb209612f3243e51a3a81c5d94a7e1425b880d0150a937276df7a1176228963', '2026-01-13 07:42:34', '2025-12-30 06:17:34', '2025-12-30 12:42:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(85, 16, '7fe929abfc0737688f52a67997251b182c910a1891338013e715cf60bbad80ff', '2026-01-13 07:43:09', '2025-12-30 05:58:48', '2025-12-30 12:43:09', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'),
(86, 29, '718f10045d972c475d51308bb8aa44d102a0110dbd5f73d032749364c578bdbc', '2026-01-13 07:43:13', '2026-01-02 05:34:52', '2025-12-30 12:43:13', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(87, 36, '88c63533a45f2a4dd0ae09352c62cc46581ad2ec1a1f519e2fb172662655a95a', '2026-01-13 07:44:52', '2025-12-30 06:00:12', '2025-12-30 12:44:52', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(88, 28, 'e3ace135f0b28aa50e84263ac8a50f374eca1f56317b63a94b457f9a1541fda2', '2026-01-13 07:45:52', '2025-12-30 06:01:23', '2025-12-30 12:45:52', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(89, 12, '169a5b3471e968df3ed126068e09cbd0b40ff07802c623c4a511c7d5e430c2fe', '2026-01-13 07:57:14', '2025-12-30 06:12:52', '2025-12-30 12:57:14', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(90, 3, '304ee11261d295b9db678df3bfb49b9b85e4176283b09011df40eb41c5d14944', '2026-01-13 07:57:42', '2025-12-30 06:12:57', '2025-12-30 12:57:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(91, 16, 'ea4d71b8e3acab29624f9ab94f48f9d814311fe218d5544b7e45231735140c60', '2026-01-13 07:58:48', '2025-12-30 06:14:48', '2025-12-30 12:58:48', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'),
(92, 36, '69837629caed8d78a613aa5da6c3ec1fc152393d01735a32a693d3532bace9c9', '2026-01-13 08:00:12', '2025-12-30 06:15:17', '2025-12-30 13:00:12', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(93, 28, 'ac23af60e53dac3caf2d1980de82eed8a2c1f5887029d6f5a4ca6edfa399b399', '2026-01-13 08:01:23', '2025-12-30 06:16:24', '2025-12-30 13:01:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(94, 12, 'b02bbe754dbcad2fc23bec764c20214d1ce6781068ebbe8002840488ac0a5a31', '2026-01-13 08:12:52', '2025-12-30 06:28:07', '2025-12-30 13:12:52', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(95, 3, '1b11a195c2b1200f7e76ac0cbf2398ad0c66b3a831f933b096780bee2d9ba445', '2026-01-13 08:12:57', '2025-12-30 06:28:42', '2025-12-30 13:12:57', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(96, 16, 'f81f76c184be19ea0e41ab805b6f4b5bfc0484598ae2753bf04193e20c2429ca', '2026-01-13 08:14:48', '2025-12-30 06:30:00', '2025-12-30 13:14:48', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'),
(97, 36, '3d2349056ea9c434a583a2f4ee71751f1a147dc459e506ffffa1ca98b9661694', '2026-01-13 08:15:17', '2025-12-30 07:19:16', '2025-12-30 13:15:17', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(98, 28, 'df2a5ef3ff37ecbfdcf7819e576316a1d5f35c29402929e3905751495609350d', '2026-01-13 08:16:24', '2025-12-30 06:32:23', '2025-12-30 13:16:24', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(99, 36, 'ba41d85a7e39497488e8643a30c57505e279f4d854aabb7af9a764669543b78a', '2026-01-13 08:16:45', NULL, '2025-12-30 13:16:45', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(100, 32, 'c4c338ae940454f186f0ac7d37bdd86abe50ca72287e635d1884dcc9860545a1', '2026-01-13 08:17:34', NULL, '2025-12-30 13:17:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(101, 36, 'c2b4532ce925ac479cacaa136d895808cdfb44bd5b6ab3b4d50aeaf102a7fd9d', '2026-01-13 08:17:56', '2025-12-30 06:33:46', '2025-12-30 13:17:56', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(102, 12, '891d3bb65b37fd0b978f847272c13c54781b36746a41434d02ad01073790163b', '2026-01-13 08:28:07', '2025-12-30 06:43:14', '2025-12-30 13:28:07', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(103, 3, 'd4a8142935ab3f9da82eee3c66199549d3e09a9148f7d672b892977a31964e35', '2026-01-13 08:28:42', '2025-12-30 06:44:42', '2025-12-30 13:28:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(104, 16, 'cac77120776845fca9e30afba1ea9342971aca5b86e765a0f0b5fe95776dec88', '2026-01-13 08:30:00', '2025-12-30 06:45:33', '2025-12-30 13:30:00', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'),
(105, 28, '04dd0a60a73ca1ece6af3423b93098b9781d4b07e77e246185677a2074bd58d9', '2026-01-13 08:32:23', '2025-12-30 06:47:23', '2025-12-30 13:32:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(106, 36, 'f56339fcc11080873d497ef9b89efe59463741767761a29b5343d7419c9b3d78', '2026-01-13 08:33:46', '2025-12-30 06:48:57', '2025-12-30 13:33:46', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(107, 12, 'cfbf3c4d20868226991a29871f0ba4a49ee600e4514dec33d6b09715cb1bbc84', '2026-01-13 08:43:14', '2025-12-30 07:17:19', '2025-12-30 13:43:14', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(108, 3, '31af7f9fdc76b0c42990a098a54fac8b63d1896cc53624cfd2a3982ca5b1e9e8', '2026-01-13 08:44:42', '2025-12-30 07:17:42', '2025-12-30 13:44:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(109, 16, 'd759663ab3150b586738e87e382ba343df95c2c5e3efb81a6d0a512f46587be6', '2026-01-13 08:45:33', '2025-12-30 07:17:48', '2025-12-30 13:45:33', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'),
(110, 28, '9c9731ee45f533f6c58d2ae00f47ff904dad7ee52cb011cd97b2a263a5572324', '2026-01-13 08:47:23', '2025-12-30 07:17:23', '2025-12-30 13:47:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(111, 36, 'b076ff8c0f61300106977d16c12fc1cff895e33cf4c239ae843be86a99c8c1bd', '2026-01-13 08:48:57', '2025-12-30 07:17:12', '2025-12-30 13:48:57', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(112, 36, 'e4f7cc82cf4742f2220acfb5276088a8b997e3673cb3c966a11e5097ba989206', '2026-01-13 09:17:12', NULL, '2025-12-30 14:17:12', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(113, 12, '0a23f643a04074e7eaa03a123f53657a2f9980490be5f49d7de7df5403c0209b', '2026-01-13 09:17:19', '2025-12-30 07:32:19', '2025-12-30 14:17:19', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(114, 28, 'ccead4c7a3e8cbb8c476d5fb853668c220b4771f35826c4ce4361ad8cb356534', '2026-01-13 09:17:23', '2025-12-30 07:32:23', '2025-12-30 14:17:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(115, 3, '862e1fa5fca9334e44a9901e07bb0de97fe33417c417d28949597237f27ea89e', '2026-01-13 09:17:42', '2025-12-30 07:33:42', '2025-12-30 14:17:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(116, 16, '472c80c0ee09de7f3795317daec2bf9aae389bed44d27ea4a7f3b1e18258e583', '2026-01-13 09:17:48', '2025-12-30 07:33:00', '2025-12-30 14:17:48', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'),
(117, 36, '88d8ad474b61b7089eaf3c07757ef606202a37fc66329a64b50a2199f145ba24', '2026-01-13 09:19:16', '2025-12-30 07:34:17', '2025-12-30 14:19:16', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(118, 32, 'e3a3d6022e84de0aadc4cef90b4e718f3b203cb4cd299b3cf3a317a452076969', '2026-01-13 09:32:12', NULL, '2025-12-30 14:32:12', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(119, 12, 'f934910c57674f41f40ff3638ea14a470f495e2f3715394199e905ef7da31a27', '2026-01-13 09:32:19', '2025-12-30 07:47:20', '2025-12-30 14:32:19', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(120, 28, 'c3ecce26a0a1559647f58979c01f13a81c8094cab0dd39efebffdd5ffabcfe3b', '2026-01-13 09:32:23', '2025-12-30 07:47:23', '2025-12-30 14:32:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(121, 16, 'c84cba955718645b6c273d946bba54e82074a2457b73f5d9997455fe8d7cfd10', '2026-01-13 09:33:00', '2025-12-30 07:48:48', '2025-12-30 14:33:00', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'),
(122, 3, 'b65604cf843ab1fb37b19c6c99bdff324507ec43fb6459230cb8d326406f27ed', '2026-01-13 09:33:42', '2025-12-30 07:49:42', '2025-12-30 14:33:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(123, 36, 'be1f156bc64b66db1e281909075b0a01d92d65b0a52f78c3a884160339339a4c', '2026-01-13 09:34:17', '2025-12-30 07:49:17', '2025-12-30 14:34:17', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(124, 32, '56205a753b10f2ca25b4220d30cbc3dfff5d0217032a01b44264deb19a2fb676', '2026-01-13 09:36:09', NULL, '2025-12-30 14:36:09', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(125, 36, 'bf4bdaf88d623e6b771d42e58b3214313117228ecf13c5a57623c3419b84513f', '2026-01-13 09:38:08', '2025-12-30 07:53:23', '2025-12-30 14:38:08', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(126, 12, '6c46e5575ac9814977c8631923a4fd5c9327607915d33f3e6a06da44ff98dbc9', '2026-01-13 09:47:20', '2025-12-30 08:02:50', '2025-12-30 14:47:20', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(127, 28, '54925335089a23976526a44fddbbfa43e377b51217ded9d295fc9d54abeb5ed2', '2026-01-13 09:47:23', '2025-12-30 08:02:23', '2025-12-30 14:47:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(128, 16, 'c825af8d3a940a559163269aeecff2c96e42645b04ea43554d010995800afddd', '2026-01-13 09:48:48', '2025-12-30 08:04:32', '2025-12-30 14:48:48', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'),
(129, 36, 'a6c913cbbcc3c7f32136df4b7b5ea8334b84fbf21c8fc5e1eaffab085c7b908b', '2026-01-13 09:49:17', '2025-12-30 08:04:28', '2025-12-30 14:49:17', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(130, 3, '7508025f3d2c48c02330d24c21a4cdb3b83a207c520c8e3b112a5c81b6ef65f1', '2026-01-13 09:49:42', '2025-12-30 08:05:42', '2025-12-30 14:49:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(131, 36, 'fea847dafba9947b74830e3c1bd8205694325bc5afe2d6665d7dca810b7ee493', '2026-01-13 09:53:23', NULL, '2025-12-30 14:53:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(132, 28, 'f72fab0997a95745eb4da06cbb5b72468eeb4ccb54b9d2c873eb504c175aa2ca', '2026-01-13 10:02:23', '2025-12-30 08:18:23', '2025-12-30 15:02:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(133, 12, 'a1a0fbd741c7f4ec646363cebb317917a2a3e95bdd86d6e4885408f35552302b', '2026-01-13 10:02:50', '2025-12-30 09:59:06', '2025-12-30 15:02:50', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(134, 36, '014d4afddf5cc7e7171565f187ceeff4af76cf9b9f8b226466b4b1cdfeb7e7d7', '2026-01-13 10:04:28', '2025-12-30 08:20:17', '2025-12-30 15:04:28', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(135, 16, '6ea11313ead5da503d214b78b5bf29530cd6e766f9bedaf86518a9c4af23fb5f', '2026-01-13 10:04:32', '2025-12-30 08:19:47', '2025-12-30 15:04:32', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'),
(136, 32, '56baa3d44a1c6bd15f78bcd3cdcf74e30579fb754dc59f68745d87f787f9d3c4', '2026-01-13 10:04:39', NULL, '2025-12-30 15:04:39', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(137, 3, 'e6f1f3802b6c01ad888b74d53faa578f4c32a53cbb9623ced474bde88d93f216', '2026-01-13 10:05:42', '2025-12-30 08:21:42', '2025-12-30 15:05:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(138, 36, '47eb39d8869af1c40a4f23b5090d720f91e92964aa7a99ca2a1894e184a71893', '2026-01-13 10:11:20', '2025-12-30 08:26:23', '2025-12-30 15:11:20', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(139, 28, '6a184b105deaccc234a5a1d96531b3a11d193463ae77d9b352813b1f0ca5e145', '2026-01-13 10:18:23', '2025-12-30 08:33:23', '2025-12-30 15:18:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(140, 16, '7f5c0cc398a892f6ac9456b53ccdbddcdf9eb3e87f5668f950020d13d9dae743', '2026-01-13 10:19:47', '2025-12-30 08:35:37', '2025-12-30 15:19:47', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'),
(141, 36, 'c4fa43870460bdc846ea94133d82bd3d6ecaef60c7f94f8d47f853a7d3a4445d', '2026-01-13 10:20:17', '2025-12-30 08:35:47', '2025-12-30 15:20:17', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(142, 3, '497156a2cb553363b24ae04682d4d19f1c41e81deb8a30809f95f900baae4dd4', '2026-01-13 10:21:42', '2025-12-30 08:37:42', '2025-12-30 15:21:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(143, 36, '60fdfc4b4e5a9bcfea8ea7f73255718f7016dd2c9e8cda31a8bccf7a3e3eba16', '2026-01-13 10:26:23', NULL, '2025-12-30 15:26:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(144, 32, '141d57589a4425d9545fadbda19509a45d3e1cd4aa84264ae2531e1a8aa7842b', '2026-01-13 10:28:33', '2025-12-30 08:43:39', '2025-12-30 15:28:33', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(145, 28, 'cd564a7c3b7f966a876fd6a777e0ce5b2db512214ad86f8ca8b726e2f37b958a', '2026-01-13 10:33:23', '2025-12-30 08:48:23', '2025-12-30 15:33:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(146, 16, '78514f060ecf61c80233f6a1ce353cd8cc1dd63845ef41c35bce3872399a778b', '2026-01-13 10:35:37', '2025-12-30 08:50:48', '2025-12-30 15:35:37', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'),
(147, 36, 'bdda26a4029a80d1e480c9f2dd7dbe8b02c5515d08b63b10b55d82882ea4b444', '2026-01-13 10:35:47', '2025-12-30 08:51:17', '2025-12-30 15:35:47', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(148, 3, 'c8b9ec4386c040fe7eb0e1dbad0af8eaf39982ba41adefda21809d0a3dd3b411', '2026-01-13 10:37:42', '2025-12-30 08:53:42', '2025-12-30 15:37:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(149, 32, '06be770eb68abd23d4ce6201189fa3ea3c13831de22c3af3306cc5264643c689', '2026-01-13 10:43:39', '2025-12-30 09:00:09', '2025-12-30 15:43:39', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(150, 28, '31f8c06117d890e3c3f4779482ead4a7b4f0483f1c56cfdeb5c993a7cbdca1ce', '2026-01-13 10:48:23', '2025-12-30 09:03:23', '2025-12-30 15:48:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(151, 16, '6abbcd747bb6f9b646b61a78abeace1b9cb305de487031e14cf0af3d08c8ec3b', '2026-01-13 10:50:48', '2025-12-30 09:06:48', '2025-12-30 15:50:48', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'),
(152, 36, '2ce5d108718a9d2aa72af1ffa0ad11c7b3d99c19026f525bf8382fea2522f44a', '2026-01-13 10:51:17', '2025-12-30 09:06:30', '2025-12-30 15:51:17', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(153, 3, '44282e2abc4be6317c84dd514b0d060286023b9f3bbb21a4e4f3147a16a7688d', '2026-01-13 10:53:42', '2025-12-30 09:09:42', '2025-12-30 15:53:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(154, 32, '600fa62a15e7f335671b8c58c6e0e0d40408e8ee0555f3d643facc5bc0650e8a', '2026-01-13 11:00:09', '2025-12-30 09:15:28', '2025-12-30 16:00:09', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(155, 28, '20c9126be131e4211d0aa16a570400c2c7d85b2d2d7335e81a6c19c4f0b47d79', '2026-01-13 11:03:23', '2025-12-30 09:18:23', '2025-12-30 16:03:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(156, 36, 'b21691f5ae338435474d61776da311a26582b430b5b644fefa9c8ac13f6e19c5', '2026-01-13 11:06:30', '2025-12-30 09:22:17', '2025-12-30 16:06:30', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(157, 16, 'c9c7cd2a3efb15260f0d67d49d13c9a0b1236953f9f3f8c5c2d4fcde43554a0f', '2026-01-13 11:06:48', '2025-12-30 09:22:48', '2025-12-30 16:06:48', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'),
(158, 3, 'f430dc89cea012481986c1ad053e085ac6ba65daa3983480ebe80db329691c67', '2026-01-13 11:09:42', '2025-12-30 09:25:42', '2025-12-30 16:09:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(159, 32, 'e0565fae833cbae3285dde8e33ace98ed66f67673e5c7361fc1895aebbca92de', '2026-01-13 11:15:28', '2025-12-30 09:30:46', '2025-12-30 16:15:28', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(160, 28, '850a42afe4ce71ac3333b0d2b5813e2afb0d8ecc8dcf0c84e27ffe97688150dc', '2026-01-13 11:18:23', '2025-12-30 09:33:23', '2025-12-30 16:18:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(161, 36, 'b96eb86d841ce427687e3e4b4698de3fb23719de3687681da760a6a4aac58d87', '2026-01-13 11:22:17', '2025-12-30 09:37:17', '2025-12-30 16:22:17', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(162, 16, '6311d2bf007d12cdbcc9b82a0fa8ba0dca605b2d45d92e4cb517e8e4d4cbc675', '2026-01-13 11:22:48', '2025-12-31 06:51:44', '2025-12-30 16:22:48', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'),
(163, 3, '75a3f66c501d4b83c0cf1fe15eea2a3e4a83618cef04f028b19290682df59732', '2026-01-13 11:25:42', '2025-12-30 09:41:42', '2025-12-30 16:25:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(164, 32, '65c3931e6bc60786992f3c7bbd5a57953909fd46518adf40eaa45057069a7946', '2026-01-13 11:30:46', '2025-12-30 09:31:00', '2025-12-30 16:30:46', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(165, 32, '854f40a9cf669ef53e722be959893154296ab378ce66bfb39e75ebc6c45c3c3b', '2026-01-13 11:31:00', NULL, '2025-12-30 16:31:00', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(166, 28, 'b917bc12718d3df5bc241b9752f06d975fedcb1a8d22e5264e98e6042370ee57', '2026-01-13 11:33:23', '2025-12-30 09:48:23', '2025-12-30 16:33:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(167, 36, 'cdf8753c23a628761518d975f6a22dad472e0934e8b0a6739787a6da3cec13f1', '2026-01-13 11:37:17', '2025-12-30 09:52:17', '2025-12-30 16:37:17', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(168, 3, 'abe8f9b5c36b88a171f7a0c3e6104a128ee9443c713203e5ff900c3e37c18ebf', '2026-01-13 11:41:42', '2025-12-30 09:57:42', '2025-12-30 16:41:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(169, 32, 'acac68d57c8c5d08d3bb60146a3b1b55b4d0f6c066d372855d6aaf1b314fb910', '2026-01-13 11:43:57', '2025-12-30 09:59:20', '2025-12-30 16:43:57', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(170, 28, '86cdae20a0d5f4d74f6835673da005dd47bc2ca1d94b880eb38ec8275c07744d', '2026-01-13 11:48:23', '2025-12-30 10:03:23', '2025-12-30 16:48:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(171, 36, '0b7d0ec5e8dbd5c1ff116e5bb5b49a9afbac12b1dc1e309aa1ed25e23d25769e', '2026-01-13 11:52:17', '2025-12-30 10:07:17', '2025-12-30 16:52:17', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(172, 3, '62ca78b06b362798e13ce090d0a7a8427527d5df0dd1526ec77b46060cddeff5', '2026-01-13 11:57:42', '2025-12-30 10:13:42', '2025-12-30 16:57:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(173, 12, '4fa1912de4ce99d80d0a753397deeea4a6ca667bde89ff331cc5b147153c422f', '2026-01-13 11:59:06', '2025-12-30 10:14:19', '2025-12-30 16:59:06', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(174, 32, '434d05e7e4dd9477ca1e27e5d1906beb8a7d97bfa542559da20f1db76fe7e528', '2026-01-13 11:59:20', '2025-12-30 10:14:46', '2025-12-30 16:59:20', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(175, 28, '5f294f212b32a176567ebe37d0f7310c409c31b0537adb29b7f17fdfd5980e59', '2026-01-13 12:03:23', '2025-12-30 10:18:23', '2025-12-30 17:03:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(176, 36, '01795c478fb184c470d8ebe1a91854073a7956e3b37bb95760526c23040ae2dd', '2026-01-13 12:07:17', '2025-12-30 10:22:17', '2025-12-30 17:07:17', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(177, 3, 'e4a8cd9b59329997b04c7bcab73b907f97671c0d7e06d543dd5f4c3d84a36c91', '2026-01-13 12:13:42', '2025-12-30 10:28:42', '2025-12-30 17:13:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(178, 12, 'cdc820426248d07f6cbb046c8aefb12943e89c55eb226554408d0a8204433a58', '2026-01-13 12:14:19', '2025-12-30 10:30:00', '2025-12-30 17:14:19', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(179, 32, '047c19221ed24fa775aa09573c470f5f1f4d9c7755d706b42b334867bbdd903e', '2026-01-13 12:14:46', '2025-12-30 10:29:50', '2025-12-30 17:14:46', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36');
INSERT INTO `refresh_tokens` (`id`, `user_id`, `token_hash`, `expires_at`, `revoked_at`, `created_at`, `ip`, `user_agent`) VALUES
(180, 28, 'a363a709bdc7b22713a41cc99710d867a27a3b128b2ea35e71182502fc98dc17', '2026-01-13 12:18:23', '2025-12-30 10:33:23', '2025-12-30 17:18:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(181, 36, '5ee96ea844f38178a511a8dc92c3a907d834e9281957c33719a7a9df3970c07c', '2026-01-13 12:22:17', '2025-12-30 10:37:17', '2025-12-30 17:22:17', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(182, 3, 'a62b9ff7280bf4847681a70514e7456b25e039444d3b4d561987ab87b81decc7', '2026-01-13 12:28:42', '2025-12-30 10:44:42', '2025-12-30 17:28:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(183, 32, 'a12e7c98dfd97f0c68ca3bfb65ad924b2611e050c8d05b3e3a2e43ff6fe1b048', '2026-01-13 12:29:50', '2025-12-30 10:45:09', '2025-12-30 17:29:50', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(184, 12, 'eebfa5e8118e46301750c61e6bc8b50f67f5ae54c3730ab32eee62b94f5e7096', '2026-01-13 12:30:00', '2025-12-30 10:45:14', '2025-12-30 17:30:00', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(185, 28, '838bbee5b8ceadc5dae59dd45a97200cb86c83859b4f5265f98fe9e06516093b', '2026-01-13 12:33:23', '2025-12-30 10:48:23', '2025-12-30 17:33:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(186, 36, 'eaa401ebc437903c62cd415be99168c4a2f0f1e53d62f4e0514e0c76129c264c', '2026-01-13 12:37:17', '2025-12-30 10:52:17', '2025-12-30 17:37:17', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(187, 3, 'f7988ffc86665102f52d7a96887ead1d4eb393dad4840038ed2a1b4ece4d7c5e', '2026-01-13 12:44:42', '2025-12-30 11:00:42', '2025-12-30 17:44:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(188, 32, 'ab7d433b32da88d0e165a04bb43808f18a8d84c08778d84e4de12aeb1df7ff44', '2026-01-13 12:45:09', '2025-12-30 11:00:33', '2025-12-30 17:45:09', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(189, 12, '541b5b3b37bd02e5fa24658a3b86a4841909ee554f3e94b513effe4452b391ba', '2026-01-13 12:45:14', '2025-12-30 11:00:14', '2025-12-30 17:45:14', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(190, 28, '270c12f796082a2c944d54684610fbea69ccf5ae8c22e7d6d06f32098c1677bd', '2026-01-13 12:48:23', '2025-12-30 11:03:23', '2025-12-30 17:48:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(191, 36, '55e6f386ee55fc640f493b5306904ee711e0d0c4e38fd9e5fa189bdd2a0bae15', '2026-01-13 12:52:17', '2025-12-30 11:07:17', '2025-12-30 17:52:17', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(192, 12, '446a6f1959bb3dffb679c82a75d9cf87d11482a55c1676d2e84df867ec830a52', '2026-01-13 13:00:14', '2026-01-05 05:35:50', '2025-12-30 18:00:14', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(193, 32, '10bc0e05792d627f3b834a847e5ede67f03fb03e29e2d7aa4d5c3412b3793d4c', '2026-01-13 13:00:33', '2025-12-30 11:15:46', '2025-12-30 18:00:33', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(194, 3, 'fb326b556f2fd1d491ec5f02c65abe71ba119a1b2c463f6032fe79c0ebaa6685', '2026-01-13 13:00:42', '2025-12-30 11:16:42', '2025-12-30 18:00:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(195, 28, '225134a539581154adfaf8e0401020a6307cc6c3e395cf11bc0857667a41cb04', '2026-01-13 13:03:23', '2025-12-30 11:18:23', '2025-12-30 18:03:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(196, 36, '5a5d9a1981b273fe902e28fd04d1dd77360417769dbb20877922f90b05e94f57', '2026-01-13 13:07:17', '2025-12-30 11:22:17', '2025-12-30 18:07:17', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(197, 32, 'b8b176f2f2d8da7a859a0ccee025a9bc9f21d11bd6ac33911192e3a162a9e016', '2026-01-13 13:15:46', '2025-12-30 11:30:46', '2025-12-30 18:15:46', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(198, 3, 'ccdffd03ee19f2a91da0fc7cfb4458a0020b5dd3ab4b22675207a0aae4b320ea', '2026-01-13 13:16:42', '2025-12-30 11:32:42', '2025-12-30 18:16:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(199, 28, '78cad5e0d5bcfde329c481264e7db101565135890817ee75ac18c4748636fb42', '2026-01-13 13:18:23', '2025-12-30 11:33:23', '2025-12-30 18:18:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(200, 36, '74725e58b4a3f207e657d19edc86b09edfa89202509ec76c90c0b5e08d76e235', '2026-01-13 13:22:17', '2025-12-30 11:37:17', '2025-12-30 18:22:17', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(201, 32, 'd1c01e411ae20bf65220c8cd76c38e388abc9f5db3a305d25f4be762f0486ae6', '2026-01-13 13:30:46', '2025-12-30 11:45:46', '2025-12-30 18:30:46', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(202, 3, 'c59f460708e306287586a757edaaafcf00b62adfec4df727e80bf5e68115fe4b', '2026-01-13 13:32:42', '2025-12-30 11:48:42', '2025-12-30 18:32:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(203, 28, '90a96033ec163091658ff3d30987d76165e204b61be212631608e291ce500c12', '2026-01-13 13:33:23', '2025-12-30 11:48:23', '2025-12-30 18:33:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(204, 36, 'e0f9e03df97620312f233654bf568f313c57e0caad8152383afbf752510a17dd', '2026-01-13 13:37:17', '2025-12-30 11:53:18', '2025-12-30 18:37:17', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(205, 32, '9b5ac004fa9f7f28e43870cbdf31542164aba792e6f2c8ca5a2a91b3df6ac0f9', '2026-01-13 13:45:46', '2025-12-30 12:00:46', '2025-12-30 18:45:46', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(206, 28, '95afdef3a97e75d4a0a2fa33862fed579f42f7bfc8f88b4c356e3245154c7ae3', '2026-01-13 13:48:23', '2025-12-30 12:03:23', '2025-12-30 18:48:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(207, 3, 'a54941ae8b15663c7eed0e07dda9307889d9800c5659f3ef71cb330c647d0503', '2026-01-13 13:48:42', '2025-12-30 12:03:42', '2025-12-30 18:48:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(208, 36, 'cba8dde79ab5a219b68cfdb6abff98b71a316548cb9b5529858114afcc323b47', '2026-01-13 13:53:18', '2025-12-30 12:09:16', '2025-12-30 18:53:18', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(209, 32, '7ac77e0d990e1611f00e0c697ce0ea358c8b039fd207f919115342438fe743a1', '2026-01-13 14:00:46', '2025-12-30 12:16:30', '2025-12-30 19:00:46', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(210, 28, 'b0c70af7fd5faccef4267230ac13cac4bb23c5c686908f84dfabb8229d564c03', '2026-01-13 14:03:23', '2025-12-30 12:18:23', '2025-12-30 19:03:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(211, 3, 'f35ec4bc42df5463482217074cae0872bc7c9e721893ee5be62fb2714dbc3f9f', '2026-01-13 14:03:42', '2025-12-30 12:19:42', '2025-12-30 19:03:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(212, 36, '4c45ceb72ba700cce50358cc84babc421d63427136e785f4826d46e71e00338d', '2026-01-13 14:09:16', '2025-12-30 12:24:16', '2025-12-30 19:09:16', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(213, 32, '9dd06b316cfa3f546b96367b693ef77dcb0e1defb10669fbe060a9f51c8434cb', '2026-01-13 14:16:30', NULL, '2025-12-30 19:16:30', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(214, 28, '6ef6cf11ab9f673b272df9a0707098ed436cd84ef65f73a57e135098f1969772', '2026-01-13 14:18:23', '2025-12-30 12:33:24', '2025-12-30 19:18:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(215, 32, 'b9f1bd9acd3d95e19b47740e23d37bae5c1cb5a168775d7fcb1160d24d15bc8f', '2026-01-13 14:18:47', NULL, '2025-12-30 19:18:47', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(216, 3, '9f678dc799ab304b8e057083a598e714523833e13375b0107b8d2a16877f406e', '2026-01-13 14:19:42', '2025-12-30 12:34:42', '2025-12-30 19:19:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(217, 32, 'b4aa2b8e4be47acec6ca0377945f7bd7f5915828906eb0dcf235414b7fe7f558', '2026-01-13 14:23:34', '2025-12-30 13:55:15', '2025-12-30 19:23:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(218, 36, '8fe8b622053c66420f1aa195a2d4e660614ab7e1becbf1abd8fe35620fb7e527', '2026-01-13 14:24:16', '2025-12-30 12:39:16', '2025-12-30 19:24:16', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(219, 4, '049c3cc28e00800acc5202330e8ed126e396150cc6b4aa4715479eaf3c9b5e41', '2026-01-13 14:25:03', '2025-12-30 12:40:21', '2025-12-30 19:25:03', '181.56.29.244', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(220, 28, '7fc507fedb437ffafe426657980490401dcfb17d87ac368557eef64b37ea80ab', '2026-01-13 14:33:24', '2025-12-30 12:48:24', '2025-12-30 19:33:24', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(221, 3, 'f61b434529f345bb0aa2ab7198ceb8fd6579fe0230af3470f15fe9607a96119d', '2026-01-13 14:34:42', '2025-12-30 12:50:42', '2025-12-30 19:34:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(222, 36, 'da3068517d6ea31e5af22e0c910cf0fe8b42e15ecec98ea62aaa3ad5c74fa8ba', '2026-01-13 14:39:16', '2025-12-30 12:55:16', '2025-12-30 19:39:16', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(223, 4, '74a1a8aa4361aa303af9eeb0c9173378dc4c0e97af6eeb658ea5ac278559f466', '2026-01-13 14:40:21', '2025-12-30 13:43:35', '2025-12-30 19:40:21', '181.56.29.244', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(224, 28, 'eb51e293e104d4ca57833770509ce838139f2cadf18105abc1f67606b52f3c0f', '2026-01-13 14:48:24', '2025-12-30 13:03:51', '2025-12-30 19:48:24', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(225, 3, '914fb0259057dccd27adfd7f493d906c4d9082467e3b1432ba04d00fa2ff82ef', '2026-01-13 14:50:42', '2025-12-30 13:05:42', '2025-12-30 19:50:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(226, 36, '631b09cfc520ccd51d56ec3091e83ef37b0413263f748c4b06691c9c306c8d73', '2026-01-13 14:55:16', '2025-12-30 13:10:16', '2025-12-30 19:55:16', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(227, 28, '3961e65d69b8d4ed2b10da4783444ae30e8cd2b3c06598ed4d1d0d0445fa1347', '2026-01-13 15:03:51', '2025-12-30 13:18:51', '2025-12-30 20:03:51', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(228, 3, 'ad2f0d7ac0f8f934099c2ad32cacba7168e88d526b994d6f33210545ca693612', '2026-01-13 15:05:42', '2025-12-30 13:21:42', '2025-12-30 20:05:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(229, 36, '9d8e0339893cdeb4f1b376560e2f33b64716de688a10b00d85b2d0c8e61418eb', '2026-01-13 15:10:16', '2025-12-30 13:26:16', '2025-12-30 20:10:16', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(230, 28, 'a0cbc638a6425dafdd6aad6228c48c2cec3c79ee28f3ab0b6dd980e8cd0d6561', '2026-01-13 15:18:51', '2025-12-30 13:33:51', '2025-12-30 20:18:51', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(231, 3, 'f9cc0188a7406a7857d71e4508f970d18357e9d727bb01a451af66c6a4721db3', '2026-01-13 15:21:42', '2025-12-30 13:36:42', '2025-12-30 20:21:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(232, 36, '5608efbc100af647f1a777935049f3abcbc1b7ecdc20e8b65b56321453b5ad3a', '2026-01-13 15:26:16', '2025-12-30 13:41:16', '2025-12-30 20:26:16', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(233, 28, 'fffbf2f768d41ce5cf67dfffc05d5e8827b3843c5181ce41eb4dc506732c362c', '2026-01-13 15:33:51', '2025-12-30 13:49:23', '2025-12-30 20:33:51', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(234, 3, '3a1df5a14572cef722ceaa7823ae0f34a37a3f0cd2b80843af3ba484e20b9521', '2026-01-13 15:36:42', '2025-12-30 13:51:42', '2025-12-30 20:36:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(235, 36, '6be4dbddd6f2fa70aa83dad7747a55abdd9b58f4a5cfe09b466cfa567d16481a', '2026-01-13 15:41:16', '2025-12-30 13:57:16', '2025-12-30 20:41:16', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(236, 4, 'd12158b04a35189230cf6eddcfa9f1f6c2a5bb8cad46384088cb81c2da0c9acf', '2026-01-13 15:43:35', '2025-12-30 13:59:25', '2025-12-30 20:43:35', '186.102.70.54', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(237, 28, 'd39702d72e99798ebb3571f34d531e2b3623a23d934e1296770e44050a1163a1', '2026-01-13 15:49:23', '2025-12-30 14:04:23', '2025-12-30 20:49:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(238, 3, '48db9cc16d2d9ded355d83fa5862c49a3aa690865fe5097d6a04c1730e90a435', '2026-01-13 15:51:42', '2025-12-30 14:06:42', '2025-12-30 20:51:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(239, 32, 'ab7535e6bca3dca52ea6f463fa6b5755536fe15b7ccff244a84aa414d2510714', '2026-01-13 15:55:15', '2025-12-30 14:10:43', '2025-12-30 20:55:15', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(240, 36, '62f7c97bf697ca1933dc11f88a7918ce6b99889d954c54552311087f13a1ecc0', '2026-01-13 15:57:16', '2025-12-30 14:13:16', '2025-12-30 20:57:16', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(241, 4, '4ab0e2ad4fe2a5e224e32d21355d428a79dd54e5a6ee4b936910a2b719502a7a', '2026-01-13 15:59:25', '2025-12-30 14:23:32', '2025-12-30 20:59:25', '186.102.70.54', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(242, 28, '47a03424c3d78271c9a694669648142e39cdf01993a86230454744e9a6b2a7f0', '2026-01-13 16:04:23', '2025-12-30 14:19:23', '2025-12-30 21:04:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(243, 3, '91212ea33e5a8c99456d04e928d11bb7c235c7c55ee636946d6cc80cf94a47eb', '2026-01-13 16:06:42', '2025-12-30 14:21:42', '2025-12-30 21:06:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(244, 32, '910cbe94bc37c2d904b018ce845ee43c85b162095a590ddf27797518a7d461ab', '2026-01-13 16:10:43', '2025-12-30 14:25:46', '2025-12-30 21:10:43', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(245, 36, '04e80617c2abab4c9af4861728f6c06b64c71acf79c2e783ee73bad53a983d23', '2026-01-13 16:13:16', '2025-12-30 14:29:16', '2025-12-30 21:13:16', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(246, 28, '860d383dd7b05f013b92d6f98be73b21bc6a30c93bd3863772ed1c9108a7ce1b', '2026-01-13 16:19:23', '2025-12-30 14:34:52', '2025-12-30 21:19:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(247, 3, '438d4a848ab2a299edf9aa445098eea0845a01519f88e17ee6cc10d1189c9fa0', '2026-01-13 16:21:42', '2025-12-30 14:36:42', '2025-12-30 21:21:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(248, 4, 'a6ce91bf6df153f4b4bb5180d86f2dff367582c9b14e5ca5685f670a26c994e8', '2026-01-13 16:23:32', '2025-12-30 14:38:32', '2025-12-30 21:23:32', '186.102.70.54', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(249, 32, 'e27aae3a3ce3b0b7820f12889c86c9d5fb0e822cb3be2a51759377d02e84859a', '2026-01-13 16:25:46', '2025-12-30 14:41:03', '2025-12-30 21:25:46', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(250, 36, '731c37becd53db8eb0963bcc6db3a6ebfa1f1fd9a70beb704509add309251eb9', '2026-01-13 16:29:16', '2025-12-30 14:45:16', '2025-12-30 21:29:16', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(251, 28, 'beb0b95411adeb9a7f0e9a4f2eafb80ccdbc3189d3b099c43c58a22af466bb2f', '2026-01-13 16:34:52', '2025-12-30 14:50:23', '2025-12-30 21:34:52', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(252, 3, 'ed770608142cdd272266c24d149121c85e7be6792565c5d0ca7219d2b51763c4', '2026-01-13 16:36:42', '2025-12-30 14:51:42', '2025-12-30 21:36:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(253, 4, '9806763d2a1cafdc351b7d0088449ce26dc5b1bacf79dd8d5acd8d69b14feae2', '2026-01-13 16:38:32', '2025-12-30 14:53:48', '2025-12-30 21:38:32', '186.102.98.212', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(254, 32, '7c50b9c236eb59ba910435b83f3cf248e56313dd79de314964495cb63651ea6c', '2026-01-13 16:41:03', '2025-12-30 14:56:36', '2025-12-30 21:41:03', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(255, 36, '1da8c0df9c4f718dc7f4333cf3659cbb0fa6b34af25e3fe424a6ada361354cf6', '2026-01-13 16:45:16', '2026-01-02 05:25:28', '2025-12-30 21:45:16', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(256, 28, 'dceea25d59515fde0a478e0538a91f5e91025df1502373611c112d140194009d', '2026-01-13 16:50:23', '2025-12-30 15:05:23', '2025-12-30 21:50:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(257, 3, '61dc8ae160fdbd85deeab79be72b8549c7dcc10f4eff6ae58557e3d9319bd482', '2026-01-13 16:51:42', '2025-12-30 15:06:42', '2025-12-30 21:51:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(258, 4, 'e8e9519d6730e433bce7148960d469a91f2510e97bdb028426df3fcf9e9a4809', '2026-01-13 16:53:48', '2025-12-30 15:09:38', '2025-12-30 21:53:48', '186.102.98.212', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(259, 32, 'c771720ee0a8ca3f324793960650ebefc65c7a98d9397c10f6bc0cb3a74a3434', '2026-01-13 16:56:36', '2026-01-06 12:21:16', '2025-12-30 21:56:36', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(260, 28, 'f5acdc9d7f6cb8dd3e3aff766281fab391b776001175d4e9d9eb9103ff0a80c9', '2026-01-13 17:05:23', '2025-12-30 15:20:46', '2025-12-30 22:05:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(261, 3, '0275a8ae33b5c31be03ad056ec9fd1a4c91126fd47b2bf41b6542297de58fbde', '2026-01-13 17:06:42', '2025-12-30 15:21:42', '2025-12-30 22:06:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(262, 4, '3861ba45088296f658648d78c051bf1b8d51eb7ea85c2bdf9125d8f517fe6eef', '2026-01-13 17:09:38', '2025-12-30 15:24:51', '2025-12-30 22:09:38', '186.102.98.212', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(263, 28, '2cde36984cf8b0ca65cc3434dc9962ceb58fefbc0838e48f5ef0bb88a929fa1d', '2026-01-13 17:20:46', '2025-12-30 15:36:23', '2025-12-30 22:20:46', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(264, 3, '2a219e23ed908c73d5912fef858a38cb870ca1bcf86047fb8fd2aff198af63b6', '2026-01-13 17:21:42', '2025-12-30 15:36:42', '2025-12-30 22:21:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(265, 4, '4e964eca786933675dc4f2a77b6b2116c1e209b047d94b14920e3310a510c30a', '2026-01-13 17:24:51', NULL, '2025-12-30 22:24:51', '186.102.98.212', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(266, 28, '1d32a4d2eff63a2d6a77484fa39e9447a5e367ac81e15c77e801d33ffa21064e', '2026-01-13 17:36:23', '2025-12-30 15:51:23', '2025-12-30 22:36:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(267, 3, 'c4d5851973899f52f11c0dbcc0a3483c93dd79bc409fc9148da38319183454f0', '2026-01-13 17:36:42', NULL, '2025-12-30 22:36:42', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(268, 28, 'b3ad1c42800be6da8f8a995305c78ada9b768cb086aa7164dd55e26261e9a66e', '2026-01-13 17:51:23', '2025-12-30 16:06:23', '2025-12-30 22:51:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(269, 28, '5f1e8e692c9acd4630221e8f87ad2cb3552a9cada0a42201cdca0248b342d749', '2026-01-13 18:06:23', '2025-12-30 16:21:23', '2025-12-30 23:06:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(270, 28, '4bc408ac1a4a3a279441d7acc552bb831ba47903bfd5dafb576a44c93d3d99a0', '2026-01-13 18:21:23', '2025-12-30 16:36:23', '2025-12-30 23:21:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(271, 28, 'b1b5b6daf6a54ae970e5d5c413145c83fd056b16974b14cdd33cd076359c5d0c', '2026-01-13 18:36:23', '2025-12-30 16:51:23', '2025-12-30 23:36:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(272, 28, 'e57227482d9e5dbf0027e049461d7267168682bfa838a1ce1f18f0d9df6c40c1', '2026-01-13 18:51:23', '2025-12-30 17:06:23', '2025-12-30 23:51:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(273, 28, '4db91eadf5dac10e7e340d04b0007f7e823a008e198506ead607af5a4fb2536e', '2026-01-13 19:06:23', '2025-12-30 17:21:23', '2025-12-31 00:06:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(274, 28, '27d998f1aad1200c6a1638db333acf7ba865ce5f4d099b65f7dd4df51f949cd6', '2026-01-13 19:21:23', '2025-12-30 17:36:23', '2025-12-31 00:21:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(275, 28, 'f3276b2aa71e7f23dcf49292fe07ea6f89863e6cab246e8904c367ae82361801', '2026-01-13 19:36:23', '2025-12-30 17:51:23', '2025-12-31 00:36:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(276, 28, '21810d6cc771cadd9e3de72c866794344feafa93d67bcd447d2df479e23edbf9', '2026-01-13 19:51:23', '2025-12-30 18:06:23', '2025-12-31 00:51:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(277, 28, '7983f03e9f7b8cf0294d63f9a1d88955f68fe5b93714e3f446c1876a041774e0', '2026-01-13 20:06:23', '2025-12-30 18:21:23', '2025-12-31 01:06:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(278, 28, 'c2f53a0158d4ad101e18da0246175d8ed6ba827825f95aea1bc5eec6320dc125', '2026-01-13 20:21:23', '2025-12-30 18:36:23', '2025-12-31 01:21:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(279, 28, '2ec065577b40efea83d52cf966ff00562014b800a5652497564cd64bff741470', '2026-01-13 20:36:23', '2025-12-30 18:51:23', '2025-12-31 01:36:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(280, 28, '0318f0ac039888ba6f2a45e04fe60a552ba6f60727d3f87a3d629b99098095d2', '2026-01-13 20:51:23', '2025-12-30 19:06:23', '2025-12-31 01:51:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(281, 28, 'cf1ed9d3bda22d51e00fc7b6dc21934453e8a9ca2fb3d66bc317064f1c110d8f', '2026-01-13 21:06:23', '2025-12-30 19:21:23', '2025-12-31 02:06:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(282, 28, 'db76d3fcd71e3beb968c5f4dfcca31222b07e902430914adda74fb4d7b1c241a', '2026-01-13 21:21:23', '2025-12-30 19:36:23', '2025-12-31 02:21:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(283, 28, 'fdfaa964c3218baa8918ee8ab0bb5dfbf65b0b68bedcd2824cd28112081a17ce', '2026-01-13 21:36:23', '2025-12-30 19:51:23', '2025-12-31 02:36:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(284, 28, '44b4009b3dc8c66f8bcd23d5c13cb54a758f28a469fa7d21f4fe339805778b0e', '2026-01-13 21:51:23', '2025-12-30 20:06:23', '2025-12-31 02:51:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(285, 28, '06cd018d2a5dc09dfa18710624ef4d9c9a3ab0313437f287b40ab4cdc36aef80', '2026-01-13 22:06:23', '2025-12-30 20:21:23', '2025-12-31 03:06:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(286, 28, '416a8c6e53dfdf773c185fe838dca77dc10b90d1eac349a710d6d925113688ad', '2026-01-13 22:21:23', '2025-12-30 20:36:23', '2025-12-31 03:21:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(287, 28, '1ead38e37b807dfe1538881a0ca727e85ae01fb504ecb758902bece8d86d04d5', '2026-01-13 22:36:23', '2025-12-30 20:51:23', '2025-12-31 03:36:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(288, 28, 'b3250abf00e5b4978066c83f918e48a8ba8f917bdbfbec2de2d23d31f4dadfb1', '2026-01-13 22:51:23', '2025-12-30 21:06:23', '2025-12-31 03:51:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(289, 28, 'c10423b3e5a0c79689dc31fa48f63f58d64d3b6079094ecbe3b6dd4f558d7914', '2026-01-13 23:06:23', '2025-12-30 21:21:23', '2025-12-31 04:06:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(290, 28, '0b8f84aedc6bb54175d044c464f1c20d05a696c3936e9a1534a2715a721e5674', '2026-01-13 23:21:23', '2025-12-30 21:36:23', '2025-12-31 04:21:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(291, 28, '420e7231665d4e6c817bfbdf2fd4dbc8e928505b3d1969223278bc8d8558ee65', '2026-01-13 23:36:23', '2025-12-30 21:51:23', '2025-12-31 04:36:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(292, 28, '8918253a7efca1aa22fe757ce1597e5dc47216a5e133e3ec3e4be7b89265ed50', '2026-01-13 23:51:23', '2025-12-30 22:06:23', '2025-12-31 04:51:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(293, 28, '8596dcab0109d4beb29458bc830a49a245379fe89eadbbbbaece1e9b9fd8e868', '2026-01-14 00:06:23', '2025-12-30 22:21:23', '2025-12-31 05:06:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(294, 28, '21c3e998d7b1b8e42ac49f0b1abf00cb54345a139ce3b48c68a8c0516479eb85', '2026-01-14 00:21:23', '2025-12-30 22:36:23', '2025-12-31 05:21:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(295, 28, '371dc4624e2c297dad98942ae8c6b6a2226f6ed203b0928ca7872e1cd38d7e07', '2026-01-14 00:36:23', '2025-12-30 22:51:23', '2025-12-31 05:36:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(296, 28, '09644cc838dbb3d52acccaf9ee568409fafa6342bbbc4e7addc732f545c1a4d4', '2026-01-14 00:51:23', '2025-12-30 23:06:23', '2025-12-31 05:51:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(297, 28, 'eab8a45a9db2cee7455dfd131d55a601b46812f9c71da2e481a822feaa5ceb9c', '2026-01-14 01:06:23', '2025-12-30 23:21:23', '2025-12-31 06:06:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(298, 28, 'cac7b8df5daa2804dbb555310515c8241033ea1c6d473b77c4719ab993f0a947', '2026-01-14 01:21:23', '2025-12-30 23:36:23', '2025-12-31 06:21:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(299, 28, '3dafe289fafc71d6cbeab7e65cab7c984d53459bd5952186b7082c8acab4586d', '2026-01-14 01:36:23', '2025-12-30 23:51:23', '2025-12-31 06:36:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(300, 28, '1292243dc737828d07759041ca489054342f06bff080844f599b6045f3e3dfe2', '2026-01-14 01:51:23', '2025-12-31 00:06:23', '2025-12-31 06:51:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(301, 28, '2cc1b94a81eb007b5363e61dddc195a4240a5f0868d610640e678569133615d5', '2026-01-14 02:06:23', '2025-12-31 00:21:23', '2025-12-31 07:06:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(302, 28, '0da5d5f89b62aff4acc1ba63ffa98140b12d93d6edf4e6eca0217d8d5aace904', '2026-01-14 02:21:23', '2025-12-31 00:36:23', '2025-12-31 07:21:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(303, 28, '05dafb7426ac7614e410f8ac3fca79aeea7df6538e6d2896570c2443df5955f2', '2026-01-14 02:36:23', '2025-12-31 00:51:23', '2025-12-31 07:36:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(304, 28, 'c47432ebee9eec0db49280096a4f91239943a3637bb54bab06acc86653effa41', '2026-01-14 02:51:23', '2025-12-31 01:06:23', '2025-12-31 07:51:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(305, 28, 'bbe301fd964c41df4d7f6a4bea82c480d6a16e76f6ed0bf24bf61a41d2b94fd5', '2026-01-14 03:06:23', '2025-12-31 01:21:23', '2025-12-31 08:06:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(306, 28, 'c8888d4307484f51a70df03cc62eb9915de2df101e4ab226bd6a4bd3cf14df43', '2026-01-14 03:21:23', '2025-12-31 01:36:23', '2025-12-31 08:21:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(307, 28, '7086d2f3b90e956d4ebb2b4091dbeaf36a8ab0c1850245741128281128892ba6', '2026-01-14 03:36:23', '2025-12-31 01:51:23', '2025-12-31 08:36:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(308, 28, '5adee72e0127490f27fbeab28e8ac9ec1937a3bd591ad23f7b61a57d4c26cfb9', '2026-01-14 03:51:23', '2025-12-31 02:06:23', '2025-12-31 08:51:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(309, 28, '0970f093e4bb0c8fe3d7ce776fbf9d1e8641e9cb48878f5fc6a2f914221ab229', '2026-01-14 04:06:23', '2025-12-31 02:21:23', '2025-12-31 09:06:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(310, 28, 'c2ea4269a384309eeb7d2d6013fd8f0014d0a83e7871f499ede895cbd550060f', '2026-01-14 04:21:23', '2025-12-31 02:36:23', '2025-12-31 09:21:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(311, 28, 'b7570de9adcb22ad332d0c313e33b7557764fe51219261ed66c9ad92d98dee22', '2026-01-14 04:36:23', '2025-12-31 02:51:23', '2025-12-31 09:36:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(312, 28, '9e39c1114f8ff5a22817145e676bafbcdf8436b4e09d1224709812fa4d5a1baa', '2026-01-14 04:51:23', '2025-12-31 03:06:23', '2025-12-31 09:51:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(313, 28, '18e6154cfaa857efba627462c02553d40aadafa274dfe0b231694a5de723521e', '2026-01-14 05:06:23', '2025-12-31 03:21:24', '2025-12-31 10:06:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(314, 28, '297e1839af1054119281485513c29d763773e42a1d234dd4d0d16aca72770a8a', '2026-01-14 05:21:24', '2025-12-31 03:37:24', '2025-12-31 10:21:24', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(315, 28, '31b5bb47cbaee4147f6002c76d00f170bbdca3197ebfa5387d8a65774ba99219', '2026-01-14 05:37:24', '2025-12-31 03:53:23', '2025-12-31 10:37:24', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(316, 28, '9b41a9986b477ca5b3fbaf7cf99b60ddb7a5b94225547b3e687688598c78d3ee', '2026-01-14 05:53:23', '2025-12-31 04:08:23', '2025-12-31 10:53:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(317, 28, '4b37d1bd647069265db1a618b61e1ecf069a90f9e2b1985eb9b58c081b4ef130', '2026-01-14 06:08:23', '2025-12-31 04:23:23', '2025-12-31 11:08:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(318, 28, 'a8937e6143f1c5c4bbb869d2839fe169317a73a6440ff5f42bb4dfe57ace6908', '2026-01-14 06:23:23', '2025-12-31 04:38:23', '2025-12-31 11:23:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(319, 28, '883e38ce97170fb3823547fc3feae331c0b835d17732885ee9add94e14c5a227', '2026-01-14 06:38:23', '2025-12-31 04:53:24', '2025-12-31 11:38:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(320, 28, '7f7267c98a4009b6095775d42646fa4930a7a6026d56c5f0f1764df70b8e0190', '2026-01-14 06:53:24', '2025-12-31 05:09:24', '2025-12-31 11:53:24', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(321, 28, '56a98b6cbd980c7209a657d26a8407b4ce47e3ea4f8744ed3c0569829ecb5b72', '2026-01-14 07:09:24', '2025-12-31 05:25:24', '2025-12-31 12:09:24', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(322, 28, '97bccefc2bf792e7f1a84fb027ae49d30ffd4ee559eb82a1cd01eac502f10046', '2026-01-14 07:25:24', '2025-12-31 05:41:24', '2025-12-31 12:25:24', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(323, 28, 'b74c41594dc98a754c213a969edc70b0e94bb842fd5aced28bfc4c12d52ac6b9', '2026-01-14 07:41:24', '2025-12-31 05:57:24', '2025-12-31 12:41:24', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(324, 28, 'a6d6c99312c0496e401f961c6dd69407b482df1eea80459fda2e2f90665685c7', '2026-01-14 07:57:24', '2025-12-31 06:13:24', '2025-12-31 12:57:24', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(325, 28, 'd69afceb91b8728fd55c740547b03b4358e6b5f7c1622e53edfdb0c3aceb44a1', '2026-01-14 08:13:24', '2025-12-31 06:29:24', '2025-12-31 13:13:24', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(326, 28, '815dba55fbf1c6e04757d8575f4de01a31f21870061145851d2daa4db93a8a89', '2026-01-14 08:29:24', '2025-12-31 06:45:24', '2025-12-31 13:29:24', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(327, 28, 'b97c89ab61c77494af6cbe56cd6a7386d5c1d31ca3273d6ac5ed7e03f8c3dcce', '2026-01-14 08:45:24', '2025-12-31 07:01:24', '2025-12-31 13:45:24', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(328, 16, '40cd81c031c4066e6215886fe2df19abef7bb4ba26b2f7c6298b1e36c0ed69a0', '2026-01-14 08:51:44', '2025-12-31 07:06:44', '2025-12-31 13:51:44', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'),
(329, 28, '80a90a83674086f225fe5b3d66e78384a16da84daface436660f1b147e6fcd5f', '2026-01-14 09:01:24', '2025-12-31 07:17:24', '2025-12-31 14:01:24', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(330, 16, '7ea7a62e3e2ca6cfb5ded77b81a7b9d33cc2b8521b5c004330c0a575d0062720', '2026-01-14 09:06:44', '2025-12-31 07:21:47', '2025-12-31 14:06:44', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'),
(331, 28, '050d3fa4d683712aef61177b4c8350b9a966eaa792e0a22d8135d9b09ab04cc4', '2026-01-14 09:17:24', '2025-12-31 07:33:24', '2025-12-31 14:17:24', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(332, 16, '912d624d983d9681a0b7da382189944394a60e1cd14279e747f206c00181e119', '2026-01-14 09:21:47', '2025-12-31 07:36:47', '2025-12-31 14:21:47', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'),
(333, 28, 'e191e91b743fa5cf1aee0e5110dfe7b722495f15f3b5ddf8e7504a5e14612768', '2026-01-14 09:33:24', '2025-12-31 07:49:24', '2025-12-31 14:33:24', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(334, 16, '8c4aff9abb41f7c4ad7d6ac6501f6dbebe3b3afe8f0bc449fe34657195284ca1', '2026-01-14 09:36:47', '2026-01-02 06:29:13', '2025-12-31 14:36:47', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'),
(335, 28, '8734783ea2f8f9718dbfac9107db3c9fa50439d648482153b4cf426e53211591', '2026-01-14 09:49:24', '2025-12-31 08:05:24', '2025-12-31 14:49:24', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(336, 28, 'dc068aec4a5481fd5076b0da553e183c0a8ca8b61a50afb85826b7fd706f2219', '2026-01-14 10:05:24', '2025-12-31 08:21:24', '2025-12-31 15:05:24', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(337, 28, 'a793fed761194dd92d128cdc97c75b4131d360fc6955ec21d07fe393876ff2ef', '2026-01-14 10:21:24', '2025-12-31 08:37:24', '2025-12-31 15:21:24', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(338, 28, '0b43d034204d4f92ac69d1d73703f09981bd7b821b524b1efac29b00b2ca76d5', '2026-01-14 10:37:24', '2025-12-31 08:53:24', '2025-12-31 15:37:24', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(339, 28, 'e2afcb45061155d8fd868de54ddfeeedb21cd6ed059b609868caebdb70940fbc', '2026-01-14 10:53:24', '2025-12-31 09:09:24', '2025-12-31 15:53:24', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(340, 28, 'd50bd2997edb9835c17363f090e562fcc5cadc35d1d092e1bbef77ef30609b08', '2026-01-14 11:09:24', '2025-12-31 09:25:24', '2025-12-31 16:09:24', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(341, 28, '2738dfdb53faffb4661b6dcb479b08c013f61fd1d679f40045e55b1513d712be', '2026-01-14 11:25:24', '2025-12-31 09:41:24', '2025-12-31 16:25:24', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(342, 28, '3337a9a03486e7b0280b4af0bea5383e4a91febda93d438cb99a3e65b181d3b8', '2026-01-14 11:41:24', '2025-12-31 09:57:24', '2025-12-31 16:41:24', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(343, 28, '8325f6be73bdca1a495982367150426e6587fee73f8d9a43329b12d28fd54390', '2026-01-14 11:57:24', '2026-01-02 05:41:33', '2025-12-31 16:57:24', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(344, 36, '7399355f3d1128ca19dd113cb9312fc933271e197098a73c7f13d8a7bd22e7ba', '2026-01-16 07:25:28', '2026-01-02 05:41:06', '2026-01-02 12:25:28', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(345, 29, 'c5580cb3433230ddf57c4cc260a4328bf810076aebcfbf64c16f0d04eb575c85', '2026-01-16 07:34:52', '2026-01-02 05:49:52', '2026-01-02 12:34:52', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(346, 36, '7637941fad1a6cb837c4b4dc4ed72422365dc960af32aa40f3bdef5afababf8c', '2026-01-16 07:41:06', '2026-01-02 05:57:06', '2026-01-02 12:41:06', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(347, 28, 'f0fc23d75b8d6885c7ea51da8804980e19f930dc6bf56e40b0ec6584d97b4141', '2026-01-16 07:41:33', '2026-01-02 05:56:34', '2026-01-02 12:41:33', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(348, 28, 'f0fc23d75b8d6885c7ea51da8804980e19f930dc6bf56e40b0ec6584d97b4141', '2026-01-16 07:41:33', '2026-01-02 05:56:34', '2026-01-02 12:41:33', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(349, 29, 'c633af0c8e867cbb8ddc9ac0dab82ebfa6d1cd48213334762169387112bf2843', '2026-01-16 07:49:52', '2026-01-02 06:05:15', '2026-01-02 12:49:52', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(350, 28, 'cec6304950ae325300fc9f77babb4eefd506d241a8f9be8e682e1a6d4cec5a88', '2026-01-16 07:56:34', '2026-01-02 06:12:34', '2026-01-02 12:56:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(351, 36, 'a641abb6cdfa04538de34226e1c96ab4ab70e3d349a065529baee018b0ff8411', '2026-01-16 07:57:06', '2026-01-02 06:12:06', '2026-01-02 12:57:06', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(352, 29, 'bfc775b4ed6c8ac3435e504ce5e44db4e022bf77eaf031fc8946b8e479352e5c', '2026-01-16 08:05:15', '2026-01-02 06:20:53', '2026-01-02 13:05:15', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36');
INSERT INTO `refresh_tokens` (`id`, `user_id`, `token_hash`, `expires_at`, `revoked_at`, `created_at`, `ip`, `user_agent`) VALUES
(353, 36, 'e3e42b482d8d0669afaa50141d0e4f64830b4b36d0b624ff58c8de8a907488df', '2026-01-16 08:12:06', '2026-01-02 06:27:06', '2026-01-02 13:12:06', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(354, 28, '60af131f26eb8f2dc492636668b2b41d83c186608102492411a3b50c67621a6d', '2026-01-16 08:12:34', '2026-01-02 06:28:34', '2026-01-02 13:12:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(355, 29, '903a9e4541edd6f5d1fe0cc3b2f32caaec3ea10d29482ef36d9fb9ad4729c60a', '2026-01-16 08:20:53', '2026-01-02 06:36:15', '2026-01-02 13:20:53', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(356, 32, 'c7e9a7a7fbfb6be4cab33ade35713e36e5c4e443b653bea0e0b38e1f7c96ba53', '2026-01-16 08:26:35', '2026-01-02 06:41:50', '2026-01-02 13:26:35', '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(357, 36, 'f9a3853229e3bfb1f1b47fcc5888bf987626e23cd08a370e7d1ed5f5b76260ae', '2026-01-16 08:27:06', '2026-01-02 06:42:06', '2026-01-02 13:27:06', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(358, 28, '32407b89a4aba4a9c35d1ee908ca31057aebd2994c2a73e49817cf2a4a4b701b', '2026-01-16 08:28:34', '2026-01-02 06:44:34', '2026-01-02 13:28:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(359, 16, 'c43035881ddaacf9a2eea79e22469af2c818d951354a16b708010b5bfa370bf7', '2026-01-16 08:29:13', '2026-01-02 06:44:46', '2026-01-02 13:29:13', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'),
(360, 29, 'e6495dcc64dc602181e025ba436bcdc4a85c62fddef4d9322c912cbf4d4b0d32', '2026-01-16 08:36:15', '2026-01-02 06:51:53', '2026-01-02 13:36:15', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(361, 32, '4b6239aa78a3c84bf22b95e59aca22c729becb0ecec31c29ab7bfc0010240e63', '2026-01-16 08:41:50', '2026-01-02 06:57:39', '2026-01-02 13:41:50', '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(362, 36, '2b79114589928106a0a7e588eefd50445fe1cbb5006bc3fd9b93386c9c376263', '2026-01-16 08:42:06', '2026-01-02 06:57:06', '2026-01-02 13:42:06', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(363, 28, '956d79aa58513881269e6f6428fcc545839bb1dfbccb1a3e5d6b66fd949ff63b', '2026-01-16 08:44:34', '2026-01-02 07:00:34', '2026-01-02 13:44:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(364, 16, '9e0e4cb893b3d2e0f45957ebda9d8e1c9020df41e8b6982fe08048f318e5c9ff', '2026-01-16 08:44:46', '2026-01-02 06:59:46', '2026-01-02 13:44:46', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'),
(365, 29, '4490f149e8022dc93d059cbe1b5aea6c7519b97c64db8923812aa0d5f0c573f8', '2026-01-16 08:51:53', '2026-01-02 07:06:53', '2026-01-02 13:51:53', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(366, 36, 'afd4a0cc59888695a2b0141fae694151bd93e91ea340bb6e66665235ef81fe53', '2026-01-16 08:57:06', '2026-01-02 07:12:06', '2026-01-02 13:57:06', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(367, 32, '983f23b4bb283762361a6f9218d65039432dc9305163a7ad87a22cd442397886', '2026-01-16 08:57:39', '2026-01-02 07:12:39', '2026-01-02 13:57:39', '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(368, 16, '9780ca47fbc4408eb61c466834aaf7a6c0bd2b158ecac54167b8db6760aa2cdd', '2026-01-16 08:59:46', '2026-01-02 07:14:46', '2026-01-02 13:59:46', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'),
(369, 28, '3ee053778e9e51fc61b2c747a519c503b2cc29914a57578e33c75bc2218db504', '2026-01-16 09:00:34', '2026-01-02 07:16:34', '2026-01-02 14:00:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(370, 29, 'fc4f452bcfc4e6f15529d9f462ff602462cc8147b1c89836b6c4398c7129dccf', '2026-01-16 09:06:53', '2026-01-02 12:56:58', '2026-01-02 14:06:53', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(371, 36, 'cadc6527f0f34d15471a5994bc51325167472df2bf9a04ba45185aca9566d66a', '2026-01-16 09:12:06', '2026-01-02 07:27:06', '2026-01-02 14:12:06', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(372, 32, '9fc778771931c47a547a69ee55725fc0d6a105e1f6521168d6db6af43ef0d513', '2026-01-16 09:12:39', '2026-01-02 07:27:58', '2026-01-02 14:12:39', '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(373, 16, '17d1216e31515973f4e7381b0f4e543c634bf85d10da8e1597c61c525d50972c', '2026-01-16 09:14:46', '2026-01-02 07:29:46', '2026-01-02 14:14:46', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'),
(374, 28, 'abc8c367c15429f73b7b301ddf7dde1786392e4ea2613a789c5511425a196b02', '2026-01-16 09:16:34', '2026-01-02 07:32:34', '2026-01-02 14:16:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(375, 36, '27eb90c2eb67df768eefd799f91db369bebd29ce795e65f2006139786de3c5dc', '2026-01-16 09:27:06', '2026-01-02 07:42:06', '2026-01-02 14:27:06', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(376, 32, 'a6ff4ce85d2c8a5b77610ecc954ca4019b3fb9b303bb53c5f5b4d46fb3c1cc48', '2026-01-16 09:27:58', '2026-01-02 07:43:20', '2026-01-02 14:27:58', '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(377, 16, '2645f667fae3c597258f2cca8d4289812b4da377c247a4199a2f4034125741b7', '2026-01-16 09:29:46', '2026-01-02 07:44:46', '2026-01-02 14:29:46', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'),
(378, 28, 'c985add00dfa9f56f3d7544d78f982351ac97b8a07809cad8b4c0dbac864c5b9', '2026-01-16 09:32:34', '2026-01-02 07:48:34', '2026-01-02 14:32:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(379, 36, '0a4d5a6543f85d9a05b797bac10792f12ae222f87e7b961c723dfec66fa5fca3', '2026-01-16 09:42:06', '2026-01-02 07:57:06', '2026-01-02 14:42:06', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(380, 32, '7fade011032809e19692d0abb7516f3ff274122ecad3ff46f30b9b53d035f3ce', '2026-01-16 09:43:20', '2026-01-02 07:58:28', '2026-01-02 14:43:20', '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(381, 16, 'bedd3001b59451512f7816c1561fe598cb029e8abc45f7ea00342c4cc4851aab', '2026-01-16 09:44:46', '2026-01-02 07:59:46', '2026-01-02 14:44:46', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'),
(382, 28, '5a1f6189b9b797e1fa31cf0f3f9820690e92e39da8811bd6a649f403e8aaa57e', '2026-01-16 09:48:34', '2026-01-02 08:04:34', '2026-01-02 14:48:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(383, 36, 'b1d6c29602f4026a803e5b227f451a35067649437a3ded6a1e97bd80cfd51359', '2026-01-16 09:57:06', '2026-01-02 08:12:06', '2026-01-02 14:57:06', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(384, 32, '723e16465b5e093f93d58fe89b294e79d0d38e8f9a1167c3f773c34d548fae47', '2026-01-16 09:58:28', '2026-01-02 08:13:30', '2026-01-02 14:58:28', '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(385, 16, '0502158fd359b90677acf8cb2331574c75d6dc3c5823e2a6c82ba21d94624553', '2026-01-16 09:59:46', '2026-01-02 09:03:45', '2026-01-02 14:59:46', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'),
(386, 28, 'fd27e2bec60664618f131245fa3b66ea5b9f1f2f63bfdd736d98f47c7730f4ca', '2026-01-16 10:04:34', '2026-01-02 08:20:34', '2026-01-02 15:04:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(387, 36, 'ec3c46d847f957beecb997c8fde1b42001fd9e960568e5fcf165739cd0af8f98', '2026-01-16 10:12:06', '2026-01-02 08:27:19', '2026-01-02 15:12:06', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(388, 32, '095303560c91f53f70f2edd38a4ee98678a56eb059122767f3c047d8eb7e7962', '2026-01-16 10:13:30', '2026-01-02 08:29:21', '2026-01-02 15:13:30', '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(389, 28, 'e8eb9be09a2ed5dced288f9fba9967edde7021259fb5d821b84ac0ab09d0b09d', '2026-01-16 10:20:34', '2026-01-02 08:36:34', '2026-01-02 15:20:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(390, 36, '3e515ab373c7ff7552ab14a40748f2f39ae0abbc084e33b3907795b25c546c54', '2026-01-16 10:27:19', '2026-01-02 08:42:20', '2026-01-02 15:27:19', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(391, 32, '9988a1d3f2d078386be6e2f1befaa107acb0ccb5a8d7472b80c94389e4a0fab7', '2026-01-16 10:29:21', '2026-01-02 08:44:36', '2026-01-02 15:29:21', '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(392, 28, '629fc6e4c44393229f0b2082c7aed86bec3c2516501e5322ff7575cb2e0135f6', '2026-01-16 10:36:34', '2026-01-02 08:52:34', '2026-01-02 15:36:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(393, 36, 'a9b6da341e7515c91e41387fb9577a848cbbe7608690e1830b5fa663814cb39d', '2026-01-16 10:42:20', '2026-01-02 14:12:56', '2026-01-02 15:42:20', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(394, 32, '951ce8777756f0cadcce87e3aed66d095e3b8edf862e0fbd0c5d373155a00fc4', '2026-01-16 10:44:36', '2026-01-02 08:59:39', '2026-01-02 15:44:36', '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(395, 28, 'ee48839337d674e085f27c71441ceb3d89dc4b0a1a1b4269169378ce582d5dbc', '2026-01-16 10:52:34', '2026-01-02 09:08:34', '2026-01-02 15:52:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(396, 32, 'e55c9c6e573ea7cb1f88b7b049222ccd4ef98cb389fd8af9ff3869e161136ec9', '2026-01-16 10:59:39', '2026-01-02 09:14:59', '2026-01-02 15:59:39', '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(397, 16, 'be87382f89e305bb8c9da6d150f7c8a8dbe9a349265248eefdc4464948f3f462', '2026-01-16 11:03:45', '2026-01-02 09:19:44', '2026-01-02 16:03:45', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'),
(398, 28, '7118dfd38b79a69d9bda048ccf52fd1ebca289c7feb79af717793a155de727da', '2026-01-16 11:08:34', '2026-01-02 09:24:34', '2026-01-02 16:08:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(399, 32, '1ceceb7d615fea15cd36fbd7364d9784d772bbb9ee99b2c58e14c583a58976e8', '2026-01-16 11:14:59', '2026-01-02 09:30:01', '2026-01-02 16:14:59', '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(400, 16, '75f1f8f1c51b798de510328ad8e515d69e9440ece4bdbf64b96d641fc7c90cdd', '2026-01-16 11:19:44', '2026-01-02 09:34:46', '2026-01-02 16:19:44', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'),
(401, 28, '821438c061270be11567af0ced0bbe2ba332a6b93d2b2268423847618bb2fb36', '2026-01-16 11:24:34', '2026-01-02 09:40:34', '2026-01-02 16:24:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(402, 32, '1bae9e2efa581da3cee4652fd782216d99b30346662cb3d40bf2b5612cf959d8', '2026-01-16 11:30:01', '2026-01-02 09:45:24', '2026-01-02 16:30:01', '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(403, 16, 'a41d7661f07029b04230e7145ca09210d7d65b93d59b3b5900694aaef54f15f2', '2026-01-16 11:34:46', '2026-01-02 09:49:46', '2026-01-02 16:34:46', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'),
(404, 28, 'bc40a2676ef02fd0175cbd04aa073a01d92930d4a05ea7cb61f6b37bca170198', '2026-01-16 11:40:34', '2026-01-02 09:56:34', '2026-01-02 16:40:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(405, 32, '17c5f56541126168f3bcc7b2b589cb51f6d605b2c8b42a6334806e49dcc96b34', '2026-01-16 11:45:24', '2026-01-02 10:00:39', '2026-01-02 16:45:24', '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(406, 16, '99c7ec9b42850a48e6e9d787723949fa2fc5d4ae6b95d924f6ca95e42e39ed1c', '2026-01-16 11:49:46', '2026-01-02 14:14:26', '2026-01-02 16:49:46', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'),
(407, 28, '43181ef5aefa04a4a105f00fbdf3948663a444f77198cc4f4365339216892b1b', '2026-01-16 11:56:34', '2026-01-02 10:11:35', '2026-01-02 16:56:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(408, 32, '7c7521d92417ac712351b3a51fda6659994acd7d1559928174e7eccb78492696', '2026-01-16 12:00:39', NULL, '2026-01-02 17:00:39', '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(409, 28, '357d37192ec9dfa7a7c82798d155ebc1e981c706424eeaf067f1538b43c5600f', '2026-01-16 12:11:35', '2026-01-02 10:26:35', '2026-01-02 17:11:35', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(410, 32, '1595486a7a23de4e593f44d55dd0b438e8d2b7a808e65d63e57305a247846c28', '2026-01-16 12:22:23', '2026-01-02 10:37:37', '2026-01-02 17:22:23', '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(411, 28, '5f3504a49d99a722f9984240752f59bca35552026ddc3402935cadf5aa5f8947', '2026-01-16 12:26:35', '2026-01-02 10:41:35', '2026-01-02 17:26:35', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(412, 32, 'b3221e4c6d6bbe195738ff2361d9205624dd5b3cff6f466ab0d1f83071c2e2c1', '2026-01-16 12:37:37', '2026-01-02 10:52:39', '2026-01-02 17:37:37', '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(413, 28, '64317179e688b93a4067c3c9d15f3c8e5a76c84a0e5e45f94b4e9a94080f0ff1', '2026-01-16 12:41:35', '2026-01-02 10:57:34', '2026-01-02 17:41:35', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(414, 32, 'e172b0fc86f87fbe1372caa3c6fe678fa6df5a1845d3f77320bff9b69736fe03', '2026-01-16 12:52:39', '2026-01-02 11:07:39', '2026-01-02 17:52:39', '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(415, 28, '694bd717742cd55736d6f2db0cafe6aeb1569eb15a00acd93efdca8eff11cdf7', '2026-01-16 12:57:34', '2026-01-02 11:12:34', '2026-01-02 17:57:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(416, 32, 'ba50ad5b164c63f430798290b620469cc4dc58827d9ab669aed2d5e661c6a05e', '2026-01-16 13:07:39', '2026-01-02 11:22:39', '2026-01-02 18:07:39', '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(417, 28, '5cdfc518df615eb16013563556dbf4c6869abfff8d08b121a332e07df69c224f', '2026-01-16 13:12:34', '2026-01-02 11:27:34', '2026-01-02 18:12:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(418, 32, '547f9073dcdb07f011f3a6b76ea868fd6239f53fef9feb15ed7392aa2c55bda0', '2026-01-16 13:22:39', '2026-01-02 11:37:39', '2026-01-02 18:22:39', '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(419, 28, '8b05f1211dcf57e52d5c63e87ffd6c0fd7a535f2cab496f3bb75661dbc3ed1d3', '2026-01-16 13:27:34', '2026-01-02 11:42:34', '2026-01-02 18:27:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(420, 32, 'b104d478a412360a1167a50972dad3d3abf1bd50d53097863f45bbe182863256', '2026-01-16 13:37:39', '2026-01-02 11:53:07', '2026-01-02 18:37:39', '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(421, 28, 'e6ae0b8ba2beb1e2387f4e71e5bdc5da92130f3c7ed547b781be405e2fced4d5', '2026-01-16 13:42:34', '2026-01-02 11:57:34', '2026-01-02 18:42:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(422, 32, 'b49bbf4181e2b0e6f6d1d5aa56d1ba81c4e5e0db9c7bdd13b314212807d34abd', '2026-01-16 13:53:07', '2026-01-02 12:08:10', '2026-01-02 18:53:07', '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(423, 28, '61e73b55a2551de2ec0bbed9a483a67b4a70a6328ee46fed5a0a6ba2202b6d28', '2026-01-16 13:57:34', '2026-01-02 12:12:34', '2026-01-02 18:57:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(424, 32, 'c345929c6152682a5d6b600cf1cb25161764232806b24e8bc5b9dbb05af1a4be', '2026-01-16 14:08:10', '2026-01-02 12:23:24', '2026-01-02 19:08:10', '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(425, 28, '2f6c8b1d100b5cdd9c689c6947b5126b438f5e93ceb3d346f453983fb35afb02', '2026-01-16 14:12:34', '2026-01-02 12:27:34', '2026-01-02 19:12:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(426, 32, '87a9dcc41f9dc7b624ec02ec2154163d9627f57e8dce1825440d2f06e7f296df', '2026-01-16 14:23:24', '2026-01-02 12:38:39', '2026-01-02 19:23:24', '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(427, 28, 'd541f1041d302cc3ab1caa01add4e3c8712c26c08bfa7ec25ac6f585f6123a32', '2026-01-16 14:27:34', '2026-01-02 12:42:34', '2026-01-02 19:27:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(428, 32, '9362e7002723c6cbd426dd2dae55bb46d2ffe88984a432edb669c59d8fd9c33b', '2026-01-16 14:38:39', NULL, '2026-01-02 19:38:39', '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(429, 3, 'cc9f13f3a2ef3912204029fc89a4548f285ae39432e9e8c85149d31c946aa2a4', '2026-01-16 14:41:26', '2026-01-02 12:56:32', '2026-01-02 19:41:26', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(430, 20, '91a2cb71ca0a68a4a8ddd3f5f545d6f4178b7b85dc7541d8d2037f6902f42d2a', '2026-01-16 14:41:34', '2026-01-02 12:57:24', '2026-01-02 19:41:34', '152.201.118.162', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(431, 11, '7c5c11b777f7e9fea8ced913ba8d2f75ed0c661f469638882b9f1ed174364efd', '2026-01-16 14:41:34', '2026-01-02 12:56:37', '2026-01-02 19:41:34', '191.97.9.169', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(432, 8, 'fda5d77d2312b20460b3caed7c11619b62beeaaccfdc57d082b3fde3b7e043f2', '2026-01-16 14:41:49', '2026-01-02 12:57:03', '2026-01-02 19:41:49', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(433, 27, '48b871e89e9a6d9f5f3eade364efc81645806177405899784559c75483f35de7', '2026-01-16 14:42:03', '2026-01-02 12:57:09', '2026-01-02 19:42:03', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(434, 32, '9fc1abc7bf43efb425d9427e07a4d9158f4b87d5bc2dc1c11201505287be003f', '2026-01-16 14:42:31', '2026-01-02 12:58:25', '2026-01-02 19:42:31', '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(435, 28, 'bacb22d9e94deb2468fa8232e204d98313edd708f2a49cbf9c44f53bee33f1b0', '2026-01-16 14:42:34', '2026-01-02 12:57:34', '2026-01-02 19:42:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(436, 3, '513d454b26339812af69c661c3753ce9522a43424aa2e9e78a552c68ab9e7c7a', '2026-01-16 14:56:32', '2026-01-02 13:11:32', '2026-01-02 19:56:32', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(437, 11, '97d911665f1cc2539441000c5aac6d08a282c982d7bdc8ee478d8e0a858fe41d', '2026-01-16 14:56:37', '2026-01-02 13:12:06', '2026-01-02 19:56:37', '191.97.9.169', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(438, 29, '00f53a389013ea4cde96a7f6960f9b7d8e64602fcb2d550a568bec087eb4eb1e', '2026-01-16 14:56:58', '2026-01-02 13:12:55', '2026-01-02 19:56:58', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(439, 8, '1e673330028e9108beb384cee6a295aff4ac6ac0ab60334ce4ab2db4db72b9ee', '2026-01-16 14:57:03', '2026-01-02 13:12:04', '2026-01-02 19:57:03', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(440, 27, 'd3ef818460200db254aa496c5e66b90a1f8bbbe5f71c1620a2299494369192ba', '2026-01-16 14:57:09', '2026-01-02 13:35:09', '2026-01-02 19:57:09', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(441, 20, '965fae4a403df26c9240cf7f831a1930814324babab77b85070cb9c8ef93af49', '2026-01-16 14:57:24', '2026-01-02 13:13:12', '2026-01-02 19:57:24', '152.201.118.162', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(442, 28, '0c7a491d6ca849ea6467138ed04ef93f4e993acd0cb179c5b352e8128de23769', '2026-01-16 14:57:34', '2026-01-02 13:12:37', '2026-01-02 19:57:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(443, 32, '6401dbf3464f74eaf0af2b55d1ea45fb885c328a59309ec29087bce6b865a07d', '2026-01-16 14:58:25', '2026-01-02 13:59:31', '2026-01-02 19:58:25', '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(444, 3, 'b944d21738051e0e839fd05408ee4991def5ef18a8e2605ee1c8ddfbc1b0d873', '2026-01-16 15:11:32', '2026-01-02 13:26:32', '2026-01-02 20:11:32', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(445, 8, 'bd034499833bc8436cb7d1ed0512d832ff5cb11731ad03143fded5226d6a1c9d', '2026-01-16 15:12:04', '2026-01-02 13:27:04', '2026-01-02 20:12:04', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(446, 11, 'db36ec9a9adcf24e5b69dfea23723229d5e3ab7d1a2edebd6285cbcab7429f5d', '2026-01-16 15:12:06', '2026-01-02 13:27:43', '2026-01-02 20:12:06', '191.97.9.169', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(447, 28, 'c252f3565d09cbf512297ac313af7fab30308a7d88e860a0ca46a000609554cb', '2026-01-16 15:12:37', '2026-01-02 13:28:34', '2026-01-02 20:12:37', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(448, 29, 'd1b2bb54b0c6d9cdb17c6b729d0538b875fe781744eb3d3ae8675ed6c5c7d006', '2026-01-16 15:12:55', '2026-01-02 13:28:54', '2026-01-02 20:12:55', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(449, 20, '90d210285d75f23ec65901a7dbb0a7e9fe8003aee2538c4ae19354367ff8ecde', '2026-01-16 15:13:12', '2026-01-02 13:29:06', '2026-01-02 20:13:12', '152.201.118.162', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(450, 3, '37d18fa8e36ae042b879588f788dde8d4ecadf0cc0856e72680b302587d6711f', '2026-01-16 15:26:32', '2026-01-02 13:41:32', '2026-01-02 20:26:32', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(451, 8, '40d318e280971f174211a57882f6bcdc0b0cee0124f7c423e5b7273d3cc9ad09', '2026-01-16 15:27:04', '2026-01-02 13:42:04', '2026-01-02 20:27:04', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(452, 11, '6db806980a94425cb0d7423d25ff6de6e24e8f24e5f925e82111926f7ebdba1d', '2026-01-16 15:27:43', '2026-01-02 14:12:04', '2026-01-02 20:27:43', '191.97.9.169', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(453, 28, 'a02589d12eb30160675d5a98176a7fa369fa9be6d379ca44ed230913f40919f6', '2026-01-16 15:28:34', '2026-01-02 13:43:34', '2026-01-02 20:28:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(454, 29, '7c312c020015c86dc0ad54809c90f7744729e4666dac03c9adac03b682818160', '2026-01-16 15:28:54', '2026-01-02 13:43:54', '2026-01-02 20:28:54', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(455, 20, '38e78d74505fe5c7675e9578e93c7a662fbbae30b7d4f19805161d6b1730a710', '2026-01-16 15:29:06', '2026-01-02 13:45:00', '2026-01-02 20:29:06', '152.201.118.162', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(456, 27, 'de7ce429e8b4fce01ef2e6e22297aeca8b127a3cd204aab253ff6577eeb784cb', '2026-01-16 15:35:09', '2026-01-02 13:50:09', '2026-01-02 20:35:09', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(457, 3, '3c89ccf6dce07f4dbaeb4b595bbfbe2144d211559a5f79fcdb619473dd316e7a', '2026-01-16 15:41:32', '2026-01-02 13:56:32', '2026-01-02 20:41:32', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(458, 8, '3bf6a17a9241e8b2851ee759a9c86b58d26a64662661556eb93711d10acfbd32', '2026-01-16 15:42:04', '2026-01-02 13:57:04', '2026-01-02 20:42:04', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(459, 28, '40eeff74acd0498669e57784077842e200f5b3a2f7851e37875e9e7c8f8df53e', '2026-01-16 15:43:34', '2026-01-02 13:58:34', '2026-01-02 20:43:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(460, 29, '3c26390d061abc4753e4f5ff9ba4020deef54504babc0296c77225254905ecf1', '2026-01-16 15:43:54', '2026-01-02 13:58:54', '2026-01-02 20:43:54', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(461, 20, 'e5677da238c690b92058d7c5a3b69347c488bf66a9e80cdb002a45f2e58d48ba', '2026-01-16 15:45:00', '2026-01-02 14:00:24', '2026-01-02 20:45:00', '152.201.118.162', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(462, 27, '0c5112cccbe4ba058e22ac54b9f6114f5b67df190b8c82792d7352f7cb1b41bc', '2026-01-16 15:50:09', '2026-01-02 14:05:09', '2026-01-02 20:50:09', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(463, 3, '5c71adc66917f6ad0c10230faa0e813722322a07a7dbc6a800f4335193ddab8a', '2026-01-16 15:56:32', '2026-01-02 14:11:32', '2026-01-02 20:56:32', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(464, 8, '497b9d41b99b46551aa233a905909ddad98c36bd83e7315a1e7f23f350154839', '2026-01-16 15:57:04', '2026-01-02 14:12:04', '2026-01-02 20:57:04', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(465, 28, 'c2fdff79cc35d285876cd947bb2515fefbc484b1ae14613e11fdd897c40c9dd9', '2026-01-16 15:58:34', '2026-01-02 14:13:34', '2026-01-02 20:58:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(466, 29, '7f2241bcecbf24e0c1011b267212b93982a27f0c80e52133089904630624d7d4', '2026-01-16 15:58:54', '2026-01-02 14:14:23', '2026-01-02 20:58:54', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(467, 32, '5dd66126eb6c2fc6082b844f6238ccf59258cfab777508444a7cf1d1c0b6e2c7', '2026-01-16 15:59:31', '2026-01-02 14:15:24', '2026-01-02 20:59:31', '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(468, 20, '13fe754e85787c24ec4d9e6ce2008335b430dc9775b905569efadc1a564293e7', '2026-01-16 16:00:24', '2026-01-02 14:16:24', '2026-01-02 21:00:24', '152.201.118.162', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(469, 27, 'b764de0d2a36977a6a4cbe337e7bd403375e7a64e449112605ebcce1167b5f17', '2026-01-16 16:05:09', '2026-01-02 14:20:09', '2026-01-02 21:05:09', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(470, 3, 'bbe10e5704f5be9e6ba458aac4d9b8f99f7b9260701d0649cc0820de1de41197', '2026-01-16 16:11:32', NULL, '2026-01-02 21:11:32', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(471, 11, '9b9bd64db7e1ba8cb50e650a33992db57b08b8db22cd8740413b74fc18867a64', '2026-01-16 16:12:04', '2026-01-05 05:32:09', '2026-01-02 21:12:04', '191.97.9.169', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(472, 8, '20e6d5fa31b5175708c4d412fe07a553a56cb3728a94705181a537fa92929549', '2026-01-16 16:12:04', NULL, '2026-01-02 21:12:04', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(473, 36, 'c83f8400dc86d7a78af61d2a00242dced8226b8192a916847a4ac85c037cd4ca', '2026-01-16 16:12:56', '2026-01-02 14:12:56', '2026-01-02 21:12:56', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(474, 36, 'c83f8400dc86d7a78af61d2a00242dced8226b8192a916847a4ac85c037cd4ca', '2026-01-16 16:12:56', NULL, '2026-01-02 21:12:56', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(475, 28, 'dc457c07c99c1b6c0a7c2756844e34ce04fffcc146cc4831234c514c94314d13', '2026-01-16 16:13:34', NULL, '2026-01-02 21:13:34', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(476, 29, '8ca87902b271c74d7f1e930d48736f868eb0563ee10273dcacd2bef53aaad5ab', '2026-01-16 16:14:23', '2026-01-02 14:29:54', '2026-01-02 21:14:23', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(477, 16, '494275be4535e2256bf628109a1598754ffb54e19d2e045401df22e80404be49', '2026-01-16 16:14:26', NULL, '2026-01-02 21:14:26', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'),
(478, 32, 'd35320d48d72fa474a3769c62cb921c4d911ea4d14067cf435fd07d35e08425f', '2026-01-16 16:15:24', '2026-01-02 14:31:24', '2026-01-02 21:15:24', '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(479, 20, '8be322366ccacddb2b298623df15d2f95a5a62460d8c7ec3058031c4b02b1ffd', '2026-01-16 16:16:24', '2026-01-02 14:32:23', '2026-01-02 21:16:24', '152.201.118.162', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(480, 27, 'ebcf9c4a5f9c11f2f915021736b25e37c0e30262a652d376c401fffee52eb0e8', '2026-01-16 16:20:09', '2026-01-02 14:35:09', '2026-01-02 21:20:09', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(481, 28, '38294d931e7de954e8650d24a474f4465f3623362a7154455131bc3235f72247', '2026-01-16 16:25:18', NULL, '2026-01-02 21:25:18', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0'),
(482, 29, '96e29879309a9d2c96c3ad39ec72ecfd9b1743eadff0965faf9b673150a16b17', '2026-01-16 16:29:54', '2026-01-05 05:21:06', '2026-01-02 21:29:54', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(483, 32, 'd2064b3d021cf05c049bc1a7d6a0e5dd182d5df2b5fa34cc4dd0bfca9ff61447', '2026-01-16 16:31:24', NULL, '2026-01-02 21:31:24', '186.85.240.133', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(484, 20, '356c3ac8439f72ce2137d5b8d4440d821da09da73f6c5da2ebd41a119a91e756', '2026-01-16 16:32:23', '2026-01-02 14:47:23', '2026-01-02 21:32:23', '152.201.118.162', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(485, 27, '229f640963ce1e304b6de0c1d6bc9b779a896cbcb69db44ec77066d80802bf10', '2026-01-16 16:35:09', '2026-01-14 12:31:08', '2026-01-02 21:35:09', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(486, 20, 'bf6cfb6d44154af21b9e3262b90a2e28a4b7a6751974c0a8773c41931669fc86', '2026-01-16 16:47:23', '2026-01-02 15:02:23', '2026-01-02 21:47:23', '152.201.118.162', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(487, 20, 'a0e2511bb5286731a70fcc539e41ebdeb5156f8ee4e4a07e04eacee709902300', '2026-01-16 17:02:23', '2026-01-02 15:17:23', '2026-01-02 22:02:23', '152.201.118.162', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(488, 20, 'ddf38a66c69802d9a9f1d360be7a2070bd482e3e5cdf7820afddb0c99fc6dcd3', '2026-01-16 17:17:23', '2026-01-02 15:32:23', '2026-01-02 22:17:23', '152.201.118.162', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(489, 20, '53c6554c20f9df63dc6cb1571ce59bb13e0992f967704e732ca970fad93e3200', '2026-01-16 17:32:23', '2026-01-02 15:47:23', '2026-01-02 22:32:23', '152.201.118.162', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(490, 20, '2b9acb20050db2d9634bd2b608da0c0379e0675508f5cdd968fd66647cdcc6b0', '2026-01-16 17:47:23', '2026-01-02 16:02:23', '2026-01-02 22:47:23', '152.201.118.162', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(491, 20, '3780d2dce773ce5bcc89920766de26aa6c69bad73a309e061194d13c09909d2e', '2026-01-16 18:02:23', '2026-01-02 16:17:23', '2026-01-02 23:02:23', '152.201.118.162', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(492, 20, '880964485ec70e70886250747c96e8d38f8eb9ac9dddbf4f754874e947d314ba', '2026-01-16 18:17:23', '2026-01-02 16:32:23', '2026-01-02 23:17:23', '152.201.118.162', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(493, 20, '6d148dc3e8945358bae37f387c00d1f69fd8a2b9f32a2bcd3d16f9afb6448b92', '2026-01-16 18:32:23', '2026-01-02 16:47:23', '2026-01-02 23:32:23', '152.201.118.162', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(494, 20, 'cd08da47f9c75c69307fa7499edadcb016b536b95f4e7b8864146e4f86a4b98b', '2026-01-16 18:47:23', '2026-01-02 17:02:23', '2026-01-02 23:47:23', '152.201.118.162', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(495, 20, '22c736590c76e8bf9aa80a7f74f649c836c645250590d87b925dc6e9cc3e69ee', '2026-01-16 19:02:23', '2026-01-02 17:17:23', '2026-01-03 00:02:23', '152.201.118.162', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(496, 20, '613025b43be8a3266529760011fc4b06d98a8a8b2ba0adcce6c7ed00936b01cb', '2026-01-16 19:17:23', '2026-01-02 17:32:23', '2026-01-03 00:17:23', '152.201.118.162', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(497, 20, '3da656d85d38a50321c2fd01448355a19fa01cda17b9bc6d44c924e115bbe91a', '2026-01-16 19:32:23', '2026-01-02 17:47:23', '2026-01-03 00:32:23', '152.201.118.162', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(498, 20, '45ae8f6905a93ac6848d7aa089dc2f29369203d541bc101a3414f2a956567922', '2026-01-16 19:47:23', '2026-01-02 18:03:46', '2026-01-03 00:47:23', '152.201.118.162', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(499, 20, '3930e191cab0e06fbde0624cac6ab5ea46522aa0774e5425cd5bbc8d35b5fc74', '2026-01-16 20:03:46', '2026-01-02 18:19:23', '2026-01-03 01:03:46', '152.201.118.162', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(500, 20, 'afbe35c9dec968f8ca11135265a15b0fdf0918d61284ebce7a273c32555f4155', '2026-01-16 20:19:23', NULL, '2026-01-03 01:19:23', '152.201.118.162', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(501, 29, '8379064f86b7b3b125670694d88ff131f2fcea843c56ebe8b573c413c4e7c3cc', '2026-01-19 07:21:06', NULL, '2026-01-05 12:21:06', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(502, 11, '73c098c070e20970ea06bdbb74f3b9f90284f3f08a40086c3d054e5c7b4a9131', '2026-01-19 07:32:09', NULL, '2026-01-05 12:32:09', '181.51.34.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(503, 12, '835651d64eded7b0f165142542b0d7a41512ac4f0aa5db771fbcf936f9d1ebc8', '2026-01-19 07:35:50', '2026-01-05 05:51:08', '2026-01-05 12:35:50', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(504, 12, '835651d64eded7b0f165142542b0d7a41512ac4f0aa5db771fbcf936f9d1ebc8', '2026-01-19 07:35:50', '2026-01-05 05:51:08', '2026-01-05 12:35:50', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(505, 8, '67124c099a98bb022b3ec63e22f1ba585cfe8697e8612aba2b5b17d1758dfced', '2026-01-19 07:48:40', '2026-01-05 06:03:52', '2026-01-05 12:48:40', '152.203.161.205', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(506, 12, '8983516c085cd595d3792091727dd6d4c1fc17d3c07ae85bd26a78fdb28ef13a', '2026-01-19 07:51:08', '2026-01-05 06:06:08', '2026-01-05 12:51:08', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(507, 8, '7dbc0068363dec967c47865b895858afadd4859d24efcf99c4294f24763635a3', '2026-01-19 08:03:52', NULL, '2026-01-05 13:03:52', '152.203.161.205', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(508, 12, '2f118a0b4ac8cd0e410c8c70a1b0b2fba12b39de14b3627ef55473dd16e86cb7', '2026-01-19 08:06:08', '2026-01-05 06:21:20', '2026-01-05 13:06:08', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(509, 12, 'e027c2cb6d14e865bf8f51e6f6f97991bbddd1208ab82ff907e6d3beb02af602', '2026-01-19 08:21:20', '2026-01-05 06:36:25', '2026-01-05 13:21:20', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(510, 12, '2f7abf56e1990229d162dd7eb07b8ef19f1b8dde1dafea2258acd3ab2fc13d16', '2026-01-19 08:36:25', '2026-01-05 06:52:08', '2026-01-05 13:36:25', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(511, 12, '70a20ef4c85f6a838762aab879b099b508a35f37a5ff908f55467ce2973e828d', '2026-01-19 08:52:08', '2026-01-05 07:07:58', '2026-01-05 13:52:08', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(512, 12, '36d92b7ee11a51dd6dcb8da429cb54e5573398856caf905acfec049bd8c7d1c1', '2026-01-19 09:07:58', '2026-01-05 07:23:08', '2026-01-05 14:07:58', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(513, 12, 'a1842846b363834e4ada8eb1878c5f2840f8ca5ec6de8a24af7b7f5e535f2488', '2026-01-19 09:23:08', '2026-01-05 07:38:52', '2026-01-05 14:23:08', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(514, 12, '3b61d5c937bd5221f74d26132b95b68d30656029628e3e3bb08fc78c8fe4cc71', '2026-01-19 09:38:52', '2026-01-05 07:53:55', '2026-01-05 14:38:52', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(515, 12, '7a52e9b72e46dc8723e72d4dcc84ff05d7fd7af5f2d7112a0e25f85272b4b9e9', '2026-01-19 09:53:55', '2026-01-05 08:09:08', '2026-01-05 14:53:55', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(516, 12, 'fc28a6efbd100c2188df5db39a0eb9acd07b459bdec2653cfe9178fda9529a4e', '2026-01-19 10:09:08', '2026-01-05 08:24:08', '2026-01-05 15:09:08', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(517, 12, 'b0452c327ae8c4be0ca3be39925bdf0a1c6b0c3aa55f56afbf226f3e8e3f3c47', '2026-01-19 10:24:08', '2026-01-05 08:39:08', '2026-01-05 15:24:08', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(518, 12, 'af92348e14ec2cb786c1f0522d83e0999d9445d782dc4e5150be81c0a329d6b6', '2026-01-19 10:39:08', '2026-01-05 08:54:08', '2026-01-05 15:39:08', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(519, 12, '38bfef4e675a4cdb0c7832736a6ef34a82d09c3139cccf43a42ce15cd2364f72', '2026-01-19 10:54:08', '2026-01-05 09:09:08', '2026-01-05 15:54:08', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(520, 12, '5e5ce64c88499e6145eb12558cce1d1a2dbd1e51e292e23f604cce4668156bf4', '2026-01-19 11:09:08', '2026-01-05 09:24:08', '2026-01-05 16:09:08', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(521, 12, '8547d26269837e0a50acedb4abb73615d7742784a0d13efd77570026feb8334f', '2026-01-19 11:24:08', '2026-01-05 09:39:08', '2026-01-05 16:24:08', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(522, 12, 'b3674c4d7a49556fbdd0ecb76bfa00a62d0e10628840213aab26f8dcc61635c6', '2026-01-19 11:39:08', '2026-01-05 09:54:08', '2026-01-05 16:39:08', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(523, 12, '3eab85bb6affe30e6bda504143066da4374ed00d581a17d58f2ff7bed24800b2', '2026-01-19 11:54:08', '2026-01-05 10:09:08', '2026-01-05 16:54:08', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(524, 12, '35aabba5994af958fe33f4bff5cbed36cae87d48726674dc3d127bd0e96929d0', '2026-01-19 12:09:08', '2026-01-05 10:24:13', '2026-01-05 17:09:08', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(525, 12, '29b8462d1a2faf2aef0cda76d183b81e7bbb76c0ca9948cd4087de2e997ebdbd', '2026-01-19 12:24:13', '2026-01-05 10:40:08', '2026-01-05 17:24:13', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(526, 12, 'fd6c5f56342be63247e99da811dc1d98c9f061c152a67bc1c6c282c15c8be20e', '2026-01-19 12:40:08', '2026-01-05 10:55:08', '2026-01-05 17:40:08', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(527, 12, '0b38d6891ab50b74c38fb5e6b1c5c364d96790b02ffe29365b2eaa354831b96b', '2026-01-19 12:55:08', '2026-01-05 11:10:08', '2026-01-05 17:55:08', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(528, 12, 'ec308d2542f059faac470f3b2cdd24ee9e95a5269a7501f348fb62d36147ffd1', '2026-01-19 13:10:08', '2026-01-05 11:25:08', '2026-01-05 18:10:08', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(529, 12, '650c59b5ff88bfa6885378fa374dd7975deb141c87044f2158f25c25c2f9845e', '2026-01-19 13:25:08', '2026-01-05 11:40:08', '2026-01-05 18:25:08', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36');
INSERT INTO `refresh_tokens` (`id`, `user_id`, `token_hash`, `expires_at`, `revoked_at`, `created_at`, `ip`, `user_agent`) VALUES
(530, 12, '4d2bf4a5e46db10c8a03eb5f8b90c2a1ee4a27d31c21e69d3892e3afffd5a054', '2026-01-19 13:40:08', '2026-01-05 12:22:45', '2026-01-05 18:40:08', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(531, 12, '0e9e91a52b4c6674abb0420fa7e23f0b03c04750502777e3d526f8ff8d381adc', '2026-01-19 14:22:45', '2026-01-05 12:38:07', '2026-01-05 19:22:45', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(532, 12, '893341b01ca8f15bbd9702f35033a09902050a437b97689c0bfe047fa2af1cbf', '2026-01-19 14:38:07', '2026-01-05 12:53:07', '2026-01-05 19:38:07', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(533, 12, 'f4b802ea1538666fe2950ef3faac9c4efd35cda0817b1a7e4c440a6abb29bc62', '2026-01-19 14:53:07', '2026-01-05 13:08:07', '2026-01-05 19:53:07', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(534, 12, 'f0906e4e223092fac5c244ce112882a1b5de7a74b333fae403a61b06fac62922', '2026-01-19 15:08:07', '2026-01-05 13:23:07', '2026-01-05 20:08:07', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(535, 12, 'd6f3c29d0399f9e5a3822ac722e7079f5f164f7a78615d43367a6f2b9ed8e93c', '2026-01-19 15:23:07', '2026-01-05 13:38:07', '2026-01-05 20:23:07', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(536, 12, '6c6729a2555b0ac92a38cbd3f4430a79c55ce20145d67faaa6a39e830606ad3b', '2026-01-19 15:38:07', '2026-01-05 13:53:07', '2026-01-05 20:38:07', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(537, 12, 'f414ef22f1730cc9ae47431ac00f620ea2e56ecf71bc7d666235334eaed7e7ef', '2026-01-19 15:53:07', '2026-01-05 14:08:07', '2026-01-05 20:53:07', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(538, 12, '974fbc7019578c8d99cfe45303e04a92013e5cb2ca6f68bfee96cb8247336255', '2026-01-19 16:08:07', '2026-01-06 08:59:16', '2026-01-05 21:08:07', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(539, 12, '134b88f4dc7092993783f66080207852dd54ee256c1056ebe745660e5fd1f40b', '2026-01-20 10:59:16', '2026-01-06 09:14:44', '2026-01-06 15:59:16', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(540, 12, 'd315709d0b0aa41ac619b0af8d64a137d3c3eb08b47a823600d98ca36373a936', '2026-01-20 11:14:44', '2026-01-07 05:49:55', '2026-01-06 16:14:44', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(541, 32, 'f9f578db94f11d37f0aa6d3cd4e8d3cdcbe2a302a2eacea98028078ecdd7f2c6', '2026-01-20 14:21:16', '2026-01-06 12:36:39', '2026-01-06 19:21:16', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(542, 32, 'e4c3c34d7e8a1c0cbd15a5cde6d0bbc00c24d238b46614990c0b301d4c52dd26', '2026-01-20 14:36:39', '2026-01-13 12:08:38', '2026-01-06 19:36:39', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(543, 12, '2b17ca467ce5b2a4ead718875a665653efb14c19fdb6e46a058f941238ac1ae9', '2026-01-21 07:49:55', '2026-01-07 06:05:04', '2026-01-07 12:49:55', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(544, 12, 'e422dcd659f839b4f3dbe4d005ecfa98fc9cb7d7ba7d7d10cdec07b489d356ac', '2026-01-21 08:05:04', '2026-01-07 06:20:04', '2026-01-07 13:05:04', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(545, 12, 'e89f95f9411f60254546a78e5d785b1bcbe8a0e438eff483bfd7d36c71edc6a3', '2026-01-21 08:20:04', '2026-01-07 06:35:04', '2026-01-07 13:20:04', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(546, 12, 'd704311d044c5bfdccf88657d05ea513caa3167bce6468c7766d1bfd22cd02ca', '2026-01-21 08:35:04', NULL, '2026-01-07 13:35:04', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(547, 32, '79a2ce2be95f4e658e6786c05c82775ab22909e02f3e52362eede5503a719759', '2026-01-27 14:08:38', NULL, '2026-01-13 19:08:38', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(548, 32, '78acb4c8ab755bda545e936eb34d457885dc1fc920c21c2dc27a7a54885f82be', '2026-01-27 14:09:09', '2026-01-13 12:24:52', '2026-01-13 19:09:09', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(549, 32, '2ae9f7f549177d86ea35fcf038a260050bd1bfb09a0c1fdd9fd8264ee19904cf', '2026-01-27 14:24:52', '2026-01-13 12:40:51', '2026-01-13 19:24:52', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(550, 32, '3658b3e80c3b1378bb10e58d76ca69f2ef8733b3529e31977a61bee4b18f9edb', '2026-01-27 14:40:51', '2026-01-13 12:55:52', '2026-01-13 19:40:51', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(551, 32, '2e1ba0ed89a579b34606bceb6bbe2b07fad051faeebb0f22cc7cd6d84e13dcca', '2026-01-27 14:55:52', '2026-01-13 13:11:52', '2026-01-13 19:55:52', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(552, 32, 'e8010dcca0e08c64c24751dbd595359f363bdce06b447c532b67b947b3f6f1d0', '2026-01-27 15:11:52', '2026-01-13 13:27:52', '2026-01-13 20:11:52', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(553, 32, '37b47fff866190247461f414ac302f0d67c358011c35661eab9ddf0e59631503', '2026-01-27 15:27:52', NULL, '2026-01-13 20:27:52', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(554, 27, '6fdae5b5ffa65f5b5253740acbb2f314dff9ad21603f5774046a19a7ce3600d4', '2026-01-28 14:31:08', '2026-01-14 12:46:27', '2026-01-14 19:31:08', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(555, 27, '76bf793b76c943a9b4b5fa7ab5c5f8885014c1bf9d403a33f95bb2ce6daa03da', '2026-01-28 14:46:27', NULL, '2026-01-14 19:46:27', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(556, 32, 'f5a47d93e6efcad2ae3b48d8db3a84352d49b749fc1c1454fb03ef42b5c9221c', '2026-02-02 09:34:41', NULL, '2026-01-19 14:34:41', '186.80.229.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id`, `name`, `description`) VALUES
(1, 'admin', 'Administrador del sistema'),
(2, 'lider_area', 'Líder de área'),
(3, 'colaborador', 'Colaborador');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tasks`
--

CREATE TABLE `tasks` (
  `id` int(11) NOT NULL,
  `area_id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `type` enum('Clave','Operativa','Mejora','Obligatoria') NOT NULL DEFAULT 'Operativa',
  `priority` enum('Alta','Media','Baja') NOT NULL DEFAULT 'Media',
  `status` enum('No iniciada','En progreso','En revisión','Completada','En riesgo') NOT NULL DEFAULT 'No iniciada',
  `progress_percent` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `responsible_id` int(11) NOT NULL,
  `created_by` int(11) NOT NULL,
  `start_date` date DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `closed_date` date DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tasks`
--

INSERT INTO `tasks` (`id`, `area_id`, `title`, `description`, `type`, `priority`, `status`, `progress_percent`, `responsible_id`, `created_by`, `start_date`, `due_date`, `closed_date`, `deleted_at`, `created_at`, `updated_at`) VALUES
(23, 8, 'SEGURIDIDAD SOCIAL PRIMERA VERSION', 'SEGURIDIDAD SOCIAL PRIMERA VERSION', 'Operativa', 'Media', 'No iniciada', 0, 24, 27, '2025-12-26', '0000-00-00', NULL, NULL, '2025-12-26 17:18:40', '2025-12-26 17:18:40'),
(24, 8, 'REALIZAR INTEGRALMENTE LA AUDITORIA DOCUMENTAL DE TODAS LAS HISTORIAS LABORALES 2026', '', 'Operativa', 'Media', 'No iniciada', 0, 27, 27, '2025-12-26', '0000-00-00', NULL, NULL, '2025-12-26 20:53:06', '2025-12-26 20:53:06'),
(25, 8, 'SOLICITAR AUDITORIA PARA SENA', '', 'Operativa', 'Media', 'No iniciada', 0, 27, 27, '2025-12-26', '0000-00-00', NULL, NULL, '2025-12-26 20:53:06', '2025-12-26 20:53:06'),
(26, 8, 'Revision de preliminar de bonos sodexos', '', 'Operativa', 'Media', 'No iniciada', 0, 27, 27, '2025-12-26', '0000-00-00', NULL, NULL, '2025-12-26 20:53:06', '2025-12-26 20:53:06'),
(27, 8, 'CERRAR NOMINA DICIEMBRE MERIDIAN', '', 'Operativa', 'Media', 'No iniciada', 0, 27, 27, '2025-12-26', '0000-00-00', NULL, NULL, '2025-12-26 20:53:06', '2025-12-26 20:53:06'),
(28, 8, 'CERRAR NOMINA DICIEMBRE ZIRCON', '', 'Operativa', 'Media', 'No iniciada', 0, 27, 27, '2025-12-26', '0000-00-00', NULL, NULL, '2025-12-26 20:53:06', '2025-12-26 20:53:06'),
(29, 8, 'Reunion Aclaratoria con Gabriel Eduardo Velez Barrera  REVISAR LA NOMINA Y PROGRAMAR REUNION', '', 'Operativa', 'Media', 'No iniciada', 0, 27, 27, '2025-12-26', '0000-00-00', NULL, NULL, '2025-12-26 20:53:06', '2025-12-26 20:53:06'),
(30, 8, 'REUNION ALCARATORIA JESUS COQUECO', '', 'Operativa', 'Media', 'No iniciada', 0, 27, 27, '2025-12-26', '0000-00-00', NULL, NULL, '2025-12-26 20:53:06', '2025-12-26 20:53:06'),
(31, 8, 'REVISION DE LIQUIDACIONES DE PETROSERVICIOS Y DEJARLAS CERRADAS', '', 'Operativa', 'Media', 'No iniciada', 0, 27, 27, '2025-12-26', '0000-00-00', NULL, NULL, '2025-12-26 20:53:06', '2025-12-26 20:53:06'),
(32, 8, 'SABANA DE VACACIONES', '', 'Operativa', 'Media', 'No iniciada', 0, 27, 27, '2025-12-26', '0000-00-00', NULL, NULL, '2025-12-26 20:53:06', '2025-12-26 20:53:06'),
(33, 8, 'atender la solicitud del Profesional Mario Augusto Moreno Castellanos REVISAR LA NOMINA Y PROGRAMAR REUNION', '', 'Operativa', 'Media', 'No iniciada', 0, 27, 27, '2025-12-26', '0000-00-00', NULL, NULL, '2025-12-26 20:53:06', '2025-12-26 20:53:06'),
(34, 8, 'REUNION JULIO ROMERO ACLARATORIA LEY 50', '', 'Operativa', 'Media', 'No iniciada', 0, 27, 27, '2025-12-26', '0000-00-00', NULL, NULL, '2025-12-26 20:53:06', '2025-12-26 20:53:06'),
(35, 8, 'Cotizacion de Colmedica', '', 'Operativa', 'Media', 'No iniciada', 0, 27, 27, '2025-12-26', '0000-00-00', NULL, NULL, '2025-12-26 20:53:06', '2025-12-26 20:53:06'),
(36, 8, 'PROYECTO: GREAT PLACE TO WORK', '', 'Operativa', 'Media', 'No iniciada', 0, 27, 27, '2025-12-26', '0000-00-00', NULL, NULL, '2025-12-26 20:53:06', '2025-12-26 20:53:06'),
(37, 8, 'VALIDAR Y ORGANIZAR NORMOGRAMA / MATRIZ LEGAL', '', 'Operativa', 'Media', 'No iniciada', 0, 27, 27, '2025-12-26', '0000-00-00', NULL, NULL, '2025-12-26 20:53:06', '2025-12-26 20:53:06'),
(38, 8, 'CITACION PROCESOS DISCIPLIRACION FABRYSIO', '', 'Operativa', 'Media', 'No iniciada', 0, 27, 27, '2025-12-26', '0000-00-00', NULL, NULL, '2025-12-26 20:53:06', '2025-12-26 20:53:06'),
(39, 8, 'NO DESVINCULACION DE DIEGO GALENAO DE PETROSERVICIOS DE LA SEGURIDAD SOCIAL POR CIRUGIA DEL PAPÁ', '', 'Operativa', 'Media', 'No iniciada', 0, 27, 27, '2025-12-26', '0000-00-00', NULL, NULL, '2025-12-26 20:53:06', '2025-12-26 20:53:06'),
(40, 8, 'CERRAR CASO DE MONICA FRANCO  CITA REUNIÓN PRÓXIMA SEMANA (PROGRAMAR LA REUNIOR)', '', 'Operativa', 'Media', 'No iniciada', 0, 27, 27, '2025-12-26', '0000-00-00', NULL, NULL, '2025-12-26 20:53:06', '2025-12-26 20:53:06'),
(41, 8, 'CITACION PROCESOS DISCIPLIRACION SANTIAGO', '', 'Operativa', 'Media', 'No iniciada', 0, 27, 27, '2025-12-26', '0000-00-00', NULL, NULL, '2025-12-26 20:53:06', '2025-12-26 20:53:06'),
(42, 2, 'prueba de aplicativo', '', 'Operativa', 'Media', 'En progreso', 10, 12, 12, '2025-12-30', '2025-12-30', NULL, NULL, '2025-12-29 20:16:27', '2025-12-30 18:00:07'),
(46, 2, 'actas de devolucion petroservicios ', 'hacer uso del aplicatipo  en desarrollo', 'Operativa', 'Alta', 'Completada', 100, 28, 12, '2025-12-30', '2025-12-30', NULL, NULL, '2025-12-29 20:19:33', '2025-12-30 19:56:24'),
(50, 2, 'Creación Matriz RACI procedimeinto credito leasing', '', 'Operativa', 'Alta', 'Completada', 100, 36, 36, '2025-12-30', '2025-12-30', NULL, NULL, '2025-12-30 12:48:02', '2025-12-30 20:20:32'),
(51, 2, 'Creación  matriz de entradas y salidas procedimiento crédito leasing', '', 'Operativa', 'Alta', 'Completada', 100, 36, 36, '2025-12-30', '2025-12-30', NULL, NULL, '2025-12-30 12:48:02', '2025-12-30 20:20:31'),
(52, 2, 'Solicitar KPIs administrativos para matriz de indicadores', '', 'Operativa', 'Media', 'Completada', 100, 36, 36, '2025-12-30', '2025-12-30', NULL, NULL, '2025-12-30 12:48:02', '2025-12-30 20:20:38'),
(53, 2, 'Modificar procedimiento procedimiento crédito leasing', '', 'Operativa', 'Alta', 'No iniciada', 100, 36, 36, '2025-12-30', '2025-12-30', NULL, NULL, '2025-12-30 12:48:02', '2025-12-30 19:34:58'),
(85, 2, 'mateo esta tomando del pelo', NULL, 'Mejora', 'Media', 'No iniciada', 0, 12, 12, '2025-12-30', '2025-12-31', NULL, NULL, '2025-12-30 17:09:24', '2025-12-30 17:09:24'),
(91, 5, ' correccion contrto transjalima ', NULL, 'Operativa', 'Alta', 'En progreso', 70, 12, 12, '2025-12-30', '2025-12-30', NULL, NULL, '2025-12-30 17:16:45', '2025-12-30 17:16:45'),
(104, 2, 'envio petro', NULL, 'Operativa', 'Media', 'No iniciada', 0, 12, 12, '2025-12-30', '2025-12-30', NULL, NULL, '2025-12-30 17:58:05', '2025-12-30 17:59:11'),
(133, 4, 'apoyo con escaneo documentos de frontera', NULL, 'Operativa', 'Alta', 'Completada', 100, 28, 28, '2025-12-30', '2025-12-30', NULL, NULL, '2025-12-30 19:56:57', '2025-12-30 19:57:26'),
(134, 1, 'apoyo a mantenimiento de equipos company man', NULL, 'Operativa', 'Alta', 'En progreso', 80, 28, 28, '2025-12-30', NULL, NULL, NULL, '2025-12-30 19:57:27', '2025-12-30 21:39:17'),
(135, 1, 'Solicitud de factura electronica en unilago', NULL, 'Operativa', 'Alta', 'Completada', 100, 28, 28, '2025-12-30', '2025-12-30', NULL, NULL, '2025-12-30 20:02:25', '2025-12-30 21:39:36'),
(136, 2, 'Cargue de KPIs pefiles administratvos a matriz ', NULL, 'Operativa', 'Alta', 'No iniciada', 0, 36, 36, '2026-01-02', NULL, NULL, NULL, '2026-01-02 12:25:48', '2026-01-02 12:25:58'),
(137, 2, 'Solicitud a GH de KPIs administrativos ', NULL, 'Operativa', 'Alta', 'Completada', 100, 36, 36, '2026-01-02', '2026-01-02', NULL, NULL, '2026-01-02 12:26:13', '2026-01-02 21:13:58'),
(138, 2, 'Realizar Flujograma procedimiento credito incluido leasing ', NULL, 'Operativa', 'Alta', 'Completada', 100, 36, 36, '2026-01-02', '2026-01-02', NULL, NULL, '2026-01-02 12:26:42', '2026-01-02 21:13:59'),
(139, 2, 'Realizar flujograma procedimiento control propiedad Planta y equipo ', NULL, 'Operativa', 'Alta', 'Completada', 100, 36, 36, '2026-01-02', '2026-01-02', NULL, NULL, '2026-01-02 12:28:23', '2026-01-02 21:14:00'),
(140, 2, 'Realizar validacion de KPIs procedimiento control propiedad Planta y equipo ', NULL, 'Operativa', 'Alta', 'Completada', 100, 36, 36, '2026-01-02', '2026-01-02', NULL, NULL, '2026-01-02 12:32:43', '2026-01-02 21:14:01'),
(141, 2, 'Realizar matriz entradas y salidas procedimiento control propiedad Planta y equipo ', NULL, 'Operativa', 'Alta', 'Completada', 100, 36, 36, '2026-01-02', '2026-01-02', NULL, NULL, '2026-01-02 12:32:57', '2026-01-02 21:14:01'),
(142, 2, 'Diligencia gerencia', NULL, 'Operativa', 'Alta', 'Completada', 100, 29, 29, '2026-01-02', '2026-01-02', NULL, NULL, '2026-01-02 12:37:24', '2026-01-02 19:57:26'),
(143, 1, 'Bitácoras de Diciembre', NULL, 'Obligatoria', 'Alta', 'No iniciada', 65, 28, 28, '2026-01-02', '2026-01-02', NULL, NULL, '2026-01-02 12:50:22', '2026-01-02 20:17:22'),
(144, 2, 'revisión de los anticipos y la facturación', NULL, 'Operativa', 'Media', 'En progreso', 60, 29, 29, '2026-01-02', '2026-01-02', NULL, NULL, '2026-01-02 13:02:11', '2026-01-02 19:57:27'),
(164, 1, 'Con Camilo se realizo una actualización en el chat de soporte tawk.io', NULL, 'Operativa', 'Alta', 'Completada', 100, 28, 28, '2026-01-02', NULL, NULL, NULL, '2026-01-02 20:17:17', '2026-01-02 20:17:17'),
(165, 2, 'verificacion retiros medplus', NULL, 'Operativa', 'Media', 'No iniciada', 0, 12, 12, '2026-01-05', '2026-01-05', NULL, NULL, '2026-01-05 13:18:56', '2026-01-05 13:23:50'),
(166, 2, 'Accesos para Juan esteban Velasquez Arias', NULL, 'Operativa', 'Media', 'No iniciada', 0, 12, 12, '2026-01-05', '2026-01-05', NULL, NULL, '2026-01-05 13:18:56', '2026-01-05 13:23:50'),
(167, 2, 'verificar pagos realizados', NULL, 'Operativa', 'Media', 'No iniciada', 0, 12, 12, '2026-01-05', '2026-01-05', NULL, NULL, '2026-01-05 13:18:56', '2026-01-05 13:23:50'),
(168, 2, ' capacitacion ', NULL, 'Obligatoria', 'Alta', 'No iniciada', 35, 12, 12, '2026-01-06', NULL, NULL, NULL, '2026-01-06 16:00:11', '2026-01-06 16:00:11');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `task_assignments`
--

CREATE TABLE `task_assignments` (
  `id` int(11) NOT NULL,
  `task_id` int(11) NOT NULL,
  `assigned_by` int(11) NOT NULL,
  `assigned_to` int(11) NOT NULL,
  `message` text DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `task_assignments`
--

INSERT INTO `task_assignments` (`id`, `task_id`, `assigned_by`, `assigned_to`, `message`, `is_read`, `created_at`) VALUES
(2, 23, 27, 24, 'SEGURIDIDAD SOCIAL PRIMERA VERSION', 0, '2025-12-26 17:18:40');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `task_comments`
--

CREATE TABLE `task_comments` (
  `id` int(11) NOT NULL,
  `task_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `comment` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `task_events`
--

CREATE TABLE `task_events` (
  `id` bigint(20) NOT NULL,
  `task_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `event_type` enum('CREATED','STATUS_CHANGED','RESPONSIBLE_CHANGED','PROGRESS_CHANGED','COMMENT_ADDED','EVIDENCE_ADDED','DUE_DATE_CHANGED','PRIORITY_CHANGED','UPDATED') NOT NULL,
  `meta_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`meta_json`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `task_evidences`
--

CREATE TABLE `task_evidences` (
  `id` int(11) NOT NULL,
  `task_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `url` varchar(500) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(5, 'CESAR AUGUSTO URREGO AVENDAÑO', 'currego@meridian.com.co', '79490148', 1, 9, 1, '2025-12-22 15:43:24', '2025-12-26 14:15:12'),
(6, 'RUTH MUÑOZ CASTILLO', 'rmunoz@meridian.com.co', '52147279', 3, 2, 1, '2025-12-22 15:43:24', '2025-12-26 13:47:15'),
(7, 'ZANDRA PATRICIA MAYORGA GOMEZ', 'coordinadoracontable@meridian.com.co', '52005033', 3, 7, 1, '2025-12-22 15:43:24', '2025-12-26 14:15:28'),
(8, 'GUSTAVO ADOLFO GIRALDO CORREA', 'ggiraldo@meridian.com.co', '1053788938', 2, 4, 1, '2025-12-22 15:43:24', '2025-12-26 14:15:37'),
(9, 'AURA ALEJANDRA CONTRERAS TORRES', 'asistenteadministrativo1@meridian.com.co', '1014251428', 3, 2, 1, '2025-12-22 15:43:24', '2025-12-26 13:47:15'),
(10, 'MICHAEL STIVEN RUIZ CARO', 'soportehseqproyectos@meridian.com.co', '1007493802', 3, 3, 1, '2025-12-22 15:43:24', '2025-12-26 14:15:46'),
(11, 'LUIS MIGUEL GUEVARA MARLES', 'hseq@meridian.com.co', '1119211830', 2, 3, 1, '2025-12-22 15:43:24', '2025-12-26 14:15:49'),
(12, 'SANDRA MILENA FLOREZ PRADO', 'asistenteadministrativo2@meridian.com.co', '1014180459', 3, 2, 1, '2025-12-22 15:43:24', '2025-12-26 13:47:15'),
(13, 'ELOY GABRIEL GOMEZ REYES', 'coordinaciongestionhumana@meridian.com.co', '1020733194', 3, 8, 1, '2025-12-22 15:43:24', '2025-12-26 14:15:59'),
(14, 'DIANA MARCELA JACOBO MANCERA', 'soportehseq@meridian.com.co', '1031145571', 3, 3, 1, '2025-12-22 15:43:24', '2025-12-26 14:16:05'),
(15, 'LAURA DANIELA SEGURA MORERA', 'profesionalhseq@meridian.com.co', '1121936876', 3, 3, 1, '2025-12-22 15:43:24', '2025-12-26 14:16:10'),
(16, 'ANDRES CAMILO CARDENAS REYES', 'soporteit@meridian.com.co', '1007627524', 3, 1, 1, '2025-12-22 15:43:24', '2025-12-30 12:43:01'),
(17, 'STEPHANIA FONSECA LOPEZ', 'contratacion@meridian.com.co', '1007647736', 3, 8, 1, '2025-12-22 15:43:24', '2025-12-26 17:14:52'),
(18, 'FABRYZCIO ANDRES ORTIZ GARCIA', 'noemail+1102580512@meridian.com.co', '1102580512', 3, 4, 1, '2025-12-22 15:43:24', '2025-12-26 14:16:28'),
(19, 'EYMER SANTIAGO MENDEZ HERRERA', 'noemail+1031649053@meridian.com.co', '1031649053', 3, 2, 1, '2025-12-22 15:43:24', '2025-12-26 13:47:15'),
(20, 'ELIANA IVETH ALARCON RONDON', 'proyectos6@meridian.com.co', '1032446831', 2, 6, 1, '2025-12-22 15:43:24', '2025-12-26 14:16:45'),
(21, 'KAREN JULIETH CARRANZA RODRIGUEZ', 'analistacontable@meridian.com.co', '1000931984', 3, 7, 1, '2025-12-22 15:43:24', '2025-12-26 14:16:52'),
(22, 'VIVIANA DEL PILAR ALFONSO AVENDAÑO', 'noemail+1022344726@meridian.com.co', '1022344726', 3, 5, 1, '2025-12-22 15:43:24', '2025-12-26 14:17:14'),
(23, 'KAROL DANIELA SALCEDO ROMERO', 'noemail+1024478397@meridian.com.co', '1024478397', 3, 2, 1, '2025-12-22 15:43:24', '2025-12-26 13:47:15'),
(24, 'RONALD VASQUEZ ZARATE', 'nominas@meridian.com.co', '79954907', 3, 7, 1, '2025-12-22 15:43:24', '2025-12-26 14:17:24'),
(25, 'DANIEL ANDRES JOYA SAAVEDRA', 'proyectos2@meridian.com.co', '1136888916', 3, 4, 1, '2025-12-22 15:43:24', '2025-12-26 14:17:29'),
(26, 'LUISA FERNANDA PACHECO RUBIO', 'asistentegestionhumana@meridian.com.co', '1000588440', 3, 8, 1, '2025-12-22 15:43:24', '2025-12-26 14:17:35'),
(27, 'MIGUEL LEONARDO MARTINEZ SOTO', 'lidergh@meridian.com.co', '1022347823', 1, 8, 1, '2025-12-22 15:43:24', '2025-12-26 14:17:40'),
(28, 'DIEGO ALEJANDRO BARRETO HERNANDEZ', 'auxiliarit@meridian.com.co', '1140916030', 3, 1, 1, '2025-12-22 15:43:24', '2025-12-26 14:17:44'),
(29, 'JORGE ARMANDO PACHECO COLLAZOS', 'asistentelogistica@meridian.com.co', '1010174163', 3, 2, 1, '2025-12-22 15:43:24', '2025-12-26 14:14:43'),
(30, 'JESSICA ALEXANDRA ALAVA CHAVEZ', 'noemail+1010222610@meridian.com.co', '1010222610', 3, 7, 1, '2025-12-22 15:43:24', '2025-12-26 14:19:32'),
(31, 'ANA EBELIA GAMEZ FIGUEREDO', 'contador@meridian.com.co', '39949703', 2, 2, 1, '2025-12-22 15:43:24', '2025-12-26 14:18:06'),
(32, 'JOSE MATEO LOPEZ CIFUENTES', 'desarrolloit@meridian.com.co', '$argon2id$v=19$m=65536,t=4,p=1$TlVmTHMuOXR2Mkd2dEJLdg$vINBmjTupl56XOVAwIe8pDot015Ip3PaN1XXTV58r9A', 1, 1, 1, '2025-12-22 15:43:24', '2025-12-26 14:18:13'),
(33, 'LUISA MARIA MELO RODRÍGUEZ', 'noemail+1018516821@meridian.com.co', '1018516821', 3, 7, 1, '2025-12-22 15:43:24', '2025-12-26 14:18:22'),
(34, 'LADY LORENA VINCHERY SOLANO', 'noemail+1019136436@meridian.com.co', '1019136436', 3, 8, 1, '2025-12-22 15:43:24', '2025-12-26 14:18:29'),
(35, 'CRISTIAN ANDRES MURILLO', 'noemail+1033703338@meridian.com.co', '1033703338', 3, 2, 1, '2025-12-22 15:43:24', '2025-12-26 13:47:15'),
(36, 'DARWIN YAMID GARZON RODRIGUEZ', 'aprendizadmin@meridian.com.co', '1070750164', 3, 2, 1, '2025-12-22 15:43:24', '2025-12-30 12:43:39'),
(37, 'PAOLA ADRIANA GIL CHIPATECUA', 'cordinadorproyectos@meridian.com', '52786386', 2, 5, 1, '2025-12-22 15:43:24', '2025-12-26 14:18:44'),
(38, 'JESSICA ASTRID MAYORGA BARRERA', 'noemail+1026301759@meridian.com.co', '1026301759', 3, 5, 1, '2025-12-22 15:43:24', '2025-12-26 14:19:09'),
(39, 'JUAN ESTEBAN LOPEZ OSORIO', 'noemail+1089599089@meridian.com.co', '1089599089', 3, 2, 1, '2025-12-22 15:43:24', '2025-12-26 13:47:15'),
(40, 'JOSHUA ELIAS MENA VARGAS', 'noemail+1091966621@meridian.com.co', '1091966621', 3, 3, 1, '2025-12-22 15:43:24', '2025-12-26 14:19:49'),
(41, 'LAURA KARINA GAMEZ GOMEZ', 'noemail+1000987240@meridian.com.co', '1000987240', 3, 2, 1, '2025-12-22 15:43:24', '2025-12-26 13:47:15'),
(42, 'JULIAN ANDRES MORALES SEGURA', 'noemail+1012395152@meridian.com.co', '1012395152', 3, 7, 1, '2025-12-22 15:43:24', '2025-12-26 14:21:27'),
(43, 'LADY JOHANNA AGUIRRE ROMERO', 'noemail+1024491663@meridian.com.co', '1024491663', 3, 7, 1, '2025-12-22 15:43:24', '2025-12-26 14:21:34'),
(44, 'ALISON VANESA GONZALEZ OROZCO', 'noemail+1105465424@meridian.com.co', '1105465424', 3, 2, 1, '2025-12-22 15:43:24', '2025-12-26 13:47:15');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_areas`
--

CREATE TABLE `user_areas` (
  `user_id` int(11) NOT NULL,
  `area_id` int(11) NOT NULL,
  `is_primary` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `areas`
--
ALTER TABLE `areas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_areas_parent` (`parent_id`),
  ADD KEY `idx_areas_type` (`type`);

--
-- Indices de la tabla `login_attempts`
--
ALTER TABLE `login_attempts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_ip_attempted` (`ip_address`,`attempted_at`),
  ADD KEY `idx_attempted_at` (`attempted_at`);

--
-- Indices de la tabla `password_reset_otps`
--
ALTER TABLE `password_reset_otps`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_active` (`user_id`,`used_at`,`expires_at`);

--
-- Indices de la tabla `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `token_hash` (`token_hash`),
  ADD KEY `idx_user_active` (`user_id`,`used_at`,`expires_at`);

--
-- Indices de la tabla `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_refresh_tokens_user` (`user_id`),
  ADD KEY `idx_refresh_tokens_expires` (`expires_at`),
  ADD KEY `idx_refresh_tokens_revoked` (`revoked_at`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indices de la tabla `tasks`
--
ALTER TABLE `tasks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_tasks_created_by` (`created_by`),
  ADD KEY `idx_tasks_area` (`area_id`),
  ADD KEY `idx_tasks_responsible` (`responsible_id`),
  ADD KEY `idx_tasks_status` (`status`),
  ADD KEY `idx_tasks_due_date` (`due_date`),
  ADD KEY `idx_tasks_updated_at` (`updated_at`),
  ADD KEY `idx_tasks_deleted_at` (`deleted_at`),
  ADD KEY `idx_tasks_area_status_due` (`area_id`,`status`,`due_date`),
  ADD KEY `idx_tasks_responsible_status_due` (`responsible_id`,`status`,`due_date`),
  ADD KEY `idx_tasks_status_due` (`status`,`due_date`),
  ADD KEY `idx_tasks_area_updated` (`area_id`,`updated_at`);

--
-- Indices de la tabla `task_assignments`
--
ALTER TABLE `task_assignments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_assigned_to` (`assigned_to`),
  ADD KEY `idx_assigned_by` (`assigned_by`),
  ADD KEY `idx_is_read` (`is_read`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `fk_task_assignments_task` (`task_id`);

--
-- Indices de la tabla `task_comments`
--
ALTER TABLE `task_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_task_comments_user` (`user_id`),
  ADD KEY `idx_task_comments_task` (`task_id`),
  ADD KEY `idx_task_comments_created` (`created_at`);

--
-- Indices de la tabla `task_events`
--
ALTER TABLE `task_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_task_events_user` (`user_id`),
  ADD KEY `idx_task_events_task` (`task_id`),
  ADD KEY `idx_task_events_created` (`created_at`),
  ADD KEY `idx_task_events_type` (`event_type`);

--
-- Indices de la tabla `task_evidences`
--
ALTER TABLE `task_evidences`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_task_evidences_user` (`user_id`),
  ADD KEY `idx_task_evidences_task` (`task_id`),
  ADD KEY `idx_task_evidences_created` (`created_at`);

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
-- Indices de la tabla `user_areas`
--
ALTER TABLE `user_areas`
  ADD PRIMARY KEY (`user_id`,`area_id`),
  ADD KEY `idx_user_areas_area` (`area_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `areas`
--
ALTER TABLE `areas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `login_attempts`
--
ALTER TABLE `login_attempts`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;

--
-- AUTO_INCREMENT de la tabla `password_reset_otps`
--
ALTER TABLE `password_reset_otps`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=557;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tasks`
--
ALTER TABLE `tasks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=169;

--
-- AUTO_INCREMENT de la tabla `task_assignments`
--
ALTER TABLE `task_assignments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `task_comments`
--
ALTER TABLE `task_comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `task_events`
--
ALTER TABLE `task_events`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `task_evidences`
--
ALTER TABLE `task_evidences`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `areas`
--
ALTER TABLE `areas`
  ADD CONSTRAINT `fk_areas_parent` FOREIGN KEY (`parent_id`) REFERENCES `areas` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `password_reset_otps`
--
ALTER TABLE `password_reset_otps`
  ADD CONSTRAINT `fk_pro_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD CONSTRAINT `fk_prt_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  ADD CONSTRAINT `fk_refresh_tokens_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `tasks`
--
ALTER TABLE `tasks`
  ADD CONSTRAINT `fk_tasks_area` FOREIGN KEY (`area_id`) REFERENCES `areas` (`id`),
  ADD CONSTRAINT `fk_tasks_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `fk_tasks_responsible` FOREIGN KEY (`responsible_id`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `task_assignments`
--
ALTER TABLE `task_assignments`
  ADD CONSTRAINT `fk_task_assignments_assigned_by` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_task_assignments_assigned_to` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_task_assignments_task` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `task_comments`
--
ALTER TABLE `task_comments`
  ADD CONSTRAINT `fk_task_comments_task` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_task_comments_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `task_events`
--
ALTER TABLE `task_events`
  ADD CONSTRAINT `fk_task_events_task` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_task_events_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `task_evidences`
--
ALTER TABLE `task_evidences`
  ADD CONSTRAINT `fk_task_evidences_task` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_task_evidences_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_area` FOREIGN KEY (`area_id`) REFERENCES `areas` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_users_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);

--
-- Filtros para la tabla `user_areas`
--
ALTER TABLE `user_areas`
  ADD CONSTRAINT `fk_user_areas_area` FOREIGN KEY (`area_id`) REFERENCES `areas` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_user_areas_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
