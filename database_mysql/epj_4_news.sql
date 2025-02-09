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
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `news` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) DEFAULT NULL,
  `image` varchar(100) DEFAULT NULL,
  `content` text,
  `is_active` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news`
--

LOCK TABLES `news` WRITE;
/*!40000 ALTER TABLE `news` DISABLE KEYS */;
INSERT INTO `news` VALUES (1,'Monthly Music Newsletter - February Edition','new1.jpg','Album of the Month: \"Ethereal Dreams\" by Luminara\nLuminara’s newest album, \"Ethereal Dreams,\" is a mesmerizing blend of synthwave and ambient music. Critics are praising its deep soundscapes and emotionally charged lyrics. Have you listened to it yet?\n\nArtist Spotlight: Rising Star - Jake Thompson\nHailing from New York, Jake Thompson is making waves in the indie rock scene. His latest EP, \"Neon Nights,\" showcases his raw talent and storytelling ability. Watch out for his upcoming tour dates!',1,'2025-01-12 09:26:23','2025-01-12 09:26:23'),(2,'Monthly Music Newsletter - March Edition','new2.jpeg','Album of the Month: \"Celestial Echoes\" by Nova\nNova’s latest release, \"Celestial Echoes,\" is a breathtaking fusion of electronic and orchestral elements. Critics praise its innovative sound and haunting melodies. Have you added it to your playlist yet?\n\nArtist Spotlight: Rising Star - Emily Rae\nThis month, we highlight Emily Rae, a soulful singer-songwriter making waves with her heartfelt lyrics and powerful vocals. Her latest single, \"Golden Hour,\" is already trending on streaming platforms!',1,'2025-01-12 09:26:23','2025-01-12 09:26:23'),(3,'Jack 5 củ ','new3.jpeg','Nghệ sĩ nuôi con 5 ',1,'2025-01-12 09:26:23','2025-01-12 09:26:23');
/*!40000 ALTER TABLE `news` ENABLE KEYS */;
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
