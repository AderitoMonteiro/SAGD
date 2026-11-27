-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 27-Nov-2026 às 17:53
-- Versão do servidor: 10.4.32-MariaDB
-- versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `sagd`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `aprovacao_tarefas`
--

CREATE TABLE `aprovacao_tarefas` (
  `id` bigint(20) NOT NULL,
  `obs` varchar(200) NOT NULL,
  `date_created` datetime(6) NOT NULL,
  `date_update` datetime(6) NOT NULL,
  `domain_id` bigint(20) DEFAULT NULL,
  `objetivo_departtamento_id` bigint(20) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `aprovacao_tarefas`
--

INSERT INTO `aprovacao_tarefas` (`id`, `obs`, `date_created`, `date_update`, `domain_id`, `objetivo_departtamento_id`, `is_active`) VALUES
(1, 'Rever alguns termos.', '2026-10-01 13:51:38.525287', '2026-10-01 14:07:19.729091', 4, NULL, 1),
(4, 'xpto', '2026-10-01 15:27:02.493130', '2026-10-01 15:27:02.493130', 4, NULL, 1),
(11, 'altera nome de tarefa', '2026-10-02 11:44:01.254064', '2026-10-02 11:44:01.254064', 3, 13, 0),
(12, 'ok', '2026-10-08 17:18:47.603903', '2026-10-08 17:18:47.603903', 4, 14, 0),
(13, '', '2026-10-14 16:31:54.594147', '2026-10-14 16:31:54.594147', 3, 15, 0),
(14, '', '2026-11-13 10:37:07.932032', '2026-11-13 10:37:07.932032', 3, 16, 0),
(15, '', '2026-11-16 10:59:07.876776', '2026-11-16 10:59:07.876776', 3, 20, 0),
(16, '', '2026-11-16 10:59:11.008398', '2026-11-16 10:59:11.008398', 3, 19, 0),
(17, '', '2026-11-24 11:35:42.547645', '2026-11-24 11:35:42.547645', 3, 21, 1),
(18, '', '2026-11-24 12:19:31.890799', '2026-11-24 12:19:31.891542', 3, 22, 1),
(19, '', '2026-11-25 11:38:32.408035', '2026-11-25 11:38:32.408035', 3, 23, 1),
(20, '', '2026-11-25 11:50:52.353560', '2026-11-25 11:50:52.353560', 3, 26, 1),
(21, '', '2026-11-25 11:50:55.488153', '2026-11-25 11:50:55.488153', 3, 25, 1),
(22, '', '2026-11-25 11:50:58.821131', '2026-11-25 11:50:58.821131', 3, 24, 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `auth_group`
--

INSERT INTO `auth_group` (`id`, `name`) VALUES
(1, 'Administrador'),
(5, 'Colaborador'),
(4, 'Conselho de Administração'),
(3, 'Gestor'),
(2, 'RH');

-- --------------------------------------------------------

--
-- Estrutura da tabela `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 2, 'add_permission'),
(6, 'Can change permission', 2, 'change_permission'),
(7, 'Can delete permission', 2, 'delete_permission'),
(8, 'Can view permission', 2, 'view_permission'),
(9, 'Can add group', 3, 'add_group'),
(10, 'Can change group', 3, 'change_group'),
(11, 'Can delete group', 3, 'delete_group'),
(12, 'Can view group', 3, 'view_group'),
(13, 'Can add user', 4, 'add_user'),
(14, 'Can change user', 4, 'change_user'),
(15, 'Can delete user', 4, 'delete_user'),
(16, 'Can view user', 4, 'view_user'),
(17, 'Can add content type', 5, 'add_contenttype'),
(18, 'Can change content type', 5, 'change_contenttype'),
(19, 'Can delete content type', 5, 'delete_contenttype'),
(20, 'Can view content type', 5, 'view_contenttype'),
(21, 'Can add session', 6, 'add_session'),
(22, 'Can change session', 6, 'change_session'),
(23, 'Can delete session', 6, 'delete_session'),
(24, 'Can view session', 6, 'view_session'),
(25, 'Can add ciclo', 7, 'add_cycle'),
(26, 'Can change ciclo', 7, 'change_cycle'),
(27, 'Can delete ciclo', 7, 'delete_cycle'),
(28, 'Can view ciclo', 7, 'view_cycle'),
(29, 'Can add avaliação', 8, 'add_evaluation'),
(30, 'Can change avaliação', 8, 'change_evaluation'),
(31, 'Can delete avaliação', 8, 'delete_evaluation'),
(32, 'Can view avaliação', 8, 'view_evaluation'),
(33, 'Can add acompanhamento', 9, 'add_followup'),
(34, 'Can change acompanhamento', 9, 'change_followup'),
(35, 'Can delete acompanhamento', 9, 'delete_followup'),
(36, 'Can view acompanhamento', 9, 'view_followup'),
(37, 'Can add objetivo', 10, 'add_objective'),
(38, 'Can change objetivo', 10, 'change_objective'),
(39, 'Can delete objetivo', 10, 'delete_objective'),
(40, 'Can view objetivo', 10, 'view_objective'),
(41, 'Can add validação', 11, 'add_validation'),
(42, 'Can change validação', 11, 'change_validation'),
(43, 'Can delete validação', 11, 'delete_validation'),
(44, 'Can view validação', 11, 'view_validation'),
(45, 'Can add objetivo departamental', 12, 'add_departmentobjective'),
(46, 'Can change objetivo departamental', 12, 'change_departmentobjective'),
(47, 'Can delete objetivo departamental', 12, 'delete_departmentobjective'),
(48, 'Can view objetivo departamental', 12, 'view_departmentobjective'),
(49, 'Can add objetivo individual', 13, 'add_individualobjective'),
(50, 'Can change objetivo individual', 13, 'change_individualobjective'),
(51, 'Can delete objetivo individual', 13, 'delete_individualobjective'),
(52, 'Can view objetivo individual', 13, 'view_individualobjective'),
(53, 'Can add objetivo institucional', 14, 'add_institutionalobjective'),
(54, 'Can change objetivo institucional', 14, 'change_institutionalobjective'),
(55, 'Can delete objetivo institucional', 14, 'delete_institutionalobjective'),
(56, 'Can view objetivo institucional', 14, 'view_institutionalobjective'),
(57, 'Can add departamento', 15, 'add_department'),
(58, 'Can change departamento', 15, 'change_department'),
(59, 'Can delete departamento', 15, 'delete_department'),
(60, 'Can view departamento', 15, 'view_department'),
(61, 'Can add departamento do utilizador', 16, 'add_userdepartment'),
(62, 'Can change departamento do utilizador', 16, 'change_userdepartment'),
(63, 'Can delete departamento do utilizador', 16, 'delete_userdepartment'),
(64, 'Can view departamento do utilizador', 16, 'view_userdepartment'),
(65, 'Can add domínio', 17, 'add_domain'),
(66, 'Can change domínio', 17, 'change_domain'),
(67, 'Can delete domínio', 17, 'delete_domain'),
(68, 'Can view domínio', 17, 'view_domain'),
(69, 'Can add aprovação de tarefa', 18, 'add_aprovacaotarefa'),
(70, 'Can change aprovação de tarefa', 18, 'change_aprovacaotarefa'),
(71, 'Can delete aprovação de tarefa', 18, 'delete_aprovacaotarefa'),
(72, 'Can view aprovação de tarefa', 18, 'view_aprovacaotarefa'),
(73, 'Can add registo de ocorrência', 19, 'add_registoocorrencia'),
(74, 'Can change registo de ocorrência', 19, 'change_registoocorrencia'),
(75, 'Can delete registo de ocorrência', 19, 'delete_registoocorrencia'),
(76, 'Can view registo de ocorrência', 19, 'view_registoocorrencia'),
(77, 'Can add histórico de operação', 20, 'add_historicooperacao'),
(78, 'Can change histórico de operação', 20, 'change_historicooperacao'),
(79, 'Can delete histórico de operação', 20, 'delete_historicooperacao'),
(80, 'Can view histórico de operação', 20, 'view_historicooperacao'),
(81, 'Can add notificação visualizada', 21, 'add_systemnotificationread'),
(82, 'Can change notificação visualizada', 21, 'change_systemnotificationread'),
(83, 'Can delete notificação visualizada', 21, 'delete_systemnotificationread'),
(84, 'Can view notificação visualizada', 21, 'view_systemnotificationread');

-- --------------------------------------------------------

--
-- Estrutura da tabela `auth_user`
--

CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `auth_user`
--

INSERT INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
(1, 'pbkdf2_sha256$1000000$Nsotlf5BdE9WbvtgZi2HBs$orcR2N8Qj+4BX4GZgGWoeylOP14u/ewH+pj5/BlCUfY=', '2026-10-05 10:07:06.835490', 0, 'demo', '', '', '', 1, 0, '2026-09-18 16:13:20.000000'),
(2, 'pbkdf2_sha256$1000000$7Ze8paaeBAzOKRPhFKE74R$8a6KsK5IIJhMINTOogLoKxnkcS1FRkLi+1fLwt7aqx4=', '2026-11-12 11:01:51.515497', 1, 'admin', '', '', 'admin@gmail.com', 1, 1, '2026-09-18 16:18:14.495000'),
(3, 'pbkdf2_sha256$1000000$iIHZ0ZnYpBynoijuNqcPrT$fw6ecvH1wu6ps5D3NgJ+rM5GAu1FzWNlphrKqeRdsSQ=', '2026-11-27 11:30:36.174785', 0, 'Raimundo.F.Lopes', 'Raimundo', 'Lopes', 'Raimundo.F.Lopes@incv.cv', 0, 1, '2026-09-24 10:18:04.000000'),
(4, 'pbkdf2_sha256$1000000$WFlNIS04mVXwxnhDBelzgO$+V8ixheT/+FI6KwD0ZVcEAWBE7TTgSjZRGKVzThbB94=', '2026-11-27 11:58:40.455279', 0, 'Arcelinda.Carvalho', 'Arcelinda', 'Carvalho', 'Arcelinda.Carvalho@incv.cv', 0, 1, '2026-09-24 12:26:01.000000'),
(5, 'pbkdf2_sha256$1000000$8rMJX10w2Vct3ETKXa55S1$USVtyNjNGIv+bkGZ7+xTxwgPN8AJNx9/Q/S+jbOIteM=', '2026-11-27 11:50:45.483575', 0, 'aderito.b.monteiro', 'Aderito', 'Monteiro', 'aderito.b.monteiro@gov.cv', 0, 1, '2026-09-24 15:21:58.000000'),
(8, 'pbkdf2_sha256$1000000$yBWRlyOavf1tJQB9GfCF8h$1AdBPNxeuKCG2jzy89r2AQabZW2Rs7AY7srqCwKEXdg=', '2026-11-25 11:41:55.399873', 0, 'Liziane.Monteiro', 'Liziane', 'Monteiro', 'Liziane.Monteiro@incv.cv', 0, 1, '2026-09-28 15:19:56.000000'),
(9, 'pbkdf2_sha256$1000000$CyEhFvInMNi1Y9PhmGCMLq$5qQNhNJTEiFIylvg/S3JBfFNMKTZ1cLpSJHTHZvUL1s=', NULL, 0, 'ivandro.g.Moniz', 'Ivandro', 'Moniz', 'ivandro.g.Moniz@incv.cv', 0, 1, '2026-09-29 12:07:02.000000'),
(10, 'pbkdf2_sha256$1000000$1ri2ypYGpXzzTGkan3d7ep$rNRCS621YpkKZSisJ2C41e1HdAPsaKewClGtdKostF4=', '2026-10-05 10:15:18.096109', 0, 'teste', '', '', '', 0, 1, '2026-10-05 10:01:22.100454');

-- --------------------------------------------------------

--
-- Estrutura da tabela `auth_user_groups`
--

CREATE TABLE `auth_user_groups` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `auth_user_groups`
--

INSERT INTO `auth_user_groups` (`id`, `user_id`, `group_id`) VALUES
(1, 3, 4),
(2, 4, 3),
(3, 5, 5),
(8, 8, 3),
(7, 9, 5);

-- --------------------------------------------------------

--
-- Estrutura da tabela `auth_user_user_permissions`
--

CREATE TABLE `auth_user_user_permissions` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `auth_user_user_permissions`
--

INSERT INTO `auth_user_user_permissions` (`id`, `user_id`, `permission_id`) VALUES
(5, 3, 25),
(6, 3, 26),
(7, 3, 27),
(8, 3, 28),
(1, 3, 53),
(2, 3, 54),
(3, 3, 55),
(4, 3, 56);

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_cycle`
--

CREATE TABLE `core_cycle` (
  `id` bigint(20) NOT NULL,
  `name` varchar(120) NOT NULL,
  `year` int(10) UNSIGNED NOT NULL CHECK (`year` >= 0),
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` varchar(20) NOT NULL,
  `domain_id` bigint(20) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `core_cycle`
--

INSERT INTO `core_cycle` (`id`, `name`, `year`, `start_date`, `end_date`, `status`, `domain_id`, `is_active`) VALUES
(33, 'Ciclo 2026/27', 2026, '2026-01-15', '2026-12-31', 'planned', 1, 0),
(34, 'ciclo 26/27 ano letivo', 2026, '2026-10-14', '2026-11-30', 'planned', 1, 0),
(35, 'ciclo 26/27', 2026, '2026-10-19', '2026-10-31', 'active', 1, 0),
(36, 'Ciclo letivo 2027', 2026, '2026-01-01', '2026-10-01', 'planned', 1, 0),
(40, 'Implimentação de ISO 90001', 2026, '2026-11-16', '2026-11-18', 'planned', 1, 0),
(41, 'Ciclo 26/27', 2026, '2026-11-24', '2026-11-27', 'planned', 1, 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_department`
--

CREATE TABLE `core_department` (
  `id` bigint(20) NOT NULL,
  `name` varchar(120) NOT NULL,
  `code` varchar(30) NOT NULL,
  `description` longtext NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_created` datetime(6) NOT NULL,
  `date_update` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `core_department`
--

INSERT INTO `core_department` (`id`, `name`, `code`, `description`, `is_active`, `date_created`, `date_update`) VALUES
(1, 'CA', 'INCV-CA', '', 1, '2026-09-23 14:47:21.184000', '2026-09-23 14:48:14.427000'),
(2, 'DC', 'INCV-DC', '', 1, '2026-09-23 14:47:43.624000', '2026-09-23 14:48:22.697000'),
(3, 'DF', 'INCV-DF', '', 1, '2026-09-23 14:47:57.246000', '2026-09-23 14:48:28.578000'),
(4, 'DP', 'INCV-DP', '', 1, '2026-09-23 14:48:47.396000', '2026-09-23 14:48:47.396000'),
(5, 'GS', 'INCV-GS', '', 1, '2026-09-23 14:49:04.373000', '2026-09-23 14:49:04.373000'),
(6, 'UJ', 'INCV-UJ', '', 1, '2026-09-23 14:49:20.393000', '2026-09-23 14:49:20.393000'),
(7, 'ULC', 'INCV-ULC', '', 1, '2026-09-23 14:49:37.696000', '2026-09-23 14:49:37.696000'),
(8, 'URH', 'INCV-URH', '', 1, '2026-09-23 14:50:02.899000', '2026-09-23 14:50:02.899000'),
(9, 'USI', 'INCV-USI', '', 1, '2026-09-23 14:50:15.196000', '2026-09-23 14:50:15.196000');

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_departmentobjective`
--

CREATE TABLE `core_departmentobjective` (
  `id` bigint(20) NOT NULL,
  `description` varchar(200) NOT NULL,
  `status` varchar(15) NOT NULL,
  `date_created` datetime(6) NOT NULL,
  `date_update` datetime(6) NOT NULL,
  `institutional_objective_id` bigint(20) NOT NULL,
  `department_id` bigint(20) DEFAULT NULL,
  `domain_id` bigint(20) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL,
  `percentagem` decimal(5,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `core_departmentobjective`
--

INSERT INTO `core_departmentobjective` (`id`, `description`, `status`, `date_created`, `date_update`, `institutional_objective_id`, `department_id`, `domain_id`, `is_active`, `percentagem`) VALUES
(13, 'Garantir bom funcionamento e sistema xpto', 'active', '2026-10-02 11:43:02.368250', '2026-10-02 11:44:34.146563', 14, 9, 1, 0, 0.00),
(14, 'teste', 'active', '2026-10-06 09:44:49.139430', '2026-10-06 09:44:49.139430', 14, 8, 1, 0, 0.00),
(15, 'fssdfsdfsdfds', 'active', '2026-10-14 16:31:29.529154', '2026-10-14 16:31:29.529154', 15, 9, 1, 0, 0.00),
(16, 'Automatização de processo!', 'active', '2026-11-13 10:19:25.815246', '2026-11-13 10:23:49.310701', 17, 9, 1, 0, 20.00),
(19, 'Desenvolvimento de sistema de gestão acesso a INCV', 'active', '2026-11-16 10:34:55.755426', '2026-11-16 10:34:55.755426', 20, 9, 1, 0, 15.00),
(20, 'Documentação de processo de desenvolvimento de BI ou passaporte.', 'active', '2026-11-16 10:43:30.939822', '2026-11-16 10:43:30.939822', 20, 9, 1, 0, 85.00),
(21, 'Automatização do processo de gestão de acesso a INCV', 'active', '2026-11-24 11:28:04.111826', '2026-11-24 11:28:04.111826', 21, 9, 1, 1, 30.00),
(22, 'Reparação de servidores', 'active', '2026-11-24 11:44:34.191470', '2026-11-24 11:44:34.191470', 21, 9, 1, 1, 40.00),
(23, 'Gestão dos computadores com mais ano de funcionamento na INCV', 'active', '2026-11-25 11:37:37.110168', '2026-11-25 11:37:37.110168', 21, 9, 1, 1, 30.00),
(24, 'Garantir graxa para todos os funcionários da INCV', 'active', '2026-11-25 11:48:18.840070', '2026-11-25 11:48:18.840070', 21, 8, 1, 1, 30.00),
(25, 'Garantir juntos dos parceiro um espaço limpo e ambiente estável.', 'active', '2026-11-25 11:50:00.704472', '2026-11-25 11:50:00.704472', 21, 8, 1, 1, 30.00),
(26, 'XPTO objetivo', 'active', '2026-11-25 11:50:28.637620', '2026-11-25 11:50:28.637620', 21, 8, 1, 1, 40.00);

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_evaluation`
--

CREATE TABLE `core_evaluation` (
  `id` bigint(20) NOT NULL,
  `evaluation_type` varchar(10) NOT NULL,
  `status` varchar(15) NOT NULL,
  `self_score` decimal(4,1) DEFAULT NULL,
  `manager_score` decimal(4,1) DEFAULT NULL,
  `feedback` longtext NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `cycle_id` bigint(20) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `evaluator_id` int(11) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_followup`
--

CREATE TABLE `core_followup` (
  `id` bigint(20) NOT NULL,
  `entry_type` varchar(15) NOT NULL,
  `title` varchar(160) NOT NULL,
  `content` longtext NOT NULL,
  `next_step` varchar(220) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `author_id` int(11) DEFAULT NULL,
  `cycle_id` bigint(20) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `is_active` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_individualobjective`
--

CREATE TABLE `core_individualobjective` (
  `id` bigint(20) NOT NULL,
  `description` varchar(200) NOT NULL,
  `status` varchar(15) NOT NULL,
  `date_created` datetime(6) NOT NULL,
  `date_update` datetime(6) NOT NULL,
  `department_objective_id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `domain_id` bigint(20) DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL,
  `percentagem` decimal(5,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `core_individualobjective`
--

INSERT INTO `core_individualobjective` (`id`, `description`, `status`, `date_created`, `date_update`, `department_objective_id`, `user_id`, `domain_id`, `end_date`, `start_date`, `is_active`, `percentagem`) VALUES
(11, 'Fazer manutencao a cada 3 mes.', 'completed', '2026-10-02 11:45:57.597547', '2026-10-05 12:19:15.547732', 13, 5, NULL, '2026-10-03', '2026-10-01', 0, 10.00),
(12, 'xpto', 'active', '2026-10-05 10:31:42.409626', '2026-10-08 16:58:24.795292', 13, 9, NULL, '2026-10-13', '2026-10-05', 0, 5.00),
(13, 'Teste grupo colaborador', 'completed', '2026-10-05 12:20:54.458735', '2026-10-08 10:58:07.637536', 13, 5, NULL, '2026-10-31', '2026-10-05', 0, 80.00),
(14, 'xpto teste', 'completed', '2026-10-05 16:13:56.381893', '2026-10-05 16:22:00.054436', 13, 4, NULL, '2026-10-06', '2026-10-05', 0, 10.00),
(15, 'ok', 'completed', '2026-10-14 16:32:17.920135', '2026-10-15 11:31:27.967225', 15, 5, NULL, '2026-10-31', '2026-10-14', 0, 10.00),
(16, 'xpto 123', 'active', '2026-11-13 10:54:16.425655', '2026-11-13 11:22:32.371829', 16, 5, NULL, '2027-01-29', '2027-01-17', 0, 10.00),
(19, 'objetivo 1', 'completed', '2026-11-16 10:59:54.535431', '2026-11-16 11:29:17.410714', 19, 4, NULL, '2026-11-17', '2026-11-17', 0, 10.00),
(20, 'Limpar lixo de recido na BD', 'active', '2026-11-24 15:27:49.569570', '2026-11-24 15:27:49.569570', 22, 5, NULL, '2026-11-26', '2026-11-25', 1, 50.00),
(21, 'Fazer backup', 'active', '2026-11-24 15:28:41.221816', '2026-11-24 15:28:41.221816', 22, 9, NULL, '2026-11-26', '2026-11-25', 1, 50.00),
(23, 'objetivo xpto 02', 'active', '2026-11-25 15:37:10.373223', '2026-11-25 16:03:20.455655', 22, 4, NULL, '2026-11-26', '2026-11-25', 1, 10.00),
(24, 'objetivo xpto3', 'active', '2026-11-25 15:37:46.653521', '2026-11-25 16:08:50.947404', 21, 4, NULL, '2026-11-26', '2026-11-25', 1, 10.00);

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_institutionalobjective`
--

CREATE TABLE `core_institutionalobjective` (
  `id` bigint(20) NOT NULL,
  `description` varchar(200) NOT NULL,
  `status` varchar(15) NOT NULL,
  `date_created` datetime(6) NOT NULL,
  `date_update` datetime(6) NOT NULL,
  `cycle_id` bigint(20) NOT NULL,
  `domain_id` bigint(20) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `core_institutionalobjective`
--

INSERT INTO `core_institutionalobjective` (`id`, `description`, `status`, `date_created`, `date_update`, `cycle_id`, `domain_id`, `is_active`) VALUES
(14, 'Aumenta  lucro 20%', 'active', '2026-10-02 11:41:42.350585', '2026-10-02 11:41:42.350585', 33, 1, 0),
(15, 'xpto 26', 'active', '2026-10-14 16:30:50.289103', '2026-10-14 16:30:50.289103', 34, 1, 0),
(16, 'Aumento de lucro de 20%', 'active', '2026-10-19 11:06:57.173213', '2026-10-19 11:06:57.173213', 35, 1, 0),
(17, 'Implementação de ISO 90001', 'active', '2026-11-13 09:47:01.997926', '2026-11-13 09:47:01.997926', 36, 1, 0),
(20, 'Automatização de processos', 'active', '2026-11-16 10:17:14.825758', '2026-11-16 10:17:14.825758', 40, 1, 0),
(21, 'Implementação do ISO 9001', 'active', '2026-11-24 11:20:12.612470', '2026-11-24 11:20:12.612470', 41, 1, 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_objective`
--

CREATE TABLE `core_objective` (
  `id` bigint(20) NOT NULL,
  `category` varchar(20) NOT NULL,
  `title` varchar(160) NOT NULL,
  `description` longtext NOT NULL,
  `measure` varchar(220) NOT NULL,
  `status` varchar(15) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `cycle_id` bigint(20) NOT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_userdepartment`
--

CREATE TABLE `core_userdepartment` (
  `id` bigint(20) NOT NULL,
  `department_id` bigint(20) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `is_active` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `core_userdepartment`
--

INSERT INTO `core_userdepartment` (`id`, `department_id`, `user_id`, `is_active`) VALUES
(1, NULL, 1, 1),
(2, NULL, 2, 1),
(3, 1, 3, 1),
(14, 9, 4, 1),
(20, 9, 5, 1),
(23, 8, 8, 1),
(24, 9, 9, 1),
(25, NULL, 10, 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `core_validation`
--

CREATE TABLE `core_validation` (
  `id` bigint(20) NOT NULL,
  `role` varchar(15) NOT NULL,
  `status` varchar(15) NOT NULL,
  `comment` longtext NOT NULL,
  `validated_at` datetime(6) DEFAULT NULL,
  `cycle_id` bigint(20) NOT NULL,
  `evaluation_id` bigint(20) NOT NULL,
  `validator_id` int(11) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `django_admin_log`
--

INSERT INTO `django_admin_log` (`id`, `action_time`, `object_id`, `object_repr`, `action_flag`, `change_message`, `content_type_id`, `user_id`) VALUES
(1, '2026-09-28 15:19:57.616238', '8', 'Liziane.Monteiro', 1, '[{\"added\": {}}]', 4, 2),
(2, '2026-09-28 15:20:42.718727', '8', 'Liziane.Monteiro', 2, '[{\"changed\": {\"fields\": [\"First name\", \"Last name\", \"Email address\", \"Groups\"]}}, {\"changed\": {\"name\": \"departamento do utilizador\", \"object\": \"Liziane.Monteiro - INCV-URH - URH\", \"fields\": [\"Departamento\"]}}]', 4, 2),
(3, '2026-09-29 12:07:03.120369', '9', 'ivandro.g.Moniz', 1, '[{\"added\": {}}]', 4, 2),
(4, '2026-09-29 12:07:45.430555', '9', 'ivandro.g.Moniz', 2, '[{\"changed\": {\"fields\": [\"First name\", \"Last name\", \"Email address\", \"Groups\"]}}, {\"changed\": {\"name\": \"departamento do utilizador\", \"object\": \"ivandro.g.Moniz - INCV-USI - USI\", \"fields\": [\"Departamento\"]}}]', 4, 2),
(5, '2026-10-05 10:01:22.931736', '10', 'teste', 1, '[{\"added\": {}}]', 4, 2),
(6, '2026-10-05 12:18:35.615137', '5', 'aderito.b.monteiro', 2, '[{\"changed\": {\"fields\": [\"password\"]}}]', 4, 2),
(7, '2026-10-06 09:38:40.210194', '8', 'Liziane.Monteiro', 2, '[{\"changed\": {\"fields\": [\"Groups\"]}}]', 4, 2);

-- --------------------------------------------------------

--
-- Estrutura da tabela `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(3, 'auth', 'group'),
(2, 'auth', 'permission'),
(4, 'auth', 'user'),
(5, 'contenttypes', 'contenttype'),
(18, 'core', 'aprovacaotarefa'),
(7, 'core', 'cycle'),
(15, 'core', 'department'),
(12, 'core', 'departmentobjective'),
(17, 'core', 'domain'),
(8, 'core', 'evaluation'),
(9, 'core', 'followup'),
(20, 'core', 'historicooperacao'),
(13, 'core', 'individualobjective'),
(14, 'core', 'institutionalobjective'),
(10, 'core', 'objective'),
(19, 'core', 'registoocorrencia'),
(21, 'core', 'systemnotificationread'),
(16, 'core', 'userdepartment'),
(11, 'core', 'validation'),
(6, 'sessions', 'session');

-- --------------------------------------------------------

--
-- Estrutura da tabela `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2026-09-25 10:17:22.442763'),
(2, 'auth', '0001_initial', '2026-09-25 10:17:22.951747'),
(3, 'admin', '0001_initial', '2026-09-25 10:17:23.073539'),
(4, 'admin', '0002_logentry_remove_auto_add', '2026-09-25 10:17:23.091596'),
(5, 'admin', '0003_logentry_add_action_flag_choices', '2026-09-25 10:17:23.091596'),
(6, 'contenttypes', '0002_remove_content_type_name', '2026-09-25 10:17:23.161492'),
(7, 'auth', '0002_alter_permission_name_max_length', '2026-09-25 10:17:23.208646'),
(8, 'auth', '0003_alter_user_email_max_length', '2026-09-25 10:17:23.221608'),
(9, 'auth', '0004_alter_user_username_opts', '2026-09-25 10:17:23.234120'),
(10, 'auth', '0005_alter_user_last_login_null', '2026-09-25 10:17:23.323371'),
(11, 'auth', '0006_require_contenttypes_0002', '2026-09-25 10:17:23.323371'),
(12, 'auth', '0007_alter_validators_add_error_messages', '2026-09-25 10:17:23.342822'),
(13, 'auth', '0008_alter_user_username_max_length', '2026-09-25 10:17:23.370170'),
(14, 'auth', '0009_alter_user_last_name_max_length', '2026-09-25 10:17:23.391784'),
(15, 'auth', '0010_alter_group_name_max_length', '2026-09-25 10:17:23.404941'),
(16, 'auth', '0011_update_proxy_permissions', '2026-09-25 10:17:23.411693'),
(17, 'auth', '0012_alter_user_first_name_max_length', '2026-09-25 10:17:23.421497'),
(18, 'core', '0001_initial', '2026-09-25 10:17:23.622934'),
(19, 'core', '0002_followup_objective_validation', '2026-09-25 10:17:24.183576'),
(20, 'core', '0003_departmentobjective_individualobjective_and_more', '2026-09-25 10:17:24.480733'),
(21, 'core', '0004_department_departmentobjective_department', '2026-09-25 10:17:24.630800'),
(22, 'core', '0005_remove_department_manager_userdepartment', '2026-09-25 10:17:26.171784'),
(23, 'sessions', '0001_initial', '2026-09-25 10:17:26.202930'),
(24, 'core', '0006_domain', '2026-09-25 15:01:16.701651'),
(25, 'core', '0007_departmentobjective_domain_and_more', '2026-09-25 15:10:54.553441'),
(26, 'core', '0008_institutionalobjective_domain', '2026-09-25 15:22:07.553858'),
(27, 'core', '0009_cycle_domain', '2026-09-28 09:51:45.503486'),
(28, 'core', '0010_assign_open_domain_to_existing_cycles', '2026-09-28 10:43:26.557282'),
(29, 'core', '0011_assign_open_domain_to_existing_institutional_objectives', '2026-09-28 10:53:34.278642'),
(30, 'core', '0012_assign_open_domain_to_existing_department_objectives', '2026-09-28 11:27:26.123029'),
(31, 'core', '0013_create_rh_group', '2026-09-28 15:25:31.616193'),
(32, 'core', '0014_aprovacaotarefa_departmentobjective_aprovacao_tarefa', '2026-10-01 13:39:38.165653'),
(33, 'core', '0015_move_department_approval_to_history', '2026-10-01 15:52:14.721808'),
(34, 'core', '0016_individualobjective_end_date_and_more', '2026-10-05 10:30:27.918465'),
(35, 'core', '0017_ensure_collaborator_group', '2026-10-05 12:16:23.064499'),
(36, 'core', '0018_registoocorrencia', '2026-10-05 12:57:31.269467'),
(37, 'core', '0019_aprovacaotarefa_is_active_cycle_is_active_and_more', '2026-10-06 11:24:56.213704'),
(38, 'core', '0020_individualobjective_percentagem', '2026-10-08 10:36:13.275866'),
(39, 'core', '0021_departmentobjective_percentagem', '2026-11-13 10:10:36.799377'),
(40, 'core', '0022_historicooperacao', '2026-11-13 11:20:08.657028'),
(41, 'core', '0023_alter_historicooperacao_acao', '2026-11-13 11:21:07.800616'),
(42, 'core', '0024_systemnotificationread', '2026-11-24 12:42:25.192872');

-- --------------------------------------------------------

--
-- Estrutura da tabela `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('01vfi7ad73q8a1mlmjb3h4m730qy1g4b', '.eJxVjMsOwiAQRf-FtSHAlEJduvcbyAwzSNXQpI-V8d-1SRe6veec-1IJt7WmbZE5jazOqlOn340wP6TtgO_YbpPOU1vnkfSu6IMu-jqxPC-H-3dQcanfGiEOQ-ktROiL8yxOOiAbyAt7ATYkIYOj0AFGEzM6RhOjG2woZI1V7w_eUTed:1xA5PD:oqGl5yk4WFOX3JyUIeqa15nkuUCTzIanGwN9lc6naW4', '2026-10-09 12:51:59.683427'),
('0c9grx4uod9uu34v9ffxfyvpkynfful3', '.eJxVjEEOwiAQRe_C2hAgBGZcuvcMZBimUjWQlHZlvLs26UK3_733XyrRtta0DVnSXNRZOXX63TLxQ9oOyp3arWvubV3mrHdFH3Toay_yvBzu30GlUb81ElDwFgJZClG4GDu5iOCMIAJYF0P2JQsFm11GNrFMIGAjMnoTWL0_0-83iw:1xEliB:SXLDnjgQZccCiqloCA-XWttXlgKxJilUzeK1gxTLsGk', '2026-10-22 10:50:55.635001'),
('1gt8veuubzaqvshadpt6i3aeicsifzcn', '.eJxVjMsOgjAQRf-la9MURhjq0j3f0EznIaiBhMLK-O9KwkK395xzXy7Rtg5pK7qkUdzFgTv9bpn4odMO5E7TbfY8T-syZr8r_qDF97Po83q4fwcDleFbY6cQGJEl5y6GBtG6swWsENWABbQ21LZhaOu6sigamUwlguZgQO79Ae0GOLI:1xErXQ:As5SI1_mIi1GyzOREan_tebNFcMIHNZVv58M35dXTPQ', '2026-10-22 17:04:12.881940'),
('324nbjtihe57zx3yiy6bc6zcnivxyihy', '.eJxVjEEOwiAQRe_C2hAgBGZcuvcMZBimUjWQlHZlvLs26UK3_733XyrRtta0DVnSXNRZOXX63TLxQ9oOyp3arWvubV3mrHdFH3Toay_yvBzu30GlUb81ElDwFgJZClG4GDu5iOCMIAJYF0P2JQsFm11GNrFMIGAjMnoTWL0_0-83iw:1xBVHl:I3S95Z7xbPqoKhccvTvKnmTmoTYNLtAHQg5vwtMBNSo', '2026-10-13 10:42:09.883452'),
('391ccrw7jh1hq7uzlwjq7m5udko11rnv', '.eJxVjM0OwiAQhN-FsyFlsfx49O4zkIVdpGogKe3J-O62SQ96nPm-mbcIuC4lrJ3nMJG4iFGcfruI6cl1B_TAem8ytbrMU5S7Ig_a5a0Rv66H-3dQsJdtzZ7jgM4Qnq0Cmx2NKpOKPoNToDN4k71TVqstGQcDW02GwEZvNCYUny_cBDdS:1xDiLu:gwl1QSL7k9wZRFO9l2rj2N9faqaHnvPHTGqypuVgZKs', '2026-10-19 13:03:34.912520'),
('3loll6ylpge905k4b0st1hum1x0vzr1u', '.eJxVjE0OwiAYBe_C2hBKgYJL956BfD8gVQNJaVfGu2uTLnT7Zua9RIRtLXHraYkzi7Pw4vS7IdAj1R3wHeqtSWp1XWaUuyIP2uW1cXpeDvfvoEAv39pYCzaRM2F0IzIlF2D0Ok-IZJUGGlRgzFoZYjKDVj6T0YFd4MkiJ_H-AO_pOGQ:1xCJuy:HULvOFiH-oG0xWoLlWywEOzfziSLrdNLwcYZzuLwDNw', '2026-10-15 16:46:00.777682'),
('3lp73lcwwmzuy1rai1zt84jejcdchw8j', '.eJxVjMsOgjAQRf-la9MURhjq0j3f0EznIaiBhMLK-O9KwkK395xzXy7Rtg5pK7qkUdzFgTv9bpn4odMO5E7TbfY8T-syZr8r_qDF97Po83q4fwcDleFbY6cQGJEl5y6GBtG6swWsENWABbQ21LZhaOu6sigamUwlguZgQO79Ae0GOLI:1xBD6l:eJ9Fx0JLvdt1XBdSlUyXsgdYDM62veybORbkpbNxUfE', '2026-10-12 15:17:35.552633'),
('3mtgchoj0n4ca8mgh9rzodbcqx1k2ntv', '.eJxVjEEOgjAQRe_StWlahjKtS_ecoZnptIIaSCisjHcXEha6_e-9_1aRtnWIW81LHEVdlVWX340pPfN0AHnQdJ91mqd1GVkfij5p1f0s-XU73b-Dgeqw16Gz3kBBxiah46bNaEtLDkmEGFzwYgJDSyFRFijEBi3kvYHOC3r1-QLeXzfY:1xDfb8:HlQWLeKCrRsPpWqAZ3gvWj5YVQAZR5122rFLtmXiXHs', '2026-10-19 10:07:06.838065'),
('3ykhcvwobb20h93q1mzw8amegaj45ahz', '.eJxVjMsOgjAQRf-la9MURhjq0j3f0EznIaiBhMLK-O9KwkK395xzXy7Rtg5pK7qkUdzFgTv9bpn4odMO5E7TbfY8T-syZr8r_qDF97Po83q4fwcDleFbY6cQGJEl5y6GBtG6swWsENWABbQ21LZhaOu6sigamUwlguZgQO79Ae0GOLI:1xErWV:K_7k8eBcrsBJoZ9CGwX87Yqf0ym6QDRPeMR_6nzdEUU', '2026-10-22 17:03:15.024427'),
('44zv19ea50t3nx01ejinth1z95ggi5x4', '.eJxVjMsOgjAQRf-la9MURhjq0j3f0EznIaiBhMLK-O9KwkK395xzXy7Rtg5pK7qkUdzFgTv9bpn4odMO5E7TbfY8T-syZr8r_qDF97Po83q4fwcDleFbY6cQGJEl5y6GBtG6swWsENWABbQ21LZhaOu6sigamUwlguZgQO79Ae0GOLI:1xB8YG:aU5jbIdvP7_ArJj2a4qSE7I-0VMnK_RFekH_mArVqv0', '2026-10-12 10:25:40.162500'),
('56vsi2c28nzxc54ayjekaoko87ukzqdc', '.eJxVjMsOwiAQRf-FtSHAlEJduvcbyAwzSNXQpI-V8d-1SRe6veec-1IJt7WmbZE5jazOqlOn340wP6TtgO_YbpPOU1vnkfSu6IMu-jqxPC-H-3dQcanfGiEOQ-ktROiL8yxOOiAbyAt7ATYkIYOj0AFGEzM6RhOjG2woZI1V7w_eUTed:1xB9WO:awlmPv4y4YAsB9TocyNv8pxKvRY2j27m4tLbYywXu-8', '2026-10-12 11:27:48.736347'),
('5barjbez12onvedydltet5kaq909jyid', '.eJxVjEEOgjAQRe_StWlahjKtS_ecoZnptIIaSCisjHcXEha6_e-9_1aRtnWIW81LHEVdlVWX340pPfN0AHnQdJ91mqd1GVkfij5p1f0s-XU73b-Dgeqw16Gz3kBBxiah46bNaEtLDkmEGFzwYgJDSyFRFijEBi3kvYHOC3r1-QLeXzfY:1xBUEv:vyBxESsfPCbgKv0YZGdT_2PjGq8qpL6jdjTum5ox13w', '2026-10-13 09:35:09.891773'),
('5s922vwbsoyjnnyxoimylk5bvni41q4i', '.eJxVjMsOgjAQRf-la9MURhjq0j3f0EznIaiBhMLK-O9KwkK395xzXy7Rtg5pK7qkUdzFgTv9bpn4odMO5E7TbfY8T-syZr8r_qDF97Po83q4fwcDleFbY6cQGJEl5y6GBtG6swWsENWABbQ21LZhaOu6sigamUwlguZgQO79Ae0GOLI:1xErbg:ySNncVpBFZtYVd2_FNa0OTTn-jq_4EFLOU7HF_LRXXI', '2026-10-22 17:08:36.076818'),
('5xj12lh2p5bzy3a32dlvqtykxg7ow25v', '.eJxVjMsOwiAQRf-FtSHAlEJduvcbyAwzSNXQpI-V8d-1SRe6veec-1IJt7WmbZE5jazOqlOn340wP6TtgO_YbpPOU1vnkfSu6IMu-jqxPC-H-3dQcanfGiEOQ-ktROiL8yxOOiAbyAt7ATYkIYOj0AFGEzM6RhOjG2woZI1V7w_eUTed:1xCJ5Z:7L1un8Lbvxs7JagkFlSQ73T9_o9wy4Tc3dn0U7In0c8', '2026-10-15 15:52:53.707938'),
('66bwurirx8panoksvswdm354t0hjm1s5', '.eJxVjEEOwiAQRe_C2pCZCjh16d4zkIEBqRpISrsy3l2bdKHb_977L-V5XYpfe5r9JOqsrDr8boHjI9UNyJ3rrenY6jJPQW-K3mnX1ybpedndv4PCvXxrPmYWYMCcaMyBxJLDkbMhiAQUQ7boDKKxPNjEJCeH0cGAmaMTA-r9AfcjN_c:1xDhck:z6Q4Uglz1mqSXsIYlVJMthD1Ae1E63GppfQ_kPuzPc8', '2026-10-19 12:16:54.731473'),
('6cli7e3i7629n8babcyq7q3b2ficpr5n', '.eJxVjMsOgjAQRf-la9MURhjq0j3f0EznIaiBhMLK-O9KwkK395xzXy7Rtg5pK7qkUdzFgTv9bpn4odMO5E7TbfY8T-syZr8r_qDF97Po83q4fwcDleFbY6cQGJEl5y6GBtG6swWsENWABbQ21LZhaOu6sigamUwlguZgQO79Ae0GOLI:1xElZR:KLZxDRCAeZOpquXCM6d7qmzTk_qMq_wYgUSOxKGL6-8', '2026-10-22 10:41:53.179135'),
('71kpjjpmfd9rdq0b85okd9rchs82wzqv', '.eJxVjE0OwiAYBe_C2hBKgYJL956BfD8gVQNJaVfGu2uTLnT7Zua9RIRtLXHraYkzi7Pw4vS7IdAj1R3wHeqtSWp1XWaUuyIP2uW1cXpeDvfvoEAv39pYCzaRM2F0IzIlF2D0Ok-IZJUGGlRgzFoZYjKDVj6T0YFd4MkiJ_H-AO_pOGQ:1xCJYS:ZPwdxQrxAwyJUG_HUU9Eu3furirYZcy9k3Cwt7p8adE', '2026-10-15 16:22:44.070134'),
('740t8vm1gwfz4ajjn58z226b198n9jcb', '.eJxVjMsOgjAQRf-la9MURhjq0j3f0EznIaiBhMLK-O9KwkK395xzXy7Rtg5pK7qkUdzFgTv9bpn4odMO5E7TbfY8T-syZr8r_qDF97Po83q4fwcDleFbY6cQGJEl5y6GBtG6swWsENWABbQ21LZhaOu6sigamUwlguZgQO79Ae0GOLI:1xA59t:1r63HUvTE-BzYaPQqAm6iUcRfHhA7I8PNrYmKRDHhSE', '2026-10-09 12:36:09.648456'),
('7cecg22oahxvgkyr5xhtlliehkzziuzi', '.eJxVjEEOwiAQRe_C2pCZCjh16d4zkIEBqRpISrsy3l2bdKHb_977L-V5XYpfe5r9JOqsrDr8boHjI9UNyJ3rrenY6jJPQW-K3mnX1ybpedndv4PCvXxrPmYWYMCcaMyBxJLDkbMhiAQUQ7boDKKxPNjEJCeH0cGAmaMTA-r9AfcjN_c:1xDhcG:UbmqNynBWhL635MqqKHhrfj0gbj3bijs2ijPTOVF0Fw', '2026-10-19 12:16:24.850172'),
('7i18sx85fmnb86u4n0lsb9m4u5ek6wyq', '.eJxVjE0OwiAYBe_C2hBKgYJL956BfD8gVQNJaVfGu2uTLnT7Zua9RIRtLXHraYkzi7Pw4vS7IdAj1R3wHeqtSWp1XWaUuyIP2uW1cXpeDvfvoEAv39pYCzaRM2F0IzIlF2D0Ok-IZJUGGlRgzFoZYjKDVj6T0YFd4MkiJ_H-AO_pOGQ:1xBX1b:SfnNmNe1vA5GOyFaQ3H3txvSEl65Nld8kjWG4Iqs37U', '2026-10-13 12:33:35.710021'),
('852l6wqnnsjm4szwesh385rvxg2j4qrg', '.eJxVjMsOgjAQRf-la9MURhjq0j3f0EznIaiBhMLK-O9KwkK395xzXy7Rtg5pK7qkUdzFgTv9bpn4odMO5E7TbfY8T-syZr8r_qDF97Po83q4fwcDleFbY6cQGJEl5y6GBtG6swWsENWABbQ21LZhaOu6sigamUwlguZgQO79Ae0GOLI:1xA57y:sw-iM4TI1NQJ5EF9_4FlDhqYWlS2sebCBx9z-9y4E28', '2026-10-09 12:34:10.011769'),
('8ad700kb5ao6snc6h9f2oe0vgohavlpy', '.eJxVjMsOgjAQRf-la9MURhjq0j3f0EznIaiBhMLK-O9KwkK395xzXy7Rtg5pK7qkUdzFgTv9bpn4odMO5E7TbfY8T-syZr8r_qDF97Po83q4fwcDleFbY6cQGJEl5y6GBtG6swWsENWABbQ21LZhaOu6sigamUwlguZgQO79Ae0GOLI:1xErdj:eWusT2kN3njMgw7aYrH4RbeokIGOvhb-R-dGQB9C8NE', '2026-10-22 17:10:43.709991'),
('8hhlu3oopja8ifoxb13vva6zm1okeegh', '.eJxVjMsOgjAQRf-la9MURhjq0j3f0EznIaiBhMLK-O9KwkK395xzXy7Rtg5pK7qkUdzFgTv9bpn4odMO5E7TbfY8T-syZr8r_qDF97Po83q4fwcDleFbY6cQGJEl5y6GBtG6swWsENWABbQ21LZhaOu6sigamUwlguZgQO79Ae0GOLI:1xCJzl:5n7XlhAxb3xfWemECq-vHgUao7Q_EM7UMwMoW3PfJBA', '2026-10-15 16:50:57.263328'),
('8jsrgv0qh9iksad4g66q9j7ke0mlmakf', '.eJxVjE0OwiAYBe_C2hBKgYJL956BfD8gVQNJaVfGu2uTLnT7Zua9RIRtLXHraYkzi7Pw4vS7IdAj1R3wHeqtSWp1XWaUuyIP2uW1cXpeDvfvoEAv39pYCzaRM2F0IzIlF2D0Ok-IZJUGGlRgzFoZYjKDVj6T0YFd4MkiJ_H-AO_pOGQ:1xCJVd:8_eWtY0KGlZcJZod3_83P2FHoUFzi_40WKjXu0BpSXs', '2026-10-15 16:19:49.634638'),
('91203hktath7r45ja4d5u02c5ubalqsu', '.eJxVjMsOgjAQRf-la9MURhjq0j3f0EznIaiBhMLK-O9KwkK395xzXy7Rtg5pK7qkUdzFgTv9bpn4odMO5E7TbfY8T-syZr8r_qDF97Po83q4fwcDleFbY6cQGJEl5y6GBtG6swWsENWABbQ21LZhaOu6sigamUwlguZgQO79Ae0GOLI:1xCJ5K:OdSIj9asXQQfNX_s1cZ-pu1TmJr1GAXDH5qWaXmmRWQ', '2026-10-15 15:52:38.664756'),
('9fja2xzk9yc6pl8h3fw5ss528cyp7pzd', '.eJxVjMsOgjAQRf-la9MURhjq0j3f0EznIaiBhMLK-O9KwkK395xzXy7Rtg5pK7qkUdzFgTv9bpn4odMO5E7TbfY8T-syZr8r_qDF97Po83q4fwcDleFbY6cQGJEl5y6GBtG6swWsENWABbQ21LZhaOu6sigamUwlguZgQO79Ae0GOLI:1xDlIH:xD7vmd4AP0kZ7aGyN8McbLRkgbfZHlKPYjnRzssJgms', '2026-10-19 16:12:01.417993'),
('a5p2wzbg8mehegeitwjluo63pyjpu2q9', '.eJxVjEEOwiAQRe_C2hAgBGZcuvcMZBimUjWQlHZlvLs26UK3_733XyrRtta0DVnSXNRZOXX63TLxQ9oOyp3arWvubV3mrHdFH3Toay_yvBzu30GlUb81ElDwFgJZClG4GDu5iOCMIAJYF0P2JQsFm11GNrFMIGAjMnoTWL0_0-83iw:1xGxdY:cbRftYWAJsU3jHHltRbvCkom98ZRWSmCX38U95iIuQU', '2026-10-28 11:59:12.063453'),
('aj41os1dzwx6h0kr7prb48haqy5cloxd', '.eJxVjE0OwiAYBe_C2hBKgYJL956BfD8gVQNJaVfGu2uTLnT7Zua9RIRtLXHraYkzi7Pw4vS7IdAj1R3wHeqtSWp1XWaUuyIP2uW1cXpeDvfvoEAv39pYCzaRM2F0IzIlF2D0Ok-IZJUGGlRgzFoZYjKDVj6T0YFd4MkiJ_H-AO_pOGQ:1xDkQX:99Eh-CN8mvV6aflEbDodumMdLrLotraUX43GgYTKsA0', '2026-10-19 15:16:29.470421'),
('ajzhsbawjb5bh800zj45kb66ttewen01', '.eJxVjMsOwiAQRf-FtSHAlEJduvcbyAwzSNXQpI-V8d-1SRe6veec-1IJt7WmbZE5jazOqlOn340wP6TtgO_YbpPOU1vnkfSu6IMu-jqxPC-H-3dQcanfGiEOQ-ktROiL8yxOOiAbyAt7ATYkIYOj0AFGEzM6RhOjG2woZI1V7w_eUTed:1xB9hV:DNP-Qq8VL1ML68KyqkKgE60LX1556SlZbDffG0CR31Y', '2026-10-12 11:39:17.275089'),
('akb854563o1g27kllh2lo2y7ob9oyg2u', '.eJxVjMsOgjAQRf-la9MURhjq0j3f0EznIaiBhMLK-O9KwkK395xzXy7Rtg5pK7qkUdzFgTv9bpn4odMO5E7TbfY8T-syZr8r_qDF97Po83q4fwcDleFbY6cQGJEl5y6GBtG6swWsENWABbQ21LZhaOu6sigamUwlguZgQO79Ae0GOLI:1xA4qp:6xctgrmIhy--P8prvuc4oP6BjsktPNFlEMwUgP1JcHw', '2026-10-09 12:16:27.630938'),
('c6neet1ohdjlp0pg6r8f1211n9gof9k8', '.eJxVjMsOgjAUBf-la9O0lV5al-75BnJfWNRAQmFl_HclYaHbMzPnZXrc1tJvVZd-FHMxYE6_GyE_dNqB3HG6zZbnaV1GsrtiD1ptN4s-r4f7d1Cwlm_dJGZ0g6rIQATSJmCP7HIKUZ2ShJbAA3PGxgdsY0wexdM5xgZcDub9AR1COFo:1xA4Un:4IwO-LYzNYUHT098dE0YMPK2C021luXece7w_3jdSu8', '2026-10-09 11:53:41.348837'),
('cam20jdpedugsqxs7instm7l2fj25v6q', '.eJxVjE0OwiAYBe_C2hBKgYJL956BfD8gVQNJaVfGu2uTLnT7Zua9RIRtLXHraYkzi7Pw4vS7IdAj1R3wHeqtSWp1XWaUuyIP2uW1cXpeDvfvoEAv39pYCzaRM2F0IzIlF2D0Ok-IZJUGGlRgzFoZYjKDVj6T0YFd4MkiJ_H-AO_pOGQ:1xDiT6:roe6k_CObAWKNEWY7XnAImwWl9oNz7IeqkPezpPx_b4', '2026-10-19 13:11:00.577429'),
('d8zy23xmz5bee9d2hprmi2h5vn1c20wm', '.eJxVjM0OwiAQhN-FsyFlsfx49O4zkIVdpGogKe3J-O62SQ96nPm-mbcIuC4lrJ3nMJG4iFGcfruI6cl1B_TAem8ytbrMU5S7Ig_a5a0Rv66H-3dQsJdtzZ7jgM4Qnq0Cmx2NKpOKPoNToDN4k71TVqstGQcDW02GwEZvNCYUny_cBDdS:1xDiMM:8orsPlHFLgs7IWPFR8G7F-VCPb150TqOmFJCGEHLJWA', '2026-10-19 13:04:02.435183'),
('dg8jv4040zkb6w33pd1si94n3pfdhwqy', '.eJxVjMsOgjAQRf-la9MURhjq0j3f0EznIaiBhMLK-O9KwkK395xzXy7Rtg5pK7qkUdzFgTv9bpn4odMO5E7TbfY8T-syZr8r_qDF97Po83q4fwcDleFbY6cQGJEl5y6GBtG6swWsENWABbQ21LZhaOu6sigamUwlguZgQO79Ae0GOLI:1xErfk:Rp9EbEzSN8UcTRK_cJUkty4Yz7ekIPNfC1RYqnWXqkI', '2026-10-22 17:12:48.068129'),
('dmi69vfgibd7yox6k0uyuveoew0h05zc', '.eJxVjE0OwiAYBe_C2hBKgYJL956BfD8gVQNJaVfGu2uTLnT7Zua9RIRtLXHraYkzi7Pw4vS7IdAj1R3wHeqtSWp1XWaUuyIP2uW1cXpeDvfvoEAv39pYCzaRM2F0IzIlF2D0Ok-IZJUGGlRgzFoZYjKDVj6T0YFd4MkiJ_H-AO_pOGQ:1xCG9C:LwddUKipvmE52w_DyctJ6B-2LsiOa4LsjXFzs9VdoVg', '2026-10-15 12:44:26.181654'),
('dp7j87izbej8lyjcb36gksugldfgmnc8', '.eJxVjMsOgjAQRf-la9MURhjq0j3f0EznIaiBhMLK-O9KwkK395xzXy7Rtg5pK7qkUdzFgTv9bpn4odMO5E7TbfY8T-syZr8r_qDF97Po83q4fwcDleFbY6cQGJEl5y6GBtG6swWsENWABbQ21LZhaOu6sigamUwlguZgQO79Ae0GOLI:1xBD6Y:s04hxXcYHVIZctCPGyYSpN4fpwZkK-2cNlvL2jsNjNs', '2026-10-12 15:17:22.247130'),
('dtglelal0ta063mw2329po3a7zjeeshz', '.eJxVjMsOgjAQRf-la9MURhjq0j3f0EznIaiBhMLK-O9KwkK395xzXy7Rtg5pK7qkUdzFgTv9bpn4odMO5E7TbfY8T-syZr8r_qDF97Po83q4fwcDleFbY6cQGJEl5y6GBtG6swWsENWABbQ21LZhaOu6sigamUwlguZgQO79Ae0GOLI:1xErQh:Tzi2ZaWcOKJ5AuvmC0MtW3LOTN2T-KQstfxL_a9Cp-I', '2026-10-22 16:57:15.981698'),
('e1h4i87qn2yo70fobhy02j8lholg1kcz', '.eJxVjMsOgjAQRf-la9MURhjq0j3f0EznIaiBhMLK-O9KwkK395xzXy7Rtg5pK7qkUdzFgTv9bpn4odMO5E7TbfY8T-syZr8r_qDF97Po83q4fwcDleFbY6cQGJEl5y6GBtG6swWsENWABbQ21LZhaOu6sigamUwlguZgQO79Ae0GOLI:1xDlMh:XW52pIKz6kcGOXMk-AqQKyMUkmTz4JpANCLLxqwSpEA', '2026-10-19 16:16:35.957958'),
('e2eza2e4thdg94dk66xi7knfe0hs6jg1', '.eJxVjMsOwiAQRf-FtSHAlEJduvcbyAwzSNXQpI-V8d-1SRe6veec-1IJt7WmbZE5jazOqlOn340wP6TtgO_YbpPOU1vnkfSu6IMu-jqxPC-H-3dQcanfGiEOQ-ktROiL8yxOOiAbyAt7ATYkIYOj0AFGEzM6RhOjG2woZI1V7w_eUTed:1xB9dP:V1oed1b2ER28M91e9hxICh81Unfl_qIYxxEmOv1eF6o', '2026-10-12 11:35:03.156697'),
('e6merub5q9z3fe1pw3zysovgoxmp3huv', '.eJxVjMsOwiAQRf-FtSHAlEJduvcbyAwzSNXQpI-V8d-1SRe6veec-1IJt7WmbZE5jazOqlOn340wP6TtgO_YbpPOU1vnkfSu6IMu-jqxPC-H-3dQcanfGiEOQ-ktROiL8yxOOiAbyAt7ATYkIYOj0AFGEzM6RhOjG2woZI1V7w_eUTed:1xBA1p:uoBJLi1miatzCxzfBKj4kW_bTfJcijYPJtYE_P2Q3H0', '2026-10-12 12:00:17.542664'),
('e7z0j74hebpi3w3twlrk2igo18od435e', '.eJxVjMsOwiAQRf-FtSHAlEJduvcbyAwzSNXQpI-V8d-1SRe6veec-1IJt7WmbZE5jazOqlOn340wP6TtgO_YbpPOU1vnkfSu6IMu-jqxPC-H-3dQcanfGiEOQ-ktROiL8yxOOiAbyAt7ATYkIYOj0AFGEzM6RhOjG2woZI1V7w_eUTed:1xB9k9:HN74L1R4-Lj5YJcK3FTPrCtZVG884bhA3bSEFuRWjLI', '2026-10-12 11:42:01.146001'),
('fuoul9nw9edx3116p9x862e2u22c4kd2', '.eJxVjMsOwiAQRf-FtSHAlEJduvcbyAwzSNXQpI-V8d-1SRe6veec-1IJt7WmbZE5jazOqlOn340wP6TtgO_YbpPOU1vnkfSu6IMu-jqxPC-H-3dQcanfGiEOQ-ktROiL8yxOOiAbyAt7ATYkIYOj0AFGEzM6RhOjG2woZI1V7w_eUTed:1xDlIH:qcbvyDZ_V-5H8MWfz2X0B9MhHeJi4rHZi6TOP4FYyvc', '2026-10-19 16:12:01.593561'),
('fvjtu6yom6d319qvfdnyg7vmzvls60zo', '.eJxVjE0OwiAYBe_C2hBKgYJL956BfD8gVQNJaVfGu2uTLnT7Zua9RIRtLXHraYkzi7Pw4vS7IdAj1R3wHeqtSWp1XWaUuyIP2uW1cXpeDvfvoEAv39pYCzaRM2F0IzIlF2D0Ok-IZJUGGlRgzFoZYjKDVj6T0YFd4MkiJ_H-AO_pOGQ:1xCG4H:XmzxtgORH4l_RRknW4gKr9_8xtDWYMxSkbObTOLgZPM', '2026-10-15 12:39:21.291659'),
('gg2ddeml85u3jqy8kn8ia4ygi5bzdbh1', '.eJxVjMsOgjAQRf-la9MURhjq0j3f0EznIaiBhMLK-O9KwkK395xzXy7Rtg5pK7qkUdzFgTv9bpn4odMO5E7TbfY8T-syZr8r_qDF97Po83q4fwcDleFbY6cQGJEl5y6GBtG6swWsENWABbQ21LZhaOu6sigamUwlguZgQO79Ae0GOLI:1xB81g:hMCM6iJTpoSa6qxEh5Jc9SQwNHtA7PsWk2bOx8LeGic', '2026-10-12 09:52:00.788264'),
('h5cm0shtct0j87wltzz8yh42jmgavfjn', '.eJxVjE0OwiAYBe_C2hBKgYJL956BfD8gVQNJaVfGu2uTLnT7Zua9RIRtLXHraYkzi7Pw4vS7IdAj1R3wHeqtSWp1XWaUuyIP2uW1cXpeDvfvoEAv39pYCzaRM2F0IzIlF2D0Ok-IZJUGGlRgzFoZYjKDVj6T0YFd4MkiJ_H-AO_pOGQ:1xCG9p:8fYD-uv086ArbTu3UpN9EGItTzKVTqPmxcQlQOoOnTg', '2026-10-15 12:45:05.051741'),
('hd7ozt7w9199gzou0c745cpypvjbqj62', '.eJxVjMsOgjAQRf-la9MURhjq0j3f0EznIaiBhMLK-O9KwkK395xzXy7Rtg5pK7qkUdzFgTv9bpn4odMO5E7TbfY8T-syZr8r_qDF97Po83q4fwcDleFbY6cQGJEl5y6GBtG6swWsENWABbQ21LZhaOu6sigamUwlguZgQO79Ae0GOLI:1xB8C7:opfmjWvsDoEg_lab5y54fdqSHsHYNZc3PZEZnIqX7yw', '2026-10-12 10:02:47.847454'),
('hsa991vp8nuw6515juh7a987r3nuc778', '.eJxVjEEOwiAQRe_C2hAgBGZcuvcMZBimUjWQlHZlvLs26UK3_733XyrRtta0DVnSXNRZOXX63TLxQ9oOyp3arWvubV3mrHdFH3Toay_yvBzu30GlUb81ElDwFgJZClG4GDu5iOCMIAJYF0P2JQsFm11GNrFMIGAjMnoTWL0_0-83iw:1xH0hy:EuHiazPIAOcApTYVpY2SAi2FzLi573CavddAdxzQOoc', '2026-10-28 15:15:58.348130'),
('io7clrfsf1pcpqxhha2ra8l09a7c3xa6', '.eJxVjMsOwiAQRf-FtSHAlEJduvcbyAwzSNXQpI-V8d-1SRe6veec-1IJt7WmbZE5jazOqlOn340wP6TtgO_YbpPOU1vnkfSu6IMu-jqxPC-H-3dQcanfGiEOQ-ktROiL8yxOOiAbyAt7ATYkIYOj0AFGEzM6RhOjG2woZI1V7w_eUTed:1xDiT6:UsTM0q13TuVh_VTZMfepZQ_hV_E-Fu1XO5E842pHXls', '2026-10-19 13:11:00.363247'),
('jygrnj6szfk6nta0c9cosu7oaqq51lcw', '.eJxVjEEOgjAQRe_StWlahjKtS_ecoZnptIIaSCisjHcXEha6_e-9_1aRtnWIW81LHEVdlVWX340pPfN0AHnQdJ91mqd1GVkfij5p1f0s-XU73b-Dgeqw16Gz3kBBxiah46bNaEtLDkmEGFzwYgJDSyFRFijEBi3kvYHOC3r1-QLeXzfY:1xBUEU:y1M6qKrHFko3eCFdclZcgQCPJVRoFjROIqIEyKFpWT8', '2026-10-13 09:34:42.232267'),
('k80oguo5ri7uvgq4rny3wle5yvequs3o', '.eJxVjMsOgjAQRf-la9MURhjq0j3f0EznIaiBhMLK-O9KwkK395xzXy7Rtg5pK7qkUdzFgTv9bpn4odMO5E7TbfY8T-syZr8r_qDF97Po83q4fwcDleFbY6cQGJEl5y6GBtG6swWsENWABbQ21LZhaOu6sigamUwlguZgQO79Ae0GOLI:1xB8zS:nEx6_LhFjVS0EUyP49lqSSV2GzeYtHE2VAHZmwUuXYA', '2026-10-12 10:53:46.508770'),
('k8fby48alsid6gegg3gzffu12r0qmd4o', '.eJxVjEEOwiAQRe_C2hAgBGZcuvcMZBimUjWQlHZlvLs26UK3_733XyrRtta0DVnSXNRZOXX63TLxQ9oOyp3arWvubV3mrHdFH3Toay_yvBzu30GlUb81ElDwFgJZClG4GDu5iOCMIAJYF0P2JQsFm11GNrFMIGAjMnoTWL0_0-83iw:1xBWrA:bPhV9mILKljrYchDuGqn0Rb8DB-jAHYCTj0_w2qrFnw', '2026-10-13 12:22:48.361208'),
('kex9uhhjj8xbm4jwqjwpqt38jexn58m7', '.eJxVjEEOwiAQRe_C2hAgBGZcuvcMZBimUjWQlHZlvLs26UK3_733XyrRtta0DVnSXNRZOXX63TLxQ9oOyp3arWvubV3mrHdFH3Toay_yvBzu30GlUb81ElDwFgJZClG4GDu5iOCMIAJYF0P2JQsFm11GNrFMIGAjMnoTWL0_0-83iw:1xDheN:ZSD2YAn6SbBLs2TstnPiAQiJmx2kXxtDWdAdRszpyEA', '2026-10-19 12:18:35.626265'),
('khrp8fkt26bwy9cy6katejrllhhk1har', '.eJxVjEEOgjAQRe_StWlahjKtS_ecoZnptIIaSCisjHcXEha6_e-9_1aRtnWIW81LHEVdlVWX340pPfN0AHnQdJ91mqd1GVkfij5p1f0s-XU73b-Dgeqw16Gz3kBBxiah46bNaEtLDkmEGFzwYgJDSyFRFijEBi3kvYHOC3r1-QLeXzfY:1xBU9u:77o0Boh11nAyIHA4wajCvOKpc6Y9BJuDwpwVcoGMnrY', '2026-10-13 09:29:58.602891'),
('kpmz6ovoanep1xgcugs84zzbrg88jmhb', '.eJxVjMsOgjAQRf-la9MURhjq0j3f0EznIaiBhMLK-O9KwkK395xzXy7Rtg5pK7qkUdzFgTv9bpn4odMO5E7TbfY8T-syZr8r_qDF97Po83q4fwcDleFbY6cQGJEl5y6GBtG6swWsENWABbQ21LZhaOu6sigamUwlguZgQO79Ae0GOLI:1xB8Qv:TTRhUk8_F25IbiGb5RgQsbHMNAzWBq0M087BTIgrmAw', '2026-10-12 10:18:05.299374'),
('kxlaoesvud61ipyrrh5wk7k116hbyq8x', '.eJxVjMsOwiAQRf-FtSHAlEJduvcbyAwzSNXQpI-V8d-1SRe6veec-1IJt7WmbZE5jazOqlOn340wP6TtgO_YbpPOU1vnkfSu6IMu-jqxPC-H-3dQcanfGiEOQ-ktROiL8yxOOiAbyAt7ATYkIYOj0AFGEzM6RhOjG2woZI1V7w_eUTed:1xDlOd:xUunjmWUKUa88314W_m_-4fXkPm3WqgFhsvuua_j8fo', '2026-10-19 16:18:35.066640'),
('ky7n31t596v78gnescadao5c6xkamy4c', '.eJxVjMsOwiAQRf-FtSHAlEJduvcbyAwzSNXQpI-V8d-1SRe6veec-1IJt7WmbZE5jazOqlOn340wP6TtgO_YbpPOU1vnkfSu6IMu-jqxPC-H-3dQcanfGiEOQ-ktROiL8yxOOiAbyAt7ATYkIYOj0AFGEzM6RhOjG2woZI1V7w_eUTed:1xBDsk:Y6JJwe-UIuVUnixcuQHiupVIAFKNr0lAnYWvrALU47w', '2026-10-12 16:07:10.392502'),
('le54m0qloaf9jq1u836t2nxzrueiahlb', '.eJxVjMsOwiAQRf-FtSHAlEJduvcbyAwzSNXQpI-V8d-1SRe6veec-1IJt7WmbZE5jazOqlOn340wP6TtgO_YbpPOU1vnkfSu6IMu-jqxPC-H-3dQcanfGiEOQ-ktROiL8yxOOiAbyAt7ATYkIYOj0AFGEzM6RhOjG2woZI1V7w_eUTed:1xBDtH:LsXBzQpq7IQUkqYB1embHf9Z3mxYRS0EcY_jn5VXA5Y', '2026-10-12 16:07:43.058226'),
('lk9wkyjstalwjgru91nidj8kvy6n9ulx', '.eJxVjMsOgjAQRf-la9MURhjq0j3f0EznIaiBhMLK-O9KwkK395xzXy7Rtg5pK7qkUdzFgTv9bpn4odMO5E7TbfY8T-syZr8r_qDF97Po83q4fwcDleFbY6cQGJEl5y6GBtG6swWsENWABbQ21LZhaOu6sigamUwlguZgQO79Ae0GOLI:1xA50J:Vk3yQ3a5pCBaOlwmylIoRlBQB30RJkF0UqKJEhmNuzk', '2026-10-09 12:26:15.173116'),
('mes7891samdxf4yn444kg4e7nqjrnhnu', '.eJxVjMsOgjAQRf-la9MURhjq0j3f0EznIaiBhMLK-O9KwkK395xzXy7Rtg5pK7qkUdzFgTv9bpn4odMO5E7TbfY8T-syZr8r_qDF97Po83q4fwcDleFbY6cQGJEl5y6GBtG6swWsENWABbQ21LZhaOu6sigamUwlguZgQO79Ae0GOLI:1xR7gs:HA2YXmS2OuFfzqZwgUHYk8rWEnW6Qz13HNKEYzQIvbs', '2026-11-25 12:44:38.758471'),
('o2rmkaxod81u7v3m3jpirt7p9afifzit', '.eJxVjMsOwiAQRf-FtSHAlEJduvcbyAwzSNXQpI-V8d-1SRe6veec-1IJt7WmbZE5jazOqlOn340wP6TtgO_YbpPOU1vnkfSu6IMu-jqxPC-H-3dQcanfGiEOQ-ktROiL8yxOOiAbyAt7ATYkIYOj0AFGEzM6RhOjG2woZI1V7w_eUTed:1xCJnC:O-jLv7NWSCZKEfrceWQgHz4WobxFhOqjH6vQ8Z2QTd0', '2026-10-15 16:37:58.608102'),
('oaku8fihaox4gzqoareoeewklcj32sbz', '.eJxVjMsOgjAQRf-la9MURhjq0j3f0EznIaiBhMLK-O9KwkK395xzXy7Rtg5pK7qkUdzFgTv9bpn4odMO5E7TbfY8T-syZr8r_qDF97Po83q4fwcDleFbY6cQGJEl5y6GBtG6swWsENWABbQ21LZhaOu6sigamUwlguZgQO79Ae0GOLI:1xCHBD:_DArrjwXsNKiKp-wLse1XB8AqcDIgKoOUwuIb4ORO9c', '2026-10-15 13:50:35.827818'),
('oevpqwvruomr2wnjm5b8z5t0ba7u1cqs', '.eJxVjEEOwiAURO_C2hAo0H5cuu8ZyIcPUjWQlHZlvLs06UJXk7x5M2_mcN-y21tc3ULsyqRgl1_oMTxjORp6YLlXHmrZ1sXzQ-Fn2_hcKb5up_t3kLHlvg5WgPUEoMGAGpIhO5qgQIAaJVEy0xRtTEhB20iDMLIHCgzSoO6Afb75uThO:1xDfbR:HRCSxJJF-2Iy1V0KTnf1KpMSGgxG3gvcWqSTTm8OFhM', '2026-10-19 10:07:25.538658'),
('oh7xqcwdzi1hr3e8glcyffjv1jvmqf59', '.eJxVjMsOwiAQRf-FtSHAlEJduvcbyAwzSNXQpI-V8d-1SRe6veec-1IJt7WmbZE5jazOqlOn340wP6TtgO_YbpPOU1vnkfSu6IMu-jqxPC-H-3dQcanfGiEOQ-ktROiL8yxOOiAbyAt7ATYkIYOj0AFGEzM6RhOjG2woZI1V7w_eUTed:1xB9WE:h469ykGG55tZ2VSwKwo_WAyOR8VD7RrhiFkRmM64HAo', '2026-10-12 11:27:38.632028'),
('osteaxdk8xxohbj30v05bi9465ipb2jd', '.eJxVjEEOgjAQRe_StWlahjKtS_ecoZnptIIaSCisjHcXEha6_e-9_1aRtnWIW81LHEVdlVWX340pPfN0AHnQdJ91mqd1GVkfij5p1f0s-XU73b-Dgeqw16Gz3kBBxiah46bNaEtLDkmEGFzwYgJDSyFRFijEBi3kvYHOC3r1-QLeXzfY:1xBUEL:n1KA8tHCmQiu9qTWDPr_nGpthzmFVuQE52RQlZ1Wa4w', '2026-10-13 09:34:33.881219'),
('qcvygcw63erwsv0t57haqs1q2nlaep92', '.eJxVjM0OwiAQhN-FsyFlsfx49O4zkIVdpGogKe3J-O62SQ96nPm-mbcIuC4lrJ3nMJG4iFGcfruI6cl1B_TAem8ytbrMU5S7Ig_a5a0Rv66H-3dQsJdtzZ7jgM4Qnq0Cmx2NKpOKPoNToDN4k71TVqstGQcDW02GwEZvNCYUny_cBDdS:1xDhm5:GaVBqhHsk9Za-HcRVBmR9C3VUE8UVQ9zu3nBDIg-U-Q', '2026-10-19 12:26:33.152804'),
('qunv20wvru7lb7td3d0ivgdqvf45cylz', '.eJxVjMsOwiAQRf-FtSHAlEJduvcbyAwzSNXQpI-V8d-1SRe6veec-1IJt7WmbZE5jazOqlOn340wP6TtgO_YbpPOU1vnkfSu6IMu-jqxPC-H-3dQcanfGiEOQ-ktROiL8yxOOiAbyAt7ATYkIYOj0AFGEzM6RhOjG2woZI1V7w_eUTed:1xB9r2:tJkKqkKNtrK6pYwfM6uILonsFcvW_qPcE8hh0ABUuUk', '2026-10-12 11:49:08.689110'),
('rrbkjp6fle9v0bc2e67143z4gyhxnsj1', '.eJxVjMsOwiAQRf-FtSHAlEJduvcbyAwzSNXQpI-V8d-1SRe6veec-1IJt7WmbZE5jazOqlOn340wP6TtgO_YbpPOU1vnkfSu6IMu-jqxPC-H-3dQcanfGiEOQ-ktROiL8yxOOiAbyAt7ATYkIYOj0AFGEzM6RhOjG2woZI1V7w_eUTed:1xBDnQ:0vT-dirgmB6-lox8nG-x8M_1tK-AyM628nm2VIK0lrU', '2026-10-12 16:01:40.378117'),
('sksjavq12ol2918u9glgv6k1nz6g6g9e', '.eJxVjMsOgjAQRf-la9MURhjq0j3f0EznIaiBhMLK-O9KwkK395xzXy7Rtg5pK7qkUdzFgTv9bpn4odMO5E7TbfY8T-syZr8r_qDF97Po83q4fwcDleFbY6cQGJEl5y6GBtG6swWsENWABbQ21LZhaOu6sigamUwlguZgQO79Ae0GOLI:1xErfp:pbayYooJxYdjMzIDczqOW3iaBKuI4QxPoOmH3NxvkcQ', '2026-10-22 17:12:53.848286'),
('srptdfiehlgz5yrghpro1knt93sdnr6w', '.eJxVjM0OwiAQhN-FsyFlsfx49O4zkIVdpGogKe3J-O62SQ96nPm-mbcIuC4lrJ3nMJG4iFGcfruI6cl1B_TAem8ytbrMU5S7Ig_a5a0Rv66H-3dQsJdtzZ7jgM4Qnq0Cmx2NKpOKPoNToDN4k71TVqstGQcDW02GwEZvNCYUny_cBDdS:1xDhvW:fxTvpDYHwr9XMwyWZbOEpuT_pbeOmzBk8ixjVhyW5y4', '2026-10-19 12:36:18.085852'),
('t2urltf5jtbcchkf53pw3diqu9sma4ac', '.eJxVjMsOwiAQRf-FtSHAlEJduvcbyAwzSNXQpI-V8d-1SRe6veec-1IJt7WmbZE5jazOqlOn340wP6TtgO_YbpPOU1vnkfSu6IMu-jqxPC-H-3dQcanfGiEOQ-ktROiL8yxOOiAbyAt7ATYkIYOj0AFGEzM6RhOjG2woZI1V7w_eUTed:1xBEVF:mN5TICFSoSr6Kn4z8LbJkUB3PVoTfo7ZXx3y9kWEWSI', '2026-10-12 16:46:57.080308'),
('tc3h8u2y5w0wm3hthe1gc7x8kyxcn9t9', '.eJxVjEEOwiAQRe_C2hAgBGZcuvcMZBimUjWQlHZlvLs26UK3_733XyrRtta0DVnSXNRZOXX63TLxQ9oOyp3arWvubV3mrHdFH3Toay_yvBzu30GlUb81ElDwFgJZClG4GDu5iOCMIAJYF0P2JQsFm11GNrFMIGAjMnoTWL0_0-83iw:1xRSYI:bzlU4I1Tp-otflhKh2dJ7Bd5SaIGhAHujTKwhl_fM2g', '2026-11-26 11:01:10.191819'),
('tdlxe0vwawz0y8rwt92mrsu7256ovxgc', '.eJxVjMsOwiAQRf-FtSHAlEJduvcbyAwzSNXQpI-V8d-1SRe6veec-1IJt7WmbZE5jazOqlOn340wP6TtgO_YbpPOU1vnkfSu6IMu-jqxPC-H-3dQcanfGiEOQ-ktROiL8yxOOiAbyAt7ATYkIYOj0AFGEzM6RhOjG2woZI1V7w_eUTed:1xEltz:vZKFEGs7oC71yrO57dEy_QJPKUkfA5Hgs1-abembFsE', '2026-10-22 11:03:07.071898'),
('te6mmbp7j8qozwb0h4akk654mast06u2', '.eJxVjMsOgjAQRf-la9MURhjq0j3f0EznIaiBhMLK-O9KwkK395xzXy7Rtg5pK7qkUdzFgTv9bpn4odMO5E7TbfY8T-syZr8r_qDF97Po83q4fwcDleFbY6cQGJEl5y6GBtG6swWsENWABbQ21LZhaOu6sigamUwlguZgQO79Ae0GOLI:1xDlU6:37o3azHEOINtw1fKP3o9AOGRIqnS_XHTMofqZoVRK94', '2026-10-19 16:24:14.152692'),
('tgew26pr3zkm5eji0hncw1s4ynjjmxxt', '.eJxVjMsOwiAQRf-FtSHAlEJduvcbyAwzSNXQpI-V8d-1SRe6veec-1IJt7WmbZE5jazOqlOn340wP6TtgO_YbpPOU1vnkfSu6IMu-jqxPC-H-3dQcanfGiEOQ-ktROiL8yxOOiAbyAt7ATYkIYOj0AFGEzM6RhOjG2woZI1V7w_eUTed:1xDkVr:U8BVjPzkFZJ59yfq4awkWtgscFOGGgKunBIFNopdsRs', '2026-10-19 15:21:59.449918'),
('u8y7anv62xlw7k65za4istty1my7fxqy', '.eJxVjMsOgjAQRf-la9MURhjq0j3f0EznIaiBhMLK-O9KwkK395xzXy7Rtg5pK7qkUdzFgTv9bpn4odMO5E7TbfY8T-syZr8r_qDF97Po83q4fwcDleFbY6cQGJEl5y6GBtG6swWsENWABbQ21LZhaOu6sigamUwlguZgQO79Ae0GOLI:1xA52n:BSNpeJ5UeKmmCquiMMM3K0oRaxo__F8SBKmfQPWLwxs', '2026-10-09 12:28:49.589720'),
('v97tp77pjll1cqnxsi0ci6cfn9170hpa', '.eJxVjMsOwiAQRf-FtSHAlEJduvcbyAwzSNXQpI-V8d-1SRe6veec-1IJt7WmbZE5jazOqlOn340wP6TtgO_YbpPOU1vnkfSu6IMu-jqxPC-H-3dQcanfGiEOQ-ktROiL8yxOOiAbyAt7ATYkIYOj0AFGEzM6RhOjG2woZI1V7w_eUTed:1xA5MM:ahfHNlQRAOWdZBDsPuVNwwOHtWNRjr8Hw7YnRNnX1Eg', '2026-10-09 12:49:02.055309'),
('vz9lag1m85sxnadbyq3agnha5716cxxt', '.eJxVjMsOwiAQRf-FtSHAlEJduvcbyAwzSNXQpI-V8d-1SRe6veec-1IJt7WmbZE5jazOqlOn340wP6TtgO_YbpPOU1vnkfSu6IMu-jqxPC-H-3dQcanfGiEOQ-ktROiL8yxOOiAbyAt7ATYkIYOj0AFGEzM6RhOjG2woZI1V7w_eUTed:1xB9ff:SC6IuKjL_-kIsVeonAhE2iYGJJHegEzM6-miQkA0UbM', '2026-10-12 11:37:23.143615'),
('w3nupf256wworp3u8p2bc5izlmuk5xhw', '.eJxVjMsOwiAQRf-FtSHAlEJduvcbyAwzSNXQpI-V8d-1SRe6veec-1IJt7WmbZE5jazOqlOn340wP6TtgO_YbpPOU1vnkfSu6IMu-jqxPC-H-3dQcanfGiEOQ-ktROiL8yxOOiAbyAt7ATYkIYOj0AFGEzM6RhOjG2woZI1V7w_eUTed:1xWubA:qozqo0l_HwsknIrUirxG-zvBdfm3UXd1Qq8eIr6B1bA', '2026-12-11 11:58:40.467299'),
('w7m97syeje9yz0xrrdetujm5ydywu4yq', '.eJxVjMsOwiAQRf-FtSHAlEJduvcbyAwzSNXQpI-V8d-1SRe6veec-1IJt7WmbZE5jazOqlOn340wP6TtgO_YbpPOU1vnkfSu6IMu-jqxPC-H-3dQcanfGiEOQ-ktROiL8yxOOiAbyAt7ATYkIYOj0AFGEzM6RhOjG2woZI1V7w_eUTed:1xDlQ2:Y6q9tULIU_Y9Fk5SWX6QyBmh7xakuQgM-hfLTO0XXI8', '2026-10-19 16:20:02.804901'),
('wfupf81ohxngnuebpg36jn9o2ovy1uge', '.eJxVjE0OwiAYBe_C2hBKgYJL956BfD8gVQNJaVfGu2uTLnT7Zua9RIRtLXHraYkzi7Pw4vS7IdAj1R3wHeqtSWp1XWaUuyIP2uW1cXpeDvfvoEAv39pYCzaRM2F0IzIlF2D0Ok-IZJUGGlRgzFoZYjKDVj6T0YFd4MkiJ_H-AO_pOGQ:1xDlIH:vWHCDFYrBHsIF9AvDK4BCIa_7nuTW6hsvmchwqBYSV0', '2026-10-19 16:12:01.550293'),
('wkegrzzp808x44azgakrad3dmyvlfnks', '.eJxVjMsOwiAQRf-FtSHAlEJduvcbyAwzSNXQpI-V8d-1SRe6veec-1IJt7WmbZE5jazOqlOn340wP6TtgO_YbpPOU1vnkfSu6IMu-jqxPC-H-3dQcanfGiEOQ-ktROiL8yxOOiAbyAt7ATYkIYOj0AFGEzM6RhOjG2woZI1V7w_eUTed:1xDlRg:k_7sTkRlIUH5WNVPqovAJmhrpbZERDrSozQSHNx83GA', '2026-10-19 16:21:44.072830'),
('wzebzhqgtpvetojazqek4glkvthsy5i0', '.eJxVjMsOgjAQRf-la9MURhjq0j3f0EznIaiBhMLK-O9KwkK395xzXy7Rtg5pK7qkUdzFgTv9bpn4odMO5E7TbfY8T-syZr8r_qDF97Po83q4fwcDleFbY6cQGJEl5y6GBtG6swWsENWABbQ21LZhaOu6sigamUwlguZgQO79Ae0GOLI:1xCFyH:BWTs6dhAT-LEPVTCNL4E7GjsAyGIJ4ARdgxfgHX0i7E', '2026-10-15 12:33:09.320771'),
('x95tolsrv5clr0m1wvj3sbkv25mlvrz0', '.eJxVjEEOwiAQRe_C2pABgYJL9z0DmWFAqoYmpV0Z765NutDtf-_9l4i4rTVuPS9xYnERgzj9boTpkdsO-I7tNss0t3WZSO6KPGiX48z5eT3cv4OKvX5r6yCkMJBjaxQp9Io8BWPZGfYenPFQig6mJM4unDUxKbKgQauACYp4fwDOszd4:1xA4gy:FlVB6xcq_LsW0qLPV9-qZh5ZiS6KzJF2cdb3Dy3Jpnw', '2026-10-09 12:06:16.885459'),
('xagfisri6phigoudocyagihcso4fufyq', '.eJxVjMsOgjAQRf-la9MURhjq0j3f0EznIaiBhMLK-O9KwkK395xzXy7Rtg5pK7qkUdzFgTv9bpn4odMO5E7TbfY8T-syZr8r_qDF97Po83q4fwcDleFbY6cQGJEl5y6GBtG6swWsENWABbQ21LZhaOu6sigamUwlguZgQO79Ae0GOLI:1xDlFb:HrVWUzTsz7MbmVNc2wOQZeH0IZHi0WeoStYsKkQ8_Rs', '2026-10-19 16:09:15.931241'),
('xei1p1h7dew5j156a55xtbkjq83njdop', '.eJxVjEEOwiAQRe_C2hAgBGZcuvcMZBimUjWQlHZlvLs26UK3_733XyrRtta0DVnSXNRZOXX63TLxQ9oOyp3arWvubV3mrHdFH3Toay_yvBzu30GlUb81ElDwFgJZClG4GDu5iOCMIAJYF0P2JQsFm11GNrFMIGAjMnoTWL0_0-83iw:1xBWol:JUrH5ymbZIbtJiyIzWKskWqK-U6fByZjUKDEN5PRlYg', '2026-10-13 12:20:19.524329'),
('y9dorcy3fo13ulp8ad1sx0d12e0e1dzv', '.eJxVjMsOgjAQRf-la9MURhjq0j3f0EznIaiBhMLK-O9KwkK395xzXy7Rtg5pK7qkUdzFgTv9bpn4odMO5E7TbfY8T-syZr8r_qDF97Po83q4fwcDleFbY6cQGJEl5y6GBtG6swWsENWABbQ21LZhaOu6sigamUwlguZgQO79Ae0GOLI:1xB97X:gAvJhPPdwSWIWGyxmTYtMnlxCB4kg6Qn5nY-i2Y6m6c', '2026-10-12 11:02:07.724180'),
('yjmd8241rji6ij4fykmwnxvby8xhg5bw', '.eJxVjM0OwiAQhN-FsyFlsfx49O4zkIVdpGogKe3J-O62SQ96nPm-mbcIuC4lrJ3nMJG4iFGcfruI6cl1B_TAem8ytbrMU5S7Ig_a5a0Rv66H-3dQsJdtzZ7jgM4Qnq0Cmx2NKpOKPoNToDN4k71TVqstGQcDW02GwEZvNCYUny_cBDdS:1xEmHN:rBK2OkrUxi_l8ln5BQgeIyl3Qfz56IZQv-hFMX5u7hY', '2026-10-22 11:27:17.058216'),
('yzy0c8otkyf1vt8g451q4y6zr4q3wbmb', '.eJxVjE0OwiAYBe_C2hBKgYJL956BfD8gVQNJaVfGu2uTLnT7Zua9RIRtLXHraYkzi7Pw4vS7IdAj1R3wHeqtSWp1XWaUuyIP2uW1cXpeDvfvoEAv39pYCzaRM2F0IzIlF2D0Ok-IZJUGGlRgzFoZYjKDVj6T0YFd4MkiJ_H-AO_pOGQ:1xDkQ7:P3cOtPM7BDmOWp0_yJJcGSStl84IOBIxBzY98uhst7I', '2026-10-19 15:16:03.952128');

-- --------------------------------------------------------

--
-- Estrutura da tabela `domain`
--

CREATE TABLE `domain` (
  `id` bigint(20) NOT NULL,
  `description` varchar(100) NOT NULL,
  `type` int(11) NOT NULL,
  `domain_description` varchar(100) NOT NULL,
  `date_created` datetime(6) NOT NULL,
  `date_update` datetime(6) NOT NULL,
  `is_active` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `domain`
--

INSERT INTO `domain` (`id`, `description`, `type`, `domain_description`, `date_created`, `date_update`, `is_active`) VALUES
(1, 'Aberto', 1, 'Status_tarefa', '0000-00-00 00:00:00.000000', '0000-00-00 00:00:00.000000', 1),
(2, 'Concluido', 2, 'Status_tarefa', '0000-00-00 00:00:00.000000', '0000-00-00 00:00:00.000000', 1),
(3, 'Aprovado', 1, 'pendente_aprovacao', '0000-00-00 00:00:00.000000', '0000-00-00 00:00:00.000000', 1),
(4, 'Rejeitado', 2, 'pendente_aprovacao', '0000-00-00 00:00:00.000000', '0000-00-00 00:00:00.000000', 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `historico_operacoes`
--

CREATE TABLE `historico_operacoes` (
  `id` bigint(20) NOT NULL,
  `acao` varchar(20) NOT NULL,
  `modelo` varchar(100) NOT NULL,
  `objeto_id` varchar(100) NOT NULL,
  `descricao_objeto` varchar(255) NOT NULL,
  `dados_anteriores` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`dados_anteriores`)),
  `dados_novos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`dados_novos`)),
  `descricao` longtext NOT NULL,
  `endereco_ip` char(39) DEFAULT NULL,
  `user_agent` longtext NOT NULL,
  `rota` varchar(255) NOT NULL,
  `metodo_http` varchar(10) NOT NULL,
  `data_criacao` datetime(6) NOT NULL,
  `utilizador_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `historico_operacoes`
--

INSERT INTO `historico_operacoes` (`id`, `acao`, `modelo`, `objeto_id`, `descricao_objeto`, `dados_anteriores`, `dados_novos`, `descricao`, `endereco_ip`, `user_agent`, `rota`, `metodo_http`, `data_criacao`, `utilizador_id`) VALUES
(4, 'editar', 'core.IndividualObjective', '16', 'xpto 123', '{\"id\": 16, \"is_active\": true, \"department_objective\": 16, \"user\": 5, \"domain\": null, \"description\": \"xpto\", \"start_date\": \"2027-01-17\", \"end_date\": \"2027-01-29\", \"percentagem\": \"10.00\", \"status\": \"active\", \"date_created\": \"2026-11-13T10:54:16.425Z\", \"date_update\": \"2026-11-13T10:54:16.425Z\"}', '{\"id\": 16, \"is_active\": true, \"department_objective\": 16, \"user\": 5, \"domain\": null, \"description\": \"xpto 123\", \"start_date\": \"2027-01-17\", \"end_date\": \"2027-01-29\", \"percentagem\": \"10.00\", \"status\": \"active\", \"date_created\": \"2026-11-13T10:54:16.425Z\", \"date_update\": \"2026-11-13T11:22:32.371Z\"}', 'Editar objetivo individual: xpto 123', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/planejamento/objetivos-individuais/16/editar/', 'POST', '2026-11-13 11:22:32.377262', 4),
(46, 'logout', 'auth.User', '4', 'Arcelinda.Carvalho', NULL, NULL, 'Utilizador terminou a sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/logout/', 'POST', '2026-11-16 10:06:35.025091', 4),
(47, 'editar', 'auth.User', '3', 'Raimundo.F.Lopes', '{\"id\": 3, \"last_login\": \"2026-11-13T10:36:52.810Z\", \"is_superuser\": false, \"username\": \"Raimundo.F.Lopes\", \"first_name\": \"Raimundo\", \"last_name\": \"Lopes\", \"email\": \"Raimundo.F.Lopes@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T10:18:04Z\"}', '{\"id\": 3, \"last_login\": \"2026-11-16T10:06:43.043Z\", \"is_superuser\": false, \"username\": \"Raimundo.F.Lopes\", \"first_name\": \"Raimundo\", \"last_name\": \"Lopes\", \"email\": \"Raimundo.F.Lopes@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T10:18:04Z\"}', 'Editar usuário: Raimundo.F.Lopes', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/login/', 'POST', '2026-11-16 10:06:43.049938', 3),
(48, 'login', 'auth.User', '3', 'Raimundo.F.Lopes', NULL, NULL, 'Utilizador iniciou sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/login/', 'POST', '2026-11-16 10:06:43.051942', 3),
(49, 'eliminar', 'core.Cycle', '36', 'Ciclo letivo 2027 2026', '{\"id\": 36, \"is_active\": true, \"name\": \"Ciclo letivo 2027\", \"year\": 2026, \"start_date\": \"2026-01-01\", \"end_date\": \"2026-10-01\", \"domain\": 1, \"status\": \"planned\"}', '{\"id\": 36, \"is_active\": false, \"name\": \"Ciclo letivo 2027\", \"year\": 2026, \"start_date\": \"2026-01-01\", \"end_date\": \"2026-10-01\", \"domain\": 1, \"status\": \"planned\"}', 'Eliminar ciclo: Ciclo letivo 2027 2026', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/planejamento/ciclos/36/excluir/', 'POST', '2026-11-16 10:14:15.867412', 3),
(50, 'criar', 'core.Cycle', '40', 'Implimentação de ISO 90001 2026', NULL, '{\"id\": 40, \"is_active\": true, \"name\": \"Implimenta\\u00e7\\u00e3o de ISO 90001\", \"year\": 2026, \"start_date\": \"2026-11-16\", \"end_date\": \"2026-11-18\", \"domain\": 1, \"status\": \"planned\"}', 'Criar ciclo: Implimentação de ISO 90001 2026', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/planejamento/ciclos/novo/', 'POST', '2026-11-16 10:15:11.097531', 3),
(51, 'criar', 'core.InstitutionalObjective', '20', 'Automatização de processos', NULL, '{\"id\": 20, \"is_active\": true, \"cycle\": 40, \"domain\": 1, \"description\": \"Automatiza\\u00e7\\u00e3o de processos\", \"status\": \"active\", \"date_created\": \"2026-11-16T10:17:14.825Z\", \"date_update\": \"2026-11-16T10:17:14.825Z\"}', 'Criar objetivo institucional: Automatização de processos', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/planejamento/objetivos-institucionais/', 'POST', '2026-11-16 10:17:14.828406', 3),
(52, 'logout', 'auth.User', '3', 'Raimundo.F.Lopes', NULL, NULL, 'Utilizador terminou a sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/logout/', 'POST', '2026-11-16 10:25:34.907547', 3),
(53, 'editar', 'auth.User', '4', 'Arcelinda.Carvalho', '{\"id\": 4, \"last_login\": \"2026-11-13T10:38:06.329Z\", \"is_superuser\": false, \"username\": \"Arcelinda.Carvalho\", \"first_name\": \"Arcelinda\", \"last_name\": \"Carvalho\", \"email\": \"Arcelinda.Carvalho@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T12:26:01Z\"}', '{\"id\": 4, \"last_login\": \"2026-11-16T10:25:57.307Z\", \"is_superuser\": false, \"username\": \"Arcelinda.Carvalho\", \"first_name\": \"Arcelinda\", \"last_name\": \"Carvalho\", \"email\": \"Arcelinda.Carvalho@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T12:26:01Z\"}', 'Editar usuário: Arcelinda.Carvalho', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/login/', 'POST', '2026-11-16 10:25:57.311670', 4),
(54, 'login', 'auth.User', '4', 'Arcelinda.Carvalho', NULL, NULL, 'Utilizador iniciou sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/login/', 'POST', '2026-11-16 10:25:57.313675', 4),
(55, 'criar', 'core.DepartmentObjective', '19', 'Desenvolvimento de sistema de gestão acesso a INCV', NULL, '{\"id\": 19, \"is_active\": true, \"institutional_objective\": 20, \"department\": 9, \"domain\": 1, \"description\": \"Desenvolvimento de sistema de gest\\u00e3o acesso a INCV\", \"percentagem\": \"15\", \"status\": \"active\", \"date_created\": \"2026-11-16T10:34:55.755Z\", \"date_update\": \"2026-11-16T10:34:55.755Z\"}', 'Criar objetivo departamental: Desenvolvimento de sistema de gestão acesso a INCV', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/planejamento/objetivos-departamentais/', 'POST', '2026-11-16 10:34:55.761325', 4),
(56, 'criar', 'core.DepartmentObjective', '20', 'Documentação de processo de desenvolvimento de BI ou passaporte.', NULL, '{\"id\": 20, \"is_active\": true, \"institutional_objective\": 20, \"department\": 9, \"domain\": 1, \"description\": \"Documenta\\u00e7\\u00e3o de processo de desenvolvimento de BI ou passaporte.\", \"percentagem\": \"85\", \"status\": \"active\", \"date_created\": \"2026-11-16T10:43:30.939Z\", \"date_update\": \"2026-11-16T10:43:30.939Z\"}', 'Criar objetivo departamental: Documentação de processo de desenvolvimento de BI ou passaporte.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/planejamento/objetivos-departamentais/', 'POST', '2026-11-16 10:43:30.943534', 4),
(57, 'logout', 'auth.User', '4', 'Arcelinda.Carvalho', NULL, NULL, 'Utilizador terminou a sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/logout/', 'POST', '2026-11-16 10:43:42.219834', 4),
(58, 'login_falhou', 'auth.User', '', 'Raimundo.F.Lopes', NULL, NULL, 'Tentativa de autenticação sem sucesso.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/login/', 'POST', '2026-11-16 10:44:04.111042', NULL),
(59, 'editar', 'auth.User', '3', 'Raimundo.F.Lopes', '{\"id\": 3, \"last_login\": \"2026-11-16T10:06:43.043Z\", \"is_superuser\": false, \"username\": \"Raimundo.F.Lopes\", \"first_name\": \"Raimundo\", \"last_name\": \"Lopes\", \"email\": \"Raimundo.F.Lopes@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T10:18:04Z\"}', '{\"id\": 3, \"last_login\": \"2026-11-16T10:44:12.094Z\", \"is_superuser\": false, \"username\": \"Raimundo.F.Lopes\", \"first_name\": \"Raimundo\", \"last_name\": \"Lopes\", \"email\": \"Raimundo.F.Lopes@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T10:18:04Z\"}', 'Editar usuário: Raimundo.F.Lopes', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/login/', 'POST', '2026-11-16 10:44:12.099788', 3),
(60, 'login', 'auth.User', '3', 'Raimundo.F.Lopes', NULL, NULL, 'Utilizador iniciou sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/login/', 'POST', '2026-11-16 10:44:12.101851', 3),
(61, 'aprovar', 'core.AprovacaoTarefa', '15', '', NULL, '{\"id\": 15, \"is_active\": true, \"obs\": \"\", \"department_objective\": 20, \"domain\": 3, \"date_created\": \"2026-11-16T10:59:07.876Z\", \"date_update\": \"2026-11-16T10:59:07.876Z\"}', 'Aprovar aprovação de tarefa: ', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/planejamento/objetivos-departamentais/20/aprovacao/', 'POST', '2026-11-16 10:59:07.887429', 3),
(62, 'aprovar', 'core.AprovacaoTarefa', '16', '', NULL, '{\"id\": 16, \"is_active\": true, \"obs\": \"\", \"department_objective\": 19, \"domain\": 3, \"date_created\": \"2026-11-16T10:59:11.008Z\", \"date_update\": \"2026-11-16T10:59:11.008Z\"}', 'Aprovar aprovação de tarefa: ', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/planejamento/objetivos-departamentais/19/aprovacao/', 'POST', '2026-11-16 10:59:11.012318', 3),
(63, 'criar', 'core.IndividualObjective', '19', 'objetivo 1', NULL, '{\"id\": 19, \"is_active\": true, \"department_objective\": 19, \"user\": 4, \"domain\": null, \"description\": \"objetivo 1\", \"start_date\": \"2026-11-17\", \"end_date\": \"2026-11-17\", \"percentagem\": \"0\", \"status\": \"active\", \"date_created\": \"2026-11-16T10:59:54.535Z\", \"date_update\": \"2026-11-16T10:59:54.535Z\"}', 'Criar objetivo individual: objetivo 1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/planejamento/objetivos-individuais/', 'POST', '2026-11-16 10:59:54.541160', 3),
(64, 'editar', 'core.IndividualObjective', '19', 'objetivo 1', '{\"id\": 19, \"is_active\": true, \"department_objective\": 19, \"user\": 4, \"domain\": null, \"description\": \"objetivo 1\", \"start_date\": \"2026-11-17\", \"end_date\": \"2026-11-17\", \"percentagem\": \"0.00\", \"status\": \"active\", \"date_created\": \"2026-11-16T10:59:54.535Z\", \"date_update\": \"2026-11-16T10:59:54.535Z\"}', '{\"id\": 19, \"is_active\": true, \"department_objective\": 19, \"user\": 4, \"domain\": null, \"description\": \"objetivo 1\", \"start_date\": \"2026-11-17\", \"end_date\": \"2026-11-17\", \"percentagem\": \"10.00\", \"status\": \"active\", \"date_created\": \"2026-11-16T10:59:54.535Z\", \"date_update\": \"2026-11-16T11:06:03.768Z\"}', 'Editar objetivo individual: objetivo 1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/planejamento/objetivos-individuais/19/editar/', 'POST', '2026-11-16 11:06:03.771580', 3),
(65, 'logout', 'auth.User', '3', 'Raimundo.F.Lopes', NULL, NULL, 'Utilizador terminou a sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/logout/', 'POST', '2026-11-16 11:28:32.685895', 3),
(66, 'editar', 'auth.User', '4', 'Arcelinda.Carvalho', '{\"id\": 4, \"last_login\": \"2026-11-16T10:25:57.307Z\", \"is_superuser\": false, \"username\": \"Arcelinda.Carvalho\", \"first_name\": \"Arcelinda\", \"last_name\": \"Carvalho\", \"email\": \"Arcelinda.Carvalho@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T12:26:01Z\"}', '{\"id\": 4, \"last_login\": \"2026-11-16T11:28:48.014Z\", \"is_superuser\": false, \"username\": \"Arcelinda.Carvalho\", \"first_name\": \"Arcelinda\", \"last_name\": \"Carvalho\", \"email\": \"Arcelinda.Carvalho@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T12:26:01Z\"}', 'Editar usuário: Arcelinda.Carvalho', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/login/', 'POST', '2026-11-16 11:28:48.024805', 4),
(67, 'login', 'auth.User', '4', 'Arcelinda.Carvalho', NULL, NULL, 'Utilizador iniciou sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/login/', 'POST', '2026-11-16 11:28:48.027918', 4),
(68, 'concluir', 'core.IndividualObjective', '19', 'objetivo 1', '{\"id\": 19, \"is_active\": true, \"department_objective\": 19, \"user\": 4, \"domain\": null, \"description\": \"objetivo 1\", \"start_date\": \"2026-11-17\", \"end_date\": \"2026-11-17\", \"percentagem\": \"10.00\", \"status\": \"active\", \"date_created\": \"2026-11-16T10:59:54.535Z\", \"date_update\": \"2026-11-16T11:06:03.768Z\"}', '{\"id\": 19, \"is_active\": true, \"department_objective\": 19, \"user\": 4, \"domain\": null, \"description\": \"objetivo 1\", \"start_date\": \"2026-11-17\", \"end_date\": \"2026-11-17\", \"percentagem\": \"10.00\", \"status\": \"completed\", \"date_created\": \"2026-11-16T10:59:54.535Z\", \"date_update\": \"2026-11-16T11:29:17.410Z\"}', 'Concluir objetivo individual: objetivo 1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/gestor/minhas-tarefas/19/concluir/', 'POST', '2026-11-16 11:29:17.415624', 4),
(69, 'logout', 'auth.User', '4', 'Arcelinda.Carvalho', NULL, NULL, 'Utilizador terminou a sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/logout/', 'POST', '2026-11-16 12:32:52.657722', 4),
(70, 'editar', 'auth.User', '3', 'Raimundo.F.Lopes', '{\"id\": 3, \"last_login\": \"2026-11-16T10:44:12.094Z\", \"is_superuser\": false, \"username\": \"Raimundo.F.Lopes\", \"first_name\": \"Raimundo\", \"last_name\": \"Lopes\", \"email\": \"Raimundo.F.Lopes@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T10:18:04Z\"}', '{\"id\": 3, \"last_login\": \"2026-11-16T12:33:04.706Z\", \"is_superuser\": false, \"username\": \"Raimundo.F.Lopes\", \"first_name\": \"Raimundo\", \"last_name\": \"Lopes\", \"email\": \"Raimundo.F.Lopes@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T10:18:04Z\"}', 'Editar usuário: Raimundo.F.Lopes', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/login/', 'POST', '2026-11-16 12:33:04.706127', 3),
(71, 'login', 'auth.User', '3', 'Raimundo.F.Lopes', NULL, NULL, 'Utilizador iniciou sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/login/', 'POST', '2026-11-16 12:33:04.706127', 3),
(72, 'logout', 'auth.User', '3', 'Raimundo.F.Lopes', NULL, NULL, 'Utilizador terminou a sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/logout/', 'POST', '2026-11-16 16:11:38.203537', 3),
(73, 'editar', 'auth.User', '3', 'Raimundo.F.Lopes', '{\"id\": 3, \"last_login\": \"2026-11-16T12:33:04.706Z\", \"is_superuser\": false, \"username\": \"Raimundo.F.Lopes\", \"first_name\": \"Raimundo\", \"last_name\": \"Lopes\", \"email\": \"Raimundo.F.Lopes@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T10:18:04Z\"}', '{\"id\": 3, \"last_login\": \"2026-11-16T16:32:25.716Z\", \"is_superuser\": false, \"username\": \"Raimundo.F.Lopes\", \"first_name\": \"Raimundo\", \"last_name\": \"Lopes\", \"email\": \"Raimundo.F.Lopes@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T10:18:04Z\"}', 'Editar usuário: Raimundo.F.Lopes', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/login/', 'POST', '2026-11-16 16:32:25.722964', 3),
(74, 'login', 'auth.User', '3', 'Raimundo.F.Lopes', NULL, NULL, 'Utilizador iniciou sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/login/', 'POST', '2026-11-16 16:32:25.725998', 3),
(75, 'logout', 'auth.User', '3', 'Raimundo.F.Lopes', NULL, NULL, 'Utilizador terminou a sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/logout/', 'POST', '2026-11-17 16:57:13.863945', 3),
(76, 'login_falhou', 'auth.User', '', 'Raimundo.F.Lopes', NULL, NULL, 'Tentativa de autenticação sem sucesso.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/login/', 'POST', '2026-11-20 11:25:13.515371', NULL),
(77, 'editar', 'auth.User', '3', 'Raimundo.F.Lopes', '{\"id\": 3, \"last_login\": \"2026-11-16T16:32:25.716Z\", \"is_superuser\": false, \"username\": \"Raimundo.F.Lopes\", \"first_name\": \"Raimundo\", \"last_name\": \"Lopes\", \"email\": \"Raimundo.F.Lopes@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T10:18:04Z\"}', '{\"id\": 3, \"last_login\": \"2026-11-20T11:25:25.421Z\", \"is_superuser\": false, \"username\": \"Raimundo.F.Lopes\", \"first_name\": \"Raimundo\", \"last_name\": \"Lopes\", \"email\": \"Raimundo.F.Lopes@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T10:18:04Z\"}', 'Editar usuário: Raimundo.F.Lopes', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/login/', 'POST', '2026-11-20 11:25:25.429882', 3),
(78, 'login', 'auth.User', '3', 'Raimundo.F.Lopes', NULL, NULL, 'Utilizador iniciou sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/login/', 'POST', '2026-11-20 11:25:25.429882', 3),
(79, 'logout', 'auth.User', '3', 'Raimundo.F.Lopes', NULL, NULL, 'Utilizador terminou a sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '/logout/', 'POST', '2026-11-20 14:30:18.442174', 3),
(80, 'editar', 'auth.User', '3', 'Raimundo.F.Lopes', '{\"id\": 3, \"last_login\": \"2026-11-20T11:25:25.421Z\", \"is_superuser\": false, \"username\": \"Raimundo.F.Lopes\", \"first_name\": \"Raimundo\", \"last_name\": \"Lopes\", \"email\": \"Raimundo.F.Lopes@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T10:18:04Z\"}', '{\"id\": 3, \"last_login\": \"2026-11-23T15:05:55.803Z\", \"is_superuser\": false, \"username\": \"Raimundo.F.Lopes\", \"first_name\": \"Raimundo\", \"last_name\": \"Lopes\", \"email\": \"Raimundo.F.Lopes@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T10:18:04Z\"}', 'Editar usuário: Raimundo.F.Lopes', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/login/', 'POST', '2026-11-23 15:05:55.811795', 3),
(81, 'login', 'auth.User', '3', 'Raimundo.F.Lopes', NULL, NULL, 'Utilizador iniciou sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/login/', 'POST', '2026-11-23 15:05:55.815939', 3),
(82, 'logout', 'auth.User', '3', 'Raimundo.F.Lopes', NULL, NULL, 'Utilizador terminou a sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/logout/', 'POST', '2026-11-23 15:36:42.169800', 3),
(83, 'login_falhou', 'auth.User', '', 'aderitoborgesmonteiro.bb@gmail.com', NULL, NULL, 'Tentativa de autenticação sem sucesso.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/login/', 'POST', '2026-11-23 15:36:56.858335', NULL),
(84, 'editar', 'auth.User', '5', 'aderito.b.monteiro', '{\"id\": 5, \"last_login\": \"2026-11-12T15:07:16.915Z\", \"is_superuser\": false, \"username\": \"aderito.b.monteiro\", \"first_name\": \"Aderito\", \"last_name\": \"Monteiro\", \"email\": \"aderito.b.monteiro@gov.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T15:21:58Z\"}', '{\"id\": 5, \"last_login\": \"2026-11-23T15:37:22.807Z\", \"is_superuser\": false, \"username\": \"aderito.b.monteiro\", \"first_name\": \"Aderito\", \"last_name\": \"Monteiro\", \"email\": \"aderito.b.monteiro@gov.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T15:21:58Z\"}', 'Editar usuário: aderito.b.monteiro', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/login/', 'POST', '2026-11-23 15:37:22.817430', 5),
(85, 'login', 'auth.User', '5', 'aderito.b.monteiro', NULL, NULL, 'Utilizador iniciou sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/login/', 'POST', '2026-11-23 15:37:22.822095', 5),
(86, 'logout', 'auth.User', '5', 'aderito.b.monteiro', NULL, NULL, 'Utilizador terminou a sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/logout/', 'POST', '2026-11-23 15:41:15.677332', 5),
(87, 'login_falhou', 'auth.User', '', 'Raimundo.F.Lopes', NULL, NULL, 'Tentativa de autenticação sem sucesso.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/login/', 'POST', '2026-11-23 15:43:51.380716', NULL),
(88, 'editar', 'auth.User', '3', 'Raimundo.F.Lopes', '{\"id\": 3, \"last_login\": \"2026-11-23T15:05:55.803Z\", \"is_superuser\": false, \"username\": \"Raimundo.F.Lopes\", \"first_name\": \"Raimundo\", \"last_name\": \"Lopes\", \"email\": \"Raimundo.F.Lopes@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T10:18:04Z\"}', '{\"id\": 3, \"last_login\": \"2026-11-23T15:44:13.717Z\", \"is_superuser\": false, \"username\": \"Raimundo.F.Lopes\", \"first_name\": \"Raimundo\", \"last_name\": \"Lopes\", \"email\": \"Raimundo.F.Lopes@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T10:18:04Z\"}', 'Editar usuário: Raimundo.F.Lopes', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/login/', 'POST', '2026-11-23 15:44:13.728287', 3),
(89, 'login', 'auth.User', '3', 'Raimundo.F.Lopes', NULL, NULL, 'Utilizador iniciou sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/login/', 'POST', '2026-11-23 15:44:13.733287', 3),
(90, 'logout', 'auth.User', '3', 'Raimundo.F.Lopes', NULL, NULL, 'Utilizador terminou a sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/logout/', 'POST', '2026-11-23 16:46:33.364408', 3),
(91, 'editar', 'auth.User', '3', 'Raimundo.F.Lopes', '{\"id\": 3, \"last_login\": \"2026-11-23T15:44:13.717Z\", \"is_superuser\": false, \"username\": \"Raimundo.F.Lopes\", \"first_name\": \"Raimundo\", \"last_name\": \"Lopes\", \"email\": \"Raimundo.F.Lopes@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T10:18:04Z\"}', '{\"id\": 3, \"last_login\": \"2026-11-24T11:15:47.361Z\", \"is_superuser\": false, \"username\": \"Raimundo.F.Lopes\", \"first_name\": \"Raimundo\", \"last_name\": \"Lopes\", \"email\": \"Raimundo.F.Lopes@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T10:18:04Z\"}', 'Editar usuário: Raimundo.F.Lopes', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/login/', 'POST', '2026-11-24 11:15:47.390543', 3),
(92, 'login', 'auth.User', '3', 'Raimundo.F.Lopes', NULL, NULL, 'Utilizador iniciou sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/login/', 'POST', '2026-11-24 11:15:47.400478', 3),
(93, 'eliminar', 'core.Cycle', '40', 'Implimentação de ISO 90001 2026', '{\"id\": 40, \"is_active\": true, \"name\": \"Implimenta\\u00e7\\u00e3o de ISO 90001\", \"year\": 2026, \"start_date\": \"2026-11-16\", \"end_date\": \"2026-11-18\", \"domain\": 1, \"status\": \"planned\"}', '{\"id\": 40, \"is_active\": false, \"name\": \"Implimenta\\u00e7\\u00e3o de ISO 90001\", \"year\": 2026, \"start_date\": \"2026-11-16\", \"end_date\": \"2026-11-18\", \"domain\": 1, \"status\": \"planned\"}', 'Eliminar ciclo: Implimentação de ISO 90001 2026', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/planejamento/ciclos/40/excluir/', 'POST', '2026-11-24 11:17:29.245998', 3),
(94, 'criar', 'core.Cycle', '41', 'Ciclo 26/27 2026', NULL, '{\"id\": 41, \"is_active\": true, \"name\": \"Ciclo 26/27\", \"year\": 2026, \"start_date\": \"2026-11-24\", \"end_date\": \"2026-11-27\", \"domain\": 1, \"status\": \"planned\"}', 'Criar ciclo: Ciclo 26/27 2026', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/planejamento/ciclos/novo/', 'POST', '2026-11-24 11:19:52.389960', 3),
(95, 'criar', 'core.InstitutionalObjective', '21', 'Implementação do ISO 9001', NULL, '{\"id\": 21, \"is_active\": true, \"cycle\": 41, \"domain\": 1, \"description\": \"Implementa\\u00e7\\u00e3o do ISO 9001\", \"status\": \"active\", \"date_created\": \"2026-11-24T11:20:12.612Z\", \"date_update\": \"2026-11-24T11:20:12.612Z\"}', 'Criar objetivo institucional: Implementação do ISO 9001', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/planejamento/objetivos-institucionais/', 'POST', '2026-11-24 11:20:12.614787', 3),
(96, 'logout', 'auth.User', '3', 'Raimundo.F.Lopes', NULL, NULL, 'Utilizador terminou a sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/logout/', 'POST', '2026-11-24 11:26:17.076779', 3),
(97, 'login_falhou', 'auth.User', '', 'Arcelinda.Carvalho@incv.cv', NULL, NULL, 'Tentativa de autenticação sem sucesso.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/login/', 'POST', '2026-11-24 11:26:36.215627', NULL),
(98, 'login_falhou', 'auth.User', '', 'Arcelinda.Carvalho@incv.cv', NULL, NULL, 'Tentativa de autenticação sem sucesso.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/login/', 'POST', '2026-11-24 11:26:52.939151', NULL),
(99, 'editar', 'auth.User', '4', 'Arcelinda.Carvalho', '{\"id\": 4, \"last_login\": \"2026-11-16T11:28:48.014Z\", \"is_superuser\": false, \"username\": \"Arcelinda.Carvalho\", \"first_name\": \"Arcelinda\", \"last_name\": \"Carvalho\", \"email\": \"Arcelinda.Carvalho@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T12:26:01Z\"}', '{\"id\": 4, \"last_login\": \"2026-11-24T11:27:06.440Z\", \"is_superuser\": false, \"username\": \"Arcelinda.Carvalho\", \"first_name\": \"Arcelinda\", \"last_name\": \"Carvalho\", \"email\": \"Arcelinda.Carvalho@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T12:26:01Z\"}', 'Editar usuário: Arcelinda.Carvalho', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/login/', 'POST', '2026-11-24 11:27:06.444493', 4),
(100, 'login', 'auth.User', '4', 'Arcelinda.Carvalho', NULL, NULL, 'Utilizador iniciou sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/login/', 'POST', '2026-11-24 11:27:06.447513', 4),
(101, 'criar', 'core.DepartmentObjective', '21', 'Automatização do processo de gestão de acesso a INCV', NULL, '{\"id\": 21, \"is_active\": true, \"institutional_objective\": 21, \"department\": 9, \"domain\": 1, \"description\": \"Automatiza\\u00e7\\u00e3o do processo de gest\\u00e3o de acesso a INCV\", \"percentagem\": \"30\", \"status\": \"active\", \"date_created\": \"2026-11-24T11:28:04.111Z\", \"date_update\": \"2026-11-24T11:28:04.111Z\"}', 'Criar objetivo departamental: Automatização do processo de gestão de acesso a INCV', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/planejamento/objetivos-departamentais/', 'POST', '2026-11-24 11:28:04.116696', 4),
(102, 'editar', 'auth.User', '3', 'Raimundo.F.Lopes', '{\"id\": 3, \"last_login\": \"2026-11-24T11:15:47.361Z\", \"is_superuser\": false, \"username\": \"Raimundo.F.Lopes\", \"first_name\": \"Raimundo\", \"last_name\": \"Lopes\", \"email\": \"Raimundo.F.Lopes@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T10:18:04Z\"}', '{\"id\": 3, \"last_login\": \"2026-11-24T11:29:00.004Z\", \"is_superuser\": false, \"username\": \"Raimundo.F.Lopes\", \"first_name\": \"Raimundo\", \"last_name\": \"Lopes\", \"email\": \"Raimundo.F.Lopes@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T10:18:04Z\"}', 'Editar usuário: Raimundo.F.Lopes', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/login/', 'POST', '2026-11-24 11:29:00.008295', 3),
(103, 'login', 'auth.User', '3', 'Raimundo.F.Lopes', NULL, NULL, 'Utilizador iniciou sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/login/', 'POST', '2026-11-24 11:29:00.011295', 3),
(104, 'aprovar', 'core.AprovacaoTarefa', '17', '', NULL, '{\"id\": 17, \"is_active\": true, \"obs\": \"\", \"department_objective\": 21, \"domain\": 3, \"date_created\": \"2026-11-24T11:35:42.547Z\", \"date_update\": \"2026-11-24T11:35:42.547Z\"}', 'Aprovar aprovação de tarefa: ', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/planejamento/objetivos-departamentais/21/aprovacao/', 'POST', '2026-11-24 11:35:42.552653', 3),
(105, 'criar', 'core.DepartmentObjective', '22', 'Reparação de servidores', NULL, '{\"id\": 22, \"is_active\": true, \"institutional_objective\": 21, \"department\": 9, \"domain\": 1, \"description\": \"Repara\\u00e7\\u00e3o de servidores\", \"percentagem\": \"40\", \"status\": \"active\", \"date_created\": \"2026-11-24T11:44:34.191Z\", \"date_update\": \"2026-11-24T11:44:34.191Z\"}', 'Criar objetivo departamental: Reparação de servidores', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/planejamento/objetivos-departamentais/', 'POST', '2026-11-24 11:44:34.191986', 4),
(106, 'aprovar', 'core.AprovacaoTarefa', '18', '', NULL, '{\"id\": 18, \"is_active\": true, \"obs\": \"\", \"department_objective\": 22, \"domain\": 3, \"date_created\": \"2026-11-24T12:19:31.890Z\", \"date_update\": \"2026-11-24T12:19:31.891Z\"}', 'Aprovar aprovação de tarefa: ', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/planejamento/objetivos-departamentais/22/aprovacao/', 'POST', '2026-11-24 12:19:31.899777', 3),
(107, 'logout', 'auth.User', '4', 'Arcelinda.Carvalho', NULL, NULL, 'Utilizador terminou a sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/logout/', 'POST', '2026-11-24 12:38:50.276364', 4),
(108, 'editar', 'auth.User', '4', 'Arcelinda.Carvalho', '{\"id\": 4, \"last_login\": \"2026-11-24T11:27:06.440Z\", \"is_superuser\": false, \"username\": \"Arcelinda.Carvalho\", \"first_name\": \"Arcelinda\", \"last_name\": \"Carvalho\", \"email\": \"Arcelinda.Carvalho@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T12:26:01Z\"}', '{\"id\": 4, \"last_login\": \"2026-11-24T12:38:52.712Z\", \"is_superuser\": false, \"username\": \"Arcelinda.Carvalho\", \"first_name\": \"Arcelinda\", \"last_name\": \"Carvalho\", \"email\": \"Arcelinda.Carvalho@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T12:26:01Z\"}', 'Editar usuário: Arcelinda.Carvalho', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/login/', 'POST', '2026-11-24 12:38:52.718284', 4),
(109, 'login', 'auth.User', '4', 'Arcelinda.Carvalho', NULL, NULL, 'Utilizador iniciou sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/login/', 'POST', '2026-11-24 12:38:52.720383', 4),
(110, 'criar', 'core.IndividualObjective', '20', 'Limpar lixo de recido na BD', NULL, '{\"id\": 20, \"is_active\": true, \"department_objective\": 22, \"user\": 5, \"domain\": null, \"description\": \"Limpar lixo de recido na BD\", \"start_date\": \"2026-11-25\", \"end_date\": \"2026-11-26\", \"percentagem\": \"50\", \"status\": \"active\", \"date_created\": \"2026-11-24T15:27:49.569Z\", \"date_update\": \"2026-11-24T15:27:49.569Z\"}', 'Criar objetivo individual: Limpar lixo de recido na BD', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/planejamento/objetivos-individuais/', 'POST', '2026-11-24 15:27:49.589448', 4),
(111, 'criar', 'core.IndividualObjective', '21', 'Fazer backup', NULL, '{\"id\": 21, \"is_active\": true, \"department_objective\": 22, \"user\": 9, \"domain\": null, \"description\": \"Fazer backup\", \"start_date\": \"2026-11-25\", \"end_date\": \"2026-11-26\", \"percentagem\": \"50\", \"status\": \"active\", \"date_created\": \"2026-11-24T15:28:41.221Z\", \"date_update\": \"2026-11-24T15:28:41.221Z\"}', 'Criar objetivo individual: Fazer backup', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/planejamento/objetivos-individuais/', 'POST', '2026-11-24 15:28:41.226882', 4),
(112, 'logout', 'auth.User', '3', 'Raimundo.F.Lopes', NULL, NULL, 'Utilizador terminou a sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/logout/', 'POST', '2026-11-24 16:13:15.210244', 3),
(113, 'editar', 'auth.User', '3', 'Raimundo.F.Lopes', '{\"id\": 3, \"last_login\": \"2026-11-24T11:29:00.004Z\", \"is_superuser\": false, \"username\": \"Raimundo.F.Lopes\", \"first_name\": \"Raimundo\", \"last_name\": \"Lopes\", \"email\": \"Raimundo.F.Lopes@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T10:18:04Z\"}', '{\"id\": 3, \"last_login\": \"2026-11-24T16:36:57.130Z\", \"is_superuser\": false, \"username\": \"Raimundo.F.Lopes\", \"first_name\": \"Raimundo\", \"last_name\": \"Lopes\", \"email\": \"Raimundo.F.Lopes@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T10:18:04Z\"}', 'Editar usuário: Raimundo.F.Lopes', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/login/', 'POST', '2026-11-24 16:36:57.140931', 3),
(114, 'login', 'auth.User', '3', 'Raimundo.F.Lopes', NULL, NULL, 'Utilizador iniciou sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/login/', 'POST', '2026-11-24 16:36:57.144463', 3),
(115, 'logout', 'auth.User', '4', 'Arcelinda.Carvalho', NULL, NULL, 'Utilizador terminou a sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/logout/', 'POST', '2026-11-25 11:36:17.781929', 4),
(116, 'editar', 'auth.User', '4', 'Arcelinda.Carvalho', '{\"id\": 4, \"last_login\": \"2026-11-24T12:38:52.712Z\", \"is_superuser\": false, \"username\": \"Arcelinda.Carvalho\", \"first_name\": \"Arcelinda\", \"last_name\": \"Carvalho\", \"email\": \"Arcelinda.Carvalho@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T12:26:01Z\"}', '{\"id\": 4, \"last_login\": \"2026-11-25T11:36:45.777Z\", \"is_superuser\": false, \"username\": \"Arcelinda.Carvalho\", \"first_name\": \"Arcelinda\", \"last_name\": \"Carvalho\", \"email\": \"Arcelinda.Carvalho@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T12:26:01Z\"}', 'Editar usuário: Arcelinda.Carvalho', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/login/', 'POST', '2026-11-25 11:36:45.780228', 4),
(117, 'login', 'auth.User', '4', 'Arcelinda.Carvalho', NULL, NULL, 'Utilizador iniciou sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/login/', 'POST', '2026-11-25 11:36:45.784368', 4),
(118, 'criar', 'core.DepartmentObjective', '23', 'Gestão dos computadores com mais ano de funcionamento na INCV', NULL, '{\"id\": 23, \"is_active\": true, \"institutional_objective\": 21, \"department\": 9, \"domain\": 1, \"description\": \"Gest\\u00e3o dos computadores com mais ano de funcionamento na INCV\", \"percentagem\": \"30\", \"status\": \"active\", \"date_created\": \"2026-11-25T11:37:37.110Z\", \"date_update\": \"2026-11-25T11:37:37.110Z\"}', 'Criar objetivo departamental: Gestão dos computadores com mais ano de funcionamento na INCV', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/planejamento/objetivos-departamentais/', 'POST', '2026-11-25 11:37:37.112788', 4),
(119, 'aprovar', 'core.AprovacaoTarefa', '19', '', NULL, '{\"id\": 19, \"is_active\": true, \"obs\": \"\", \"department_objective\": 23, \"domain\": 3, \"date_created\": \"2026-11-25T11:38:32.408Z\", \"date_update\": \"2026-11-25T11:38:32.408Z\"}', 'Aprovar aprovação de tarefa: ', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/planejamento/objetivos-departamentais/23/aprovacao/', 'POST', '2026-11-25 11:38:32.412215', 3),
(120, 'logout', 'auth.User', '4', 'Arcelinda.Carvalho', NULL, NULL, 'Utilizador terminou a sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/logout/', 'POST', '2026-11-25 11:41:26.045617', 4),
(121, 'login_falhou', 'auth.User', '', 'Liziane.Monteiro', NULL, NULL, 'Tentativa de autenticação sem sucesso.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/login/', 'POST', '2026-11-25 11:41:43.175776', NULL),
(122, 'editar', 'auth.User', '8', 'Liziane.Monteiro', '{\"id\": 8, \"last_login\": \"2026-10-08T17:19:03.326Z\", \"is_superuser\": false, \"username\": \"Liziane.Monteiro\", \"first_name\": \"Liziane\", \"last_name\": \"Monteiro\", \"email\": \"Liziane.Monteiro@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-28T15:19:56Z\"}', '{\"id\": 8, \"last_login\": \"2026-11-25T11:41:55.399Z\", \"is_superuser\": false, \"username\": \"Liziane.Monteiro\", \"first_name\": \"Liziane\", \"last_name\": \"Monteiro\", \"email\": \"Liziane.Monteiro@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-28T15:19:56Z\"}', 'Editar usuário: Liziane.Monteiro', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/login/', 'POST', '2026-11-25 11:41:55.403461', 8),
(123, 'login', 'auth.User', '8', 'Liziane.Monteiro', NULL, NULL, 'Utilizador iniciou sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/login/', 'POST', '2026-11-25 11:41:55.406464', 8),
(124, 'criar', 'core.DepartmentObjective', '24', 'Garantir graxa para todos os funcionários da INCV', NULL, '{\"id\": 24, \"is_active\": true, \"institutional_objective\": 21, \"department\": 8, \"domain\": 1, \"description\": \"Garantir graxa para todos os funcion\\u00e1rios da INCV\", \"percentagem\": \"30\", \"status\": \"active\", \"date_created\": \"2026-11-25T11:48:18.840Z\", \"date_update\": \"2026-11-25T11:48:18.840Z\"}', 'Criar objetivo departamental: Garantir graxa para todos os funcionários da INCV', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/planejamento/objetivos-departamentais/', 'POST', '2026-11-25 11:48:18.844425', 8),
(125, 'criar', 'core.DepartmentObjective', '25', 'Garantir juntos dos parceiro um espaço limpo e ambiente estável.', NULL, '{\"id\": 25, \"is_active\": true, \"institutional_objective\": 21, \"department\": 8, \"domain\": 1, \"description\": \"Garantir juntos dos parceiro um espa\\u00e7o limpo e ambiente est\\u00e1vel.\", \"percentagem\": \"30\", \"status\": \"active\", \"date_created\": \"2026-11-25T11:50:00.704Z\", \"date_update\": \"2026-11-25T11:50:00.704Z\"}', 'Criar objetivo departamental: Garantir juntos dos parceiro um espaço limpo e ambiente estável.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/planejamento/objetivos-departamentais/', 'POST', '2026-11-25 11:50:00.706859', 8),
(126, 'criar', 'core.DepartmentObjective', '26', 'XPTO objetivo', NULL, '{\"id\": 26, \"is_active\": true, \"institutional_objective\": 21, \"department\": 8, \"domain\": 1, \"description\": \"XPTO objetivo\", \"percentagem\": \"40\", \"status\": \"active\", \"date_created\": \"2026-11-25T11:50:28.637Z\", \"date_update\": \"2026-11-25T11:50:28.637Z\"}', 'Criar objetivo departamental: XPTO objetivo', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/planejamento/objetivos-departamentais/', 'POST', '2026-11-25 11:50:28.640041', 8),
(127, 'aprovar', 'core.AprovacaoTarefa', '20', '', NULL, '{\"id\": 20, \"is_active\": true, \"obs\": \"\", \"department_objective\": 26, \"domain\": 3, \"date_created\": \"2026-11-25T11:50:52.353Z\", \"date_update\": \"2026-11-25T11:50:52.353Z\"}', 'Aprovar aprovação de tarefa: ', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/planejamento/objetivos-departamentais/26/aprovacao/', 'POST', '2026-11-25 11:50:52.356650', 3),
(128, 'aprovar', 'core.AprovacaoTarefa', '21', '', NULL, '{\"id\": 21, \"is_active\": true, \"obs\": \"\", \"department_objective\": 25, \"domain\": 3, \"date_created\": \"2026-11-25T11:50:55.488Z\", \"date_update\": \"2026-11-25T11:50:55.488Z\"}', 'Aprovar aprovação de tarefa: ', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/planejamento/objetivos-departamentais/25/aprovacao/', 'POST', '2026-11-25 11:50:55.490048', 3),
(129, 'aprovar', 'core.AprovacaoTarefa', '22', '', NULL, '{\"id\": 22, \"is_active\": true, \"obs\": \"\", \"department_objective\": 24, \"domain\": 3, \"date_created\": \"2026-11-25T11:50:58.821Z\", \"date_update\": \"2026-11-25T11:50:58.821Z\"}', 'Aprovar aprovação de tarefa: ', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/planejamento/objetivos-departamentais/24/aprovacao/', 'POST', '2026-11-25 11:50:58.824140', 3),
(130, 'criar', 'core.IndividualObjective', '22', 'gestor 01', NULL, '{\"id\": 22, \"is_active\": true, \"department_objective\": 23, \"user\": 4, \"domain\": null, \"description\": \"gestor 01\", \"start_date\": \"2026-11-25\", \"end_date\": \"2026-11-26\", \"percentagem\": \"40\", \"status\": \"active\", \"date_created\": \"2026-11-25T11:53:21.182Z\", \"date_update\": \"2026-11-25T11:53:21.183Z\"}', 'Criar objetivo individual: gestor 01', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/planejamento/objetivos-individuais/', 'POST', '2026-11-25 11:53:21.185695', 3),
(131, 'criar', 'core.IndividualObjective', '23', 'objetivo xpto 02', NULL, '{\"id\": 23, \"is_active\": true, \"department_objective\": 22, \"user\": 4, \"domain\": null, \"description\": \"objetivo xpto 02\", \"start_date\": \"2026-11-25\", \"end_date\": \"2026-11-26\", \"percentagem\": \"10\", \"status\": \"active\", \"date_created\": \"2026-11-25T15:37:10.373Z\", \"date_update\": \"2026-11-25T15:37:10.373Z\"}', 'Criar objetivo individual: objetivo xpto 02', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/planejamento/objetivos-individuais/', 'POST', '2026-11-25 15:37:10.390576', 3),
(132, 'criar', 'core.IndividualObjective', '24', 'objetivo xpto3', NULL, '{\"id\": 24, \"is_active\": true, \"department_objective\": 21, \"user\": 4, \"domain\": null, \"description\": \"objetivo xpto3\", \"start_date\": \"2026-11-25\", \"end_date\": \"2026-11-26\", \"percentagem\": \"10\", \"status\": \"active\", \"date_created\": \"2026-11-25T15:37:46.653Z\", \"date_update\": \"2026-11-25T15:37:46.653Z\"}', 'Criar objetivo individual: objetivo xpto3', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/planejamento/objetivos-individuais/', 'POST', '2026-11-25 15:37:46.657639', 3),
(133, 'logout', 'auth.User', '8', 'Liziane.Monteiro', NULL, NULL, 'Utilizador terminou a sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/logout/', 'POST', '2026-11-25 15:38:03.803207', 8),
(134, 'editar', 'auth.User', '4', 'Arcelinda.Carvalho', '{\"id\": 4, \"last_login\": \"2026-11-25T11:36:45.777Z\", \"is_superuser\": false, \"username\": \"Arcelinda.Carvalho\", \"first_name\": \"Arcelinda\", \"last_name\": \"Carvalho\", \"email\": \"Arcelinda.Carvalho@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T12:26:01Z\"}', '{\"id\": 4, \"last_login\": \"2026-11-25T15:38:08.157Z\", \"is_superuser\": false, \"username\": \"Arcelinda.Carvalho\", \"first_name\": \"Arcelinda\", \"last_name\": \"Carvalho\", \"email\": \"Arcelinda.Carvalho@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T12:26:01Z\"}', 'Editar usuário: Arcelinda.Carvalho', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/login/', 'POST', '2026-11-25 15:38:08.164045', 4),
(135, 'login', 'auth.User', '4', 'Arcelinda.Carvalho', NULL, NULL, 'Utilizador iniciou sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/login/', 'POST', '2026-11-25 15:38:08.166041', 4),
(136, 'concluir', 'core.IndividualObjective', '24', 'objetivo xpto3', '{\"id\": 24, \"is_active\": true, \"department_objective\": 21, \"user\": 4, \"domain\": null, \"description\": \"objetivo xpto3\", \"start_date\": \"2026-11-25\", \"end_date\": \"2026-11-26\", \"percentagem\": \"10.00\", \"status\": \"active\", \"date_created\": \"2026-11-25T15:37:46.653Z\", \"date_update\": \"2026-11-25T15:37:46.653Z\"}', '{\"id\": 24, \"is_active\": true, \"department_objective\": 21, \"user\": 4, \"domain\": null, \"description\": \"objetivo xpto3\", \"start_date\": \"2026-11-25\", \"end_date\": \"2026-11-26\", \"percentagem\": \"10.00\", \"status\": \"completed\", \"date_created\": \"2026-11-25T15:37:46.653Z\", \"date_update\": \"2026-11-25T15:39:53.039Z\"}', 'Concluir objetivo individual: objetivo xpto3', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/gestor/minhas-tarefas/24/concluir/', 'POST', '2026-11-25 15:39:53.043771', 4);
INSERT INTO `historico_operacoes` (`id`, `acao`, `modelo`, `objeto_id`, `descricao_objeto`, `dados_anteriores`, `dados_novos`, `descricao`, `endereco_ip`, `user_agent`, `rota`, `metodo_http`, `data_criacao`, `utilizador_id`) VALUES
(137, 'concluir', 'core.IndividualObjective', '23', 'objetivo xpto 02', '{\"id\": 23, \"is_active\": true, \"department_objective\": 22, \"user\": 4, \"domain\": null, \"description\": \"objetivo xpto 02\", \"start_date\": \"2026-11-25\", \"end_date\": \"2026-11-26\", \"percentagem\": \"10.00\", \"status\": \"active\", \"date_created\": \"2026-11-25T15:37:10.373Z\", \"date_update\": \"2026-11-25T15:37:10.373Z\"}', '{\"id\": 23, \"is_active\": true, \"department_objective\": 22, \"user\": 4, \"domain\": null, \"description\": \"objetivo xpto 02\", \"start_date\": \"2026-11-25\", \"end_date\": \"2026-11-26\", \"percentagem\": \"10.00\", \"status\": \"completed\", \"date_created\": \"2026-11-25T15:37:10.373Z\", \"date_update\": \"2026-11-25T15:44:54.958Z\"}', 'Concluir objetivo individual: objetivo xpto 02', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/gestor/minhas-tarefas/23/concluir/', 'POST', '2026-11-25 15:44:54.962932', 4),
(138, 'concluir', 'core.IndividualObjective', '24', 'objetivo xpto3', '{\"id\": 24, \"is_active\": true, \"department_objective\": 21, \"user\": 4, \"domain\": null, \"description\": \"objetivo xpto3\", \"start_date\": \"2026-11-25\", \"end_date\": \"2026-11-26\", \"percentagem\": \"10.00\", \"status\": \"active\", \"date_created\": \"2026-11-25T15:37:46.653Z\", \"date_update\": \"2026-11-25T15:39:53.039Z\"}', '{\"id\": 24, \"is_active\": true, \"department_objective\": 21, \"user\": 4, \"domain\": null, \"description\": \"objetivo xpto3\", \"start_date\": \"2026-11-25\", \"end_date\": \"2026-11-26\", \"percentagem\": \"10.00\", \"status\": \"completed\", \"date_created\": \"2026-11-25T15:37:46.653Z\", \"date_update\": \"2026-11-25T16:00:00.085Z\"}', 'Concluir objetivo individual: objetivo xpto3', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/gestor/minhas-tarefas/24/concluir/', 'POST', '2026-11-25 16:00:00.088572', 4),
(139, 'concluir', 'core.IndividualObjective', '23', 'objetivo xpto 02', '{\"id\": 23, \"is_active\": true, \"department_objective\": 22, \"user\": 4, \"domain\": null, \"description\": \"objetivo xpto 02\", \"start_date\": \"2026-11-25\", \"end_date\": \"2026-11-26\", \"percentagem\": \"10.00\", \"status\": \"active\", \"date_created\": \"2026-11-25T15:37:10.373Z\", \"date_update\": \"2026-11-25T15:44:54.958Z\"}', '{\"id\": 23, \"is_active\": true, \"department_objective\": 22, \"user\": 4, \"domain\": null, \"description\": \"objetivo xpto 02\", \"start_date\": \"2026-11-25\", \"end_date\": \"2026-11-26\", \"percentagem\": \"10.00\", \"status\": \"completed\", \"date_created\": \"2026-11-25T15:37:10.373Z\", \"date_update\": \"2026-11-25T16:03:20.455Z\"}', 'Concluir objetivo individual: objetivo xpto 02', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/gestor/minhas-tarefas/23/concluir/', 'POST', '2026-11-25 16:03:20.459670', 4),
(140, 'editar', 'core.IndividualObjective', '24', 'objetivo xpto3  bdfzbdsfsvsdvdsv fb bbdbsdbs d b sbdbdb adfbdfba', '{\"id\": 24, \"is_active\": true, \"department_objective\": 21, \"user\": 4, \"domain\": null, \"description\": \"objetivo xpto3\", \"start_date\": \"2026-11-25\", \"end_date\": \"2026-11-26\", \"percentagem\": \"10.00\", \"status\": \"active\", \"date_created\": \"2026-11-25T15:37:46.653Z\", \"date_update\": \"2026-11-25T16:00:00.085Z\"}', '{\"id\": 24, \"is_active\": true, \"department_objective\": 21, \"user\": 4, \"domain\": null, \"description\": \"objetivo xpto3  bdfzbdsfsvsdvdsv fb bbdbsdbs d b sbdbdb adfbdfba\", \"start_date\": \"2026-11-25\", \"end_date\": \"2026-11-26\", \"percentagem\": \"10.00\", \"status\": \"active\", \"date_created\": \"2026-11-25T15:37:46.653Z\", \"date_update\": \"2026-11-25T16:08:28.805Z\"}', 'Editar objetivo individual: objetivo xpto3  bdfzbdsfsvsdvdsv fb bbdbsdbs d b sbdbdb adfbdfba', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/planejamento/objetivos-individuais/24/editar/', 'POST', '2026-11-25 16:08:28.807465', 3),
(141, 'editar', 'core.IndividualObjective', '24', 'objetivo xpto3', '{\"id\": 24, \"is_active\": true, \"department_objective\": 21, \"user\": 4, \"domain\": null, \"description\": \"objetivo xpto3  bdfzbdsfsvsdvdsv fb bbdbsdbs d b sbdbdb adfbdfba\", \"start_date\": \"2026-11-25\", \"end_date\": \"2026-11-26\", \"percentagem\": \"10.00\", \"status\": \"active\", \"date_created\": \"2026-11-25T15:37:46.653Z\", \"date_update\": \"2026-11-25T16:08:28.805Z\"}', '{\"id\": 24, \"is_active\": true, \"department_objective\": 21, \"user\": 4, \"domain\": null, \"description\": \"objetivo xpto3\", \"start_date\": \"2026-11-25\", \"end_date\": \"2026-11-26\", \"percentagem\": \"10.00\", \"status\": \"active\", \"date_created\": \"2026-11-25T15:37:46.653Z\", \"date_update\": \"2026-11-25T16:08:50.947Z\"}', 'Editar objetivo individual: objetivo xpto3', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/planejamento/objetivos-individuais/24/editar/', 'POST', '2026-11-25 16:08:50.952492', 3),
(142, 'logout', 'auth.User', '3', 'Raimundo.F.Lopes', NULL, NULL, 'Utilizador terminou a sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '/logout/', 'POST', '2026-11-25 16:33:56.416821', 3),
(143, 'logout', 'auth.User', '4', 'Arcelinda.Carvalho', NULL, NULL, 'Utilizador terminou a sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/logout/', 'POST', '2026-11-27 11:30:18.614321', 4),
(144, 'login_falhou', 'auth.User', '', 'Raimundo.F.Lopes', NULL, NULL, 'Tentativa de autenticação sem sucesso.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/login/', 'POST', '2026-11-27 11:30:25.037742', NULL),
(145, 'editar', 'auth.User', '3', 'Raimundo.F.Lopes', '{\"id\": 3, \"last_login\": \"2026-11-24T16:36:57.130Z\", \"is_superuser\": false, \"username\": \"Raimundo.F.Lopes\", \"first_name\": \"Raimundo\", \"last_name\": \"Lopes\", \"email\": \"Raimundo.F.Lopes@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T10:18:04Z\"}', '{\"id\": 3, \"last_login\": \"2026-11-27T11:30:36.174Z\", \"is_superuser\": false, \"username\": \"Raimundo.F.Lopes\", \"first_name\": \"Raimundo\", \"last_name\": \"Lopes\", \"email\": \"Raimundo.F.Lopes@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T10:18:04Z\"}', 'Editar usuário: Raimundo.F.Lopes', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/login/', 'POST', '2026-11-27 11:30:36.176132', 3),
(146, 'login', 'auth.User', '3', 'Raimundo.F.Lopes', NULL, NULL, 'Utilizador iniciou sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/login/', 'POST', '2026-11-27 11:30:36.176132', 3),
(147, 'logout', 'auth.User', '3', 'Raimundo.F.Lopes', NULL, NULL, 'Utilizador terminou a sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/logout/', 'POST', '2026-11-27 11:47:08.538262', 3),
(148, 'editar', 'auth.User', '4', 'Arcelinda.Carvalho', '{\"id\": 4, \"last_login\": \"2026-11-25T15:38:08.157Z\", \"is_superuser\": false, \"username\": \"Arcelinda.Carvalho\", \"first_name\": \"Arcelinda\", \"last_name\": \"Carvalho\", \"email\": \"Arcelinda.Carvalho@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T12:26:01Z\"}', '{\"id\": 4, \"last_login\": \"2026-11-27T11:47:13.583Z\", \"is_superuser\": false, \"username\": \"Arcelinda.Carvalho\", \"first_name\": \"Arcelinda\", \"last_name\": \"Carvalho\", \"email\": \"Arcelinda.Carvalho@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T12:26:01Z\"}', 'Editar usuário: Arcelinda.Carvalho', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/login/', 'POST', '2026-11-27 11:47:13.588055', 4),
(149, 'login', 'auth.User', '4', 'Arcelinda.Carvalho', NULL, NULL, 'Utilizador iniciou sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/login/', 'POST', '2026-11-27 11:47:13.590431', 4),
(150, 'logout', 'auth.User', '4', 'Arcelinda.Carvalho', NULL, NULL, 'Utilizador terminou a sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/logout/', 'POST', '2026-11-27 11:50:23.204488', 4),
(151, 'editar', 'auth.User', '5', 'aderito.b.monteiro', '{\"id\": 5, \"last_login\": \"2026-11-23T15:37:22.807Z\", \"is_superuser\": false, \"username\": \"aderito.b.monteiro\", \"first_name\": \"Aderito\", \"last_name\": \"Monteiro\", \"email\": \"aderito.b.monteiro@gov.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T15:21:58Z\"}', '{\"id\": 5, \"last_login\": \"2026-11-27T11:50:45.483Z\", \"is_superuser\": false, \"username\": \"aderito.b.monteiro\", \"first_name\": \"Aderito\", \"last_name\": \"Monteiro\", \"email\": \"aderito.b.monteiro@gov.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T15:21:58Z\"}', 'Editar usuário: aderito.b.monteiro', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/login/', 'POST', '2026-11-27 11:50:45.486320', 5),
(152, 'login', 'auth.User', '5', 'aderito.b.monteiro', NULL, NULL, 'Utilizador iniciou sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/login/', 'POST', '2026-11-27 11:50:45.486320', 5),
(153, 'logout', 'auth.User', '5', 'aderito.b.monteiro', NULL, NULL, 'Utilizador terminou a sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/logout/', 'POST', '2026-11-27 11:58:35.982763', 5),
(154, 'editar', 'auth.User', '4', 'Arcelinda.Carvalho', '{\"id\": 4, \"last_login\": \"2026-11-27T11:47:13.583Z\", \"is_superuser\": false, \"username\": \"Arcelinda.Carvalho\", \"first_name\": \"Arcelinda\", \"last_name\": \"Carvalho\", \"email\": \"Arcelinda.Carvalho@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T12:26:01Z\"}', '{\"id\": 4, \"last_login\": \"2026-11-27T11:58:40.455Z\", \"is_superuser\": false, \"username\": \"Arcelinda.Carvalho\", \"first_name\": \"Arcelinda\", \"last_name\": \"Carvalho\", \"email\": \"Arcelinda.Carvalho@incv.cv\", \"is_staff\": false, \"is_active\": true, \"date_joined\": \"2026-09-24T12:26:01Z\"}', 'Editar usuário: Arcelinda.Carvalho', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/login/', 'POST', '2026-11-27 11:58:40.459328', 4),
(155, 'login', 'auth.User', '4', 'Arcelinda.Carvalho', NULL, NULL, 'Utilizador iniciou sessão.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '/login/', 'POST', '2026-11-27 11:58:40.461997', 4);

-- --------------------------------------------------------

--
-- Estrutura da tabela `registo_ocorrencia`
--

CREATE TABLE `registo_ocorrencia` (
  `id` bigint(20) NOT NULL,
  `description` varchar(200) NOT NULL,
  `date_created` datetime(6) NOT NULL,
  `date_update` datetime(6) NOT NULL,
  `objetivo_individual_id` bigint(20) NOT NULL,
  `is_active` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `registo_ocorrencia`
--

INSERT INTO `registo_ocorrencia` (`id`, `description`, `date_created`, `date_update`, `objetivo_individual_id`, `is_active`) VALUES
(2, 'pendente xpto', '2026-10-05 13:06:22.282219', '2026-10-05 13:06:22.282219', 13, 0),
(3, 'estou bloqueado com alguns pontos', '2026-10-05 13:11:49.917187', '2026-10-05 13:11:49.918179', 13, 0),
(5, 'ok', '2026-10-05 16:20:22.719348', '2026-10-05 16:20:22.719348', 14, 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `system_notification_reads`
--

CREATE TABLE `system_notification_reads` (
  `id` bigint(20) NOT NULL,
  `notification_key` varchar(200) NOT NULL,
  `read_at` datetime(6) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `system_notification_reads`
--

INSERT INTO `system_notification_reads` (`id`, `notification_key`, `read_at`, `user_id`) VALUES
(1, 'department-decision-22-18', '2026-11-24 12:50:30.051332', 4),
(2, 'department-decision-21-17', '2026-11-24 12:50:30.051332', 4),
(3, 'department-approval-23-new', '2026-11-25 11:37:47.645620', 3),
(4, 'department-decision-23-19', '2026-11-25 11:38:39.463441', 4),
(5, 'department-approval-26-new', '2026-11-25 11:50:43.272029', 3),
(6, 'department-approval-25-new', '2026-11-25 11:50:43.273030', 3),
(7, 'department-approval-24-new', '2026-11-25 11:50:43.273030', 3),
(8, 'department-decision-24-22', '2026-11-25 11:51:03.071816', 8),
(9, 'department-decision-25-21', '2026-11-25 11:51:03.071816', 8),
(10, 'department-decision-26-20', '2026-11-25 11:51:03.071816', 8);

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `aprovacao_tarefas`
--
ALTER TABLE `aprovacao_tarefas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `aprovacao_tarefas_domain_id_8af424d0_fk_domain_id` (`domain_id`),
  ADD KEY `aprovacao_tarefas_objetivo_departtamen_46b124cb_fk_core_depa` (`objetivo_departtamento_id`),
  ADD KEY `aprovacao_tarefas_is_active_8c2f367c` (`is_active`);

--
-- Índices para tabela `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Índices para tabela `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- Índices para tabela `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- Índices para tabela `auth_user`
--
ALTER TABLE `auth_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Índices para tabela `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  ADD KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`);

--
-- Índices para tabela `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  ADD KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`);

--
-- Índices para tabela `core_cycle`
--
ALTER TABLE `core_cycle`
  ADD PRIMARY KEY (`id`),
  ADD KEY `core_cycle_domain_id_d5bcf151_fk_domain_id` (`domain_id`),
  ADD KEY `core_cycle_is_active_d98743fa` (`is_active`);

--
-- Índices para tabela `core_department`
--
ALTER TABLE `core_department`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `core_department_is_active_153c78b2` (`is_active`);

--
-- Índices para tabela `core_departmentobjective`
--
ALTER TABLE `core_departmentobjective`
  ADD PRIMARY KEY (`id`),
  ADD KEY `core_departmentobjec_institutional_object_e9ce3fa4_fk_core_inst` (`institutional_objective_id`),
  ADD KEY `core_departmentobjec_department_id_26d00e03_fk_core_depa` (`department_id`),
  ADD KEY `core_departmentobjective_domain_id_9afd1de1_fk_domain_id` (`domain_id`),
  ADD KEY `core_departmentobjective_is_active_869aa4cd` (`is_active`);

--
-- Índices para tabela `core_evaluation`
--
ALTER TABLE `core_evaluation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `core_evaluation_cycle_id_17fd6337_fk_core_cycle_id` (`cycle_id`),
  ADD KEY `core_evaluation_employee_id_3a4e6fa9_fk_auth_user_id` (`employee_id`),
  ADD KEY `core_evaluation_evaluator_id_e5ed403a_fk_auth_user_id` (`evaluator_id`),
  ADD KEY `core_evaluation_is_active_d0f469c7` (`is_active`);

--
-- Índices para tabela `core_followup`
--
ALTER TABLE `core_followup`
  ADD PRIMARY KEY (`id`),
  ADD KEY `core_followup_author_id_8af1ba40_fk_auth_user_id` (`author_id`),
  ADD KEY `core_followup_cycle_id_85aada54_fk_core_cycle_id` (`cycle_id`),
  ADD KEY `core_followup_employee_id_66a088b9_fk_auth_user_id` (`employee_id`),
  ADD KEY `core_followup_is_active_954f37b4` (`is_active`);

--
-- Índices para tabela `core_individualobjective`
--
ALTER TABLE `core_individualobjective`
  ADD PRIMARY KEY (`id`),
  ADD KEY `core_individualobjec_department_objective_0076e82a_fk_core_depa` (`department_objective_id`),
  ADD KEY `core_individualobjective_user_id_a55c270d_fk_auth_user_id` (`user_id`),
  ADD KEY `core_individualobjective_domain_id_e7d778f8_fk_domain_id` (`domain_id`),
  ADD KEY `core_individualobjective_is_active_8f1e7c76` (`is_active`);

--
-- Índices para tabela `core_institutionalobjective`
--
ALTER TABLE `core_institutionalobjective`
  ADD PRIMARY KEY (`id`),
  ADD KEY `core_institutionalobjective_cycle_id_a3ba4704_fk_core_cycle_id` (`cycle_id`),
  ADD KEY `core_institutionalobjective_domain_id_e8fea75a_fk_domain_id` (`domain_id`),
  ADD KEY `core_institutionalobjective_is_active_fa67d440` (`is_active`);

--
-- Índices para tabela `core_objective`
--
ALTER TABLE `core_objective`
  ADD PRIMARY KEY (`id`),
  ADD KEY `core_objective_created_by_id_c97b88cc_fk_auth_user_id` (`created_by_id`),
  ADD KEY `core_objective_cycle_id_e363031b_fk_core_cycle_id` (`cycle_id`),
  ADD KEY `core_objective_employee_id_e550bb13_fk_auth_user_id` (`employee_id`),
  ADD KEY `core_objective_is_active_67e4ece2` (`is_active`);

--
-- Índices para tabela `core_userdepartment`
--
ALTER TABLE `core_userdepartment`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD KEY `core_userdepartment_department_id_9eca1c3a_fk_core_department_id` (`department_id`),
  ADD KEY `core_userdepartment_is_active_0c9bfe2f` (`is_active`);

--
-- Índices para tabela `core_validation`
--
ALTER TABLE `core_validation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `core_validation_cycle_id_f1d92e75_fk_core_cycle_id` (`cycle_id`),
  ADD KEY `core_validation_evaluation_id_6aba2f77_fk_core_evaluation_id` (`evaluation_id`),
  ADD KEY `core_validation_validator_id_56e80a4b_fk_auth_user_id` (`validator_id`),
  ADD KEY `core_validation_is_active_9bd1bac8` (`is_active`);

--
-- Índices para tabela `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`);

--
-- Índices para tabela `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Índices para tabela `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- Índices para tabela `domain`
--
ALTER TABLE `domain`
  ADD PRIMARY KEY (`id`),
  ADD KEY `domain_is_active_f6c3358a` (`is_active`);

--
-- Índices para tabela `historico_operacoes`
--
ALTER TABLE `historico_operacoes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `historico_operacoes_data_criacao_88b5bf92` (`data_criacao`),
  ADD KEY `historico_o_utiliza_1db581_idx` (`utilizador_id`,`data_criacao`),
  ADD KEY `historico_o_acao_3de594_idx` (`acao`,`data_criacao`),
  ADD KEY `historico_o_modelo_e354a9_idx` (`modelo`,`objeto_id`);

--
-- Índices para tabela `registo_ocorrencia`
--
ALTER TABLE `registo_ocorrencia`
  ADD PRIMARY KEY (`id`),
  ADD KEY `registo_ocorrencia_objetivo_individual__b35dd0d8_fk_core_indi` (`objetivo_individual_id`),
  ADD KEY `registo_ocorrencia_is_active_4ddf3ea3` (`is_active`);

--
-- Índices para tabela `system_notification_reads`
--
ALTER TABLE `system_notification_reads`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_system_notification_read_user_key` (`user_id`,`notification_key`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `aprovacao_tarefas`
--
ALTER TABLE `aprovacao_tarefas`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de tabela `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=85;

--
-- AUTO_INCREMENT de tabela `auth_user`
--
ALTER TABLE `auth_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de tabela `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de tabela `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de tabela `core_cycle`
--
ALTER TABLE `core_cycle`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT de tabela `core_department`
--
ALTER TABLE `core_department`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de tabela `core_departmentobjective`
--
ALTER TABLE `core_departmentobjective`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT de tabela `core_evaluation`
--
ALTER TABLE `core_evaluation`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `core_followup`
--
ALTER TABLE `core_followup`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `core_individualobjective`
--
ALTER TABLE `core_individualobjective`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT de tabela `core_institutionalobjective`
--
ALTER TABLE `core_institutionalobjective`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de tabela `core_objective`
--
ALTER TABLE `core_objective`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `core_userdepartment`
--
ALTER TABLE `core_userdepartment`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT de tabela `core_validation`
--
ALTER TABLE `core_validation`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de tabela `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de tabela `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT de tabela `domain`
--
ALTER TABLE `domain`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `historico_operacoes`
--
ALTER TABLE `historico_operacoes`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=156;

--
-- AUTO_INCREMENT de tabela `registo_ocorrencia`
--
ALTER TABLE `registo_ocorrencia`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `system_notification_reads`
--
ALTER TABLE `system_notification_reads`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `aprovacao_tarefas`
--
ALTER TABLE `aprovacao_tarefas`
  ADD CONSTRAINT `aprovacao_tarefas_domain_id_8af424d0_fk_domain_id` FOREIGN KEY (`domain_id`) REFERENCES `domain` (`id`),
  ADD CONSTRAINT `aprovacao_tarefas_objetivo_departtamen_46b124cb_fk_core_depa` FOREIGN KEY (`objetivo_departtamento_id`) REFERENCES `core_departmentobjective` (`id`);

--
-- Limitadores para a tabela `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Limitadores para a tabela `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Limitadores para a tabela `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Limitadores para a tabela `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Limitadores para a tabela `core_cycle`
--
ALTER TABLE `core_cycle`
  ADD CONSTRAINT `core_cycle_domain_id_d5bcf151_fk_domain_id` FOREIGN KEY (`domain_id`) REFERENCES `domain` (`id`);

--
-- Limitadores para a tabela `core_departmentobjective`
--
ALTER TABLE `core_departmentobjective`
  ADD CONSTRAINT `core_departmentobjec_department_id_26d00e03_fk_core_depa` FOREIGN KEY (`department_id`) REFERENCES `core_department` (`id`),
  ADD CONSTRAINT `core_departmentobjec_institutional_object_e9ce3fa4_fk_core_inst` FOREIGN KEY (`institutional_objective_id`) REFERENCES `core_institutionalobjective` (`id`),
  ADD CONSTRAINT `core_departmentobjective_domain_id_9afd1de1_fk_domain_id` FOREIGN KEY (`domain_id`) REFERENCES `domain` (`id`);

--
-- Limitadores para a tabela `core_evaluation`
--
ALTER TABLE `core_evaluation`
  ADD CONSTRAINT `core_evaluation_cycle_id_17fd6337_fk_core_cycle_id` FOREIGN KEY (`cycle_id`) REFERENCES `core_cycle` (`id`),
  ADD CONSTRAINT `core_evaluation_employee_id_3a4e6fa9_fk_auth_user_id` FOREIGN KEY (`employee_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `core_evaluation_evaluator_id_e5ed403a_fk_auth_user_id` FOREIGN KEY (`evaluator_id`) REFERENCES `auth_user` (`id`);

--
-- Limitadores para a tabela `core_followup`
--
ALTER TABLE `core_followup`
  ADD CONSTRAINT `core_followup_author_id_8af1ba40_fk_auth_user_id` FOREIGN KEY (`author_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `core_followup_cycle_id_85aada54_fk_core_cycle_id` FOREIGN KEY (`cycle_id`) REFERENCES `core_cycle` (`id`),
  ADD CONSTRAINT `core_followup_employee_id_66a088b9_fk_auth_user_id` FOREIGN KEY (`employee_id`) REFERENCES `auth_user` (`id`);

--
-- Limitadores para a tabela `core_individualobjective`
--
ALTER TABLE `core_individualobjective`
  ADD CONSTRAINT `core_individualobjec_department_objective_0076e82a_fk_core_depa` FOREIGN KEY (`department_objective_id`) REFERENCES `core_departmentobjective` (`id`),
  ADD CONSTRAINT `core_individualobjective_domain_id_e7d778f8_fk_domain_id` FOREIGN KEY (`domain_id`) REFERENCES `domain` (`id`),
  ADD CONSTRAINT `core_individualobjective_user_id_a55c270d_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Limitadores para a tabela `core_institutionalobjective`
--
ALTER TABLE `core_institutionalobjective`
  ADD CONSTRAINT `core_institutionalobjective_cycle_id_a3ba4704_fk_core_cycle_id` FOREIGN KEY (`cycle_id`) REFERENCES `core_cycle` (`id`),
  ADD CONSTRAINT `core_institutionalobjective_domain_id_e8fea75a_fk_domain_id` FOREIGN KEY (`domain_id`) REFERENCES `domain` (`id`);

--
-- Limitadores para a tabela `core_objective`
--
ALTER TABLE `core_objective`
  ADD CONSTRAINT `core_objective_created_by_id_c97b88cc_fk_auth_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `core_objective_cycle_id_e363031b_fk_core_cycle_id` FOREIGN KEY (`cycle_id`) REFERENCES `core_cycle` (`id`),
  ADD CONSTRAINT `core_objective_employee_id_e550bb13_fk_auth_user_id` FOREIGN KEY (`employee_id`) REFERENCES `auth_user` (`id`);

--
-- Limitadores para a tabela `core_userdepartment`
--
ALTER TABLE `core_userdepartment`
  ADD CONSTRAINT `core_userdepartment_department_id_9eca1c3a_fk_core_department_id` FOREIGN KEY (`department_id`) REFERENCES `core_department` (`id`),
  ADD CONSTRAINT `core_userdepartment_user_id_d59374b1_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Limitadores para a tabela `core_validation`
--
ALTER TABLE `core_validation`
  ADD CONSTRAINT `core_validation_cycle_id_f1d92e75_fk_core_cycle_id` FOREIGN KEY (`cycle_id`) REFERENCES `core_cycle` (`id`),
  ADD CONSTRAINT `core_validation_evaluation_id_6aba2f77_fk_core_evaluation_id` FOREIGN KEY (`evaluation_id`) REFERENCES `core_evaluation` (`id`),
  ADD CONSTRAINT `core_validation_validator_id_56e80a4b_fk_auth_user_id` FOREIGN KEY (`validator_id`) REFERENCES `auth_user` (`id`);

--
-- Limitadores para a tabela `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Limitadores para a tabela `historico_operacoes`
--
ALTER TABLE `historico_operacoes`
  ADD CONSTRAINT `historico_operacoes_utilizador_id_3f6b8516_fk_auth_user_id` FOREIGN KEY (`utilizador_id`) REFERENCES `auth_user` (`id`);

--
-- Limitadores para a tabela `registo_ocorrencia`
--
ALTER TABLE `registo_ocorrencia`
  ADD CONSTRAINT `registo_ocorrencia_objetivo_individual__b35dd0d8_fk_core_indi` FOREIGN KEY (`objetivo_individual_id`) REFERENCES `core_individualobjective` (`id`);

--
-- Limitadores para a tabela `system_notification_reads`
--
ALTER TABLE `system_notification_reads`
  ADD CONSTRAINT `system_notification_reads_user_id_b02cbe43_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
