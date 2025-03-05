-- DB update 2025_02_24_00 -> 2025_03_05_00
-- SylCore Copyright 2025

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for acore_world
CREATE DATABASE IF NOT EXISTS `acore_world` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `acore_world`;

-- Dumping structure for table acore_world.creature_outfits
CREATE TABLE IF NOT EXISTS `creature_outfits` (
  `entry` int unsigned NOT NULL,
  `race` tinyint unsigned NOT NULL DEFAULT '1',
  `gender` tinyint unsigned NOT NULL DEFAULT '0',
  `skin` tinyint unsigned NOT NULL DEFAULT '0',
  `face` tinyint unsigned NOT NULL DEFAULT '0',
  `hair` tinyint unsigned NOT NULL DEFAULT '0',
  `haircolor` tinyint unsigned NOT NULL DEFAULT '0',
  `facialhair` tinyint unsigned NOT NULL DEFAULT '0',
  `head` int NOT NULL DEFAULT '0',
  `shoulders` int NOT NULL DEFAULT '0',
  `body` int NOT NULL DEFAULT '0',
  `chest` int NOT NULL DEFAULT '0',
  `waist` int NOT NULL DEFAULT '0',
  `legs` int NOT NULL DEFAULT '0',
  `feet` int NOT NULL DEFAULT '0',
  `wrists` int NOT NULL DEFAULT '0',
  `hands` int NOT NULL DEFAULT '0',
  `back` int NOT NULL DEFAULT '0',
  `tabard` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

