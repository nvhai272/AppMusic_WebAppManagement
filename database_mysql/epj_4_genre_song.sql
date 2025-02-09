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
-- Table structure for table `genre_song`
--

DROP TABLE IF EXISTS `genre_song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genre_song` (
  `id` int NOT NULL AUTO_INCREMENT,
  `genre_id` int DEFAULT NULL,
  `song_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_genre_song` (`genre_id`,`song_id`),
  KEY `song_id` (`song_id`),
  CONSTRAINT `genre_song_ibfk_1` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`id`) ON DELETE CASCADE,
  CONSTRAINT `genre_song_ibfk_2` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=111 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genre_song`
--

LOCK TABLES `genre_song` WRITE;
/*!40000 ALTER TABLE `genre_song` DISABLE KEYS */;
INSERT INTO `genre_song` VALUES (1,1,1),(4,1,2),(8,1,3),(11,1,4),(14,1,5),(15,1,6),(18,1,7),(21,1,8),(24,1,9),(27,1,10),(28,1,11),(33,1,12),(2,2,1),(5,2,2),(9,2,3),(12,2,4),(16,2,6),(19,2,7),(22,2,8),(25,2,9),(34,2,12),(3,3,1),(6,3,2),(10,3,3),(13,3,4),(17,3,6),(20,3,7),(23,3,8),(26,3,9),(29,3,11),(35,3,12),(7,4,2),(30,4,11),(36,4,12),(31,5,11),(42,5,18),(46,5,19),(50,5,20),(53,5,21),(57,5,22),(60,5,23),(63,5,24),(66,5,25),(69,5,26),(72,5,27),(75,5,28),(79,5,29),(83,5,30),(86,5,31),(32,6,11),(99,6,37),(108,6,41),(37,7,13),(38,7,14),(39,7,15),(40,7,16),(41,8,17),(43,8,18),(47,8,19),(51,8,20),(54,8,21),(58,8,22),(61,8,23),(64,8,24),(67,8,25),(70,8,26),(73,8,27),(76,8,28),(80,8,29),(84,8,30),(87,8,31),(44,9,18),(48,9,19),(52,9,20),(55,9,21),(59,9,22),(62,9,23),(65,9,24),(68,9,25),(71,9,26),(74,9,27),(77,9,28),(81,9,29),(85,9,30),(88,9,31),(45,10,18),(49,10,19),(56,10,21),(82,10,29),(78,11,28),(89,12,32),(91,12,33),(93,12,34),(95,12,35),(97,12,36),(100,12,37),(102,12,38),(104,12,39),(106,12,40),(109,12,41),(90,13,32),(92,13,33),(94,13,34),(96,13,35),(98,13,36),(101,13,37),(103,13,38),(105,13,39),(107,13,40),(110,13,41);
/*!40000 ALTER TABLE `genre_song` ENABLE KEYS */;
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
