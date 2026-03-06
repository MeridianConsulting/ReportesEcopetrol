START TRANSACTION;

CREATE TABLE IF NOT EXISTS `ods_activities` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `service_order_id` bigint(20) NOT NULL,
  `title` varchar(180) NOT NULL,
  `item_general` varchar(20) DEFAULT NULL,
  `item_activity` varchar(20) DEFAULT NULL,
  `description` text NOT NULL,
  `support_text` text DEFAULT NULL,
  `delivery_medium_id` int(11) DEFAULT NULL,
  `contracted_days` decimal(10,2) DEFAULT NULL,
  `planned_start_date` date DEFAULT NULL,
  `planned_end_date` date DEFAULT NULL,
  `status` enum('Borrador','Activa','En pausa','Finalizada','Cancelada') NOT NULL DEFAULT 'Borrador',
  `notes` text DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_ods_activities_service_order` (`service_order_id`),
  KEY `idx_ods_activities_status` (`status`),
  KEY `idx_ods_activities_delivery_medium` (`delivery_medium_id`),
  KEY `idx_ods_activities_created_by` (`created_by`),
  KEY `idx_ods_activities_deleted` (`deleted_at`),
  CONSTRAINT `fk_ods_activities_service_order`
    FOREIGN KEY (`service_order_id`) REFERENCES `service_orders` (`id`),
  CONSTRAINT `fk_ods_activities_delivery_medium`
    FOREIGN KEY (`delivery_medium_id`) REFERENCES `delivery_media` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_ods_activities_created_by`
    FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_ods_activities_updated_by`
    FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `ods_activity_assignments` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `activity_id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `assigned_by` int(11) NOT NULL,
  `assigned_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_ods_activity_assignment_active` (`activity_id`, `user_id`, `is_active`),
  KEY `idx_ods_activity_assignments_user` (`user_id`),
  KEY `idx_ods_activity_assignments_active` (`is_active`),
  CONSTRAINT `fk_ods_activity_assignments_activity`
    FOREIGN KEY (`activity_id`) REFERENCES `ods_activities` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ods_activity_assignments_user`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_ods_activity_assignments_assigned_by`
    FOREIGN KEY (`assigned_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

COMMIT;
