-- MySQL dump 10.13  Distrib 8.0.23, for Win64 (x86_64)
--
-- Host: localhost    Database: db_teste
-- ------------------------------------------------------
-- Server version	8.0.23

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
-- Table structure for table `clientes`
--
CREATE DATABASE DB_TESTE;

USE DB_TESTE;

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `CODIGO` int NOT NULL AUTO_INCREMENT,
  `NOME` varchar(80) NOT NULL,
  `CIDADE` varchar(60) DEFAULT NULL,
  `UF` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`CODIGO`),
  UNIQUE KEY `CODIGO_UNIQUE` (`CODIGO`),
  UNIQUE KEY `NOME_UNIQUE` (`NOME`),
  KEY `IND_NOME` (`NOME`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'José','Americana','SP'),(2,'João','São Paulo','SP'),(3,'Pedro','Campinas','SP'),(4,'Marcelo','Porto Alegre','RS'),(5,'Paulo','Salvador','BA'),(6,'Carlos','Aracajú','SE'),(7,'Helena','Amparo','SP'),(8,'Alice','Belem','PA'),(9,'Maria','Bonfim','MG'),(10,'Isabela','Cavalcante','GO'),(11,'Luisa','Caxias','MA'),(12,'Julia','Cedro','CE'),(13,'Gabriel','Ermo','SC'),(14,'Samuel','Juara','MT'),(15,'Piedro','Jaú','SP'),(16,'Lucas','Jati','CE'),(17,'Joaquim','Ipê','RS'),(18,'Felipe','Graça','CE'),(19,'Joana','Franca','SP'),(20,'Marcos','Flores','PE');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-29  0:26:51
