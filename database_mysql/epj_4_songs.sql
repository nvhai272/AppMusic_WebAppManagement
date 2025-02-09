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
-- Table structure for table `songs`
--

DROP TABLE IF EXISTS `songs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `songs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `album_id` int DEFAULT NULL,
  `artist_id` int DEFAULT NULL,
  `audio_path` varchar(150) DEFAULT NULL,
  `listen_amount` int DEFAULT NULL,
  `feature_artist` varchar(150) DEFAULT NULL,
  `lyric_file_path` varchar(150) DEFAULT NULL,
  `is_pending` tinyint(1) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_songs_album` (`album_id`),
  KEY `idx_songs_artist` (`artist_id`),
  KEY `idx_songs_status` (`is_pending`,`is_deleted`),
  KEY `idx_songs_title` (`title`),
  CONSTRAINT `songs_ibfk_1` FOREIGN KEY (`album_id`) REFERENCES `albums` (`id`) ON DELETE CASCADE,
  CONSTRAINT `songs_ibfk_2` FOREIGN KEY (`artist_id`) REFERENCES `artists` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `songs`
--

LOCK TABLES `songs` WRITE;
/*!40000 ALTER TABLE `songs` DISABLE KEYS */;
INSERT INTO `songs` VALUES (1,'Don\'t Stay',1,1,'Dont Stay  Linkin Park Meteora_17e43101-8c05-4047-a291-e6148475d365.mp3',103,'','linkin park - don\'t stay.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(2,'Somewhere I Belong',1,1,'Linkin Park  Somewhere I Belong Audio_89d5ed25-9bf3-450c-9cb9-7d534a56f429.mp3',201,'','Somewhere I Belong.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(3,'Lying From You',3,1,'Lying From You  Linkin Park Meteora_98ab254f-23c3-40fa-94d9-4087f05e2374.mp3',2000,'','linkin park - lying from you.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(4,'Hit The Floor',3,1,'Hit The Floor  Linkin Park Meteora_a1ed9d6a-8f46-4386-b55f-79614428f049.mp3',100,'','Linkin Park - Hit The Floor.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(5,'Easier To Run',3,1,'Easier To Run  Linkin Park Meteora_592d4f14-411b-4fa4-ba51-7e447bd596b1.mp3',100,'','linkin park - easier to run.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(6,'Faint',1,1,'Linkin Park  Faint Audio_6f34cf84-3434-409e-b3d1-e67310eae33c.mp3',100,NULL,'Linkin Park - Faint.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(7,'Figure.09',1,1,'Figure09  Linkin Park Meteora_4c5bc15f-3705-4531-8199-93263e112b36.mp3',101,NULL,'Linkin Park - Figure09.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(8,'Breaking the Habit',1,1,'Linkin Park  Breaking the Habit Audio_19bfa2cb-99b6-4b6f-b926-3285436c8a0d.mp3',100,NULL,'linkin park - breaking the habit.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(9,'From The Inside',1,1,'Linkin Park  From the Inside Audio_0b602525-55d8-42d4-b757-9af58a16392c.mp3',100,NULL,'Linkin Park - From The Inside.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(10,'Nobody\'s Listening',2,1,'Nobodys Listening  Linkin Park Meteora_3214142e-0029-4986-bee7-aee6a685f443.mp3',100,NULL,'linkin park - nobody\'s listening.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(11,'In The End',2,1,'Linkin Park  In The End Audio.mp3',101,NULL,'Linkin Park - in the End.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(12,'Numb',2,1,'Numb Official Music Video 4K UPGRADE  Linkin Park_2c6f030a-15df-40a3-a2a4-106c3ab5e7c1.mp3',103,NULL,'linkin park - numb.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(13,'Hana No Uta',4,2,'Hana No Uta_727dd017-19d6-4741-8bb3-390481f8ddca.mp3',100,NULL,'Aimer - Hana no Uta.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(14,'I Beg You',4,2,'Aimer  I Beg You_c97948bb-726f-4a75-bc3c-dd0cb4343a2f.mp3',100,NULL,'Aimer - I beg you.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(15,'Haru wa Yuku',4,2,'HaruWaYuku-Aimer-6240149.mp3',100,NULL,'Aimer - haruhayuku.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(16,'Hana No Uta end of spring version',5,2,'Hana No Uta end of spring version_925b64bf-af34-44db-9d33-937c9298aeb8.mp3',100,NULL,'Aimer - Hana no Uta end of spring ver.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(17,'Haru wa Yuku late spring version',5,2,'haruhayuku the late spring Version_ae20365a-6763-4e90-b30b-b572583a4cbe.mp3',100,NULL,'Aimer - Haru wa Yuku the late spring ver.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(18,'Kill You',6,3,'Kill You_e564baad-02ab-401e-a68b-7755a4adf53f.mp3',100,NULL,'Eminem - Kill You.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(19,'Stan',6,3,'Stan_ac4cf49e-7ad1-4280-a6e4-00bdb46ab824.mp3',100,NULL,'eminem - stan.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(20,'Who Knew',6,3,'Who Knew.mp3',100,NULL,'Eminem - Who Knew.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(21,'The Way I Am',6,3,'The Way I Am.mp3',100,NULL,'eminem - the way i am.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(22,'The Real Slim Shady',6,3,'The Real Slim Shady.mp3',100,NULL,'EMINEM - The Real Slim Shady.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(23,'Remember Me',6,3,'Remember Me.mp3',100,'RBX & Sticky Fingaz','Eminem - Remember Me (feat. RBX & Sticky Fingaz).lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(24,'Im Back',6,3,'Im Back.mp3',100,NULL,'Eminem - Im Back.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(25,'Marshall Mathers',6,3,'Marshall Mathers.mp3',100,NULL,'EMINEM - Marshall Mathers.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(26,'Drug Ballad',6,3,'Drug Ballad.mp3',100,NULL,'Eminem - Drug Ballad.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(27,'Amityville',6,3,'Amityville.mp3',100,'Bizarre','EMINEM - Amityville.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(28,'Bitch Please II',6,3,'Bitch Please II.mp3',100,'Dr.Dre, Snoop Dogg, Xzibit, Nate Dogg','Eminem - Bitch Please II.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(29,'Kim',6,3,'Kim.mp3',100,NULL,'eminem - kim.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(30,'Under The Influence',6,3,'Under The Influence.mp3',100,NULL,'eminem - under the influence.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(31,'Criminal',6,3,'Criminal.mp3',100,NULL,'eminem - criminal.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(32,'Supernova',7,4,'Supernova.mp3',100,NULL,'aespa - Supernova.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(33,'Armageddon',7,4,'Armageddon.mp3',100,NULL,'aespa - Armageddon.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(34,'Set The Tone',7,4,'Set The Tone.mp3',100,NULL,'aespa - Set The Tone.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(35,'Mine',7,4,'Mine.mp3',100,NULL,'aespa - Mine.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(36,'Licorice',7,4,'Licorice.mp3',100,NULL,'aespa - Licorice.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(37,'BAHAMA',7,4,'BAHAMA.mp3',100,NULL,'aespa - BAHAMA.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(38,'Long Chat',7,4,'Long Chat .mp3',100,NULL,'aespa - Long Chat.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(39,'Prologue',7,4,'Prologue.mp3',100,NULL,'aespa - Prologue.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(40,'Live My Life',7,4,'Live My Life.mp3',100,NULL,'aespa - Live My Life.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11'),(41,'Melody',7,4,'Melody.mp3',100,NULL,'aespa - Melody.lrc',1,0,'2025-01-12 09:26:11','2025-01-12 09:26:11');
/*!40000 ALTER TABLE `songs` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-02-09 19:02:59
