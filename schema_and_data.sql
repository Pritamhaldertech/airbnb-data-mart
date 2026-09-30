-- Airbnb-style booking platform: schema and sample data (MySQL 8)
-- Author: Pritam Halder · IU project "Build a Data Mart in SQL"
-- Import: mysql -u root -p < schema_and_data.sql

CREATE DATABASE IF NOT EXISTS airbnbdb CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE airbnbdb;

SET NAMES utf8mb4;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;

--
-- Table structure for table `Admin`
--

DROP TABLE IF EXISTS `Admin`;
CREATE TABLE `Admin` (
  `admin_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `role_level` enum('Support','Finance','SuperAdmin') NOT NULL,
  `department` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`admin_id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `admin_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Admin`
--

INSERT INTO `Admin` VALUES (1,24,'SuperAdmin','Management'),(2,1,'Support','Customer Support'),(3,3,'Finance','Accounting'),(4,5,'Support','Dispute Resolution'),(5,7,'Finance','Payments'),(6,9,'SuperAdmin','Compliance'),(7,11,'Support','Technical Support');

--
-- Table structure for table `Amenity`
--

DROP TABLE IF EXISTS `Amenity`;
CREATE TABLE `Amenity` (
  `amenity_id` int NOT NULL AUTO_INCREMENT,
  `amenity_name` varchar(100) NOT NULL,
  PRIMARY KEY (`amenity_id`),
  UNIQUE KEY `amenity_name` (`amenity_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Amenity`
--

INSERT INTO `Amenity` VALUES (4,'Air Conditioning'),(14,'Balcony'),(17,'Beachfront'),(12,'Breakfast'),(19,'City View'),(16,'Dryer'),(10,'Elevator'),(20,'Fireplace'),(9,'Gym'),(5,'Heating'),(13,'Hot Tub'),(2,'Kitchen'),(18,'Mountain View'),(7,'Parking'),(11,'Pet Friendly'),(8,'Pool'),(6,'TV'),(3,'Washer'),(1,'WiFi'),(15,'Workspace');

--
-- Table structure for table `AvailabilityCalendar`
--

DROP TABLE IF EXISTS `AvailabilityCalendar`;
CREATE TABLE `AvailabilityCalendar` (
  `availability_id` int NOT NULL AUTO_INCREMENT,
  `property_id` int NOT NULL,
  `date` date NOT NULL,
  `is_available` tinyint(1) DEFAULT '1',
  `price_modifier` decimal(10,2) DEFAULT '0.00',
  PRIMARY KEY (`availability_id`),
  UNIQUE KEY `property_id` (`property_id`,`date`),
  CONSTRAINT `availabilitycalendar_ibfk_1` FOREIGN KEY (`property_id`) REFERENCES `Property` (`property_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `AvailabilityCalendar`
--

INSERT INTO `AvailabilityCalendar` VALUES (1,1,'2026-05-01',1,0.00),(2,1,'2026-05-02',1,0.00),(3,1,'2026-05-03',1,0.00),(4,1,'2026-05-04',0,0.00),(5,2,'2026-05-01',1,20.00),(6,2,'2026-05-02',1,20.00),(7,3,'2026-05-01',1,0.00),(8,3,'2026-05-02',1,0.00),(9,4,'2026-05-01',1,30.00),(10,4,'2026-05-02',1,30.00),(11,5,'2026-05-01',1,0.00),(12,5,'2026-05-02',1,0.00),(13,6,'2026-05-01',1,0.00),(14,6,'2026-05-02',0,0.00),(15,7,'2026-05-01',1,0.00),(16,7,'2026-05-02',1,0.00),(17,8,'2026-05-01',1,15.00),(18,8,'2026-05-02',1,15.00),(19,9,'2026-05-01',1,50.00),(20,9,'2026-05-02',1,50.00),(21,10,'2026-05-01',1,0.00),(22,10,'2026-05-02',1,0.00),(23,11,'2026-05-01',1,0.00),(24,12,'2026-05-01',1,10.00),(25,13,'2026-05-01',1,0.00),(26,14,'2026-05-01',1,25.00),(27,15,'2026-05-01',1,0.00),(28,16,'2026-05-01',1,0.00),(29,17,'2026-05-01',1,0.00),(30,18,'2026-05-01',1,0.00),(31,19,'2026-05-01',1,0.00),(32,20,'2026-05-01',1,0.00);

--
-- Table structure for table `Booking`
--

DROP TABLE IF EXISTS `Booking`;
CREATE TABLE `Booking` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `guest_id` int NOT NULL,
  `host_id` int NOT NULL,
  `property_id` int NOT NULL,
  `check_in_date` date NOT NULL,
  `check_out_date` date NOT NULL,
  `guest_count` int NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `booking_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` enum('pending','confirmed','cancelled','completed') DEFAULT 'pending',
  PRIMARY KEY (`booking_id`),
  KEY `guest_id` (`guest_id`),
  KEY `host_id` (`host_id`),
  KEY `property_id` (`property_id`),
  CONSTRAINT `booking_ibfk_1` FOREIGN KEY (`guest_id`) REFERENCES `Guest` (`guest_id`),
  CONSTRAINT `booking_ibfk_2` FOREIGN KEY (`host_id`) REFERENCES `Host` (`host_id`),
  CONSTRAINT `booking_ibfk_3` FOREIGN KEY (`property_id`) REFERENCES `Property` (`property_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Booking`
--

INSERT INTO `Booking` VALUES (1,1,1,1,'2026-05-01','2026-05-05',2,340.00,'2026-04-27 18:35:14','confirmed'),(2,2,2,3,'2026-05-10','2026-05-15',1,475.00,'2026-04-27 18:35:14','confirmed'),(3,3,3,5,'2026-06-01','2026-06-07',4,450.00,'2026-04-27 18:35:14','pending'),(4,4,4,6,'2026-05-20','2026-05-25',2,600.00,'2026-04-27 18:35:14','confirmed'),(5,5,5,7,'2026-07-01','2026-07-08',4,770.00,'2026-04-27 18:35:14','pending'),(6,6,6,8,'2026-05-15','2026-05-20',2,1000.00,'2026-04-27 18:35:14','confirmed'),(7,7,7,9,'2026-08-01','2026-08-10',6,5000.00,'2026-04-27 18:35:14','confirmed'),(8,8,8,10,'2026-06-10','2026-06-15',3,750.00,'2026-04-27 18:35:14','cancelled'),(9,9,9,11,'2026-05-25','2026-05-30',2,900.00,'2026-04-27 18:35:14','confirmed'),(10,10,10,12,'2026-07-15','2026-07-20',2,650.00,'2026-04-27 18:35:14','pending'),(11,1,2,2,'2026-09-01','2026-09-07',4,1500.00,'2026-04-27 18:35:14','confirmed'),(12,2,4,4,'2026-10-01','2026-10-08',6,2450.00,'2026-04-27 18:35:14','confirmed'),(13,3,6,13,'2026-11-01','2026-11-06',3,700.00,'2026-04-27 18:35:14','pending'),(14,4,8,14,'2026-05-05','2026-05-10',4,1100.00,'2026-04-27 18:35:14','confirmed'),(15,5,10,15,'2026-06-20','2026-06-25',2,1400.00,'2026-04-27 18:35:14','confirmed'),(16,6,12,16,'2026-07-10','2026-07-17',5,1540.00,'2026-04-27 18:35:14','confirmed'),(17,7,14,17,'2026-08-15','2026-08-20',2,675.00,'2026-04-27 18:35:14','pending'),(18,8,16,18,'2026-09-10','2026-09-15',4,625.00,'2026-04-27 18:35:14','confirmed'),(19,9,18,19,'2026-10-15','2026-10-20',3,775.00,'2026-04-27 18:35:14','confirmed'),(20,10,20,20,'2026-11-10','2026-11-15',4,825.00,'2026-04-27 18:35:14','pending'),(21,11,1,21,'2026-12-01','2026-12-05',2,380.00,'2026-04-27 18:35:14','confirmed'),(22,12,3,22,'2026-12-10','2026-12-15',2,550.00,'2026-04-27 18:35:14','confirmed');

--
-- Table structure for table `CancellationPolicy`
--

DROP TABLE IF EXISTS `CancellationPolicy`;
CREATE TABLE `CancellationPolicy` (
  `policy_id` int NOT NULL AUTO_INCREMENT,
  `policy_name` varchar(50) NOT NULL,
  `refund_percentage` int NOT NULL,
  `deadline_hours` int NOT NULL,
  PRIMARY KEY (`policy_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `CancellationPolicy`
--

INSERT INTO `CancellationPolicy` VALUES (1,'Flexible',100,24),(2,'Moderate',100,120),(3,'Strict',50,168),(4,'Super Strict',0,720),(5,'Non-Refundable',0,0),(6,'Partial Refund',50,1),(7,'Long Term',100,336),(8,'Last Minute',90,6);

--
-- Table structure for table `City`
--

DROP TABLE IF EXISTS `City`;
CREATE TABLE `City` (
  `city_id` int NOT NULL AUTO_INCREMENT,
  `city_name` varchar(100) NOT NULL,
  `country_id` int NOT NULL,
  PRIMARY KEY (`city_id`),
  KEY `country_id` (`country_id`),
  CONSTRAINT `city_ibfk_1` FOREIGN KEY (`country_id`) REFERENCES `Country` (`country_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `City`
--

INSERT INTO `City` VALUES (1,'Berlin',1),(2,'Munich',1),(3,'Hamburg',1),(4,'Frankfurt',1),(5,'Cologne',1),(6,'New York',2),(7,'Los Angeles',2),(8,'Chicago',2),(9,'London',3),(10,'Paris',4),(11,'Barcelona',5),(12,'Madrid',5),(13,'Rome',6),(14,'Amsterdam',7),(15,'Zurich',8),(16,'Vienna',9),(17,'Brussels',10),(18,'Copenhagen',11),(19,'Stockholm',12),(20,'Oslo',13);

--
-- Table structure for table `Commission`
--

DROP TABLE IF EXISTS `Commission`;
CREATE TABLE `Commission` (
  `commission_id` int NOT NULL AUTO_INCREMENT,
  `user_type` enum('host','guest') NOT NULL,
  `percentage` decimal(5,2) NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`commission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Commission`
--

INSERT INTO `Commission` VALUES (1,'host',3.00,1),(2,'guest',9.00,1),(3,'host',2.50,0),(4,'guest',8.00,0),(5,'host',5.00,0),(6,'guest',12.00,0);

--
-- Table structure for table `Country`
--

DROP TABLE IF EXISTS `Country`;
CREATE TABLE `Country` (
  `country_id` int NOT NULL AUTO_INCREMENT,
  `country_name` varchar(100) NOT NULL,
  `country_code` varchar(3) NOT NULL,
  PRIMARY KEY (`country_id`),
  UNIQUE KEY `country_name` (`country_name`),
  UNIQUE KEY `country_code` (`country_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Country`
--

INSERT INTO `Country` VALUES (1,'Germany','DE'),(2,'United States','US'),(3,'United Kingdom','GB'),(4,'France','FR'),(5,'Spain','ES'),(6,'Italy','IT'),(7,'Netherlands','NL'),(8,'Switzerland','CH'),(9,'Austria','AT'),(10,'Belgium','BE'),(11,'Denmark','DK'),(12,'Sweden','SE'),(13,'Norway','NO'),(14,'Portugal','PT'),(15,'Greece','GR'),(16,'Turkey','TR'),(17,'Poland','PL'),(18,'Czech Republic','CZ'),(19,'Hungary','HU'),(20,'Ireland','IE');

--
-- Table structure for table `Guest`
--

DROP TABLE IF EXISTS `Guest`;
CREATE TABLE `Guest` (
  `guest_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `total_bookings` int DEFAULT '0',
  `total_spent` decimal(10,2) DEFAULT '0.00',
  `member_level` enum('Basic','Silver','Gold','Platinum') DEFAULT 'Basic',
  PRIMARY KEY (`guest_id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `guest_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Guest`
--

INSERT INTO `Guest` VALUES (1,2,12,2450.00,'Gold'),(2,4,8,1875.00,'Silver'),(3,6,15,4200.00,'Platinum'),(4,8,3,550.00,'Basic'),(5,10,9,2100.00,'Silver'),(6,12,20,6800.00,'Platinum'),(7,14,5,1200.00,'Silver'),(8,16,11,3100.00,'Gold'),(9,18,4,890.00,'Basic'),(10,20,14,3950.00,'Gold'),(11,22,7,1650.00,'Silver'),(12,24,10,2300.00,'Gold'),(13,1,3,650.00,'Basic'),(14,3,7,1600.00,'Silver'),(15,5,9,2100.00,'Gold'),(16,7,12,2900.00,'Platinum'),(17,9,4,880.00,'Basic'),(18,11,8,1750.00,'Silver'),(19,13,10,2400.00,'Gold'),(20,15,6,1350.00,'Silver');

--
-- Table structure for table `Host`
--

DROP TABLE IF EXISTS `Host`;
CREATE TABLE `Host` (
  `host_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `total_earnings` decimal(10,2) DEFAULT '0.00',
  `response_rate` decimal(5,2) DEFAULT '0.00',
  `superhost_status` tinyint(1) DEFAULT '0',
  `listings_count` int DEFAULT '0',
  `join_date` date DEFAULT NULL,
  PRIMARY KEY (`host_id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `host_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Host`
--

INSERT INTO `Host` VALUES (1,1,15250.00,98.50,1,3,'2018-03-15'),(2,3,8750.00,95.00,1,2,'2019-06-20'),(3,5,3200.00,88.00,0,1,'2020-01-10'),(4,7,12400.00,99.00,1,4,'2017-11-05'),(5,9,5600.00,92.00,0,2,'2019-09-15'),(6,11,18900.00,100.00,1,5,'2016-04-22'),(7,13,4300.00,85.00,0,1,'2021-02-18'),(8,15,9800.00,97.00,1,3,'2018-08-30'),(9,17,11200.00,96.00,1,3,'2017-12-01'),(10,19,6700.00,90.00,0,2,'2019-04-12'),(11,21,14500.00,99.50,1,4,'2016-09-25'),(12,23,5100.00,89.00,0,1,'2020-07-14'),(13,2,5000.00,95.00,0,1,'2020-05-10'),(14,4,7500.00,97.00,1,2,'2019-08-20'),(15,6,3000.00,88.00,0,1,'2021-03-15'),(16,8,12000.00,99.00,1,3,'2017-11-01'),(17,10,8500.00,94.00,1,2,'2018-06-10'),(18,12,11000.00,98.00,1,3,'2017-04-12'),(19,14,6500.00,92.00,0,2,'2019-12-05'),(20,16,13500.00,99.50,1,4,'2016-08-18'),(21,18,5000.00,90.00,0,1,'2020-06-01'),(22,20,8000.00,95.00,1,2,'2019-05-15');

--
-- Table structure for table `Invoice`
--

DROP TABLE IF EXISTS `Invoice`;
CREATE TABLE `Invoice` (
  `invoice_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `booking_id` int NOT NULL,
  `invoice_number` varchar(50) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `invoice_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`invoice_id`),
  UNIQUE KEY `invoice_number` (`invoice_number`),
  KEY `user_id` (`user_id`),
  KEY `booking_id` (`booking_id`),
  CONSTRAINT `invoice_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`),
  CONSTRAINT `invoice_ibfk_2` FOREIGN KEY (`booking_id`) REFERENCES `Booking` (`booking_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Invoice`
--

INSERT INTO `Invoice` VALUES (1,2,1,'INV-1001',374.00,'2026-04-27 18:35:14'),(2,5,2,'INV-1002',522.50,'2026-04-27 18:35:14'),(3,7,3,'INV-1003',495.00,'2026-04-27 18:35:14'),(4,9,4,'INV-1004',660.00,'2026-04-27 18:35:14'),(5,11,5,'INV-1005',847.00,'2026-04-27 18:35:14'),(6,13,6,'INV-1006',1100.00,'2026-04-27 18:35:14'),(7,15,7,'INV-1007',5500.00,'2026-04-27 18:35:14'),(8,17,8,'INV-1008',825.00,'2026-04-27 18:35:14'),(9,19,9,'INV-1009',990.00,'2026-04-27 18:35:14'),(10,21,10,'INV-1010',715.00,'2026-04-27 18:35:14'),(11,2,11,'INV-1011',1650.00,'2026-04-27 18:35:14'),(12,5,12,'INV-1012',2695.00,'2026-04-27 18:35:14'),(13,7,13,'INV-1013',770.00,'2026-04-27 18:35:14'),(14,9,14,'INV-1014',1210.00,'2026-04-27 18:35:14'),(15,11,15,'INV-1015',1540.00,'2026-04-27 18:35:14'),(16,13,16,'INV-1016',1694.00,'2026-04-27 18:35:14'),(17,15,17,'INV-1017',742.50,'2026-04-27 18:35:14'),(18,17,18,'INV-1018',687.50,'2026-04-27 18:35:14'),(19,19,19,'INV-1019',852.50,'2026-04-27 18:35:14'),(20,21,20,'INV-1020',907.50,'2026-04-27 18:35:14'),(21,1,21,'INV-1021',418.00,'2026-04-27 18:35:14'),(22,3,22,'INV-1022',605.00,'2026-04-27 18:35:14');

--
-- Table structure for table `Location`
--

DROP TABLE IF EXISTS `Location`;
CREATE TABLE `Location` (
  `location_id` int NOT NULL AUTO_INCREMENT,
  `address_line1` varchar(255) NOT NULL,
  `address_line2` varchar(255) DEFAULT NULL,
  `city_id` int NOT NULL,
  `postal_code` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`location_id`),
  KEY `city_id` (`city_id`),
  CONSTRAINT `location_ibfk_1` FOREIGN KEY (`city_id`) REFERENCES `City` (`city_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Location`
--

INSERT INTO `Location` VALUES (1,'Alexanderplatz 1',NULL,1,'10178'),(2,'Marienplatz 8',NULL,2,'80331'),(3,'Reeperbahn 25',NULL,3,'20359'),(4,'Zeil 75',NULL,4,'60313'),(5,'Domkloster 3',NULL,5,'50667'),(6,'Broadway 1500',NULL,6,'10036'),(7,'Hollywood Blvd 7000',NULL,7,'90028'),(8,'Michigan Ave 875',NULL,8,'60611'),(9,'Oxford Street 200',NULL,9,'W1D 1LL'),(10,'Champs-Élysées 15',NULL,10,'75008'),(11,'La Rambla 115',NULL,11,'08002'),(12,'Gran Via 45',NULL,12,'28013'),(13,'Via del Corso 12',NULL,13,'00186'),(14,'Damrak 25',NULL,14,'1012 LH'),(15,'Bahnhofstrasse 10',NULL,15,'8001'),(16,'Kärntner Strasse 18',NULL,16,'1010'),(17,'Rue Neuve 22',NULL,17,'1000'),(18,'Strøget 1',NULL,18,'1457'),(19,'Drottninggatan 55',NULL,19,'11121'),(20,'Karl Johans gate 30',NULL,20,'0159');

--
-- Table structure for table `Message`
--

DROP TABLE IF EXISTS `Message`;
CREATE TABLE `Message` (
  `message_id` int NOT NULL AUTO_INCREMENT,
  `sender_id` int NOT NULL,
  `recipient_id` int NOT NULL,
  `property_id` int DEFAULT NULL,
  `parent_message_id` int DEFAULT NULL,
  `content` text NOT NULL,
  `sent_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `is_read` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`message_id`),
  KEY `sender_id` (`sender_id`),
  KEY `recipient_id` (`recipient_id`),
  KEY `property_id` (`property_id`),
  KEY `parent_message_id` (`parent_message_id`),
  CONSTRAINT `message_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `User` (`user_id`),
  CONSTRAINT `message_ibfk_2` FOREIGN KEY (`recipient_id`) REFERENCES `User` (`user_id`),
  CONSTRAINT `message_ibfk_3` FOREIGN KEY (`property_id`) REFERENCES `Property` (`property_id`),
  CONSTRAINT `message_ibfk_4` FOREIGN KEY (`parent_message_id`) REFERENCES `Message` (`message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Message`
--

INSERT INTO `Message` VALUES (1,2,1,1,NULL,'Is the apartment available for May 1-5?','2026-04-27 18:35:14',0),(2,1,2,1,1,'Yes, it is available!','2026-04-27 18:35:14',0),(3,5,4,3,NULL,'Is parking included?','2026-04-27 18:35:14',0),(4,4,5,3,3,'Yes, free parking on site','2026-04-27 18:35:14',0),(5,7,6,5,NULL,'Are dogs allowed?','2026-04-27 18:35:14',0),(6,6,7,5,5,'Yes, small dogs are welcome','2026-04-27 18:35:14',0),(7,9,8,6,NULL,'Can I check in at 10am?','2026-04-27 18:35:14',0),(8,8,9,6,7,'Sorry, check-in is at 2pm','2026-04-27 18:35:14',0),(9,11,10,7,NULL,'Any discount for 7+ days?','2026-04-27 18:35:14',0),(10,10,11,7,9,'Yes, 10% off for weekly stays','2026-04-27 18:35:14',0),(11,13,12,8,NULL,'Do you offer airport pickup?','2026-04-27 18:35:14',0),(12,12,13,8,11,'Yes, for an extra fee','2026-04-27 18:35:14',0),(13,15,14,9,NULL,'Planning a surprise party','2026-04-27 18:35:14',0),(14,14,15,9,13,'We can help arrange decorations','2026-04-27 18:35:14',0),(15,17,16,10,NULL,'Can we checkout at 1pm?','2026-04-27 18:35:14',0),(16,16,17,10,15,'Yes, approved','2026-04-27 18:35:14',0),(17,19,18,11,NULL,'Need an extra bed for child','2026-04-27 18:35:14',0),(18,18,19,11,17,'We can provide a rollaway bed','2026-04-27 18:35:14',0),(19,21,20,12,NULL,'Any vegan breakfast options?','2026-04-27 18:35:14',0),(20,20,21,12,19,'Yes, we have vegan options','2026-04-27 18:35:14',0);

--
-- Table structure for table `Notification`
--

DROP TABLE IF EXISTS `Notification`;
CREATE TABLE `Notification` (
  `notification_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `type` varchar(50) NOT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `created_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`notification_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `notification_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Notification`
--

INSERT INTO `Notification` VALUES (1,2,'booking','Your booking for May 1-5 is confirmed',1,'2026-04-27 18:35:14'),(2,1,'booking','You have a new booking from Jane Smith',0,'2026-04-27 18:35:14'),(3,5,'payment','Your payment of €475 has been received',1,'2026-04-27 18:35:14'),(4,4,'payment','Your payout of €427.50 is scheduled',0,'2026-04-27 18:35:14'),(5,7,'review','You received a 5-star review',0,'2026-04-27 18:35:14'),(6,6,'review','Guest left a review for your property',1,'2026-04-27 18:35:14'),(7,9,'booking','Booking #8 has been cancelled',1,'2026-04-27 18:35:14'),(8,8,'booking','Guest cancelled booking #8',0,'2026-04-27 18:35:14'),(9,11,'payment','Payment for booking #5 failed',0,'2026-04-27 18:35:14'),(10,10,'payment','Please update payment method',1,'2026-04-27 18:35:14'),(11,13,'message','You have a new message',0,'2026-04-27 18:35:14'),(12,12,'message','Guest sent a message about parking',1,'2026-04-27 18:35:14'),(13,15,'booking','Your stay begins in 3 days',0,'2026-04-27 18:35:14'),(14,14,'booking','Guest arriving in 3 days',1,'2026-04-27 18:35:14'),(15,17,'review','Please review your recent stay',0,'2026-04-27 18:35:14'),(16,16,'payment','Your payout has been processed',0,'2026-04-27 18:35:14'),(17,18,'review','Guest left a new review',1,'2026-04-27 18:35:14'),(18,20,'booking','New booking received',0,'2026-04-27 18:35:14'),(19,22,'message','You have an unread message',1,'2026-04-27 18:35:14'),(20,24,'promotion','Special offer for you',0,'2026-04-27 18:35:14');

--
-- Table structure for table `Payment`
--

DROP TABLE IF EXISTS `Payment`;
CREATE TABLE `Payment` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_method` enum('Credit Card','Debit Card','PayPal') NOT NULL,
  `status` enum('pending','completed','failed') DEFAULT 'pending',
  `payment_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_id`),
  KEY `booking_id` (`booking_id`),
  CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `Booking` (`booking_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Payment`
--

INSERT INTO `Payment` VALUES (1,1,340.00,'Credit Card','completed','2026-04-27 18:35:14'),(2,2,475.00,'PayPal','completed','2026-04-27 18:35:14'),(3,3,450.00,'Credit Card','pending','2026-04-27 18:35:14'),(4,4,600.00,'Debit Card','completed','2026-04-27 18:35:14'),(5,5,770.00,'Credit Card','pending','2026-04-27 18:35:14'),(6,6,1000.00,'PayPal','completed','2026-04-27 18:35:14'),(7,7,5000.00,'Credit Card','completed','2026-04-27 18:35:14'),(8,8,750.00,'PayPal','failed','2026-04-27 18:35:14'),(9,9,900.00,'Credit Card','completed','2026-04-27 18:35:14'),(10,10,650.00,'Debit Card','pending','2026-04-27 18:35:14'),(11,11,1500.00,'Credit Card','completed','2026-04-27 18:35:14'),(12,12,2450.00,'PayPal','completed','2026-04-27 18:35:14'),(13,13,700.00,'Credit Card','pending','2026-04-27 18:35:14'),(14,14,1100.00,'PayPal','completed','2026-04-27 18:35:14'),(15,15,1400.00,'Credit Card','completed','2026-04-27 18:35:14'),(16,16,1540.00,'Credit Card','completed','2026-04-27 18:35:14'),(17,17,675.00,'PayPal','pending','2026-04-27 18:35:14'),(18,18,625.00,'Credit Card','completed','2026-04-27 18:35:14'),(19,19,775.00,'Credit Card','completed','2026-04-27 18:35:14'),(20,20,825.00,'Debit Card','pending','2026-04-27 18:35:14'),(21,21,380.00,'Credit Card','completed','2026-04-27 18:35:14'),(22,22,550.00,'PayPal','completed','2026-04-27 18:35:14');

--
-- Table structure for table `Payout`
--

DROP TABLE IF EXISTS `Payout`;
CREATE TABLE `Payout` (
  `payout_id` int NOT NULL AUTO_INCREMENT,
  `host_id` int NOT NULL,
  `booking_id` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `scheduled_date` date NOT NULL,
  `status` enum('pending','completed','failed') DEFAULT 'pending',
  PRIMARY KEY (`payout_id`),
  KEY `host_id` (`host_id`),
  KEY `booking_id` (`booking_id`),
  CONSTRAINT `payout_ibfk_1` FOREIGN KEY (`host_id`) REFERENCES `Host` (`host_id`),
  CONSTRAINT `payout_ibfk_2` FOREIGN KEY (`booking_id`) REFERENCES `Booking` (`booking_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Payout`
--

INSERT INTO `Payout` VALUES (1,1,1,306.00,'2026-05-10','completed'),(2,2,2,427.50,'2026-05-20','completed'),(3,3,3,405.00,'2026-06-10','pending'),(4,4,4,540.00,'2026-05-30','completed'),(5,5,5,693.00,'2026-07-15','pending'),(6,6,6,900.00,'2026-05-25','completed'),(7,7,7,4500.00,'2026-08-20','pending'),(8,8,8,675.00,'2026-06-20','failed'),(9,9,9,810.00,'2026-06-05','completed'),(10,10,10,585.00,'2026-07-25','pending'),(11,1,11,1350.00,'2026-09-15','completed'),(12,2,12,2205.00,'2026-10-15','completed'),(13,3,13,630.00,'2026-11-10','pending'),(14,4,14,990.00,'2026-05-15','completed'),(15,5,15,1260.00,'2026-06-30','completed'),(16,6,16,1386.00,'2026-07-20','completed'),(17,7,17,607.50,'2026-08-25','pending'),(18,8,18,562.50,'2026-09-20','completed'),(19,9,19,697.50,'2026-10-25','completed'),(20,10,20,742.50,'2026-11-20','pending'),(21,11,21,342.00,'2026-12-10','completed'),(22,12,22,495.00,'2026-12-20','completed');

--
-- Table structure for table `Property`
--

DROP TABLE IF EXISTS `Property`;
CREATE TABLE `Property` (
  `property_id` int NOT NULL AUTO_INCREMENT,
  `host_id` int NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` text,
  `property_type` enum('Apartment','House','Villa','Studio','Room') NOT NULL,
  `location_id` int NOT NULL,
  `price_per_night` decimal(10,2) NOT NULL,
  `max_guests` int NOT NULL,
  `bedrooms` int DEFAULT NULL,
  `beds` int DEFAULT NULL,
  `bathrooms` decimal(3,1) DEFAULT NULL,
  `policy_id` int DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`property_id`),
  KEY `host_id` (`host_id`),
  KEY `location_id` (`location_id`),
  KEY `policy_id` (`policy_id`),
  CONSTRAINT `property_ibfk_1` FOREIGN KEY (`host_id`) REFERENCES `Host` (`host_id`),
  CONSTRAINT `property_ibfk_2` FOREIGN KEY (`location_id`) REFERENCES `Location` (`location_id`),
  CONSTRAINT `property_ibfk_3` FOREIGN KEY (`policy_id`) REFERENCES `CancellationPolicy` (`policy_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Property`
--

INSERT INTO `Property` VALUES (1,1,'Cozy Berlin Apartment','Beautiful apartment','Apartment',1,85.00,4,2,2,1.5,1,1),(2,1,'Luxury Penthouse','Stunning views','Apartment',1,250.00,6,3,3,2.0,3,1),(3,2,'Munich Studio','Perfect for business','Studio',2,95.00,2,1,1,1.0,1,1),(4,2,'Modern Villa','Luxury villa','Villa',2,350.00,8,4,5,3.5,3,1),(5,3,'Hamburg Harbour View','Harbour views','Apartment',3,75.00,4,2,2,1.0,2,1),(6,4,'Frankfurt Financial','Close to banks','Apartment',4,120.00,2,1,1,1.0,1,1),(7,5,'Cologne Cathedral Suite','Steps from cathedral','Apartment',5,110.00,4,2,2,1.5,1,1),(8,6,'Times Square Hideaway','Central NYC','Apartment',6,200.00,4,2,2,1.0,3,1),(9,7,'Hollywood Hills Mansion','Celebrity style','House',7,500.00,12,5,6,4.0,4,1),(10,8,'Chicago Downtown Loft','Industrial loft','Apartment',8,150.00,6,2,3,2.0,2,1),(11,9,'London Classic Flat','Traditional flat','Apartment',9,180.00,4,2,2,1.5,2,1),(12,10,'Paris Charming Studio','Eiffel view','Studio',10,130.00,2,1,1,1.0,1,1),(13,11,'Barcelona Beach','Steps from beach','Apartment',11,140.00,6,3,3,2.0,2,1),(14,12,'Madrid Royal Suite','Luxury suite','Apartment',12,160.00,4,2,2,1.5,3,1),(15,13,'Rome Historic Center','Ancient Rome','Apartment',13,125.00,4,2,2,1.0,1,1),(16,14,'Amsterdam Canal House','17th century','House',14,220.00,6,3,3,2.5,2,1),(17,15,'Zurich Luxury','High-end','Apartment',15,280.00,4,2,2,1.5,3,1),(18,16,'Vienna Opera View','Culture lover','Apartment',16,145.00,4,2,2,1.0,2,1),(19,17,'Brussels Art Nouveau','Architectural gem','House',17,135.00,6,3,3,2.0,1,1),(20,18,'Copenhagen Hygge','Warm atmosphere','Apartment',18,125.00,4,2,2,1.0,1,1),(21,19,'Stockholm Archipelago','Water views','Apartment',19,155.00,4,2,2,1.5,2,1),(22,20,'Oslo Modern Suite','Norwegian design','Apartment',20,165.00,4,2,2,1.0,1,1),(23,1,'Lisbon Sunny Retreat','Sunshine','Apartment',1,95.00,4,2,2,1.0,1,1),(24,2,'Athens Acropolis View','Ancient history','Apartment',2,110.00,4,2,2,1.0,2,1);

--
-- Table structure for table `PropertyAmenity`
--

DROP TABLE IF EXISTS `PropertyAmenity`;
CREATE TABLE `PropertyAmenity` (
  `property_id` int NOT NULL,
  `amenity_id` int NOT NULL,
  PRIMARY KEY (`property_id`,`amenity_id`),
  KEY `amenity_id` (`amenity_id`),
  CONSTRAINT `propertyamenity_ibfk_1` FOREIGN KEY (`property_id`) REFERENCES `Property` (`property_id`) ON DELETE CASCADE,
  CONSTRAINT `propertyamenity_ibfk_2` FOREIGN KEY (`amenity_id`) REFERENCES `Amenity` (`amenity_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `PropertyAmenity`
--

INSERT INTO `PropertyAmenity` VALUES (1,1),(2,1),(3,1),(4,1),(5,1),(6,1),(7,1),(8,1),(9,1),(10,1),(11,1),(12,1),(13,1),(14,1),(15,1),(16,1),(17,1),(18,1),(19,1),(20,1),(21,1),(1,2),(3,2),(5,2),(7,2),(10,2),(11,2),(14,2),(16,2),(19,2),(21,2),(1,3),(2,4),(4,4),(7,4),(8,4),(12,4),(1,5),(2,5),(3,5),(4,5),(5,5),(6,5),(7,5),(8,5),(9,5),(10,5),(13,5),(15,5),(17,5),(18,5),(20,5),(2,6),(4,6),(6,6),(7,6),(9,6),(4,7),(9,7),(9,8);

--
-- Table structure for table `PropertyPhoto`
--

DROP TABLE IF EXISTS `PropertyPhoto`;
CREATE TABLE `PropertyPhoto` (
  `photo_id` int NOT NULL AUTO_INCREMENT,
  `property_id` int NOT NULL,
  `photo_url` varchar(500) NOT NULL,
  `is_primary` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`photo_id`),
  KEY `property_id` (`property_id`),
  CONSTRAINT `propertyphoto_ibfk_1` FOREIGN KEY (`property_id`) REFERENCES `Property` (`property_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `PropertyPhoto`
--

INSERT INTO `PropertyPhoto` VALUES (1,1,'https://example.com/berlin1.jpg',1),(2,1,'https://example.com/berlin2.jpg',0),(3,2,'https://example.com/penthouse1.jpg',1),(4,3,'https://example.com/munich1.jpg',1),(5,4,'https://example.com/villa1.jpg',1),(6,5,'https://example.com/hamburg1.jpg',1),(7,6,'https://example.com/frankfurt1.jpg',1),(8,7,'https://example.com/cologne1.jpg',1),(9,8,'https://example.com/nyc1.jpg',1),(10,9,'https://example.com/hollywood1.jpg',1),(11,10,'https://example.com/chicago1.jpg',1),(12,11,'https://example.com/london1.jpg',1),(13,12,'https://example.com/paris1.jpg',1),(14,13,'https://example.com/barcelona1.jpg',1),(15,14,'https://example.com/madrid1.jpg',1),(16,15,'https://example.com/rome1.jpg',1),(17,16,'https://example.com/amsterdam1.jpg',1),(18,17,'https://example.com/zurich1.jpg',1),(19,18,'https://example.com/vienna1.jpg',1),(20,19,'https://example.com/brussels1.jpg',1),(21,20,'https://example.com/copenhagen1.jpg',1),(22,21,'https://example.com/stockholm1.jpg',1),(23,22,'https://example.com/oslo1.jpg',1),(24,23,'https://example.com/lisbon1.jpg',1),(25,24,'https://example.com/athens1.jpg',1);

--
-- Table structure for table `Review`
--

DROP TABLE IF EXISTS `Review`;
CREATE TABLE `Review` (
  `review_id` int NOT NULL AUTO_INCREMENT,
  `reviewer_id` int NOT NULL,
  `reviewee_id` int NOT NULL,
  `booking_id` int NOT NULL,
  `rating` decimal(2,1) NOT NULL,
  `comment` text,
  `review_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`review_id`),
  KEY `reviewer_id` (`reviewer_id`),
  KEY `reviewee_id` (`reviewee_id`),
  KEY `booking_id` (`booking_id`),
  CONSTRAINT `review_ibfk_1` FOREIGN KEY (`reviewer_id`) REFERENCES `User` (`user_id`),
  CONSTRAINT `review_ibfk_2` FOREIGN KEY (`reviewee_id`) REFERENCES `User` (`user_id`),
  CONSTRAINT `review_ibfk_3` FOREIGN KEY (`booking_id`) REFERENCES `Booking` (`booking_id`),
  CONSTRAINT `review_chk_1` CHECK ((`rating` between 1 and 5))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Review`
--

INSERT INTO `Review` VALUES (1,2,1,1,4.5,'Great apartment, very clean!','2026-04-27 18:35:14'),(2,5,4,2,5.0,'Perfect stay, highly recommend','2026-04-27 18:35:14'),(3,7,6,3,3.5,'Good location but small','2026-04-27 18:35:14'),(4,9,8,4,4.0,'Nice place, good value','2026-04-27 18:35:14'),(5,11,10,5,4.5,'Loved it!','2026-04-27 18:35:14'),(6,13,12,6,5.0,'Amazing experience','2026-04-27 18:35:14'),(7,15,14,7,4.0,'Beautiful mansion','2026-04-27 18:35:14'),(8,17,16,8,2.5,'Not as described','2026-04-27 18:35:14'),(9,19,18,9,4.5,'Very cozy flat','2026-04-27 18:35:14'),(10,21,20,10,4.0,'Good stay','2026-04-27 18:35:14'),(11,2,3,11,4.5,'Luxury penthouse!','2026-04-27 18:35:14'),(12,5,7,12,5.0,'Best villa ever','2026-04-27 18:35:14'),(13,7,11,13,4.0,'Beachfront paradise','2026-04-27 18:35:14'),(14,9,15,14,4.5,'Great location in Zurich','2026-04-27 18:35:14'),(15,11,19,15,4.0,'Nice modern apartment','2026-04-27 18:35:14'),(16,13,1,16,4.5,'Wonderful canal house','2026-04-27 18:35:14'),(17,15,5,17,3.5,'Good but pricey','2026-04-27 18:35:14'),(18,17,9,18,4.0,'Clean and modern','2026-04-27 18:35:14'),(19,19,13,19,4.5,'Beautiful views','2026-04-27 18:35:14'),(20,21,17,20,4.0,'Solid choice','2026-04-27 18:35:14');

--
-- Table structure for table `SearchHistory`
--

DROP TABLE IF EXISTS `SearchHistory`;
CREATE TABLE `SearchHistory` (
  `search_id` int NOT NULL AUTO_INCREMENT,
  `guest_id` int NOT NULL,
  `search_query` varchar(500) DEFAULT NULL,
  `location` varchar(200) DEFAULT NULL,
  `search_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`search_id`),
  KEY `guest_id` (`guest_id`),
  CONSTRAINT `searchhistory_ibfk_1` FOREIGN KEY (`guest_id`) REFERENCES `Guest` (`guest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `SearchHistory`
--

INSERT INTO `SearchHistory` VALUES (1,1,'Berlin apartment','Berlin','2026-04-27 18:35:14'),(2,1,'Luxury penthouse','Berlin','2026-04-27 18:35:14'),(3,2,'Beachfront villa','Barcelona','2026-04-27 18:35:14'),(4,2,'City center studio','Munich','2026-04-27 18:35:14'),(5,3,'Family friendly','Amsterdam','2026-04-27 18:35:14'),(6,3,'Pet friendly','Hamburg','2026-04-27 18:35:14'),(7,4,'Business trip','Frankfurt','2026-04-27 18:35:14'),(8,4,'Romantic getaway','Paris','2026-04-27 18:35:14'),(9,5,'Luxury stay','New York','2026-04-27 18:35:14'),(10,5,'Apartment with pool','Los Angeles','2026-04-27 18:35:14'),(11,6,'City views','Chicago','2026-04-27 18:35:14'),(12,6,'Historic center','Rome','2026-04-27 18:35:14'),(13,7,'Beach house','Lisbon','2026-04-27 18:35:14'),(14,7,'Mountain view','Zurich','2026-04-27 18:35:14'),(15,8,'Family vacation','Copenhagen','2026-04-27 18:35:14'),(16,8,'Modern apartment','Stockholm','2026-04-27 18:35:14'),(17,9,'Northern lights','Oslo','2026-04-27 18:35:14'),(18,9,'Cultural trip','Vienna','2026-04-27 18:35:14'),(19,10,'Weekend break','Brussels','2026-04-27 18:35:14'),(20,10,'Summer escape','Athens','2026-04-27 18:35:14');

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
CREATE TABLE `User` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `registration_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `user_type` enum('Host','Guest','Admin') NOT NULL,
  `is_verified` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `User`
--

INSERT INTO `User` VALUES (1,'john.doe@email.com','hash1','John','Doe','+49123456789','1985-03-15','2026-04-27 18:35:14','Host',1),(2,'jane.smith@email.com','hash2','Jane','Smith','+49123456790','1990-07-22','2026-04-27 18:35:14','Guest',1),(3,'mike.wilson@email.com','hash3','Mike','Wilson','+49123456791','1975-11-10','2026-04-27 18:35:14','Host',1),(4,'sarah.johnson@email.com','hash4','Sarah','Johnson','+49123456792','1988-04-05','2026-04-27 18:35:14','Guest',1),(5,'david.brown@email.com','hash5','David','Brown','+49123456793','1995-09-20','2026-04-27 18:35:14','Host',0),(6,'emma.davis@email.com','hash6','Emma','Davis','+49123456794','1992-12-12','2026-04-27 18:35:14','Guest',1),(7,'robert.miller@email.com','hash7','Robert','Miller','+49123456795','1982-06-18','2026-04-27 18:35:14','Host',1),(8,'lisa.wilson@email.com','hash8','Lisa','Wilson','+49123456796','1998-02-28','2026-04-27 18:35:14','Guest',1),(9,'thomas.moore@email.com','hash9','Thomas','Moore','+49123456797','1970-08-14','2026-04-27 18:35:14','Host',1),(10,'amy.taylor@email.com','hash10','Amy','Taylor','+49123456798','1993-10-30','2026-04-27 18:35:14','Guest',1),(11,'kevin.anderson@email.com','hash11','Kevin','Anderson','+49123456799','1987-03-25','2026-04-27 18:35:14','Host',1),(12,'laura.thomas@email.com','hash12','Laura','Thomas','+49123456800','1991-07-19','2026-04-27 18:35:14','Guest',1),(13,'jason.jackson@email.com','hash13','Jason','Jackson','+49123456801','1979-12-05','2026-04-27 18:35:14','Host',0),(14,'olivia.white@email.com','hash14','Olivia','White','+49123456802','1996-01-17','2026-04-27 18:35:14','Guest',1),(15,'daniel.harris@email.com','hash15','Daniel','Harris','+49123456803','1984-09-09','2026-04-27 18:35:14','Host',1),(16,'sophia.martin@email.com','hash16','Sophia','Martin','+49123456804','1994-11-22','2026-04-27 18:35:14','Guest',1),(17,'matthew.thompson@email.com','hash17','Matthew','Thompson','+49123456805','1977-05-13','2026-04-27 18:35:14','Host',1),(18,'chloe.garcia@email.com','hash18','Chloe','Garcia','+49123456806','1999-08-08','2026-04-27 18:35:14','Guest',1),(19,'andrew.martinez@email.com','hash19','Andrew','Martinez','+49123456807','1983-04-20','2026-04-27 18:35:14','Host',1),(20,'natalia.rodriguez@email.com','hash20','Natalia','Rodriguez','+49123456808','1997-06-14','2026-04-27 18:35:14','Guest',1),(21,'patrick.lee@email.com','hash21','Patrick','Lee','+49123456809','1986-10-01','2026-04-27 18:35:14','Host',1),(22,'rebecca.clark@email.com','hash22','Rebecca','Clark','+49123456810','1990-02-27','2026-04-27 18:35:14','Guest',1),(23,'christopher.lewis@email.com','hash23','Christopher','Lewis','+49123456811','1981-12-10','2026-04-27 18:35:14','Host',1),(24,'admin.user@email.com','hash24','Admin','User','+49123456812','1980-01-01','2026-04-27 18:35:14','Admin',1);

--
-- Table structure for table `Wishlist`
--

DROP TABLE IF EXISTS `Wishlist`;
CREATE TABLE `Wishlist` (
  `wishlist_id` int NOT NULL AUTO_INCREMENT,
  `guest_id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `created_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`wishlist_id`),
  KEY `guest_id` (`guest_id`),
  CONSTRAINT `wishlist_ibfk_1` FOREIGN KEY (`guest_id`) REFERENCES `Guest` (`guest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Wishlist`
--

INSERT INTO `Wishlist` VALUES (1,1,'Summer Vacation 2026','2026-04-27 18:35:14'),(2,1,'Winter Getaways','2026-04-27 18:35:14'),(3,2,'Beach Properties','2026-04-27 18:35:14'),(4,2,'Luxury Stays','2026-04-27 18:35:14'),(5,3,'City Breaks','2026-04-27 18:35:14'),(6,3,'Mountain Retreats','2026-04-27 18:35:14'),(7,4,'Weekend Escapes','2026-04-27 18:35:14'),(8,5,'Europe Trip','2026-04-27 18:35:14'),(9,6,'Family Vacations','2026-04-27 18:35:14'),(10,7,'Business Travel','2026-04-27 18:35:14'),(11,8,'Romantic Getaways','2026-04-27 18:35:14'),(12,9,'Adventure Stays','2026-04-27 18:35:14'),(13,10,'Dream Homes','2026-04-27 18:35:14'),(14,11,'Weekend Getaways','2026-04-27 18:35:14'),(15,12,'Luxury Collection','2026-04-27 18:35:14'),(16,13,'Budget Stays','2026-04-27 18:35:14'),(17,14,'Nature Escapes','2026-04-27 18:35:14'),(18,15,'City Explorations','2026-04-27 18:35:14'),(19,16,'Beach Dreams','2026-04-27 18:35:14'),(20,17,'Mountain Retreats','2026-04-27 18:35:14');

--
-- Table structure for table `WishlistItem`
--

DROP TABLE IF EXISTS `WishlistItem`;
CREATE TABLE `WishlistItem` (
  `wishlist_id` int NOT NULL,
  `property_id` int NOT NULL,
  `added_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`wishlist_id`,`property_id`),
  KEY `property_id` (`property_id`),
  CONSTRAINT `wishlistitem_ibfk_1` FOREIGN KEY (`wishlist_id`) REFERENCES `Wishlist` (`wishlist_id`) ON DELETE CASCADE,
  CONSTRAINT `wishlistitem_ibfk_2` FOREIGN KEY (`property_id`) REFERENCES `Property` (`property_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `WishlistItem`
--

INSERT INTO `WishlistItem` VALUES (1,1,'2026-04-27 18:35:14'),(1,2,'2026-04-27 18:35:14'),(1,5,'2026-04-27 18:35:14'),(2,3,'2026-04-27 18:35:14'),(2,4,'2026-04-27 18:35:14'),(3,11,'2026-04-27 18:35:14'),(3,13,'2026-04-27 18:35:14'),(4,2,'2026-04-27 18:35:14'),(4,9,'2026-04-27 18:35:14'),(5,6,'2026-04-27 18:35:14'),(5,8,'2026-04-27 18:35:14'),(6,14,'2026-04-27 18:35:14'),(6,16,'2026-04-27 18:35:14'),(7,10,'2026-04-27 18:35:14'),(7,12,'2026-04-27 18:35:14'),(8,17,'2026-04-27 18:35:14'),(8,18,'2026-04-27 18:35:14'),(9,21,'2026-04-27 18:35:14'),(9,22,'2026-04-27 18:35:14'),(10,7,'2026-04-27 18:35:14');

SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
