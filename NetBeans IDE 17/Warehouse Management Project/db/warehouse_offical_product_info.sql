-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: warehouse_offical
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `product_info`
--

DROP TABLE IF EXISTS `product_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `code` varchar(50) NOT NULL,
  `cate_id` int DEFAULT NULL,
  `unit_id` int DEFAULT NULL,
  `active_flag` tinyint(1) DEFAULT '1',
  `status` varchar(20) DEFAULT NULL,
  `description` text,
  `min_stock_threshold` decimal(10,2) DEFAULT NULL COMMENT 'Minimum stock level to trigger low stock warning',
  `supplier_id` int DEFAULT NULL COMMENT 'Foreign key reference to supplier table',
  `expiration_date` date DEFAULT NULL COMMENT 'Product expiration date',
  `additional_notes` text COMMENT 'Additional notes or remarks about the product',
  `created_by` int DEFAULT NULL COMMENT 'User ID who created this product record',
  `created_date` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Date and time when product was created',
  `updated_date` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Date and time when product was last updated',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `unit_id` (`unit_id`),
  KEY `product_info_ibfk_1` (`cate_id`),
  KEY `idx_product_info_min_stock_threshold` (`min_stock_threshold`),
  KEY `fk_product_created_by` (`created_by`),
  KEY `idx_product_info_supplier_id` (`supplier_id`),
  KEY `idx_product_info_expiration_date` (`expiration_date`),
  CONSTRAINT `fk_product_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_product_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `supplier` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `product_info_ibfk_1` FOREIGN KEY (`cate_id`) REFERENCES `category` (`id`),
  CONSTRAINT `product_info_ibfk_2` FOREIGN KEY (`unit_id`) REFERENCES `unit` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-22 13:38:33
