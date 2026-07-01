CREATE DATABASE  IF NOT EXISTS `uniresolvedb` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `uniresolvedb`;
-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: uniresolvedb
-- ------------------------------------------------------
-- Server version	8.0.43

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
-- Table structure for table `accounts_notification`
--

DROP TABLE IF EXISTS `accounts_notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accounts_notification` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `message` varchar(255) NOT NULL,
  `is_read` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `user_id` bigint NOT NULL,
  `link` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `accounts_notification_user_id_30e6cfc5_fk_accounts_user_id` (`user_id`),
  CONSTRAINT `accounts_notification_user_id_30e6cfc5_fk_accounts_user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=236 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts_notification`
--

LOCK TABLES `accounts_notification` WRITE;
/*!40000 ALTER TABLE `accounts_notification` DISABLE KEYS */;
INSERT INTO `accounts_notification` VALUES (1,'Your ticket \"#29\" status was updated to REJECTED.',1,'2026-04-02 13:16:22.542717',22,'/api/v1/student-dashboard/ticket/29/'),(2,'Your ticket \"#35\" status was updated to IN_PROGRESS.',1,'2026-04-02 13:31:02.508429',15,'/api/v1/ticket/35/'),(3,'Your ticket \"#35\" status was updated to PENDING.',1,'2026-04-02 14:00:25.145117',15,'/api/v1/ticket/35/'),(4,'Your ticket \"#35\" has been resolved. Please provide feedback to close it.',1,'2026-04-02 14:28:23.895568',15,'/api/v1/ticket/35/'),(5,'New ticket \"#38\" submitted by Lydia Waweru.',1,'2026-04-02 16:29:03.538280',10,'/api/v1/ticket/38/'),(6,'New ticket \"#38\" submitted by Lydia Waweru.',0,'2026-04-02 16:29:03.538280',42,'/api/v1/ticket/38/'),(7,'New ticket \"#38\" submitted by Lydia Waweru.',0,'2026-04-02 16:29:03.538280',56,'/api/v1/ticket/38/'),(8,'Your ticket \"#38\" requires additional information.',1,'2026-04-02 16:33:27.419215',15,'/api/v1/ticket/38/'),(9,'Lydia Waweru provided additional info for ticket \"#38\".',1,'2026-04-02 16:34:22.429378',10,'/api/v1/staff-dashboard/ticket/38/'),(10,'Lydia Waweru provided additional info for ticket \"#38\".',0,'2026-04-02 16:34:22.429378',42,'/api/v1/staff-dashboard/ticket/38/'),(11,'Lydia Waweru provided additional info for ticket \"#38\".',0,'2026-04-02 16:34:22.429378',56,'/api/v1/staff-dashboard/ticket/38/'),(12,'Your ticket \"#38\" has been resolved. Please provide feedback to close it.',1,'2026-04-02 16:36:37.963314',15,'/api/v1/ticket/38/'),(13,'Ticket \"#38\" was REOPENED by Lydia Waweru based on feedback.',1,'2026-04-02 16:37:37.283050',10,'/api/v1/staff-dashboard/ticket/38/'),(14,'Ticket \"#38\" was REOPENED by Lydia Waweru based on feedback.',0,'2026-04-02 16:37:37.283050',42,'/api/v1/staff-dashboard/ticket/38/'),(15,'Ticket \"#38\" was REOPENED by Lydia Waweru based on feedback.',0,'2026-04-02 16:37:37.283050',56,'/api/v1/staff-dashboard/ticket/38/'),(16,'Your ticket \"#38\" has been transferred to Registry.',1,'2026-04-02 16:47:30.904565',15,'/api/v1/ticket/38/'),(17,'Ticket \"#38\" was transferred out to Registry.',1,'2026-04-02 16:47:30.914527',10,'/api/v1/staff-dashboard/all-issues/'),(18,'Ticket \"#38\" was transferred out to Registry.',0,'2026-04-02 16:47:30.914527',42,'/api/v1/staff-dashboard/all-issues/'),(19,'Ticket \"#38\" was transferred out to Registry.',0,'2026-04-02 16:47:30.914527',56,'/api/v1/staff-dashboard/all-issues/'),(20,'Ticket \"#38\" was transferred into your department from Computer & Information Science.',0,'2026-04-02 16:47:30.921504',7,'/api/v1/staff-dashboard/ticket/38/'),(21,'Ticket \"#38\" was transferred into your department from Computer & Information Science.',0,'2026-04-02 16:47:30.921504',8,'/api/v1/staff-dashboard/ticket/38/'),(22,'Ticket \"#38\" was transferred into your department from Computer & Information Science.',1,'2026-04-02 16:47:30.921504',20,'/api/v1/staff-dashboard/ticket/38/'),(23,'Ticket \"#38\" was transferred into your department from Computer & Information Science.',1,'2026-04-02 16:47:30.922507',23,'/api/v1/staff-dashboard/ticket/38/'),(24,'Ticket \"#38\" was transferred into your department from Computer & Information Science.',0,'2026-04-02 16:47:30.922507',59,'/api/v1/staff-dashboard/ticket/38/'),(25,'New ticket \"#39\" submitted by King Luther.',0,'2026-04-02 16:59:58.400427',7,'/api/v1/staff-dashboard/ticket/39/'),(26,'New ticket \"#39\" submitted by King Luther.',0,'2026-04-02 16:59:58.400427',8,'/api/v1/staff-dashboard/ticket/39/'),(27,'New ticket \"#39\" submitted by King Luther.',1,'2026-04-02 16:59:58.400427',20,'/api/v1/staff-dashboard/ticket/39/'),(28,'New ticket \"#39\" submitted by King Luther.',1,'2026-04-02 16:59:58.400427',23,'/api/v1/staff-dashboard/ticket/39/'),(29,'New ticket \"#39\" submitted by King Luther.',0,'2026-04-02 16:59:58.400427',59,'/api/v1/staff-dashboard/ticket/39/'),(30,'Your ticket \"#39\" status was updated to ESCALATED through auto-escalation.',1,'2026-04-03 11:07:00.446910',13,'/api/v1/ticket/39/'),(31,'Ticket \"#39\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',0,'2026-04-03 11:07:00.475173',7,'/api/v1/staff-dashboard/ticket/39/'),(32,'Ticket \"#39\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',0,'2026-04-03 11:07:00.475173',8,'/api/v1/staff-dashboard/ticket/39/'),(33,'Ticket \"#39\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',1,'2026-04-03 11:07:00.475173',20,'/api/v1/staff-dashboard/ticket/39/'),(34,'Ticket \"#39\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',1,'2026-04-03 11:07:00.475173',23,'/api/v1/staff-dashboard/ticket/39/'),(35,'Ticket \"#39\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',0,'2026-04-03 11:07:00.475173',59,'/api/v1/staff-dashboard/ticket/39/'),(36,'Your ticket \"#9\" has been escalated.',0,'2026-04-03 11:19:50.579233',9,'/api/v1/ticket/9/'),(37,'Ticket \"#9\" has been escalated to Senior Staff.',1,'2026-04-03 11:19:50.586201',23,'/api/v1/staff-dashboard/ticket/9/'),(38,'Ticket \"#9\" has been escalated to Senior Staff.',0,'2026-04-03 11:19:50.590190',7,'/api/v1/staff-dashboard/all-issues/'),(39,'Ticket \"#9\" has been escalated to Senior Staff.',0,'2026-04-03 11:19:50.590190',8,'/api/v1/staff-dashboard/all-issues/'),(40,'Ticket \"#9\" has been escalated to Senior Staff.',1,'2026-04-03 11:19:50.590190',20,'/api/v1/staff-dashboard/all-issues/'),(41,'Ticket \"#9\" has been escalated to Senior Staff.',0,'2026-04-03 11:19:50.590190',59,'/api/v1/staff-dashboard/all-issues/'),(42,'Your ticket \"#38\" status was updated to ESCALATED through auto-escalation.',1,'2026-04-04 11:31:19.906242',15,'/api/v1/ticket/38/'),(43,'Ticket \"#38\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',1,'2026-04-04 11:31:19.924154',23,'/api/v1/staff-dashboard/ticket/38/'),(44,'Ticket \"#38\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',0,'2026-04-04 11:31:19.932229',7,'/api/v1/staff-dashboard/all-issues/'),(45,'Ticket \"#38\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',0,'2026-04-04 11:31:19.932229',8,'/api/v1/staff-dashboard/all-issues/'),(46,'Ticket \"#38\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',1,'2026-04-04 11:31:19.932229',20,'/api/v1/staff-dashboard/all-issues/'),(47,'Ticket \"#38\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',0,'2026-04-04 11:31:19.932229',59,'/api/v1/staff-dashboard/all-issues/'),(48,'New ticket \"#40\" submitted by Joe Down.',0,'2026-04-04 11:32:12.625499',7,'/api/v1/staff-dashboard/ticket/40/'),(49,'New ticket \"#40\" submitted by Joe Down.',0,'2026-04-04 11:32:12.625499',8,'/api/v1/staff-dashboard/ticket/40/'),(50,'New ticket \"#40\" submitted by Joe Down.',1,'2026-04-04 11:32:12.625499',20,'/api/v1/staff-dashboard/ticket/40/'),(51,'New ticket \"#40\" submitted by Joe Down.',1,'2026-04-04 11:32:12.626496',23,'/api/v1/staff-dashboard/ticket/40/'),(52,'New ticket \"#40\" submitted by Joe Down.',0,'2026-04-04 11:32:12.626572',59,'/api/v1/staff-dashboard/ticket/40/'),(53,'WARNING: Ticket \"#40\" is approaching its deadline. Less than 0.4 hours remain.',0,'2026-04-04 12:09:00.901377',7,'/api/v1/staff-dashboard/ticket/40/'),(54,'WARNING: Ticket \"#40\" is approaching its deadline. Less than 0.4 hours remain.',0,'2026-04-04 12:09:00.901377',8,'/api/v1/staff-dashboard/ticket/40/'),(55,'WARNING: Ticket \"#40\" is approaching its deadline. Less than 0.4 hours remain.',1,'2026-04-04 12:09:00.901377',20,'/api/v1/staff-dashboard/ticket/40/'),(56,'WARNING: Ticket \"#40\" is approaching its deadline. Less than 0.4 hours remain.',0,'2026-04-04 12:09:00.901377',59,'/api/v1/staff-dashboard/ticket/40/'),(57,'New ticket \"#41\" submitted by King Luther.',0,'2026-04-04 12:19:20.501747',7,'/api/v1/staff-dashboard/ticket/41/'),(58,'New ticket \"#41\" submitted by King Luther.',0,'2026-04-04 12:19:20.501747',8,'/api/v1/staff-dashboard/ticket/41/'),(59,'New ticket \"#41\" submitted by King Luther.',1,'2026-04-04 12:19:20.501747',20,'/api/v1/staff-dashboard/ticket/41/'),(60,'New ticket \"#41\" submitted by King Luther.',1,'2026-04-04 12:19:20.501747',23,'/api/v1/staff-dashboard/ticket/41/'),(61,'New ticket \"#41\" submitted by King Luther.',0,'2026-04-04 12:19:20.501747',59,'/api/v1/staff-dashboard/ticket/41/'),(62,'Your ticket \"#40\" status was updated to ESCALATED through auto-escalation.',0,'2026-04-04 12:44:45.816499',22,'/api/v1/ticket/40/'),(63,'Ticket \"#40\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',1,'2026-04-04 12:44:45.832224',23,'/api/v1/staff-dashboard/ticket/40/'),(64,'Ticket \"#40\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',0,'2026-04-04 12:44:45.842189',7,'/api/v1/staff-dashboard/all-issues/'),(65,'Ticket \"#40\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',0,'2026-04-04 12:44:45.842189',8,'/api/v1/staff-dashboard/all-issues/'),(66,'Ticket \"#40\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',1,'2026-04-04 12:44:45.842189',20,'/api/v1/staff-dashboard/all-issues/'),(67,'Ticket \"#40\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',0,'2026-04-04 12:44:45.842189',59,'/api/v1/staff-dashboard/all-issues/'),(68,'WARNING: Ticket \"#41\" is approaching its deadline. Only 20m remaining.',0,'2026-04-04 12:58:23.933805',7,'/api/v1/staff-dashboard/ticket/41/'),(69,'WARNING: Ticket \"#41\" is approaching its deadline. Only 20m remaining.',0,'2026-04-04 12:58:23.933805',8,'/api/v1/staff-dashboard/ticket/41/'),(70,'WARNING: Ticket \"#41\" is approaching its deadline. Only 20m remaining.',1,'2026-04-04 12:58:23.933805',20,'/api/v1/staff-dashboard/ticket/41/'),(71,'WARNING: Ticket \"#41\" is approaching its deadline. Only 20m remaining.',0,'2026-04-04 12:58:23.933805',59,'/api/v1/staff-dashboard/ticket/41/'),(72,'Your ticket \"#41\" has been resolved. Please provide feedback to close it.',0,'2026-04-04 12:59:20.557372',13,'/api/v1/ticket/41/'),(73,'New ticket \"#42\" submitted by Robyn Fenty.',0,'2026-04-05 23:55:39.164234',7,'/api/v1/staff-dashboard/ticket/42/'),(74,'New ticket \"#42\" submitted by Robyn Fenty.',0,'2026-04-05 23:55:39.164234',8,'/api/v1/staff-dashboard/ticket/42/'),(75,'New ticket \"#42\" submitted by Robyn Fenty.',1,'2026-04-05 23:55:39.164234',20,'/api/v1/staff-dashboard/ticket/42/'),(76,'New ticket \"#42\" submitted by Robyn Fenty.',1,'2026-04-05 23:55:39.164234',23,'/api/v1/staff-dashboard/ticket/42/'),(77,'New ticket \"#43\" submitted by Andre Muruiki.',1,'2026-04-06 00:07:46.216763',20,'/api/v1/staff-dashboard/ticket/43/'),(78,'New ticket \"#43\" submitted by Andre Muruiki.',1,'2026-04-06 00:07:46.216763',23,'/api/v1/staff-dashboard/ticket/43/'),(79,'Your ticket \"#42\" status was updated to ESCALATED through auto-escalation.',0,'2026-04-14 22:38:23.141103',45,'/api/v1/ticket/42/'),(80,'Ticket \"#42\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',1,'2026-04-14 22:38:23.169110',23,'/api/v1/staff-dashboard/ticket/42/'),(81,'Ticket \"#42\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',1,'2026-04-14 22:38:23.241722',20,'/api/v1/staff-dashboard/all-issues/'),(82,'Your ticket \"#43\" status was updated to ESCALATED through auto-escalation.',0,'2026-04-14 22:38:23.358158',53,'/api/v1/ticket/43/'),(83,'Ticket \"#43\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',1,'2026-04-14 22:38:23.394584',23,'/api/v1/staff-dashboard/ticket/43/'),(84,'Ticket \"#43\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',1,'2026-04-14 22:38:23.419069',20,'/api/v1/staff-dashboard/all-issues/'),(85,'New ticket \"#44\" submitted by King Luther.',1,'2026-04-14 22:38:58.234746',20,'/api/v1/staff-dashboard/ticket/44/'),(86,'New ticket \"#44\" submitted by King Luther.',1,'2026-04-14 22:38:58.234746',23,'/api/v1/staff-dashboard/ticket/44/'),(87,'Your ticket \"#43\" status was updated to REJECTED.',0,'2026-04-14 22:52:27.006139',53,'/api/v1/ticket/43/'),(88,'Your ticket \"#44\" status was updated to ESCALATED through auto-escalation.',0,'2026-04-15 11:11:49.944176',13,'/api/v1/ticket/44/'),(89,'Ticket \"#44\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',1,'2026-04-15 11:11:50.153442',23,'/api/v1/staff-dashboard/ticket/44/'),(90,'Ticket \"#44\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',1,'2026-04-15 11:11:50.263985',20,'/api/v1/staff-dashboard/all-issues/'),(91,'Your ticket \"#28\" requires additional information.',1,'2026-04-15 13:00:01.032353',13,'/api/v1/ticket/28/'),(92,'New ticket \"#45\" submitted by Andre Muruiki.',0,'2026-04-21 12:00:43.628359',21,'/api/v1/staff-dashboard/ticket/45/'),(93,'Your ticket \"#45\" has been transferred to Computer & Information Science.',0,'2026-04-21 12:25:48.338153',53,'/api/v1/ticket/45/'),(94,'Ticket \"#45\" was transferred out to Computer & Information Science.',0,'2026-04-21 12:25:48.390259',21,'/api/v1/staff-dashboard/all-issues/'),(95,'Ticket \"#45\" was transferred into your department from Finance.',1,'2026-04-21 12:25:48.445493',10,'/api/v1/staff-dashboard/ticket/45/'),(96,'Your ticket \"#45\" status was updated to ESCALATED through auto-escalation.',0,'2026-04-22 17:33:23.484662',53,'/api/v1/ticket/45/'),(97,'Ticket \"#45\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',0,'2026-04-22 17:33:23.515135',10,'/api/v1/staff-dashboard/all-issues/'),(98,'New ticket \"#46\" submitted by Mark Njoroge.',0,'2026-04-22 17:40:55.294831',10,'/api/v1/staff-dashboard/ticket/46/'),(99,'Your ticket \"#46\" has been resolved. Please provide feedback to close it.',1,'2026-04-22 18:06:10.355002',66,'/api/v1/ticket/46/'),(100,'Ticket \"#46\" was REOPENED by Mark Njoroge based on feedback.',0,'2026-04-22 18:09:29.011752',10,'/api/v1/staff-dashboard/ticket/46/'),(101,'Your ticket \"#46\" has been transferred to Test Department.',0,'2026-04-22 18:21:30.880102',66,'/api/v1/ticket/46/'),(102,'Ticket \"#46\" was transferred out to Test Department.',0,'2026-04-22 18:21:30.891660',10,'/api/v1/staff-dashboard/all-issues/'),(103,'Ticket \"#46\" was transferred into your department from Computer & Information Science.',0,'2026-04-22 18:21:30.926856',64,'/api/v1/staff-dashboard/ticket/46/'),(104,'New ticket \"#47\" submitted by Gatura Hamisi.',0,'2026-04-22 21:41:30.369901',10,'/api/v1/staff-dashboard/ticket/47/'),(105,'New ticket \"#47\" submitted by Gatura Hamisi.',0,'2026-04-22 21:41:30.369901',67,'/api/v1/staff-dashboard/ticket/47/'),(106,'Your ticket \"#47\" requires additional information.',1,'2026-04-22 22:01:26.892433',65,'/api/v1/ticket/47/'),(107,'Gatura Hamisi provided additional info for ticket \"#47\".',0,'2026-04-22 22:06:41.558969',10,'/api/v1/staff-dashboard/ticket/47/'),(108,'Gatura Hamisi provided additional info for ticket \"#47\".',0,'2026-04-22 22:06:41.558969',67,'/api/v1/staff-dashboard/ticket/47/'),(109,'Your ticket \"#47\" status was updated to IN_PROGRESS.',1,'2026-04-22 22:12:28.051880',65,'/api/v1/ticket/47/'),(110,'Your ticket \"#2\" status was updated to REJECTED.',0,'2026-04-22 22:30:42.377069',6,'/api/v1/ticket/2/'),(111,'Your ticket \"#23\" status was updated to REJECTED.',0,'2026-04-22 22:31:08.953175',22,'/api/v1/ticket/23/'),(112,'Your ticket \"#22\" has been resolved. Please provide feedback to close it.',0,'2026-04-22 22:33:29.574310',22,'/api/v1/ticket/22/'),(113,'Your ticket \"#25\" has been resolved. Please provide feedback to close it.',0,'2026-04-22 22:34:18.950435',22,'/api/v1/ticket/25/'),(114,'New ticket \"#48\" submitted by Joe Down.',0,'2026-04-22 22:42:17.806486',10,'/api/v1/staff-dashboard/ticket/48/'),(115,'New ticket \"#48\" submitted by Joe Down.',0,'2026-04-22 22:42:17.806486',67,'/api/v1/staff-dashboard/ticket/48/'),(116,'Your ticket \"#48\" status was updated to ESCALATED through auto-escalation.',0,'2026-04-23 06:07:01.533963',22,'/api/v1/ticket/48/'),(117,'Ticket \"#48\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',0,'2026-04-23 06:07:01.692718',67,'/api/v1/staff-dashboard/ticket/48/'),(118,'Ticket \"#48\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',0,'2026-04-23 06:07:01.749472',10,'/api/v1/staff-dashboard/all-issues/'),(119,'Your ticket \"#36\" has been resolved. Please provide feedback to close it.',0,'2026-04-23 06:09:18.606351',15,'/api/v1/ticket/36/'),(120,'Your ticket \"#17\" status was updated to REJECTED.',0,'2026-04-23 06:10:16.621912',13,'/api/v1/ticket/17/'),(121,'Your ticket \"#20\" has been resolved. Please provide feedback to close it.',0,'2026-04-23 06:19:39.377343',24,'/api/v1/ticket/20/'),(122,'Your ticket \"#9\" has been resolved. Please provide feedback to close it.',0,'2026-04-23 06:21:09.613730',9,'/api/v1/ticket/9/'),(123,'Your ticket \"#34\" has been transferred to IT.',0,'2026-04-23 06:22:12.018515',13,'/api/v1/ticket/34/'),(124,'Ticket \"#34\" was transferred out to IT.',1,'2026-04-23 06:22:12.031051',20,'/api/v1/staff-dashboard/all-issues/'),(125,'Ticket \"#34\" was transferred out to IT.',0,'2026-04-23 06:22:12.031051',23,'/api/v1/staff-dashboard/all-issues/'),(126,'Ticket \"#34\" was transferred into your department from Registry.',0,'2026-04-23 06:22:12.155400',14,'/api/v1/staff-dashboard/ticket/34/'),(127,'Your ticket \"#38\" status was updated to REJECTED.',0,'2026-04-23 06:22:57.259599',15,'/api/v1/ticket/38/'),(128,'Your ticket \"#39\" has been resolved. Please provide feedback to close it.',0,'2026-04-23 06:24:05.717916',13,'/api/v1/ticket/39/'),(129,'Your ticket \"#40\" status was updated to REJECTED.',0,'2026-04-23 06:25:57.232384',22,'/api/v1/ticket/40/'),(130,'Your ticket \"#11\" has been resolved. Please provide feedback to close it.',0,'2026-04-23 06:30:32.302219',13,'/api/v1/ticket/11/'),(131,'Your ticket \"#28\" requires additional information.',0,'2026-04-23 06:31:24.091179',13,'/api/v1/ticket/28/'),(132,'Your ticket \"#1\" has been resolved. Please provide feedback to close it.',0,'2026-04-23 06:40:01.886200',2,'/api/v1/ticket/1/'),(133,'Your ticket \"#3\" has been resolved. Please provide feedback to close it.',0,'2026-04-23 06:41:15.654274',6,'/api/v1/ticket/3/'),(134,'Your ticket \"#18\" status was updated to REJECTED.',0,'2026-04-23 06:41:41.084387',15,'/api/v1/ticket/18/'),(135,'Your ticket \"#19\" status was updated to REJECTED.',0,'2026-04-23 06:42:07.901438',13,'/api/v1/ticket/19/'),(136,'Your ticket \"#13\" status was updated to REJECTED.',0,'2026-04-23 06:43:00.395678',15,'/api/v1/ticket/13/'),(137,'Your ticket \"#15\" has been resolved. Please provide feedback to close it.',0,'2026-04-23 06:44:01.452968',13,'/api/v1/ticket/15/'),(138,'Your ticket \"#10\" status was updated to REJECTED.',0,'2026-04-23 06:45:09.334173',13,'/api/v1/ticket/10/'),(139,'Your ticket \"#21\" has been resolved. Please provide feedback to close it.',0,'2026-04-23 06:46:23.285894',22,'/api/v1/ticket/21/'),(140,'New ticket \"#49\" submitted by Gatura Hamisi.',0,'2026-04-23 08:12:26.081392',10,'/api/v1/staff-dashboard/ticket/49/'),(141,'New ticket \"#49\" submitted by Gatura Hamisi.',0,'2026-04-23 08:12:26.081392',67,'/api/v1/staff-dashboard/ticket/49/'),(142,'Your ticket \"#49\" status was updated to REJECTED.',1,'2026-04-23 08:13:21.908147',65,'/api/v1/ticket/49/'),(143,'Your ticket \"#34\" status was updated to ESCALATED through auto-escalation.',0,'2026-05-02 20:56:55.774989',13,'/api/v1/ticket/34/'),(144,'Ticket \"#34\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',0,'2026-05-02 20:56:55.839808',14,'/api/v1/staff-dashboard/all-issues/'),(145,'Your ticket \"#46\" status was updated to ESCALATED through auto-escalation.',1,'2026-05-02 20:56:55.859753',66,'/api/v1/ticket/46/'),(146,'Ticket \"#46\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',0,'2026-05-02 20:56:55.870725',64,'/api/v1/staff-dashboard/ticket/46/'),(147,'Your ticket \"#47\" status was updated to ESCALATED through auto-escalation.',1,'2026-05-02 20:56:55.890669',65,'/api/v1/ticket/47/'),(148,'Ticket \"#47\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',0,'2026-05-02 20:56:55.924579',67,'/api/v1/staff-dashboard/ticket/47/'),(149,'Ticket \"#47\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',0,'2026-05-02 20:56:55.970455',10,'/api/v1/staff-dashboard/all-issues/'),(150,'New ticket \"#50\" submitted by Mark Njoroge.',0,'2026-06-09 20:10:46.870717',21,'/api/v1/staff-dashboard/ticket/50/'),(151,'New ticket \"#50\" submitted by Mark Njoroge.',0,'2026-06-09 20:10:46.870717',43,'/api/v1/staff-dashboard/ticket/50/'),(152,'Your ticket \"#50\" has been transferred to Registry.',1,'2026-06-09 20:12:09.739323',66,'/api/v1/ticket/50/'),(153,'Ticket \"#50\" was transferred out to Registry.',0,'2026-06-09 20:12:09.802548',21,'/api/v1/staff-dashboard/all-issues/'),(154,'Ticket \"#50\" was transferred out to Registry.',0,'2026-06-09 20:12:09.802548',43,'/api/v1/staff-dashboard/all-issues/'),(155,'Ticket \"#50\" was transferred into your department from Finance.',1,'2026-06-09 20:12:09.947193',20,'/api/v1/staff-dashboard/ticket/50/'),(156,'Ticket \"#50\" was transferred into your department from Finance.',0,'2026-06-09 20:12:09.947193',23,'/api/v1/staff-dashboard/ticket/50/'),(157,'Your ticket \"#50\" status was updated to ESCALATED through auto-escalation.',0,'2026-06-11 09:51:22.738904',66,'/api/v1/ticket/50/'),(158,'Ticket \"#50\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',0,'2026-06-11 09:51:22.965294',23,'/api/v1/staff-dashboard/ticket/50/'),(159,'Ticket \"#50\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',0,'2026-06-11 09:51:23.060581',20,'/api/v1/staff-dashboard/all-issues/'),(160,'Your ticket \"#45\" status was updated to REJECTED.',0,'2026-06-12 09:41:03.259675',53,'/api/v1/ticket/45/'),(161,'Your ticket \"#47\" has been resolved. Please provide feedback to close it.',0,'2026-06-12 09:42:20.286988',65,'/api/v1/ticket/47/'),(162,'Ticket \"#47\" was CLOSED by Gatura Hamisi based on feedback.',0,'2026-06-12 09:43:02.015912',10,'/api/v1/staff-dashboard/ticket/47/'),(163,'Ticket \"#47\" was CLOSED by Gatura Hamisi based on feedback.',0,'2026-06-12 09:43:02.015912',67,'/api/v1/staff-dashboard/ticket/47/'),(164,'Your ticket \"#48\" has been resolved. Please provide feedback to close it.',1,'2026-06-12 09:45:28.323719',22,'/api/v1/ticket/48/'),(165,'New ticket \"#51\" submitted by Gatura Hamisi.',0,'2026-06-13 17:43:48.585539',10,'/api/v1/staff-dashboard/ticket/51/'),(166,'New ticket \"#51\" submitted by Gatura Hamisi.',0,'2026-06-13 17:43:48.585539',67,'/api/v1/staff-dashboard/ticket/51/'),(167,'Your ticket \"#51\" has been resolved. Please provide feedback to close it.',1,'2026-06-13 17:44:33.290538',65,'/api/v1/ticket/51/'),(168,'Ticket \"#51\" was REOPENED by Gatura Hamisi based on feedback.',0,'2026-06-13 17:45:08.804271',10,'/api/v1/staff-dashboard/ticket/51/'),(169,'Ticket \"#51\" was REOPENED by Gatura Hamisi based on feedback.',0,'2026-06-13 17:45:08.804271',67,'/api/v1/staff-dashboard/ticket/51/'),(170,'Your ticket \"#51\" has been escalated.',0,'2026-06-13 17:46:04.770447',65,'/api/v1/ticket/51/'),(171,'Ticket \"#51\" has been escalated to Senior Staff.',1,'2026-06-13 17:46:04.791211',67,'/api/v1/staff-dashboard/ticket/51/'),(172,'Ticket \"#51\" has been escalated to Senior Staff.',0,'2026-06-13 17:46:04.825359',10,'/api/v1/staff-dashboard/all-issues/'),(173,'Ticket \"#51\" has been escalated to Senior Staff.',0,'2026-06-13 17:46:04.825359',42,'/api/v1/staff-dashboard/all-issues/'),(174,'Ticket \"#51\" has been escalated to Senior Staff.',0,'2026-06-13 17:46:04.825359',56,'/api/v1/staff-dashboard/all-issues/'),(175,'Your ticket \"#51\" requires additional information.',1,'2026-06-13 17:46:29.558577',65,'/api/v1/ticket/51/'),(177,'King Luther provided additional info for ticket \"#28\".',0,'2026-06-14 18:13:14.604010',20,'/api/v1/staff-dashboard/ticket/28/'),(178,'King Luther provided additional info for ticket \"#28\".',0,'2026-06-14 18:13:14.604010',23,'/api/v1/staff-dashboard/ticket/28/'),(179,'WARNING: Ticket \"#52\" is approaching its deadline. Only 9h 59m remaining.',0,'2026-06-14 20:01:57.534817',57,'/api/v1/staff-dashboard/ticket/52/'),(180,'New ticket \"#53\" submitted by Gatura Hamisi.',0,'2026-06-14 20:21:36.855639',10,'/api/v1/staff-dashboard/ticket/53/'),(181,'New ticket \"#53\" submitted by Gatura Hamisi.',0,'2026-06-14 20:21:36.855639',67,'/api/v1/staff-dashboard/ticket/53/'),(182,'New ticket \"#54\" submitted by Mark Njoroge.',1,'2026-06-14 20:27:39.560458',10,'/api/v1/staff-dashboard/ticket/54/'),(183,'New ticket \"#54\" submitted by Mark Njoroge.',0,'2026-06-14 20:27:39.560458',67,'/api/v1/staff-dashboard/ticket/54/'),(184,'WARNING: Ticket \"#54\" has exceeded its deadline.',1,'2026-06-14 21:29:28.670820',10,'/api/v1/staff-dashboard/ticket/54/'),(185,'Your ticket \"#54\" status was updated to ESCALATED through auto-escalation.',0,'2026-06-14 21:29:28.894502',66,'/api/v1/ticket/54/'),(186,'Ticket \"#54\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',0,'2026-06-14 21:29:29.126620',67,'/api/v1/staff-dashboard/ticket/54/'),(187,'Ticket \"#54\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',0,'2026-06-14 21:29:29.194785',10,'/api/v1/staff-dashboard/all-issues/'),(188,'Your ticket \"#51\" has been resolved. Please provide feedback to close it.',0,'2026-06-14 21:42:42.799287',65,'/api/v1/ticket/51/'),(189,'New ticket \"#55\" submitted by Gatura Hamisi.',0,'2026-06-14 21:47:39.504474',21,'/api/v1/staff-dashboard/ticket/55/'),(190,'New ticket \"#55\" submitted by Gatura Hamisi.',0,'2026-06-14 21:47:39.504474',43,'/api/v1/staff-dashboard/ticket/55/'),(191,'Your ticket \"#55\" requires additional information.',0,'2026-06-14 21:48:59.584793',65,'/api/v1/ticket/55/'),(192,'Gatura Hamisi provided additional info for ticket \"#55\".',1,'2026-06-14 21:50:09.971518',21,'/api/v1/staff-dashboard/ticket/55/'),(193,'Gatura Hamisi provided additional info for ticket \"#55\".',0,'2026-06-14 21:50:09.972026',43,'/api/v1/staff-dashboard/ticket/55/'),(194,'Your ticket \"#55\" status was updated to REJECTED.',0,'2026-06-14 21:51:34.502358',65,'/api/v1/ticket/55/'),(195,'New ticket \"#56\" submitted by Gatura Hamisi.',1,'2026-06-14 21:53:16.147936',10,'/api/v1/staff-dashboard/ticket/56/'),(196,'New ticket \"#56\" submitted by Gatura Hamisi.',0,'2026-06-14 21:53:16.147936',67,'/api/v1/staff-dashboard/ticket/56/'),(197,'Your ticket \"#56\" has been resolved. Please provide feedback to close it.',1,'2026-06-14 21:55:27.906916',65,'/api/v1/ticket/56/'),(198,'Ticket \"#56\" was REOPENED by Gatura Hamisi based on feedback.',1,'2026-06-14 21:56:16.843750',10,'/api/v1/staff-dashboard/ticket/56/'),(199,'Ticket \"#56\" was REOPENED by Gatura Hamisi based on feedback.',0,'2026-06-14 21:56:16.843750',67,'/api/v1/staff-dashboard/ticket/56/'),(200,'Your ticket \"#56\" has been escalated.',0,'2026-06-14 21:57:03.661341',65,'/api/v1/ticket/56/'),(201,'Ticket \"#56\" has been escalated to Senior Staff.',0,'2026-06-14 21:57:03.697687',67,'/api/v1/staff-dashboard/ticket/56/'),(202,'Ticket \"#56\" has been escalated to Senior Staff.',0,'2026-06-14 21:57:03.731503',10,'/api/v1/staff-dashboard/all-issues/'),(203,'Ticket \"#56\" has been escalated to Senior Staff.',0,'2026-06-14 21:57:03.731503',42,'/api/v1/staff-dashboard/all-issues/'),(204,'Ticket \"#56\" has been escalated to Senior Staff.',0,'2026-06-14 21:57:03.731503',56,'/api/v1/staff-dashboard/all-issues/'),(205,'Your ticket \"#56\" has been resolved. Please provide feedback to close it.',0,'2026-06-14 21:58:08.258445',65,'/api/v1/ticket/56/'),(206,'Ticket \"#56\" was CLOSED by Gatura Hamisi based on feedback.',0,'2026-06-14 21:58:36.044160',10,'/api/v1/staff-dashboard/ticket/56/'),(207,'Ticket \"#56\" was CLOSED by Gatura Hamisi based on feedback.',1,'2026-06-14 21:58:36.044160',67,'/api/v1/staff-dashboard/ticket/56/'),(208,'New ticket \"#57\" submitted by Mark Njoroge.',0,'2026-06-14 22:02:44.579821',10,'/api/v1/staff-dashboard/ticket/57/'),(209,'New ticket \"#57\" submitted by Mark Njoroge.',0,'2026-06-14 22:02:44.579821',67,'/api/v1/staff-dashboard/ticket/57/'),(210,'Your ticket \"#57\" has been transferred to Finance.',0,'2026-06-14 22:03:40.526732',66,'/api/v1/ticket/57/'),(211,'Ticket \"#57\" was transferred out to Finance.',0,'2026-06-14 22:03:40.550502',10,'/api/v1/staff-dashboard/all-issues/'),(212,'Ticket \"#57\" was transferred out to Finance.',0,'2026-06-14 22:03:40.550502',67,'/api/v1/staff-dashboard/all-issues/'),(213,'Ticket \"#57\" was transferred into your department from Computer & Information Science.',0,'2026-06-14 22:03:40.567558',21,'/api/v1/staff-dashboard/ticket/57/'),(214,'Ticket \"#57\" was transferred into your department from Computer & Information Science.',0,'2026-06-14 22:03:40.567558',43,'/api/v1/staff-dashboard/ticket/57/'),(215,'New ticket \"#58\" submitted by Gatura Hamisi.',0,'2026-06-15 10:18:14.440827',10,'/api/v1/staff-dashboard/ticket/58/'),(216,'New ticket \"#58\" submitted by Gatura Hamisi.',0,'2026-06-15 10:18:14.440827',67,'/api/v1/staff-dashboard/ticket/58/'),(217,'Your ticket \"#58\" has been resolved. Please provide feedback to close it.',1,'2026-06-15 10:18:57.175923',65,'/api/v1/ticket/58/'),(218,'Ticket \"#58\" was REOPENED by Gatura Hamisi based on feedback.',0,'2026-06-15 10:19:31.312062',10,'/api/v1/staff-dashboard/ticket/58/'),(219,'Ticket \"#58\" was REOPENED by Gatura Hamisi based on feedback.',0,'2026-06-15 10:19:31.312062',67,'/api/v1/staff-dashboard/ticket/58/'),(220,'Your ticket \"#58\" has been escalated.',0,'2026-06-15 10:20:32.504540',65,'/api/v1/ticket/58/'),(221,'Ticket \"#58\" has been escalated to Senior Staff.',0,'2026-06-15 10:20:32.516509',67,'/api/v1/staff-dashboard/ticket/58/'),(222,'Ticket \"#58\" has been escalated to Senior Staff.',0,'2026-06-15 10:20:32.524143',10,'/api/v1/staff-dashboard/all-issues/'),(223,'Ticket \"#58\" has been escalated to Senior Staff.',0,'2026-06-15 10:20:32.524521',42,'/api/v1/staff-dashboard/all-issues/'),(224,'Ticket \"#58\" has been escalated to Senior Staff.',0,'2026-06-15 10:20:32.524521',56,'/api/v1/staff-dashboard/all-issues/'),(225,'WARNING: Ticket \"#52\" has exceeded its deadline.',0,'2026-06-30 12:50:35.536663',57,'/api/v1/staff-dashboard/ticket/52/'),(226,'WARNING: Ticket \"#53\" has exceeded its deadline.',0,'2026-06-30 12:50:35.536663',10,'/api/v1/staff-dashboard/ticket/53/'),(227,'WARNING: Ticket \"#57\" has exceeded its deadline.',0,'2026-06-30 12:50:35.536663',21,'/api/v1/staff-dashboard/ticket/57/'),(228,'Your ticket \"#52\" status was updated to ESCALATED through auto-escalation.',0,'2026-06-30 12:50:35.582682',52,'/api/v1/ticket/52/'),(229,'Ticket \"#52\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',0,'2026-06-30 12:50:35.613256',57,'/api/v1/staff-dashboard/all-issues/'),(230,'Your ticket \"#53\" status was updated to ESCALATED through auto-escalation.',0,'2026-06-30 12:50:35.650582',65,'/api/v1/ticket/53/'),(231,'Ticket \"#53\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',0,'2026-06-30 12:50:35.666233',67,'/api/v1/staff-dashboard/ticket/53/'),(232,'Ticket \"#53\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',0,'2026-06-30 12:50:35.691542',10,'/api/v1/staff-dashboard/all-issues/'),(233,'Your ticket \"#57\" status was updated to ESCALATED through auto-escalation.',0,'2026-06-30 12:50:35.753411',66,'/api/v1/ticket/57/'),(234,'Ticket \"#57\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',0,'2026-06-30 12:50:35.768927',43,'/api/v1/staff-dashboard/ticket/57/'),(235,'Ticket \"#57\" was AUTO-ESCALATED to Senior Staff due to deadline breach.',1,'2026-06-30 12:50:35.786275',21,'/api/v1/staff-dashboard/all-issues/');
/*!40000 ALTER TABLE `accounts_notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accounts_staffprofile`
--

DROP TABLE IF EXISTS `accounts_staffprofile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accounts_staffprofile` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `employee_id` varchar(20) NOT NULL,
  `department_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `staff_role` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employee_id` (`employee_id`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `accounts_staffprofil_department_id_3eb21dad_fk_organizat` (`department_id`),
  CONSTRAINT `accounts_staffprofil_department_id_3eb21dad_fk_organizat` FOREIGN KEY (`department_id`) REFERENCES `organization_department` (`id`),
  CONSTRAINT `accounts_staffprofile_user_id_1ed1af60_fk_accounts_user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts_staffprofile`
--

LOCK TABLES `accounts_staffprofile` WRITE;
/*!40000 ALTER TABLE `accounts_staffprofile` DISABLE KEYS */;
INSERT INTO `accounts_staffprofile` VALUES (1,'EMP/001',1,5,'STAFF'),(2,'EMP/002',4,7,'STAFF'),(3,'EMP/003',4,8,'STAFF'),(4,'EMP-008',5,10,'STAFF'),(5,'EMP-011',2,14,'STAFF'),(8,'EMP-012',4,20,'STAFF'),(9,'EMP-014',1,21,'STAFF'),(10,'EMP-022',4,23,'SENIOR'),(12,'EMP-300',2,37,'STAFF'),(17,'EMP-301',5,42,'STAFF'),(18,'EMP-302',1,43,'SENIOR'),(19,'EMP-303',6,54,'STAFF'),(20,'EMP-304',10,55,'STAFF'),(21,'EMP-305',5,56,'STAFF'),(22,'EMP-306',12,57,'STAFF'),(23,'EMP-307',12,58,'STAFF'),(24,'EMP-308',4,59,'STAFF'),(25,'EMP-309',10,60,'STAFF'),(26,'EMP-310',2,61,'STAFF'),(27,'EMP-311',2,62,'STAFF'),(28,'EMP-312',1,63,'STAFF'),(29,'EMP-333',9,64,'SENIOR'),(30,'EMP-444',5,67,'SENIOR');
/*!40000 ALTER TABLE `accounts_staffprofile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accounts_studentprofile`
--

DROP TABLE IF EXISTS `accounts_studentprofile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accounts_studentprofile` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `reg_number` varchar(20) NOT NULL,
  `user_id` bigint NOT NULL,
  `course_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `reg_number` (`reg_number`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `accounts_studentprof_course_id_7b68d7db_fk_organizat` (`course_id`),
  CONSTRAINT `accounts_studentprof_course_id_7b68d7db_fk_organizat` FOREIGN KEY (`course_id`) REFERENCES `organization_course` (`id`),
  CONSTRAINT `accounts_studentprofile_user_id_04a48d2e_fk_accounts_user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts_studentprofile`
--

LOCK TABLES `accounts_studentprofile` WRITE;
/*!40000 ALTER TABLE `accounts_studentprofile` DISABLE KEYS */;
INSERT INTO `accounts_studentprofile` VALUES (1,'1089001',4,NULL),(2,'1043444',6,2),(3,'1049066',9,1),(4,'1049003',11,2),(5,'1049000',12,3),(6,'1049999',13,3),(7,'1039222',15,1),(10,'1049011',22,2),(11,'1049577',24,2),(20,'1055555',34,2),(21,'1034567',35,3),(22,'1020900',36,1),(23,'1055076',44,1),(24,'1051000',45,5),(25,'1051001',46,7),(26,'1051002',47,1),(27,'1051003',48,5),(28,'1051004',49,3),(29,'1051005',50,1),(30,'1051006',51,5),(31,'1051007',52,7),(32,'1051008',53,2),(33,'1049065',65,1),(34,'1049578',66,1);
/*!40000 ALTER TABLE `accounts_studentprofile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accounts_user`
--

DROP TABLE IF EXISTS `accounts_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accounts_user` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `role` varchar(20) NOT NULL,
  `email` varchar(254) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `username` varchar(100) DEFAULT NULL,
  `must_change_password` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts_user`
--

LOCK TABLES `accounts_user` WRITE;
/*!40000 ALTER TABLE `accounts_user` DISABLE KEYS */;
INSERT INTO `accounts_user` VALUES (1,'pbkdf2_sha256$1200000$nNzgBsOVDmuGQyqbIomJkS$vAc6VYNy04BQ7XnoS053JBGGKcSudrutBfdGsHszSiU=','2026-06-30 12:51:02.050284',1,1,1,'2025-12-16 19:07:29.000000','Admin','admin@gmail.com','John','Doe',NULL,0),(2,'school341',NULL,0,0,0,'2025-12-16 19:13:47.000000','Student','k123@gmail.com','Kaka','Joe',NULL,0),(3,'staff0012',NULL,0,0,0,'2025-12-16 19:16:24.000000','Staff','justken@gmail.com','Ken','Just',NULL,0),(4,'pbkdf2_sha256$1200000$THezNAHAfO9nvuvb5v1jst$Gi+CLZM8wPCGbyCpYIgBRTyG76EWN2jQSxjFiczJXPk=',NULL,0,0,0,'2025-12-18 08:59:32.878856','Student','grace@student.edu','Grace','Lang',NULL,0),(5,'pbkdf2_sha256$1200000$ejjXZ0I9i6Kd0FC0RtcjFH$TiLM0g7pvaRSWwusq1GDGaHbNDCwh5C/g48YOPIjSKA=',NULL,0,0,0,'2025-12-18 09:04:08.725153','Staff','elvis@staff.edu','Elvis','Presley',NULL,0),(6,'pbkdf2_sha256$1200000$aZrHGbngOuFTgHAx8VFUNF$J8KYhzVB3+wCrepRZsh51DAix7RSScOmj+FGz7vnvnM=',NULL,0,0,1,'2025-12-19 16:28:49.556115','Student','test@student.edu','Test','Student',NULL,0),(7,'pbkdf2_sha256$1200000$PycwuRCBh2MpvINKm3LE1u$6XYjTjoO0K4othAtwStipm0UKhi6tYBNHhB9/s7nzqU=',NULL,0,0,0,'2025-12-20 17:46:21.065609','Staff','cudi@staff.edu','Cudi','Kid',NULL,0),(8,'pbkdf2_sha256$1200000$srivqPHV50yBKB3LCctZFb$hr6jW5F/B/MR+h01NExrAkarbb3aLXRisOrkPpYSfmw=',NULL,0,0,0,'2025-12-24 12:04:07.400686','Staff','Jane@lx.edu','Jane','Dorathy',NULL,0),(9,'pbkdf2_sha256$1200000$oFRhQ0UpoW1ZaQO5tMuHXh$UXzeIL9oWksBiepppOnoRUWx8PCRNkVrI1vvZVezgq8=',NULL,0,0,0,'2025-12-24 12:04:40.105605','Student','Hamisi@alx.edu','Hamisi','Juma',NULL,0),(10,'pbkdf2_sha256$1200000$s7N6Z05zZ4rBbaLgr9aHTl$eH8K49itRALIVqnbXaFGnKava+6niYEScFrZMJI6uuo=','2026-06-15 10:18:30.731329',0,0,1,'2026-01-19 11:38:40.603592','Staff','james@staff.edu','James','Waweru',NULL,0),(11,'pbkdf2_sha256$1200000$Xcyd7vcRiKCaq56txoZ9ln$kmwkqHVd4TXk2leC1JYAheQ6ywyLDpVIA1tYoxc/+58=',NULL,0,0,1,'2026-01-19 11:43:12.256268','Student','grace.student@cuea.edu','Grace','Joy',NULL,0),(12,'pbkdf2_sha256$1200000$kh4RooGBvI6aG7FDStDoSs$5P05QPgMr911ZW5JiAxKmiKn7TjwqAbR/m7uja1swdI=',NULL,0,0,1,'2026-01-19 12:07:38.586996','Student','randy@student.edu','Randy','Tom',NULL,0),(13,'pbkdf2_sha256$1200000$BX29CB1iriYBO1rrrCCg8L$UgK7SpVuta6Jfynkb6AAXIMj5SnRl5l8uxntFTs0J80=','2026-06-14 18:12:44.653998',0,0,1,'2026-01-19 12:55:01.615848','Student','king@student.edu','King','Luther',NULL,0),(14,'pbkdf2_sha256$1200000$Ecfs7SgvQE6izhAA43hdS0$QXBE1k06MqF2xTHW7yHa4oOMx69vd4SzhEpSrUQ5cwA=','2026-05-04 12:40:52.889947',0,0,1,'2026-01-19 12:56:50.796425','Staff','dluke@staff.edu','Debora','Luke',NULL,0),(15,'pbkdf2_sha256$1200000$VNbz3hIZx1GKtWYG2AnY67$dhF0I3AjGOSdFG0kSmfbInHUIyLTG2eHChyf+zpziVQ=','2026-04-20 19:24:03.003621',0,0,1,'2026-01-20 11:48:15.919774','Student','lydia@student.edu','Lydia','Waweru',NULL,0),(20,'pbkdf2_sha256$1200000$RnR9k66vhLV4t44H20H0dr$aShgtqr53OYLzfG5gjthq9E9KF4wB3wsaPmHajTqP30=','2026-06-14 15:54:21.700886',0,0,1,'2026-01-25 11:07:07.152417','Staff','wayne@staff.edu','Wayne','Abuto',NULL,0),(21,'pbkdf2_sha256$1200000$Xj43udbI6ZP43TKrO2mxCQ$vvm32aNo8Lt0We50zRlmXSURP5WpgyBnmzQWx8D8Juo=','2026-06-30 12:50:33.472036',0,0,1,'2026-01-25 11:14:23.014372','Staff','sheila@staff.edu','Sheila','Amani',NULL,0),(22,'pbkdf2_sha256$1200000$tt5UzGps3t4lEz7DoFjwfS$hBKUO/p+X5U5jT4YeqjrQCFDDYa9Ts1x3xDl2n3Q2QE=','2026-06-12 09:46:22.130450',0,0,1,'2026-01-25 11:40:05.424889','Student','jod@student.edu','Joe','Down',NULL,0),(23,'pbkdf2_sha256$1200000$85FELMJFEXS2x0D4L8Qg5N$px1gObAlDdivjv3OUiY8ib2c2kBDyeFtHh/BzTZuX/I=','2026-06-14 17:59:56.974200',0,0,1,'2026-01-25 22:07:22.291283','Staff','charliex@staff.edu','Charlie','Xavier',NULL,0),(24,'pbkdf2_sha256$1200000$2n1OubuZdP0FJzuF2KYmSk$la00QLmf49M1tpfvz74LyMvbZ/ObKHXTbvzvS+jCBec=','2026-01-25 22:27:03.952294',0,0,1,'2026-01-25 22:22:34.728063','Student','joy12@gmail.com','Joy','Mumbi',NULL,0),(34,'pbkdf2_sha256$1200000$AD8EQgJxLNqFP2uwJ0kE9B$Hq0J/MJ3t0tArnnoPNonMCMJQ+qKmSVVmAj60fUiVew=',NULL,0,0,1,'2026-02-21 10:00:16.529763','Student','ksteve@cuea.edu','Kimani','Steve',NULL,1),(35,'pbkdf2_sha256$1200000$vrkLr7ZSY7blafnluhsIs5$f0g5dfHSZaP84coTokKEEruENNxeqny1yixXEkjscKU=',NULL,0,0,1,'2026-02-21 10:00:21.404238','Student','joystin@cuea.edu','Joy','Austin',NULL,1),(36,'pbkdf2_sha256$1200000$Y4ZTQmow02p1iP41XplvnV$guiZfgIksShXXXdVMm738klp/oR2rcqxtajohSYFexg=','2026-04-05 22:01:34.193290',0,0,1,'2026-02-21 10:00:26.266147','Student','githu@cuea.edu','Githu','Roger',NULL,1),(37,'pbkdf2_sha256$1200000$hbX19T1Oro6MTvSV6gZ7mk$aqKPviSsV8tJ+UfPfyutrtAPsV8WJcIqVnzU3JFMBeY=',NULL,0,0,1,'2026-02-21 10:11:02.391594','Staff','chrisk33@staff.com','Chris','King',NULL,1),(42,'pbkdf2_sha256$1200000$c9AFe4ziRivQnbXUTMiqGx$stehi5OFvMkf7U2mUQcdDlWXSncKu+1UgLHf7Xu6oSY=',NULL,0,0,1,'2026-02-21 13:00:26.380580','Staff','christinek02@staff.com','Christine','Kivundo',NULL,1),(43,'pbkdf2_sha256$1200000$DxYLmkG4sGLqTh1YRcSqzc$noNC97V76eNHxvcoInOy7F1S4IZ0w1yl6szISOX/kzc=','2026-04-23 06:38:59.300350',0,0,1,'2026-02-21 13:00:28.037668','Staff','josem27@staff.com','Joseph','Miles',NULL,0),(44,'pbkdf2_sha256$1200000$mg0lm3DLeUbdIBMCye1oId$Qe5IAZSq7tNNKpEWPgzRwcXVDysEL0Vcw5So+k6ILq8=','2026-02-21 13:27:24.212951',0,0,1,'2026-02-21 13:20:17.385106','Student','samokate@cuea.edu','Kate','Samo',NULL,1),(45,'pbkdf2_sha256$1200000$N67FXAx1kUPfxVClByboJw$wuCXi0iPjSAGv65StTRhjFCm3aO6B5trTFK5PjsOsp0=','2026-04-05 23:56:10.853058',0,0,1,'2026-03-11 22:24:56.776241','Student','robyn11@gmail.com','Robyn','Fenty',NULL,0),(46,'pbkdf2_sha256$1200000$755wzLKBz31Wyr9qRkkO7j$UvteZz+J4aJbq8XUBskXYY3ep9VdXoQYelCVrxXYUS4=',NULL,0,0,1,'2026-03-11 22:25:01.298021','Student','1051001@cuea.edu','Destiny','Cyrus',NULL,1),(47,'pbkdf2_sha256$1200000$fv90n1kcroopGuhTU4Xo7N$qH2hU/FktK0kd/cKS2jaBmBhY7XNnMggsXFpE5kbMLA=',NULL,0,0,1,'2026-03-11 22:25:04.994054','Student','1051002@cuea.edu','Finn','Wolf',NULL,1),(48,'pbkdf2_sha256$1200000$uXYjvGkWtuY1GpOc9e3cpM$r2uwmcekJW86wC7a1VVF/OFldevxks080wb1M+SAZdA=',NULL,0,0,1,'2026-03-11 22:25:08.450641','Student','jordanmike@gmail.com','Michael','Jordan',NULL,1),(49,'pbkdf2_sha256$1200000$RDysmQM4miaAhfEMeo3DZ0$9zgRpePvirU/dFydAHy9obSBRjKnc1b5RyTrp3SCndA=',NULL,0,0,1,'2026-03-11 22:25:11.891372','Student','1051004@cuea.edu','Raymond','Umoja',NULL,1),(50,'pbkdf2_sha256$1200000$BLSV2E1JjQ2hZ4N2eEOx8G$WIZP8Ge3zZpkBL/lWmijM0tYbrCvSLdC/x7Ii96Y7dA=',NULL,0,0,1,'2026-03-11 22:25:15.467925','Student','1051005@cuea.edu','Hank','Thunderman',NULL,1),(51,'pbkdf2_sha256$1200000$WYGI1ESOQHD3JORGlIDmXH$694ezDl/fXf1udMEvnSdUjshMJd4xNbajeynVKlagcU=',NULL,0,0,1,'2026-03-11 22:25:18.374694','Student','1051006@cuea.edu','Emmanuel','Otieno',NULL,1),(52,'pbkdf2_sha256$1200000$S6H8y4ghBwpL5CG6PVHQ3v$FM+u/knrBfbfO5sB+3hRYQAbbmRbrks30PnTyvHPdnQ=','2026-06-14 09:22:56.060589',0,0,1,'2026-03-11 22:25:20.513365','Student','1051007@cuea.edu','Tori',' Vega',NULL,0),(53,'pbkdf2_sha256$1200000$gKMsz2xsivDbXl5l6xNlpH$j5VgbkCqksXiJKst68p6ZpoobuRh0XHiH3HZtU9WUOA=','2026-04-22 22:35:08.095241',0,0,1,'2026-03-11 22:25:22.822714','Student','andre@gmail.com','Andre','Muruiki',NULL,0),(54,'pbkdf2_sha256$1200000$1W5wOLEaX9sC9JTux9rOgH$IvB/mSOO4VF0m33LSXRDW94hPLVHsKngzJDZDF3UaBM=',NULL,0,0,1,'2026-03-11 22:36:17.843455','Staff','jnjambi@cuea.edu','Joy','Njambi',NULL,1),(55,'pbkdf2_sha256$1200000$mtQQXkw4EswKeF2n7DuEGf$uyWrXMlVdEscFEYCAa9VkB8hbgJ9onpjO7QcTsahROo=',NULL,0,0,1,'2026-03-11 22:36:19.904185','Staff','fgrande@cuea.edu','Frank','Grande',NULL,1),(56,'pbkdf2_sha256$1200000$HxIGYhKaChHVHNRKPdqoFh$/yAFR/mKmyAfMz2j38WjHyBawqWJ6F9j3kjKONZWZ64=',NULL,0,0,1,'2026-03-11 22:36:21.944230','Staff','mdemi@cuea.edu','Demi','Mwala',NULL,1),(57,'pbkdf2_sha256$1200000$u801yjBp3u9xrwvnTX8wBP$AEnRE80pV630ij/y7SFfioS7K/EfmtSuIagygT0sZAw=','2026-06-14 12:14:27.445888',0,0,1,'2026-03-11 22:36:24.205778','Staff','ngutu@cuea.edu','Mzee','Ngutu',NULL,0),(58,'pbkdf2_sha256$1200000$AfEgkP60PyKDuIvGFRpZnk$NJqBeEGQeO8Z5Pac1AKE4C6KN8rX36OIlMJuGgCsW5A=',NULL,0,0,1,'2026-03-11 22:36:26.020961','Staff','nzula@cuea.edu','Harry','Nzula',NULL,1),(59,'pbkdf2_sha256$1200000$rz8FjayGHJXqhIcf7d8GcE$fM4669k6VxB1Al8IMr+QKJ9qJUhfLISywleh8WuLls8=',NULL,0,0,1,'2026-03-11 22:36:28.086875','Staff','phenry1@cuea.edu','Henry','Peter',NULL,1),(60,'pbkdf2_sha256$1200000$TIlZYBPW2zMQVn5q5Ta0ZM$8iH+DKYQB1bWLdnq1wnIs1Y7sFMpNvNYDDrm8bDKxK4=',NULL,0,0,1,'2026-03-11 22:36:30.032094','Staff','sun11@cuea.edu','Stella','Sun',NULL,1),(61,'pbkdf2_sha256$1200000$4cAZOM3HiRvKpYdOh0Ke3d$XQYEF3y0c3xTzykYCL56dhn20jgaBE6CoygE4qQ+1XA=',NULL,0,0,1,'2026-03-11 22:36:32.200034','Staff','wangb@cuea.edu','Barry','Wang',NULL,1),(62,'pbkdf2_sha256$1200000$PqsGD3zC3uP0mt9t1vWhBo$+eR4IeQfpIe2daJaDS5UYiOEWigKCR4/4wzS4Mx/NGQ=',NULL,0,0,1,'2026-03-11 22:36:34.585051','Staff','fiona44@gmail.com','Fiona','Kwamboka',NULL,1),(63,'pbkdf2_sha256$1200000$rbkk2FQIJ9Fk6AhgbKRch7$vTnupneR62kTyTcMCJK0aS6H1Cdf50Jla3xhedwtHUk=',NULL,0,0,1,'2026-03-11 22:36:36.840341','Staff','edwards@gmail.com','Perry','Edwards',NULL,1),(64,'pbkdf2_sha256$1200000$cug97LMrXJ07ZoGMA9X3f2$3TM3lFYyTPOyIiGHL0ybgnYPx1bNOCaskAxHtHbIALU=','2026-04-22 18:22:01.129450',0,0,1,'2026-03-12 18:14:11.874077','Staff','teststaff@gmail.com','Test','Staff',NULL,0),(65,'pbkdf2_sha256$1200000$bCV6Ij9ebHulRLIOBoT0NL$Nu2tmYRjT+ElDPolk466DBlIazMNdq50/Wdql2aZfL8=','2026-06-15 10:17:10.933007',0,0,1,'2026-04-13 14:13:38.166646','Student','1049065@cuea.edu','Gatura','Hamisi',NULL,0),(66,'pbkdf2_sha256$1200000$TWtMo5bNg6laoMcImAhnMb$0PHtDjBN7h9MqcKLd7t2151gptTbTh4OUsAQCkSv6qs=','2026-06-14 22:00:43.755206',0,0,1,'2026-04-22 17:28:27.882815','Student','1049578@cuea.edu','Mark','Njoroge',NULL,0),(67,'pbkdf2_sha256$1200000$jippRMiHBbD0SSdtUn2vdJ$5WgYUBWQFijINh179oCnbY3TmqQmu2d/Iqd9KZV+wDs=','2026-06-15 10:20:46.833019',0,0,1,'2026-04-22 21:38:00.764670','Staff','jumathe1st@gmail.com','Kaka','Juma',NULL,0),(69,'pbkdf2_sha256$1200000$untN9uD3uLPEUX3ugYxdDD$VM2WeqxMI4NNJoyep0hNdJJgiZpUQLe/CvogCily9Xs=','2026-05-02 21:08:38.371300',1,1,1,'2026-05-02 21:07:17.114531','Admin','testadmin@gmail.com','Test','Admin',NULL,0);
/*!40000 ALTER TABLE `accounts_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accounts_user_groups`
--

DROP TABLE IF EXISTS `accounts_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accounts_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `accounts_user_groups_user_id_group_id_59c0b32f_uniq` (`user_id`,`group_id`),
  KEY `accounts_user_groups_group_id_bd11a704_fk_auth_group_id` (`group_id`),
  CONSTRAINT `accounts_user_groups_group_id_bd11a704_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `accounts_user_groups_user_id_52b62117_fk_accounts_user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts_user_groups`
--

LOCK TABLES `accounts_user_groups` WRITE;
/*!40000 ALTER TABLE `accounts_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `accounts_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accounts_user_user_permissions`
--

DROP TABLE IF EXISTS `accounts_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accounts_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `accounts_user_user_permi_user_id_permission_id_2ab516c2_uniq` (`user_id`,`permission_id`),
  KEY `accounts_user_user_p_permission_id_113bb443_fk_auth_perm` (`permission_id`),
  CONSTRAINT `accounts_user_user_p_permission_id_113bb443_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `accounts_user_user_p_user_id_e4f0a161_fk_accounts_` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts_user_user_permissions`
--

LOCK TABLES `accounts_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `accounts_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `accounts_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',3,'add_permission'),(6,'Can change permission',3,'change_permission'),(7,'Can delete permission',3,'delete_permission'),(8,'Can view permission',3,'view_permission'),(9,'Can add group',2,'add_group'),(10,'Can change group',2,'change_group'),(11,'Can delete group',2,'delete_group'),(12,'Can view group',2,'view_group'),(13,'Can add content type',4,'add_contenttype'),(14,'Can change content type',4,'change_contenttype'),(15,'Can delete content type',4,'delete_contenttype'),(16,'Can view content type',4,'view_contenttype'),(17,'Can add session',5,'add_session'),(18,'Can change session',5,'change_session'),(19,'Can delete session',5,'delete_session'),(20,'Can view session',5,'view_session'),(21,'Can add user',8,'add_user'),(22,'Can change user',8,'change_user'),(23,'Can delete user',8,'delete_user'),(24,'Can view user',8,'view_user'),(25,'Can add staff profile',6,'add_staffprofile'),(26,'Can change staff profile',6,'change_staffprofile'),(27,'Can delete staff profile',6,'delete_staffprofile'),(28,'Can view staff profile',6,'view_staffprofile'),(29,'Can add student profile',7,'add_studentprofile'),(30,'Can change student profile',7,'change_studentprofile'),(31,'Can delete student profile',7,'delete_studentprofile'),(32,'Can view student profile',7,'view_studentprofile'),(33,'Can add department',10,'add_department'),(34,'Can change department',10,'change_department'),(35,'Can delete department',10,'delete_department'),(36,'Can view department',10,'view_department'),(37,'Can add category',9,'add_category'),(38,'Can change category',9,'change_category'),(39,'Can delete category',9,'delete_category'),(40,'Can view category',9,'view_category'),(41,'Can add ticket',12,'add_ticket'),(42,'Can change ticket',12,'change_ticket'),(43,'Can delete ticket',12,'delete_ticket'),(44,'Can view ticket',12,'view_ticket'),(45,'Can add resolution',11,'add_resolution'),(46,'Can change resolution',11,'change_resolution'),(47,'Can delete resolution',11,'delete_resolution'),(48,'Can view resolution',11,'view_resolution'),(49,'Can add course',13,'add_course'),(50,'Can change course',13,'change_course'),(51,'Can delete course',13,'delete_course'),(52,'Can view course',13,'view_course'),(53,'Can add notification',14,'add_notification'),(54,'Can change notification',14,'change_notification'),(55,'Can delete notification',14,'delete_notification'),(56,'Can view notification',14,'view_notification'),(57,'Can add student feedback',15,'add_studentfeedback'),(58,'Can change student feedback',15,'change_studentfeedback'),(59,'Can delete student feedback',15,'delete_studentfeedback'),(60,'Can view student feedback',15,'view_studentfeedback'),(61,'Can add additional info',16,'add_additionalinfo'),(62,'Can change additional info',16,'change_additionalinfo'),(63,'Can delete additional info',16,'delete_additionalinfo'),(64,'Can view additional info',16,'view_additionalinfo');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_accounts_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_accounts_user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2025-12-16 19:12:31.280151','1','John Doe - Admin',2,'[{\"changed\": {\"fields\": [\"Role\"]}}]',8,1),(2,'2025-12-16 19:15:37.958990','2','Kaka Joe - Student',1,'[{\"added\": {}}]',8,1),(3,'2025-12-16 19:15:52.999613','2','Kaka Joe - Student',2,'[]',8,1),(4,'2025-12-16 19:17:30.246773','3','Ken Just - Staff',1,'[{\"added\": {}}]',8,1),(5,'2025-12-17 11:48:49.581818','1','Finance',1,'[{\"added\": {}}]',10,1),(6,'2025-12-17 11:48:54.526685','1','Finance',2,'[]',10,1),(7,'2025-12-17 11:49:52.963700','1','Fee Payment Issues - Department(Finance)',1,'[{\"added\": {}}]',9,1),(8,'2025-12-17 11:51:21.802444','1','Failure to update my fee balance - OPEN',1,'[{\"added\": {}}]',12,1),(9,'2025-12-17 11:52:25.136757','1','Resolution for Failure to update my fee balance',1,'[{\"added\": {}}]',11,1),(10,'2025-12-19 16:16:49.186278','2','IT',1,'[{\"added\": {}}]',10,1),(11,'2025-12-19 16:17:58.492144','3','Law',1,'[{\"added\": {}}]',10,1),(12,'2025-12-19 16:18:20.344448','4','Registry',1,'[{\"added\": {}}]',10,1),(13,'2025-12-19 16:18:45.406480','2','Missing Marks - Department(Registry)',1,'[{\"added\": {}}]',9,1),(14,'2026-01-19 10:42:39.826674','5','Computer & Information Science',1,'[{\"added\": {}}]',10,1),(15,'2026-01-19 10:43:11.124648','1','BSc Computer Scice',1,'[{\"added\": {}}]',13,1),(16,'2026-01-19 10:44:18.930864','2','BSc Information Science',1,'[{\"added\": {}}]',13,1),(17,'2026-01-19 10:44:35.463123','3','Diploma in IT',1,'[{\"added\": {}}]',13,1),(18,'2026-01-19 11:23:56.795271','1','BSc Computer Science',2,'[{\"changed\": {\"fields\": [\"Course name\"]}}]',13,1),(19,'2026-01-26 05:19:59.239366','3','Law',3,'',10,1),(20,'2026-01-26 05:20:47.443454','3','Clashing Exam Timetable',1,'[{\"added\": {}}]',9,1),(21,'2026-01-26 05:21:24.975634','4','Unit Registration Issues',1,'[{\"added\": {}}]',9,1),(22,'2026-02-21 23:19:31.415273','5','Clashing Unit Registration',1,'[{\"added\": {}}]',9,1),(23,'2026-02-23 09:31:37.851265','1','Fee Payment Issues',2,'[]',9,1),(24,'2026-02-23 10:12:04.191399','6','Examinations and Timetabling',1,'[{\"added\": {}}]',10,1),(25,'2026-02-23 10:12:15.691615','6','Examinations & Timetabling',2,'[{\"changed\": {\"fields\": [\"Department name\"]}}]',10,1),(26,'2026-02-23 10:14:03.064009','2','Missing Marks',2,'[{\"changed\": {\"fields\": [\"Is academic\"]}}]',9,1),(27,'2026-02-23 10:20:49.780237','4','Unit Registration Issues',2,'[{\"changed\": {\"fields\": [\"Department\", \"Is academic\"]}}]',9,1),(28,'2026-02-23 10:20:58.268035','3','Clashing Exam Timetable',2,'[{\"changed\": {\"fields\": [\"Department\", \"Is academic\"]}}]',9,1),(29,'2026-02-23 10:22:12.174398','6','ODEL & Student Portal Issues',1,'[{\"added\": {}}]',9,1),(30,'2026-02-23 10:50:52.063634','2','Test Student - 1043444',2,'[{\"changed\": {\"fields\": [\"Course\"]}}]',7,1),(31,'2026-02-23 10:51:31.476254','3','Hamisi Juma - 1049065',2,'[{\"changed\": {\"fields\": [\"Course\"]}}]',7,1),(32,'2026-02-25 15:57:21.801460','7','test',1,'[{\"added\": {}}]',9,1),(33,'2026-03-12 18:52:06.146248','64','Test Staff',2,'[{\"changed\": {\"fields\": [\"password\"]}}]',8,1),(34,'2026-04-04 11:42:21.517725','60','Resolution for More tests',3,'',11,1),(35,'2026-04-04 11:42:44.351891','33','More tests - ESCALATED',3,'',12,1),(36,'2026-04-04 11:43:15.615479','8','Testing addition 2',3,'',9,1);
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (14,'accounts','notification'),(6,'accounts','staffprofile'),(7,'accounts','studentprofile'),(8,'accounts','user'),(1,'admin','logentry'),(2,'auth','group'),(3,'auth','permission'),(4,'contenttypes','contenttype'),(9,'organization','category'),(13,'organization','course'),(10,'organization','department'),(5,'sessions','session'),(16,'tickets','additionalinfo'),(11,'tickets','resolution'),(15,'tickets','studentfeedback'),(12,'tickets','ticket');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'organization','0001_initial','2025-12-16 18:55:15.813241'),(2,'contenttypes','0001_initial','2025-12-16 18:55:15.934097'),(3,'contenttypes','0002_remove_content_type_name','2025-12-16 18:55:16.110462'),(4,'auth','0001_initial','2025-12-16 18:55:16.678228'),(5,'auth','0002_alter_permission_name_max_length','2025-12-16 18:55:16.782961'),(6,'auth','0003_alter_user_email_max_length','2025-12-16 18:55:16.792451'),(7,'auth','0004_alter_user_username_opts','2025-12-16 18:55:16.803423'),(8,'auth','0005_alter_user_last_login_null','2025-12-16 18:55:16.815400'),(9,'auth','0006_require_contenttypes_0002','2025-12-16 18:55:16.819382'),(10,'auth','0007_alter_validators_add_error_messages','2025-12-16 18:55:16.828358'),(11,'auth','0008_alter_user_username_max_length','2025-12-16 18:55:16.841327'),(12,'auth','0009_alter_user_last_name_max_length','2025-12-16 18:55:16.850307'),(13,'auth','0010_alter_group_name_max_length','2025-12-16 18:55:16.894421'),(14,'auth','0011_update_proxy_permissions','2025-12-16 18:55:16.922350'),(15,'auth','0012_alter_user_first_name_max_length','2025-12-16 18:55:16.944611'),(16,'accounts','0001_initial','2025-12-16 18:55:18.010411'),(17,'admin','0001_initial','2025-12-16 18:55:18.292876'),(18,'admin','0002_logentry_remove_auto_add','2025-12-16 18:55:18.305844'),(19,'admin','0003_logentry_add_action_flag_choices','2025-12-16 18:55:18.322808'),(20,'sessions','0001_initial','2025-12-16 18:55:18.395911'),(21,'tickets','0001_initial','2025-12-17 11:11:09.024842'),(22,'tickets','0002_alter_resolution_ticket','2025-12-19 18:26:16.619272'),(23,'tickets','0003_alter_resolution_ticket','2025-12-19 18:35:25.435188'),(24,'organization','0002_rename_name_category_category_name_and_more','2026-01-18 22:01:41.434026'),(25,'tickets','0004_alter_ticket_status','2026-01-18 22:01:41.461098'),(26,'accounts','0002_remove_studentprofile_program_and_more','2026-01-18 22:43:27.560822'),(27,'tickets','0005_ticket_attachment','2026-01-20 09:46:53.350162'),(28,'accounts','0003_notification','2026-01-25 22:42:02.773966'),(29,'accounts','0004_user_must_change_password','2026-02-20 14:39:02.106367'),(30,'organization','0003_category_is_academic_category_sla_hours','2026-02-21 22:29:58.172823'),(31,'tickets','0006_ticket_current_department_ticket_due_date','2026-02-21 22:29:58.563556'),(32,'organization','0004_rename_sla_hours_category_resolution_timeframe','2026-02-21 23:02:34.405748'),(33,'tickets','0007_ticket_is_escalated','2026-02-23 09:02:07.800648'),(34,'tickets','0008_alter_ticket_status','2026-02-23 13:32:55.610414'),(35,'tickets','0009_resolution_status','2026-02-25 12:54:56.932204'),(36,'tickets','0010_alter_resolution_status_alter_ticket_status_and_more','2026-02-28 12:36:57.627491'),(37,'tickets','0011_alter_resolution_status_alter_ticket_status','2026-03-11 11:58:20.979615'),(38,'tickets','0012_alter_resolution_status_alter_ticket_status','2026-03-11 12:11:23.918541'),(39,'tickets','0013_additionalinfo','2026-03-11 15:43:22.330886'),(40,'tickets','0014_ticket_pending_since','2026-03-12 13:41:21.703086'),(41,'tickets','0015_alter_resolution_status_alter_ticket_status','2026-04-02 10:47:02.054198'),(42,'accounts','0005_notification_link','2026-04-02 13:03:06.514173'),(43,'tickets','0016_ticket_is_deadline_warning_sent','2026-04-04 11:30:34.841219'),(44,'organization','0005_alter_category_department','2026-04-04 11:39:47.673914');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('11q57xos8kq49642exicdhb1em4w1kzc','.eJxVjMEOwiAQRP-FsyFQYFs8eu83EBZ2pWpoUtqT8d9tkx70NMm8N_MWIW5rCVujJUxZXIUWl98OY3pSPUB-xHqfZZrrukwoD0WetMlxzvS6ne7fQYmt7OtB9cAGOmtRkXLotcbcWcbcIw-c0JpI7JVLnhQ70sAA2RE4E_c04vMF5fc4OA:1vjEmY:b28In4k6rG4Tf-1Omt5CkDrQ6fWHgh3Nk4BCwUdLCsc','2026-02-06 10:52:50.417037'),('1wdrg0l897mdlyrwc8lajv6n6crpemy7','.eJxVjDsOwjAQBe_iGlnEXrxrSnrOYO36gwPIkeKkQtwdIqWA9s3Me6nA61LD2vMcxqTOyqE6_I7C8ZHbRtKd223ScWrLPIreFL3Trq9Tys_L7v4dVO71W9MRAFEcGevFp1hKBvLGRmPZExJJFHQFvSANjCfDjAQZByOQLYF6fwD2bTd8:1wXyMV:yaFHEVXc91PQbPaxofyJynjum_UADAGJf6UvYKjZtoQ','2026-06-26 09:39:39.490118'),('4tzp76epzelm8txyux1srrml8p7ute0h','.eJxVjMEOwiAQRP-FsyFQYFs8eu83EBZ2pWpoUtqT8d9tkx70NMm8N_MWIW5rCVujJUxZXIUWl98OY3pSPUB-xHqfZZrrukwoD0WetMlxzvS6ne7fQYmt7OtB9cAGOmtRkXLotcbcWcbcIw-c0JpI7JVLnhQ70sAA2RE4E_c04vMF5fc4OA:1wX4LK:qNwYqkuOfipkeqcLbMF7mZuX-tUqcaXLoCXaL7W6XZ0','2026-06-23 21:50:42.383844'),('54wmutg925bpxz5m4zhtk9eetl7ctwk1','.eJxVjEEOwiAQRe_C2pBpYQi4dO8ZyAxMpWogKe3KeHdt0oVu_3vvv1SkbS1x67LEOauzGkGdfkem9JC6k3ynems6tbouM-td0Qft-tqyPC-H-3dQqJdvjYgCgx28AAObyRp2PrmQ0RrjgcfJu5RDNoQAiQyFxMiAVpiDc6jeH-6RN8Q:1vk9Ke:Du5K8orIYeuTsNieJKHhiTufAZ4e6ba4vnfsxwcDvPc','2026-02-08 23:15:48.814448'),('5x7argxcbabluhycszbnxoclb97g2ra2','.eJxVjEEOwiAQRe_C2hCQKaBL956hmWEGqRpISrsy3l2bdKHb_977LzXiupRx7TKPE6uz8oM6_I6E6SF1I3zHems6tbrME-lN0Tvt-tpYnpfd_Tso2Mu3Bi_BRT4aDCRESCeybMlEMAyO_JAsxmisAIMIZXYmIGUywYPnjOr9ASQROQ8:1wZ1DF:DvE1vkH1191opB80bsjwjeQUKBJkVBaevZ6j26n-0Ss','2026-06-29 06:54:25.051570'),('7ax4jci33ihfimbl05dn3xx0p0d18d6y','.eJxVjMEOwiAQRP-FsyGwdC149O43ENgFqRqalPZk_Hdp0oOeJnnzZt7Ch20tfmtp8ROLiwAtTr8wBnqmujf8CPU-S5rrukxR7oo82iZvM6fX9XD_Dkpopa8j50EpGM6MGRW7PGIm1GSBtEUegcBBUBR7poCgjDGgUVnuzDgSny8EADe6:1wYsw7:hvDf8yQzChECQg0MRRKUDTrn9Fd7xYHzN8Pkxgk-tBM','2026-06-28 22:04:11.949446'),('7r5mjlw4rwqhin4jyatfot80url3p9hs','.eJxVjEEOwiAQRe_C2hAInWHq0r1nIANMpWpoUtpV491tky50-997f1OB16WEtckcxqyuyhp1-R0jp5fUg-Qn18ek01SXeYz6UPRJm75PWd630_07KNzKXgMgduKTiB8M5MTOEcUUM3UyEABZZEuInsS52O8cfDRsEbIh7I36fAEL6je7:1wJtRl:LAkHPkg0IhvuI-lOsDPLgGDelMOXmHXm_QuWYJ5vY_M','2026-05-18 13:34:53.967748'),('8dilb2ca21awh9sz6nuaimoiwltj91jt','.eJxVjEEOwiAQRe_C2pBShgFcuu8ZmoEBqRqalHZlvLtt0oVu_3vvv8VI21rGraVlnFhcBXpx-R0DxWeqB-EH1fss41zXZQryUORJmxxmTq_b6f4dFGplr61G1NzZPgOHjlwftQZUDBkBvMFgbM4-B9w5kFOw24SOwShFLhrx-QLzEzeN:1wJHZM:h-Y912afWfhncy8WiqSfjAD27vY5P6dLI2xXCKaAkX4','2026-05-16 21:08:12.673844'),('e93ajibcxy7inu27fytu0mne0cp2f1qy','.eJxVjMEOwiAQRP-FsyFQYFs8eu83EBZ2pWpoUtqT8d9tkx70NMm8N_MWIW5rCVujJUxZXIUWl98OY3pSPUB-xHqfZZrrukwoD0WetMlxzvS6ne7fQYmt7OtB9cAGOmtRkXLotcbcWcbcIw-c0JpI7JVLnhQ70sAA2RE4E_c04vMF5fc4OA:1wZ4So:xVFAxHYAkCO62LFYfubc6eMuMrD4lD65anHPBM-sJA4','2026-06-29 10:22:42.031088'),('g4lhwav82bm7m8yf8op0bo3660n0bc39','.eJxVjMEOwiAQRP-FsyFQYFs8eu83EBZ2pWpoUtqT8d9tkx70NMm8N_MWIW5rCVujJUxZXIUWl98OY3pSPUB-xHqfZZrrukwoD0WetMlxzvS6ne7fQYmt7OtB9cAGOmtRkXLotcbcWcbcIw-c0JpI7JVLnhQ70sAA2RE4E_c04vMF5fc4OA:1vVaRw:O6dzkxwhlHs9E4TlzN5Eho6CP93MiJDsBlG-fZqmYYk','2025-12-30 19:11:08.233078'),('hu66r3aonlutwtrviejpbbmbb4nmm97k','.eJxVjMsOwiAURP-FtSG88bp07zcQ7gWkaiAp7cr477ZJF7qcOWfmzUJclxrWkecwJXZhSrPTb4mRnrntJD1iu3dOvS3zhHxX-EEHv_WUX9fD_TuocdRt7QkoatDeJmcNQhFFmi1F8I48ZCBBJIuQThcgUhmNRJvPxiMCKMM-XwFwN_E:1wYp1B:e35jLqKjM02u3wvJGrkxIB-OUdUlRo-9tXVXtuUepUo','2026-06-28 17:53:09.524458'),('hvg82rf9q1m69fmkpn0892gsjqv291ly','.eJxVjMEOwiAQRP-FsyFQYFs8eu83EBZ2pWpoUtqT8d9tkx70NMm8N_MWIW5rCVujJUxZXIUWl98OY3pSPUB-xHqfZZrrukwoD0WetMlxzvS6ne7fQYmt7OtB9cAGOmtRkXLotcbcWcbcIw-c0JpI7JVLnhQ70sAA2RE4E_c04vMF5fc4OA:1wYSZ1:7TdD56h6u5wiu3h1Jg8xsTZtyEEvwmHHbIGSVBi8N9U','2026-06-27 17:54:35.063936'),('iz1a0lb8cvv6qzmiuyogpl50917qowq9','.eJxVjMEOwiAQRP-FsyFQYFs8eu83EBZ2pWpoUtqT8d9tkx70NMm8N_MWIW5rCVujJUxZXIUWl98OY3pSPUB-xHqfZZrrukwoD0WetMlxzvS6ne7fQYmt7OtB9cAGOmtRkXLotcbcWcbcIw-c0JpI7JVLnhQ70sAA2RE4E_c04vMF5fc4OA:1weXva:veGBda36IPBQXP_sHGzF0ZXyv3iJqDLMhorbx46umWs','2026-07-14 12:51:02.050284'),('midd7g3azi0zxeb7ihw63klr8b1uuh0g','.eJxVjMEOwiAQRP-FsyFQYFs8eu83EBZ2pWpoUtqT8d9tkx70NMm8N_MWIW5rCVujJUxZXIUWl98OY3pSPUB-xHqfZZrrukwoD0WetMlxzvS6ne7fQYmt7OtB9cAGOmtRkXLotcbcWcbcIw-c0JpI7JVLnhQ70sAA2RE4E_c04vMF5fc4OA:1vjeBN:PArDyrzhh8OkhSx15zSfZHjuXTz0dANnBoBNrBt4qc8','2026-02-07 14:00:09.456712'),('n6252hu3asllplij0fk8wzm737dgz7a3','.eJxVjMEOwiAQRP-FsyFQYFs8eu83EBZ2pWpoUtqT8d9tkx70NMm8N_MWIW5rCVujJUxZXIUWl98OY3pSPUB-xHqfZZrrukwoD0WetMlxzvS6ne7fQYmt7OtB9cAGOmtRkXLotcbcWcbcIw-c0JpI7JVLnhQ70sAA2RE4E_c04vMF5fc4OA:1wYrMT:zYQxndMtYQ0EMUOmV-w4lD9l_2uVTuWPP3Sa3uo8Z10','2026-06-28 20:23:17.924877'),('qp5segene5tqm0xihk2ynsu32x648xdj','.eJxVjDsOwjAQBe_iGlnEXrxrSnrOYO36gwPIkeKkQtwdIqWA9s3Me6nA61LD2vMcxqTOyqE6_I7C8ZHbRtKd223ScWrLPIreFL3Trq9Tys_L7v4dVO71W9MRAFEcGevFp1hKBvLGRmPZExJJFHQFvSANjCfDjAQZByOQLYF6fwD2bTd8:1wFfkg:L_Ir3VnfF3r-vKhbwxdBs2rEran9fYcQuxGy_C05uA4','2026-05-06 22:08:58.685762'),('ru2yxfmqmqlv8xejyc3ns4mrzziz3y7k','.eJxVjMEOwiAQRP-FsyFQYFs8eu83EBZ2pWpoUtqT8d9tkx70NMm8N_MWIW5rCVujJUxZXIUWl98OY3pSPUB-xHqfZZrrukwoD0WetMlxzvS6ne7fQYmt7OtB9cAGOmtRkXLotcbcWcbcIw-c0JpI7JVLnhQ70sAA2RE4E_c04vMF5fc4OA:1vWd92:rN49BDevaHZg7IfHLyNoXCq0wU-smStDjixHzZeoxZk','2026-01-02 16:15:56.829307'),('rv0sfuofry736d6xn72ki0xf7kgd3zwl','.eJxVjDsOwjAQBe_iGllZHP8o6TmDtV6vcQDZUpxUiLuTSCmgnZn33iLgupSwdp7DlMRFaCtOvzAiPbnuJj2w3pukVpd5inJP5GG7vLXEr-vR_h0U7GVbs1dxAE9xcMBEBkdGtmfyG3AeiROCQmALRmWvRsOQc45Oa0tZkRafLy19OQE:1wYh6W:WK77Ww9DhhpYPb2GmYrXbdK9sfmpxkaSFJZZlHU9_vM','2026-06-28 09:26:08.970308'),('scgoi4z2gt27po9l6jzuy869p837rzfw','.eJxVjEEOwiAQRe_C2hCQKaBL956hmWEGqRpISrsy3l2bdKHb_977LzXiupRx7TKPE6uz8oM6_I6E6SF1I3zHems6tbrME-lN0Tvt-tpYnpfd_Tso2Mu3Bi_BRT4aDCRESCeybMlEMAyO_JAsxmisAIMIZXYmIGUywYPnjOr9ASQROQ8:1wZ4NS:I4xuyTLyxEWm0xSyuWD5avwVqxMM45kWFk5hilX4BJQ','2026-06-29 10:17:10.943689'),('tbp4x5gymy5y82ubo7itiulmsb4dp6u9','.eJxVjEEOwiAQRe_C2hAInWHq0r1nIANMpWpoUtpV491tky50-997f1OB16WEtckcxqyuyhp1-R0jp5fUg-Qn18ek01SXeYz6UPRJm75PWd630_07KNzKXgMgduKTiB8M5MTOEcUUM3UyEABZZEuInsS52O8cfDRsEbIh7I36fAEL6je7:1wZ4Ok:R-1IkoMn0TUQykbLxvQChrUigecipg0j9dwvZwW1Jao','2026-06-29 10:18:30.749625'),('tuipeprd050yfym0eg82yedzstnduatp','.eJxVjDsOwjAQBe_iGlnEXrxrSnrOYO36gwPIkeKkQtwdIqWA9s3Me6nA61LD2vMcxqTOyqE6_I7C8ZHbRtKd223ScWrLPIreFL3Trq9Tys_L7v4dVO71W9MRAFEcGevFp1hKBvLGRmPZExJJFHQFvSANjCfDjAQZByOQLYF6fwD2bTd8:1wZ4Qw:-srr_nJr6tjV6KWxUbS2idqVD90LJzcKIjxr8PlMp6Q','2026-06-29 10:20:46.842252'),('um1ij9yo2wvp5kgrq3hiwcdnqsyif61z','.eJxVjMEOwiAQRP-FsyFQYFs8eu83EBZ2pWpoUtqT8d9tkx70NMm8N_MWIW5rCVujJUxZXIUWl98OY3pSPUB-xHqfZZrrukwoD0WetMlxzvS6ne7fQYmt7OtB9cAGOmtRkXLotcbcWcbcIw-c0JpI7JVLnhQ70sAA2RE4E_c04vMF5fc4OA:1vYNQt:ucDQh8_A4MnP5hwXP3zHpXh9i4etREqKHsswBbX8sqs','2026-01-07 11:53:35.564154'),('urtl80t306xt62ozvha46gergk34tov7','.eJxVjMEOwiAQRP-FsyFQYFs8eu83EBZ2pWpoUtqT8d9tkx70NMm8N_MWIW5rCVujJUxZXIUWl98OY3pSPUB-xHqfZZrrukwoD0WetMlxzvS6ne7fQYmt7OtB9cAGOmtRkXLotcbcWcbcIw-c0JpI7JVLnhQ70sAA2RE4E_c04vMF5fc4OA:1w0whw:fZRkJSEWjEi7hwfcvQdVGjaXYsrfHroVlkVwZdJ9caE','2026-03-27 07:13:16.806918'),('visizb29i7t8ugod6hmnc768v37hx1rk','.eJxVjEEOwiAQRe_C2hCQKaBL956hmWEGqRpISrsy3l2bdKHb_977LzXiupRx7TKPE6uz8oM6_I6E6SF1I3zHems6tbrME-lN0Tvt-tpYnpfd_Tso2Mu3Bi_BRT4aDCRESCeybMlEMAyO_JAsxmisAIMIZXYmIGUywYPnjOr9ASQROQ8:1wFfpT:V4FsqZvkMXZnOYdKnuI0bcFQs3TL_Bdp8zwkQjsPJZE','2026-05-06 22:13:55.068938'),('wkf7zct8q8nfq9jz64g8atvklfa9exrc','.eJxVjMsOwiAURP-FtSG88bp07zcQ7gWkaiAp7cr477ZJF7qcOWfmzUJclxrWkecwJXZhSrPTb4mRnrntJD1iu3dOvS3zhHxX-EEHv_WUX9fD_TuocdRt7QkoatDeJmcNQhFFmi1F8I48ZCBBJIuQThcgUhmNRJvPxiMCKMM-XwFwN_E:1vueDy:H44_k-LIZhHUxSxsxwmpzO7VOcyDXGKqBh9MGDXxwak','2026-03-09 22:16:18.044532'),('wuzoaws1tbjiqpl6ugkofv4gtql3d2f0','.eJxVjMEOwiAQRP-FsyGwdC149O43ENgFqRqalPZk_Hdp0oOeJnnzZt7Ch20tfmtp8ROLiwAtTr8wBnqmujf8CPU-S5rrukxR7oo82iZvM6fX9XD_Dkpopa8j50EpGM6MGRW7PGIm1GSBtEUegcBBUBR7poCgjDGgUVnuzDgSny8EADe6:1wZ3t2:AJfH2qIDS8M_WMp_pRaFH1aVfLP3QoLjdbHbBi7U66Y','2026-06-29 09:45:44.457331'),('x6abotwwn26w5iij93p266htaa5k9ifb','.eJxVjEEOwiAQRe_C2hAInWHq0r1nIANMpWpoUtpV491tky50-997f1OB16WEtckcxqyuyhp1-R0jp5fUg-Qn18ek01SXeYz6UPRJm75PWd630_07KNzKXgMgduKTiB8M5MTOEcUUM3UyEABZZEuInsS52O8cfDRsEbIh7I36fAEL6je7:1vjxqA:DtJghqYzXjDCHXAwYHNOBfhv6LAKfAGhX6B8CSRzflc','2026-02-08 10:59:34.988522');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `organization_category`
--

DROP TABLE IF EXISTS `organization_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `organization_category` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `category_name` varchar(100) NOT NULL,
  `department_id` bigint DEFAULT NULL,
  `is_academic` tinyint(1) NOT NULL,
  `resolution_timeframe` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `organization_categor_department_id_35ac9278_fk_organizat` (`department_id`),
  CONSTRAINT `organization_categor_department_id_35ac9278_fk_organizat` FOREIGN KEY (`department_id`) REFERENCES `organization_department` (`id`),
  CONSTRAINT `organization_category_resolution_timeframe_88aa4b74_check` CHECK ((`resolution_timeframe` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `organization_category`
--

LOCK TABLES `organization_category` WRITE;
/*!40000 ALTER TABLE `organization_category` DISABLE KEYS */;
INSERT INTO `organization_category` VALUES (1,'Fee Payment Issues',1,0,48),(2,'Missing Marks',4,1,48),(3,'Clashing Exam Timetable',6,1,48),(4,'Unit Registration Issues',4,1,48),(5,'Clashing Unit Registration',4,1,48),(6,'ODEL & Student Portal Issues',2,0,48),(7,'test',4,0,1),(10,'Attachment Inquiries or Issues',NULL,1,48),(11,'Research Project Inquiries or Issues',NULL,1,48),(12,'Test notifications',5,0,1),(15,'Not sure which category my issue belongs to',NULL,1,1);
/*!40000 ALTER TABLE `organization_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `organization_course`
--

DROP TABLE IF EXISTS `organization_course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `organization_course` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `course_name` varchar(100) NOT NULL,
  `department_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `organization_course_department_id_4d7dc13d_fk_organizat` (`department_id`),
  CONSTRAINT `organization_course_department_id_4d7dc13d_fk_organizat` FOREIGN KEY (`department_id`) REFERENCES `organization_department` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `organization_course`
--

LOCK TABLES `organization_course` WRITE;
/*!40000 ALTER TABLE `organization_course` DISABLE KEYS */;
INSERT INTO `organization_course` VALUES (1,'BSc Computer Science',5),(2,'BSc Information Science',5),(3,'Diploma in IT',5),(5,'Law Degree',10),(7,'Economics',12),(8,'Diploma in Clinical Psychology',13),(9,'Diploma in Law',10);
/*!40000 ALTER TABLE `organization_course` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `organization_department`
--

DROP TABLE IF EXISTS `organization_department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `organization_department` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `department_name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `organization_department`
--

LOCK TABLES `organization_department` WRITE;
/*!40000 ALTER TABLE `organization_department` DISABLE KEYS */;
INSERT INTO `organization_department` VALUES (1,'Finance'),(2,'IT'),(4,'Registry'),(5,'Computer & Information Science'),(6,'Examinations & Timetabling'),(9,'Test Department'),(10,'Law'),(12,'Business Department'),(13,'Psychology'),(14,'Quality Assuarance'),(16,'NEW');
/*!40000 ALTER TABLE `organization_department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tickets_additionalinfo`
--

DROP TABLE IF EXISTS `tickets_additionalinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tickets_additionalinfo` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `info` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `attachment` varchar(100) DEFAULT NULL,
  `added_by_id` bigint DEFAULT NULL,
  `ticket_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tickets_additionalinfo_added_by_id_073a8b7a_fk_accounts_user_id` (`added_by_id`),
  KEY `tickets_additionalinfo_ticket_id_2bfaf97b_fk_tickets_ticket_id` (`ticket_id`),
  CONSTRAINT `tickets_additionalinfo_added_by_id_073a8b7a_fk_accounts_user_id` FOREIGN KEY (`added_by_id`) REFERENCES `accounts_user` (`id`),
  CONSTRAINT `tickets_additionalinfo_ticket_id_2bfaf97b_fk_tickets_ticket_id` FOREIGN KEY (`ticket_id`) REFERENCES `tickets_ticket` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tickets_additionalinfo`
--

LOCK TABLES `tickets_additionalinfo` WRITE;
/*!40000 ALTER TABLE `tickets_additionalinfo` DISABLE KEYS */;
INSERT INTO `tickets_additionalinfo` VALUES (1,'1049999','2026-03-11 17:20:40.165442','additional_info_attachments/a78bccc0-363b-44b9-bcb0-f804f82c9f5d.png',13,11),(2,'Test for additional info plus auto change status and auto message','2026-03-11 17:32:24.247178','',22,31),(3,'here\'s my second response','2026-03-11 20:50:46.660393','additional_info_attachments/Analytics_Driven_Issue_Flow-2026-01-15-084334.png',22,31),(4,'Now let us confirm if it will change the due date and time after unpausing','2026-03-12 14:59:02.671393','additional_info_attachments/Screenshot_2025-02-27_192847.png',15,35),(5,'final test on adding additional info','2026-03-12 19:58:05.449762','additional_info_attachments/Screenshot_20260111_151236_Samsung_Internet.jpg',22,31),(6,'Ok let me know if this works','2026-04-02 14:11:03.103630','',15,35),(7,'Test was for unit 101','2026-04-02 16:34:22.412424','',15,38),(8,'Sorry let me upload again','2026-04-22 22:06:41.527977','additional_info_attachments/DOMAIN_1.pdf',65,47),(9,'More info has been sent','2026-06-14 18:13:14.562000','',13,28),(10,'Hamisi101 is the account','2026-06-14 21:50:09.938820','',65,55);
/*!40000 ALTER TABLE `tickets_additionalinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tickets_resolution`
--

DROP TABLE IF EXISTS `tickets_resolution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tickets_resolution` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `feedback` longtext NOT NULL,
  `resolved_at` datetime(6) NOT NULL,
  `resolved_by_id` bigint DEFAULT NULL,
  `ticket_id` bigint NOT NULL,
  `status` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tickets_resolution_resolved_by_id_0f215aa1_fk_accounts_user_id` (`resolved_by_id`),
  KEY `tickets_resolution_ticket_id_de2ea6cb` (`ticket_id`),
  CONSTRAINT `tickets_resolution_resolved_by_id_0f215aa1_fk_accounts_user_id` FOREIGN KEY (`resolved_by_id`) REFERENCES `accounts_user` (`id`),
  CONSTRAINT `tickets_resolution_ticket_id_de2ea6cb_fk_tickets_ticket_id` FOREIGN KEY (`ticket_id`) REFERENCES `tickets_ticket` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=153 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tickets_resolution`
--

LOCK TABLES `tickets_resolution` WRITE;
/*!40000 ALTER TABLE `tickets_resolution` DISABLE KEYS */;
INSERT INTO `tickets_resolution` VALUES (1,'Update is under progress','2025-12-17 11:52:25.131771',3,1,'OPEN'),(2,'This is being sorted and will be updated shortly','2025-12-19 18:44:42.342008',5,3,'OPEN'),(3,'Use paybill 223344 and account name input your admission number','2025-12-19 18:59:33.947922',5,4,'RESOLVED'),(4,'Use paybill 223344 and account name input your admission number and have a good day','2025-12-19 19:05:04.653582',5,4,'RESOLVED'),(5,'It will be checked and decided on the next steps. We will keep you posted','2025-12-19 19:12:32.855889',5,5,'RESOLVED'),(6,'Let me inquire then get back to you','2025-12-19 19:24:57.898905',5,6,'RESOLVED'),(7,'Write an official email requesting this','2025-12-19 19:26:46.045565',5,6,'RESOLVED'),(8,'It will be carried foward to next semister','2025-12-19 19:28:24.364797',5,5,'RESOLVED'),(9,'It will be carried foward to next semister','2025-12-19 19:29:15.908650',5,5,'RESOLVED'),(10,'This will be checked','2025-12-20 17:56:54.778740',7,7,'RESOLVED'),(11,'This has been updated, kindly check','2025-12-20 17:58:39.877716',7,7,'RESOLVED'),(12,'This has been updated','2025-12-24 11:33:14.341681',7,8,'RESOLVED'),(13,'This will be checked and updated','2025-12-24 12:07:35.430956',8,9,'PENDING'),(14,'Try using the Mpesa app','2026-01-25 13:20:14.153229',21,16,'RESOLVED'),(15,'Updated it. Check on transcripts','2026-01-25 13:22:32.854638',20,12,'RESOLVED'),(16,'It has been updated. Check transcript','2026-01-25 14:02:31.112275',20,14,'RESOLVED'),(17,'Updated kindly check','2026-01-25 14:53:13.167143',20,17,'RESOLVED'),(18,'Payment has been received','2026-01-25 17:40:07.617339',21,16,'RESOLVED'),(19,'This is being worked on.','2026-01-25 19:53:49.064065',20,11,'ESCALATED'),(20,'working on it','2026-01-25 22:25:33.472793',20,20,'PENDING'),(21,'This is being worked on. Thank you for bringing this foward','2026-01-26 05:27:03.597060',10,22,'PENDING'),(22,'[TRANSFERRED from Computer & Information Science to Registry]: The registry will take a look at this','2026-02-23 15:20:02.365202',10,24,'TRANSFERRED'),(23,'[INTERNAL ESCALATION]: Clarify this issue','2026-02-23 19:28:01.896179',10,23,'ESCALATED'),(24,'[INTERNAL ESCALATION]: requires HOD feedback','2026-02-23 22:19:12.702198',20,11,'ESCALATED'),(25,'This is being worked on','2026-02-25 13:25:58.897543',21,21,'PENDING'),(26,'Check your portal. It has been uploaded','2026-02-25 13:29:23.918807',21,21,'RESOLVED'),(27,'This has been worked on. Check your timetable','2026-02-25 20:23:58.991919',20,24,'RESOLVED'),(28,'[AUTOMATIC ESCALATION]: Ticket exceeded SLA timeframe and was escalated automatically.','2026-02-25 20:35:08.648786',NULL,1,'ESCALATED'),(29,'[AUTOMATIC ESCALATION]: Ticket exceeded SLA timeframe and was escalated automatically.','2026-02-25 20:35:08.649784',NULL,2,'ESCALATED'),(30,'[AUTOMATIC ESCALATION]: Ticket exceeded SLA timeframe and was escalated automatically.','2026-02-25 20:35:08.649784',NULL,3,'ESCALATED'),(31,'[AUTOMATIC ESCALATION]: Ticket exceeded SLA timeframe and was escalated automatically.','2026-02-25 20:35:08.649784',NULL,10,'ESCALATED'),(32,'[AUTOMATIC ESCALATION]: Ticket exceeded SLA timeframe and was escalated automatically.','2026-02-25 20:35:08.649784',NULL,13,'ESCALATED'),(33,'[AUTOMATIC ESCALATION]: Ticket exceeded SLA timeframe and was escalated automatically.','2026-02-25 20:35:08.649784',NULL,15,'ESCALATED'),(34,'[AUTOMATIC ESCALATION]: Ticket exceeded SLA timeframe and was escalated automatically.','2026-02-25 20:35:08.649784',NULL,18,'ESCALATED'),(35,'[AUTOMATIC ESCALATION]: Ticket exceeded SLA timeframe and was escalated automatically.','2026-02-25 20:35:08.649784',NULL,19,'ESCALATED'),(36,'[AUTOMATIC ESCALATION]: Ticket exceeded SLA timeframe and was escalated automatically.','2026-02-25 20:35:08.649784',NULL,20,'ESCALATED'),(37,'[AUTOMATIC ESCALATION]: Ticket exceeded SLA timeframe and was escalated automatically.','2026-02-25 20:35:08.649784',NULL,22,'ESCALATED'),(38,'[AUTOMATIC ESCALATION]: Ticket exceeded SLA timeframe and was escalated automatically.','2026-02-25 20:35:08.649784',NULL,25,'ESCALATED'),(39,'[AUTOMATIC ESCALATION]: Ticket exceeded SLA timeframe and was escalated automatically.','2026-02-25 20:35:08.649784',NULL,27,'ESCALATED'),(40,'[AUTOMATIC ESCALATION]: Ticket exceeded the due date and was escalated automatically.','2026-02-28 12:43:22.820399',NULL,26,'ESCALATED'),(41,'Ok it works','2026-03-01 16:08:49.916675',20,17,'RESOLVED'),(42,'[AUTOMATIC ESCALATION]: Ticket exceeded the due date and was escalated automatically.','2026-03-01 16:22:29.735244',NULL,28,'ESCALATED'),(43,'[INTERNAL ESCALATION]: Check this issue','2026-03-01 16:23:15.095796',20,17,'ESCALATED'),(44,'[INTERNAL ESCALATION]: Test if escalation still works','2026-03-02 11:47:46.344181',20,29,'ESCALATED'),(45,'[TRANSFERRED from Registry to Finance]: Testing transfer','2026-03-02 14:06:16.320337',20,30,'TRANSFERRED'),(46,'Managed to transfer. Let us try to complete the feedback process','2026-03-02 14:11:02.910794',21,30,'PENDING'),(47,'Now give feedback, negative first','2026-03-02 14:11:51.516754',21,30,'RESOLVED'),(48,'Successfully reopened, can we close this now?','2026-03-02 14:13:53.573220',21,30,'RESOLVED'),(49,'[AUTOMATIC ESCALATION]: Ticket exceeded the due date and was escalated automatically.','2026-03-03 12:56:07.889023',NULL,31,'ESCALATED'),(50,'[AUTOMATIC ESCALATION]: Ticket exceeded the due date and was escalated automatically.','2026-03-08 12:56:14.909169',NULL,32,'ESCALATED'),(51,'Please provide more details','2026-03-11 12:23:27.141308',23,31,'PENDING'),(52,'Working on this currently','2026-03-11 12:32:35.663979',23,28,'IN_PROGRESS'),(53,'[TRANSFERRED from Registry to IT]: Testing Senior staff transfer','2026-03-11 12:47:33.980869',23,27,'TRANSFERRED'),(54,'send your admission number','2026-03-11 16:59:32.391644',23,11,'PENDING'),(55,'Student (Joe Down) provided additional information. Status updated to IN PROGRESS.','2026-03-11 17:32:24.261932',NULL,31,'IN_PROGRESS'),(56,'Testing with pending once more','2026-03-11 20:49:21.840227',23,31,'PENDING'),(57,'Student (Joe Down) provided additional information. Status updated to IN PROGRESS.','2026-03-11 20:50:46.675875',NULL,31,'IN_PROGRESS'),(58,'[AUTOMATIC ESCALATION]: Ticket exceeded the due date and was escalated automatically.','2026-03-12 13:52:20.114561',NULL,21,'ESCALATED'),(59,'[AUTOMATIC ESCALATION]: Ticket exceeded the due date and was escalated automatically.','2026-03-12 13:52:20.114561',NULL,27,'ESCALATED'),(61,'testing the pause when pending','2026-03-12 13:54:54.880469',20,35,'PENDING'),(62,'Student (Lydia Waweru) provided additional information. Status updated to IN PROGRESS.','2026-03-12 14:59:02.681367',NULL,35,'IN_PROGRESS'),(63,'[AUTOMATIC ESCALATION]: Ticket exceeded the due date and was escalated automatically.','2026-03-12 16:47:45.736137',NULL,35,'ESCALATED'),(64,'Test aimed at reopening and checking timelines','2026-03-12 17:13:35.011276',23,31,'RESOLVED'),(65,'[TRANSFERRED from Registry to Computer & Information Science]: Test to see whether the timeframes will change when transferred','2026-03-12 17:54:05.714634',23,31,'TRANSFERRED'),(66,'Successfully added 24hrs for the transfer. So SLA Calculations are a success','2026-03-12 17:56:33.859038',10,31,'RESOLVED'),(67,'final pending test','2026-03-12 19:54:55.587035',10,31,'PENDING'),(68,'Student (Joe Down) provided additional information. Status updated to IN PROGRESS.','2026-03-12 19:58:05.459264',NULL,31,'IN_PROGRESS'),(69,'we are working on he test','2026-03-12 19:59:59.434243',10,31,'IN_PROGRESS'),(70,'last resolution','2026-03-12 20:01:06.810212',10,31,'RESOLVED'),(71,'[TRANSFERRED from IT to Registry]: Check if there is an issue with registy','2026-03-12 20:42:46.903856',14,34,'TRANSFERRED'),(72,'[TRANSFERRED from Registry to Registry]: rrr','2026-03-12 21:59:43.811501',23,35,'TRANSFERRED'),(73,'[AUTOMATIC ESCALATION]: Ticket exceeded the due date and was escalated automatically.','2026-04-02 10:47:52.206813',NULL,34,'ESCALATED'),(74,'[AUTOMATIC ESCALATION]: Ticket exceeded the due date and was escalated automatically.','2026-04-02 10:47:52.206813',NULL,35,'ESCALATED'),(75,'[AUTOMATIC ESCALATION]: Ticket exceeded the due date and was escalated automatically.','2026-04-02 10:47:52.206813',NULL,36,'ESCALATED'),(76,'Not enough details were provided','2026-04-02 10:56:30.759422',21,37,'REJECTED'),(77,'This is to test notifications on students end','2026-04-02 13:16:22.525762',23,29,'REJECTED'),(78,'Testing notifications','2026-04-02 13:31:02.500451',23,35,'IN_PROGRESS'),(79,'Extra details needed for notification testing','2026-04-02 14:00:25.134146',23,35,'PENDING'),(80,'Student (Lydia Waweru) provided additional information. Status updated to IN PROGRESS.','2026-04-02 14:11:03.117592',NULL,35,'IN_PROGRESS'),(81,'Yes now check the notification','2026-04-02 14:28:23.886590',23,35,'RESOLVED'),(82,'add more information','2026-04-02 16:33:27.409197',10,38,'PENDING'),(83,'Student (Lydia Waweru) provided additional information. Status updated to IN PROGRESS.','2026-04-02 16:34:22.422397',NULL,38,'IN_PROGRESS'),(84,'Solved','2026-04-02 16:36:37.951348',10,38,'RESOLVED'),(85,'[TRANSFERRED from Computer & Information Science to Registry]: transfer notification','2026-04-02 16:47:30.875386',10,38,'TRANSFERRED'),(86,'[AUTOMATIC ESCALATION]: Ticket exceeded the due date and was escalated automatically.','2026-04-03 11:07:00.490717',NULL,39,'ESCALATED'),(87,'[INTERNAL ESCALATION]: test notification','2026-04-03 11:19:50.534340',20,9,'ESCALATED'),(88,'[AUTOMATIC ESCALATION]: Ticket exceeded the due date and was escalated automatically.','2026-04-04 11:31:19.937681',NULL,38,'ESCALATED'),(89,'[AUTOMATIC ESCALATION]: Ticket exceeded the due date and was escalated automatically.','2026-04-04 12:44:45.852803',NULL,40,'ESCALATED'),(90,'The auto escalation message is ok now and it is detailed','2026-04-04 12:59:20.547400',20,41,'RESOLVED'),(91,'[AUTOMATIC ESCALATION]: Ticket exceeded the due date and was escalated automatically.','2026-04-14 22:38:23.436533',NULL,42,'ESCALATED'),(92,'[AUTOMATIC ESCALATION]: Ticket exceeded the due date and was escalated automatically.','2026-04-14 22:38:23.436533',NULL,43,'ESCALATED'),(93,'check emails','2026-04-14 22:52:26.992177',23,43,'REJECTED'),(94,'[AUTOMATIC ESCALATION]: Ticket exceeded the due date and was escalated automatically.','2026-04-15 11:11:50.349728',NULL,44,'ESCALATED'),(95,'Send additional background','2026-04-15 13:00:01.018036',23,28,'PENDING'),(96,'[TRANSFERRED from Finance to Computer & Information Science]: The student has selected the wrong category','2026-04-21 12:25:48.298385',21,45,'TRANSFERRED'),(97,'[AUTOMATIC ESCALATION]: Ticket exceeded the due date and was escalated automatically.','2026-04-22 17:33:23.533675',NULL,45,'ESCALATED'),(98,'Records show you never registered for the unit.','2026-04-22 18:06:10.340536',10,46,'RESOLVED'),(99,'[TRANSFERRED from Computer & Information Science to Test Department]: ???????//','2026-04-22 18:21:30.861201',10,46,'TRANSFERRED'),(100,'Kindly upload your transcript','2026-04-22 22:01:26.869861',67,47,'PENDING'),(101,'Student (Gatura Hamisi) provided additional information. Status updated to IN PROGRESS.','2026-04-22 22:06:41.547960',NULL,47,'IN_PROGRESS'),(102,'This is being checked and we will get back to you','2026-04-22 22:12:28.036609',67,47,'IN_PROGRESS'),(103,'You did not sign during the exam','2026-04-22 22:30:42.357359',67,2,'REJECTED'),(104,'Spam','2026-04-22 22:31:08.929102',67,23,'REJECTED'),(105,'You will have to do both at the same time. Start with one then proceed to the other one. The changes cannot be implemented at this time','2026-04-22 22:33:29.551202',67,22,'RESOLVED'),(106,'Stream C available on Thursday 2PM','2026-04-22 22:34:18.934137',67,25,'RESOLVED'),(107,'[AUTOMATIC ESCALATION]: Ticket exceeded the due date and was escalated automatically.','2026-04-23 06:07:01.834603',NULL,48,'ESCALATED'),(108,'Updated check your portal.','2026-04-23 06:09:18.589400',67,36,'RESOLVED'),(109,'Undefined issue','2026-04-23 06:10:16.607950',23,17,'REJECTED'),(110,'This has been updated','2026-04-23 06:19:39.367346',23,20,'RESOLVED'),(111,'Updated. Sorry for the inconvenience','2026-04-23 06:21:09.601015',23,9,'RESOLVED'),(112,'[TRANSFERRED from Registry to IT]: The IT department should be available to help you with that','2026-04-23 06:22:12.005470',23,34,'TRANSFERRED'),(113,'They were notified','2026-04-23 06:22:57.244533',23,38,'REJECTED'),(114,'Success notification received','2026-04-23 06:24:05.708639',23,39,'RESOLVED'),(115,'No since the system is not live yet I only got the auto escalation notification after it was already escalated','2026-04-23 06:25:57.222537',23,40,'REJECTED'),(116,'Updated wait for a few minutes for it to reflect on your transcript','2026-04-23 06:30:32.290747',23,11,'RESOLVED'),(117,'No updates sent','2026-04-23 06:31:24.078505',23,28,'PENDING'),(118,'It takes some time before it updates','2026-04-23 06:40:01.875502',43,1,'RESOLVED'),(119,'Takes some time for it to reflect and by the end of the day it will reflect.','2026-04-23 06:41:15.628958',43,3,'RESOLVED'),(120,'SPAM','2026-04-23 06:41:41.067440',43,18,'REJECTED'),(121,'spam','2026-04-23 06:42:07.890714',43,19,'REJECTED'),(122,'spam','2026-04-23 06:43:00.377511',43,13,'REJECTED'),(123,'MPESA was down but it is now back up. Try again','2026-04-23 06:44:01.441324',43,15,'RESOLVED'),(124,'Unfortunately the deadline has passed try coming physically to get more assistance','2026-04-23 06:45:09.321187',43,10,'REJECTED'),(125,'Print it from your student portal','2026-04-23 06:46:23.276033',43,21,'RESOLVED'),(126,'FALSE','2026-04-23 08:13:21.892191',67,49,'REJECTED'),(127,'[AUTOMATIC ESCALATION]: Ticket exceeded the due date and was escalated automatically.','2026-05-02 20:56:55.997385',NULL,34,'ESCALATED'),(128,'[AUTOMATIC ESCALATION]: Ticket exceeded the due date and was escalated automatically.','2026-05-02 20:56:55.997385',NULL,46,'ESCALATED'),(129,'[AUTOMATIC ESCALATION]: Ticket exceeded the due date and was escalated automatically.','2026-05-02 20:56:55.997385',NULL,47,'ESCALATED'),(130,'[TRANSFERRED from Finance to Registry]: Wrong category selected','2026-06-09 20:12:09.720783',21,50,'TRANSFERRED'),(131,'[AUTOMATIC ESCALATION]: Ticket exceeded the due date and was escalated automatically.','2026-06-11 09:51:23.123576',NULL,50,'ESCALATED'),(132,'Lack of specification','2026-06-12 09:41:03.243718',67,45,'REJECTED'),(133,'Fixed','2026-06-12 09:42:20.278376',67,47,'RESOLVED'),(134,'Auto escalation notification sent but not  warning but let me test','2026-06-12 09:45:28.304301',67,48,'RESOLVED'),(135,'RESOLVED','2026-06-13 17:44:33.270843',67,51,'RESOLVED'),(136,'[INTERNAL ESCALATION]: ESCALATE','2026-06-13 17:46:04.752451',10,51,'ESCALATED'),(137,'RESOLVED','2026-06-13 17:46:29.547568',67,51,'PENDING'),(138,'Student (King Luther) provided additional information. Status updated to IN PROGRESS.','2026-06-14 18:13:14.586106',NULL,28,'IN_PROGRESS'),(139,'[AUTOMATIC ESCALATION]: Ticket exceeded the due date and was escalated automatically.','2026-06-14 21:29:29.225715',NULL,54,'ESCALATED'),(140,'solved','2026-06-14 21:42:42.776305',67,51,'RESOLVED'),(141,'provide account name','2026-06-14 21:48:59.571464',21,55,'PENDING'),(142,'Student (Gatura Hamisi) provided additional information. Status updated to IN PROGRESS.','2026-06-14 21:50:09.955936',NULL,55,'IN_PROGRESS'),(143,'Wrong account','2026-06-14 21:51:34.487967',21,55,'REJECTED'),(144,'Updated check transcript','2026-06-14 21:55:27.892025',10,56,'RESOLVED'),(145,'[INTERNAL ESCALATION]: Check this out','2026-06-14 21:57:03.642566',10,56,'ESCALATED'),(146,'Now fixed','2026-06-14 21:58:08.237586',67,56,'RESOLVED'),(147,'[TRANSFERRED from Computer & Information Science to Finance]: This is a finance issue','2026-06-14 22:03:40.509996',10,57,'TRANSFERRED'),(148,'FIXED','2026-06-15 10:18:57.157294',10,58,'RESOLVED'),(149,'[INTERNAL ESCALATION]: ESCALTE','2026-06-15 10:20:32.485690',10,58,'ESCALATED'),(150,'[AUTOMATIC ESCALATION]: Ticket exceeded the due date and was escalated automatically.','2026-06-30 12:50:35.794254',NULL,52,'ESCALATED'),(151,'[AUTOMATIC ESCALATION]: Ticket exceeded the due date and was escalated automatically.','2026-06-30 12:50:35.794254',NULL,53,'ESCALATED'),(152,'[AUTOMATIC ESCALATION]: Ticket exceeded the due date and was escalated automatically.','2026-06-30 12:50:35.794254',NULL,57,'ESCALATED');
/*!40000 ALTER TABLE `tickets_resolution` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tickets_studentfeedback`
--

DROP TABLE IF EXISTS `tickets_studentfeedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tickets_studentfeedback` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `is_satisfied` tinyint(1) NOT NULL,
  `comments` longtext,
  `created_at` datetime(6) NOT NULL,
  `student_id` bigint DEFAULT NULL,
  `ticket_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tickets_studentfeedback_student_id_fb50178c_fk_accounts_user_id` (`student_id`),
  KEY `tickets_studentfeedback_ticket_id_f99c77c3_fk_tickets_ticket_id` (`ticket_id`),
  CONSTRAINT `tickets_studentfeedback_student_id_fb50178c_fk_accounts_user_id` FOREIGN KEY (`student_id`) REFERENCES `accounts_user` (`id`),
  CONSTRAINT `tickets_studentfeedback_ticket_id_f99c77c3_fk_tickets_ticket_id` FOREIGN KEY (`ticket_id`) REFERENCES `tickets_ticket` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tickets_studentfeedback`
--

LOCK TABLES `tickets_studentfeedback` WRITE;
/*!40000 ALTER TABLE `tickets_studentfeedback` DISABLE KEYS */;
INSERT INTO `tickets_studentfeedback` VALUES (1,1,'','2026-03-01 13:55:19.827696',13,24),(2,0,'Testing reopen','2026-03-01 13:56:10.436303',13,17),(3,0,'testing second reopen','2026-03-01 16:22:06.685590',13,17),(4,0,'Final test on reopening','2026-03-02 14:12:34.633164',22,30),(5,1,'Ok!!','2026-03-02 14:14:21.872241',22,30),(6,0,'still no confirmation','2026-03-10 21:03:21.259579',22,21),(7,0,'Testing reopening timelines','2026-03-12 17:14:18.870739',22,31),(8,1,'','2026-03-12 19:52:51.434159',15,14),(9,0,'Final test to see if it is ok','2026-03-12 19:53:59.666630',22,31),(10,1,'final close','2026-03-12 20:03:51.671590',22,31),(11,1,'','2026-03-13 07:05:14.269251',13,16),(12,0,'reopened notification','2026-04-02 16:37:37.275071',15,38),(13,0,'Nah. You\'re wrong bro.','2026-04-22 18:09:28.998792',66,46),(14,1,'It was fixed. Thank you','2026-06-12 09:43:01.995457',65,47),(15,0,'NO','2026-06-13 17:45:08.791640',65,51),(16,0,'Still not showing','2026-06-14 21:56:16.832096',65,56),(17,1,'Thank you','2026-06-14 21:58:36.031003',65,56),(18,0,'STILL NOT','2026-06-15 10:19:31.301035',65,58);
/*!40000 ALTER TABLE `tickets_studentfeedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tickets_ticket`
--

DROP TABLE IF EXISTS `tickets_ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tickets_ticket` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `description` longtext NOT NULL,
  `status` varchar(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `category_id` bigint NOT NULL,
  `owner_id` bigint NOT NULL,
  `attachment` varchar(100) DEFAULT NULL,
  `current_department_id` bigint DEFAULT NULL,
  `due_date` datetime(6) DEFAULT NULL,
  `is_escalated` tinyint(1) NOT NULL,
  `pending_since` datetime(6) DEFAULT NULL,
  `is_deadline_warning_sent` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tickets_ticket_category_id_710dbfd0_fk_organization_category_id` (`category_id`),
  KEY `tickets_ticket_owner_id_40236788_fk_accounts_user_id` (`owner_id`),
  KEY `tickets_ticket_current_department_i_09dc52bf_fk_organizat` (`current_department_id`),
  CONSTRAINT `tickets_ticket_category_id_710dbfd0_fk_organization_category_id` FOREIGN KEY (`category_id`) REFERENCES `organization_category` (`id`),
  CONSTRAINT `tickets_ticket_current_department_i_09dc52bf_fk_organizat` FOREIGN KEY (`current_department_id`) REFERENCES `organization_department` (`id`),
  CONSTRAINT `tickets_ticket_owner_id_40236788_fk_accounts_user_id` FOREIGN KEY (`owner_id`) REFERENCES `accounts_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tickets_ticket`
--

LOCK TABLES `tickets_ticket` WRITE;
/*!40000 ALTER TABLE `tickets_ticket` DISABLE KEYS */;
INSERT INTO `tickets_ticket` VALUES (1,'Failure to update my fee balance','I paid my fees but it has not been updated on my portal.','RESOLVED','2025-12-17 11:51:21.796461','2026-04-23 06:40:01.880299',1,2,'',1,'2025-12-19 11:51:21.796461',1,NULL,0),(2,'Missing Grade for Med101','I attended the exam but my portal shows \'No Grade\'.','REJECTED','2025-12-19 16:32:27.591810','2026-04-22 22:30:42.365727',2,6,'',5,'2025-12-21 16:32:27.591810',1,NULL,0),(3,'No fee updates on my portal','I paid full fees but the portal is not updated to show I have paid','RESOLVED','2025-12-19 17:02:31.464264','2026-04-23 06:41:15.640793',1,6,'',1,'2025-12-21 17:02:31.464264',1,NULL,0),(4,'Unable to pay fees','I don\'t have the necessary account number to use','RESOLVED','2025-12-19 18:57:45.990744','2026-02-23 10:34:20.118808',1,6,'',1,'2025-12-21 18:57:45.990744',0,NULL,0),(5,'Paid excess','Can I get a refund','RESOLVED','2025-12-19 19:10:37.307362','2026-02-23 10:34:20.130776',1,6,'',1,'2025-12-21 19:10:37.307362',0,NULL,0),(6,'Extension of fee payment','I will not be able to pay on expected date. Can I get an extension?','RESOLVED','2025-12-19 19:22:25.848129','2026-02-23 10:34:20.144350',1,6,'',1,'2025-12-21 19:22:25.848129',0,NULL,0),(7,'Missing marks for 435 CAT','My CAT marks are not uploaded','RESOLVED','2025-12-20 17:55:03.605721','2026-02-23 11:04:00.548620',2,6,'',4,NULL,0,NULL,0),(8,'Missing marks for 435 CAT','My CAT marks are not uploaded','RESOLVED','2025-12-24 11:32:00.119931','2026-02-23 11:04:00.562888',2,6,'',4,NULL,0,NULL,0),(9,'Missing marks for Python 101 CAT','My CAT marks are not uploaded','RESOLVED','2025-12-24 12:05:20.672892','2026-04-23 06:21:09.606356',2,9,'',4,'2026-04-04 11:19:50.562333',1,NULL,0),(10,'Request for a fee extension deadline','I will unfortunately not be able to pay my fees on time. I would like to request for an extension.','REJECTED','2026-01-21 10:26:36.852994','2026-04-23 06:45:09.327808',1,13,'ticket_attachments/Transcript_-_1446944_-_Hamisi_Juma.pdf',1,'2026-01-23 10:26:36.852994',1,NULL,0),(11,'missing exam mark for GS 100','Results were released and I have a missing mark in GS100. Kindly assist','RESOLVED','2026-01-21 10:50:16.223410','2026-04-23 06:30:32.296732',2,13,'ticket_attachments/hello.txt',4,'2026-01-23 10:50:16.223410',1,NULL,0),(12,'111','eeee','RESOLVED','2026-01-21 10:54:10.979424','2026-02-23 11:04:00.620991',2,13,'',4,'2026-01-23 10:54:10.979424',0,NULL,0),(13,'hhhh','gggg','REJECTED','2026-01-23 11:00:34.109908','2026-04-23 06:43:00.389416',1,15,'',1,'2026-01-25 11:00:34.109908',1,NULL,0),(14,'missing CMT 100','Lorem','CLOSED','2026-01-23 11:09:28.310354','2026-03-12 19:52:51.442136',2,15,'ticket_attachments/Transcript_-_1446944_-_Hamisi_Juma_liLCErq.pdf',4,'2026-01-25 11:09:28.310354',0,NULL,0),(15,'can\'t pay using mpesa','I tried to pay but payment didn\'t go through','RESOLVED','2026-01-23 11:45:23.712282','2026-04-23 06:44:01.446409',1,13,'',1,'2026-01-25 11:45:23.712282',1,NULL,0),(16,'Failed transaction','I tried to pay but it failed','CLOSED','2026-01-23 11:55:05.688261','2026-03-13 07:05:14.280324',1,13,'',1,'2026-01-25 11:55:05.688261',0,NULL,0),(17,'fffff','lorem','REJECTED','2026-01-25 10:16:44.134391','2026-04-23 06:10:16.614096',2,13,'ticket_attachments/Screenshot_20260111_151236_Samsung_Internet.jpg',4,'2026-01-27 10:16:44.134391',1,NULL,0),(18,'Uhjdvwj','jsjfqureudsv','REJECTED','2026-01-25 14:04:53.398436','2026-04-23 06:41:41.077984',1,15,'ticket_attachments/Screenshot_2025-02-27_192847.png',1,'2026-01-27 14:04:53.398436',1,NULL,0),(19,'DDDDD','2122EDFGR','REJECTED','2026-01-25 17:11:45.785815','2026-04-23 06:42:07.894138',1,13,'',1,'2026-01-27 17:11:45.785815',1,NULL,0),(20,'CMT 108 missing exam marks','I did not have results','RESOLVED','2026-01-25 22:24:25.703272','2026-04-23 06:19:39.372277',2,24,'ticket_attachments/Screenshot_2025-11-02_132810.png',4,'2026-01-27 22:24:25.703272',1,NULL,0),(21,'no confirmation of payment','I have not received the receipt','RESOLVED','2026-01-26 00:37:43.505185','2026-04-23 06:46:23.280025',1,22,'',1,'2026-01-28 00:37:43.505185',1,NULL,0),(22,'CMT 402 and CMT 300','I have both units on Monday, 28th April,2026 at 9am. Kindly assist on the way foward','RESOLVED','2026-01-26 05:24:43.027150','2026-04-22 22:33:29.562273',3,22,'',5,'2026-01-28 05:24:43.027150',1,NULL,0),(23,'fff','uiuti7','REJECTED','2026-01-26 06:58:07.448075','2026-04-22 22:31:08.946092',2,22,'',5,'2026-01-28 06:58:07.448075',1,NULL,0),(24,'CMT 400 and CMT 300','These are clashing','CLOSED','2026-01-26 07:15:55.395890','2026-03-01 13:55:19.833661',3,13,'ticket_attachments/Screenshot_20260111_151236_Samsung_Internet_nR96kE6.jpg',4,'2026-01-28 07:15:55.395890',0,NULL,0),(25,'CMT 210 and GS 101 are clashing','Both units are at Monday 8 AM','RESOLVED','2026-02-21 23:22:09.240152','2026-04-22 22:34:18.942841',5,22,'ticket_attachments/90088041859.png',5,'2026-02-23 23:22:09.226643',1,NULL,0),(26,'Failed Transaction','I tried to pay semester fees via the bank, but it failed. Can I get alternatives?','ESCALATED','2026-02-25 13:24:30.599529','2026-02-25 13:24:30.599529',1,22,'',1,'2026-02-27 13:24:30.597534',1,NULL,0),(27,'This is a test on escalation','Can you escalate this?','ESCALATED','2026-02-25 16:06:19.565394','2026-03-11 12:47:33.989846',7,13,'',2,'2026-02-25 17:06:19.561405',1,NULL,0),(28,'Testing','New issue','IN_PROGRESS','2026-03-01 15:22:15.875078','2026-06-14 18:13:14.579117',7,13,'',4,'2026-04-30 21:35:29.420013',1,NULL,0),(29,'This is another test','lorem lorem lorem','REJECTED','2026-03-02 11:46:17.500886','2026-04-02 13:16:22.535735',7,22,'',4,'2026-03-02 12:46:17.496734',1,NULL,0),(30,'Test transfer','Try transfer','CLOSED','2026-03-02 13:40:42.875273','2026-03-02 14:14:21.874235',7,22,'',1,'2026-03-02 14:40:42.871276',0,NULL,0),(31,'Test minutes due/overdue functionality','Check to see if it works','CLOSED','2026-03-02 18:12:19.879541','2026-03-12 20:03:51.683672',7,22,'',5,'2026-03-13 19:57:09.542924',0,NULL,0),(32,'failed payments','my fee payment does not reflect on the portal','ESCALATED','2026-03-05 14:52:54.580668','2026-03-05 14:52:54.580668',1,13,'',1,'2026-03-07 14:52:54.577676',1,NULL,0),(34,'cannot log in','I tried severally but could not manage','ESCALATED','2026-03-11 22:37:56.410155','2026-05-02 20:56:55.763010',6,13,'',2,'2026-05-03 20:56:55.762013',1,NULL,0),(35,'This is a test on the escalations and timeframes','Testing timeframes','RESOLVED','2026-03-12 13:53:46.236440','2026-04-02 14:28:23.890580',7,15,'',4,'2026-04-03 10:58:30.151523',1,NULL,0),(36,'Missing cmt 100','Missing cmt 100 cat marks','RESOLVED','2026-03-13 07:07:57.740319','2026-04-23 06:09:18.599369',2,15,'ticket_attachments/Screenshot_20260111_151310_Samsung_Internet.jpg',5,'2026-04-03 10:47:52.195561',1,NULL,0),(37,'payment failure','I failed to pay','REJECTED','2026-04-02 10:55:37.241730','2026-04-02 10:56:30.762466',1,15,'',1,'2026-04-04 10:55:37.236745',0,NULL,0),(38,'test results missing','test staff notification','REJECTED','2026-04-02 16:29:03.514485','2026-04-23 06:22:57.251620',2,15,'',4,'2026-04-05 11:31:19.887233',1,NULL,0),(39,'testing auto escalation notifications','Testing','RESOLVED','2026-04-02 16:59:58.385469','2026-04-23 06:24:05.712688',7,13,'',4,'2026-04-04 11:07:00.422855',1,NULL,0),(40,'Testing auto escalation notification','Let me know if you\'ll be informed before it happens','REJECTED','2026-04-04 11:32:12.614180','2026-04-23 06:25:57.226928',7,22,'',4,'2026-04-05 12:44:45.785575',1,NULL,0),(41,'another test for auto escalation','to see the detailed notif meaasge','RESOLVED','2026-04-04 12:19:20.489780','2026-04-04 12:59:20.553382',7,13,'',4,'2026-04-04 13:19:20.484793',0,NULL,1),(42,'New test','To check whether new uploaded staff get this notification despite not having changed the password','ESCALATED','2026-04-05 23:55:39.136321','2026-04-14 22:38:23.124894',7,45,'',4,'2026-04-15 22:38:23.124569',1,NULL,0),(43,'Check notifications','Did inactive users get notifications?','REJECTED','2026-04-06 00:07:46.203798','2026-04-14 22:52:27.000156',7,53,'ticket_attachments/image.png',4,'2026-04-15 22:38:23.346147',1,NULL,0),(44,'test email notifications','New notification','ESCALATED','2026-04-14 22:38:58.222720','2026-04-15 11:11:49.915635',7,13,'',4,'2026-04-16 11:11:49.915635',1,NULL,0),(45,'CMT 403 Is full','Is there any other stream I can register for because Stream A is full','REJECTED','2026-04-21 12:00:43.600642','2026-06-12 09:41:03.253791',1,53,'',5,'2026-04-23 17:33:23.464034',1,NULL,0),(46,'Attachment Marks','Missing marks for GS 101 September - December 2022','ESCALATED','2026-04-22 17:40:55.276495','2026-05-02 20:56:55.847783',2,66,'ticket_attachments/CMT_437_-_2022.pdf',9,'2026-05-03 20:56:55.847783',1,NULL,0),(47,'Missing marks for CMT 202','The results seem to be missing after the recent release of results','CLOSED','2026-04-22 21:41:30.352918','2026-06-12 09:43:02.096258',2,65,'ticket_attachments/Web_Application-2026-04-20-105158.png',5,'2026-05-03 20:56:55.880695',1,NULL,0),(48,'Test email notifications','1) Warning notifications via email\r\n2) Auto-escalation emails','RESOLVED','2026-04-22 22:42:17.787775','2026-06-12 09:45:28.317788',12,22,'',5,'2026-04-24 06:07:01.504353',1,NULL,0),(49,'RRR','RRRR','REJECTED','2026-04-23 08:12:26.066433','2026-04-23 08:13:21.899171',5,65,'',5,'2026-04-25 08:12:26.061387',0,NULL,0),(50,'Missing Marks for  CMT 101','I have no cat marks for CMT 101','ESCALATED','2026-06-09 20:10:46.813711','2026-06-11 09:51:22.707188',1,66,'',4,'2026-06-12 09:51:22.705299',1,NULL,0),(51,'CMT 101','FF','RESOLVED','2026-06-13 17:43:48.561356','2026-06-14 21:42:42.790311',2,65,'ticket_attachments/CC_CERTIFICATE.pdf',5,'2026-06-15 21:42:17.995603',1,NULL,0),(52,'BUS 123 & GS 101 are clashing','Both units are at Monday 11am and they are both core units can either units be relocated','ESCALATED','2026-06-14 09:25:40.567106','2026-06-30 12:50:35.566502',5,52,'ticket_attachments/CMT_451_Module_1.pdf',12,'2026-07-01 12:50:35.566502',1,NULL,0),(53,'Requesting final assessment','I am about to finish my attachment and would like to request for assessment before 25th June','ESCALATED','2026-06-14 20:21:36.828743','2026-06-30 12:50:35.633915',10,65,'',5,'2026-07-01 12:50:35.633915',1,NULL,0),(54,'Uncertain classes','CMT 102 is it on offer?','ESCALATED','2026-06-14 20:27:39.541509','2026-06-14 21:29:28.829877',15,66,'',5,'2026-06-15 21:29:28.829877',1,NULL,0),(55,'Failed payment','Lorem','REJECTED','2026-06-14 21:47:39.484006','2026-06-14 21:51:34.497393',1,65,'ticket_attachments/DOMAIN_5.pdf',1,'2026-06-16 21:48:49.842309',0,NULL,0),(56,'CMT 400 CAT marks','My Cat marks are missing','CLOSED','2026-06-14 21:53:16.129803','2026-06-14 21:58:36.143967',2,65,'',5,'2026-06-15 21:57:03.655221',1,NULL,0),(57,'Failed transaction','could not pay','ESCALATED','2026-06-14 22:02:44.560082','2026-06-30 12:50:35.738473',15,66,'ticket_attachments/Screenshot_2026-05-21_182745.png',1,'2026-07-01 12:50:35.738473',1,NULL,0),(58,'CMT 101','MISSING CAT MARKS','ESCALATED','2026-06-15 10:18:14.393989','2026-06-15 10:20:32.496631',2,65,'',5,'2026-06-16 10:20:32.496566',1,NULL,0);
/*!40000 ALTER TABLE `tickets_ticket` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-02  1:34:57
