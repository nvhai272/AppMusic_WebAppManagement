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
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `avatar` varchar(100) NOT NULL,
  `password` varchar(60) NOT NULL,
  `phone` varchar(11) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `role` varchar(20) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_users_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (4,'manh1234','Truong Duc Manh','ava1.jpeg','$2a$12$flJIlAaLr3eBnu7ToOoXKe3dLWa4gMVb9.QSIqXnxXSS6sbHINjyK','0364154661','truongducmanh@gmail.com','ROLE_ADMIN','2004-09-07',0,'2025-01-13 22:00:40','2025-01-23 09:49:14'),(5,'phuong','Ngo Dang Phuong','av2.jpeg','$2a$12$roiXaK0wSQ7Kz6IZiHiZTOxv/W5juv3E0w4xrzynlNkJyccTFEDX2','0364154662','ngodangphuong@gmail.com','ROLE_USER','2004-08-21',0,'2025-01-13 22:04:40','2025-01-13 22:04:40'),(6,'nvhai272','Nguyen Van Hai','av3.jpeg','$2a$12$win4ooA391sCDpP6ZSe.Du1AAfLW/9aF6OErxavU5AtF4vHkYP8T6','0364154663','nguyenvanhai@gmail.com','ROLE_ADMIN','2000-03-27',0,'2025-01-13 22:07:51','2025-01-13 22:07:51'),(7,'loc','Nguyen Xuan Loc','av4.jpeg','$2a$12$K/Y6553DxjlMi81kj666vOxdieQoFwnbzRsjPMO6mpBIwbTk3xxGK','0364154664','nguyenxuanloc@gmail.com','ROLE_USER','2000-10-13',0,'2025-01-13 22:08:53','2025-01-13 22:08:53'),(8,'thuy','Nguyen Thi Thu Thuy','v5a.jpeg','$2a$12$oraqzP6Xmeo3.0bGurvgG.nIC9jDWBvyKEMAZwtK4TsYMaSeAXw0S','0364154665','nguyenthithuthuy@gmail.com','ROLE_USER','2000-10-13',0,'2025-01-13 23:00:41','2025-01-13 23:00:41'),(9,'admin','Nguyễn Văn Hải','av6.jpeg','$2a$12$YmBygpVT0qPFiPxjZ1hOQu4henI/X1sV3DBB9pZINt/lpDbMc/wGK','0123456777','adminn@gmail.com','ROLE_ADMIN','2025-02-01',0,'2025-02-06 15:32:30','2025-02-06 15:32:30'),(10,'jack5cu','Trinh Tran Phuong Tuan','new3_de1690a0-c7aa-4cc6-8435-9195c9430396.jpeg','$2a$12$MCoImkOgx2yxLn8N884mOOoqJq9Ka3ibZoSGZB752mDAI.kz2.tEG','0999987651','tuanbocon@gmail.com','ROLE_ARTIST','2025-02-20',0,'2025-02-06 15:51:09','2025-02-06 15:51:09'),(11,'hainv123','nguyen van hai','default_avatar.png','$2a$12$A2scBmKAMHT.HjY/Zi8aY.tkFpOL/UXbC3G5FfDHSavzvUWDJG7u2','0123123451','hainv272@gmail.com','ROLE_USER','2025-02-06',0,'2025-02-06 16:01:01','2025-02-08 14:30:23');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
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
