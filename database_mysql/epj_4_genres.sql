-- MySQL dump 10.13  Distrib 8.0.41, for Linux (x86_64)
--
-- Host: localhost    Database: epj_4
-- ------------------------------------------------------
-- Server version	8.0.41-0ubuntu0.24.04.1

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
-- Table structure for table `genres`
--

DROP TABLE IF EXISTS `genres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genres` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `image` varchar(150) DEFAULT NULL,
  `color_id` int DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `color_id` (`color_id`),
  KEY `idx_genres_title` (`title`),
  CONSTRAINT `genres_ibfk_1` FOREIGN KEY (`color_id`) REFERENCES `colors` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genres`
--

LOCK TABLES `genres` WRITE;
/*!40000 ALTER TABLE `genres` DISABLE KEYS */;
INSERT INTO `genres` VALUES (1,'Rock','Rock.jpg',1,0,'2025-01-12 09:24:14','2025-01-12 09:24:14'),(2,'Metal','metal.jpg',2,0,'2025-01-12 09:24:14','2025-01-12 09:24:14'),(3,'Alternative Rock','alt-rock.jpg',20,0,'2025-01-12 09:24:14','2025-01-12 09:24:14'),(4,'Nu metal','Nu metal.jpg',1,0,'2025-01-12 09:24:46','2025-01-12 09:24:46'),(5,'Rap','Rap.jpg',2,0,'2025-01-12 09:24:46','2025-01-12 09:24:46'),(6,'Pop','Pop.jpg',20,0,'2025-01-12 09:24:46','2025-01-12 09:24:46'),(7,'J-Pop','jpop.jpg',3,0,'2025-01-12 09:24:46','2025-01-12 09:24:46'),(8,'Spoken word','spoken word.jpg',4,0,'2025-01-12 09:24:46','2025-01-12 09:24:46'),(9,'Hip hop','hip hop.jpg',5,0,'2025-01-12 09:24:46','2025-01-12 09:24:46'),(10,'Horror core','Horror core.jpg',6,0,'2025-01-12 09:24:46','2025-01-12 09:24:46'),(11,'Gangsta rap','Gangsta rap.jpg',7,0,'2025-01-12 09:24:46','2025-01-12 09:24:46'),(12,'K-Pop','K-Pop.jpg',3,0,'2025-01-12 09:24:46','2025-01-12 09:24:46'),(13,'Korean dance','Korean dance.jpg',4,0,'2025-01-12 09:24:46','2025-01-12 09:24:46');
/*!40000 ALTER TABLE `genres` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-02-09 19:03:00
