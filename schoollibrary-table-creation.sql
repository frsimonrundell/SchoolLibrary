--
-- Table structure for table `tblbook`
--

DROP TABLE IF EXISTS `tblbook`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tblbook` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Title` varchar(255) DEFAULT NULL,
  `Author` varchar(255) DEFAULT NULL,
  `Category` varchar(255) DEFAULT NULL,
  `ISBN` varchar(255) DEFAULT NULL,
  `BabcockCode` bigint NOT NULL,
  `Owner` tinyint DEFAULT '0',
  `Media` varchar(255) DEFAULT NULL,
  `BookStatus` varchar(255) DEFAULT NULL,
  `ARQuiz` varchar(255) DEFAULT NULL,
  `OutTo` int DEFAULT NULL,
  `Blurb` longtext,
  `ReadingLevel` varchar(5) DEFAULT NULL,
  `DeweyRef` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1106083 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Table structure for table `tblborrow`
--

DROP TABLE IF EXISTS `tblborrow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tblborrow` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `User` int DEFAULT NULL,
  `Book` bigint DEFAULT NULL,
  `DateOut` date DEFAULT NULL,
  `DateIn` date DEFAULT NULL,
  `Status` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Table structure for table `tblconfig`
--

DROP TABLE IF EXISTS `tblconfig`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tblconfig` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Category` varchar(255) NOT NULL,
  `CategoryID` varchar(255) NOT NULL,
  `CategoryValue` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tblconfig`
--

LOCK TABLES `tblconfig` WRITE;
/*!40000 ALTER TABLE `tblconfig` DISABLE KEYS */;
INSERT INTO `tblconfig` VALUES (10,'YESNO','Y','Yes'),(11,'YESNO','N','No'),(12,'BOOKCATEGORY','Non-Fiction','Non-Fiction'),(13,'BOOKCATEGORY','Fiction','Fiction'),(14,'OWNER','0','School'),(15,'OWNER','1','Library Service'),(16,'BOOKSTATUS','0','In Library'),(17,'BOOKSTATUS','1','Borrowed'),(18,'BOOKSTATUS','2','Under Repair'),(19,'BOOKSTATUS','3','Mssing'),(20,'BOOKCATEGORY','Other','Other'),(21,'BOOKSTATUS','4','Guided Reading Shelf'),(22,'BOOKSTATUS','5','EYFS'),(23,'BOOKSTATUS','6','Year 1'),(24,'BOOKSTATUS','7','Year 2'),(25,'BOOKSTATUS','8','Year 3'),(26,'BOOKSTATUS','9','Year 4'),(27,'BOOKSTATUS','10','Year 5'),(28,'BOOKSTATUS','11','Year 6'),(29,'BOOKSTATUS','12','Staff'),(30,'BOOKSTATUS','13','Science Cupboard'),(31,'MEDIA','Hardback','Hardback'),(32,'MEDIA','Paperback','Paperback');
/*!40000 ALTER TABLE `tblconfig` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbluser`
--

DROP TABLE IF EXISTS `tbluser`;
CREATE TABLE `tbluser` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(255) NOT NULL,
  `Surname` varchar(255) NOT NULL,
  `Class` varchar(10) DEFAULT NULL,
  `Level` varchar(255) DEFAULT NULL,
  `Notes` longtext,
  `Staff` tinyint(1) DEFAULT NULL,
  `BarcodeURL` mediumtext,
  `BarcodeBlob` longblob,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1142 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
