/*
 Navicat Premium Data Transfer

 Source Server         : Grzegorz Piasny
 Source Server Type    : MariaDB
 Source Server Version : 100707
 Source Host           : db.it.pk.edu.pl:3306
 Source Schema         : projekt_nalyvaiko_piasny_pedryc

 Target Server Type    : MariaDB
 Target Server Version : 100707
 File Encoding         : 65001

 Date: 07/06/2023 10:07:25
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for Cenniki
-- ----------------------------
DROP TABLE IF EXISTS `Cenniki`;
CREATE TABLE `Cenniki`  (
  `CNN_ID` int(11) NOT NULL AUTO_INCREMENT,
  `CNN_WAZNY_OD` datetime NULL DEFAULT NULL,
  `CNN_WAZNY_DO` datetime NULL DEFAULT NULL,
  `CNN_AKTYWNY` tinyint(1) NULL DEFAULT NULL,
  `CNN_NAZWA` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`CNN_ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = 'Jezeli ktos po aktualizacji zatwierdza cennik to wszystkim osobą ktre mialy pozycje wczesniejszych cennikow wlaczy sie flaga w ich koszykach informujac ze należy potwierdzic nowa cennę (o ile cena jest wyższa poprzednia).\r\nJeżeli cenna spadnie to automatycznie pozycja zostanie przekierowana na nowy cennik.\r\n\r\n1. Zakładmy że nie da się insertowac cennikow zatwierdzonych\r\n2. Zakładmy że licencja z dostawcami zabezpiecza mine że jesli ktoś zamówił film do którego tracę prawa mam prawo go sprzedać.' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of Cenniki
-- ----------------------------
INSERT INTO `Cenniki` VALUES (1, '2021-01-01 19:52:03', '2021-12-31 19:52:12', 0, '2021');
INSERT INTO `Cenniki` VALUES (2, '2022-01-01 19:52:33', '2022-12-31 19:52:42', 0, '2022');
INSERT INTO `Cenniki` VALUES (3, '2023-06-01 00:00:00', '2023-12-01 00:00:00', 1, '2023');
INSERT INTO `Cenniki` VALUES (4, '2023-06-01 00:00:00', '2023-06-01 00:00:00', 0, 'TEST');
INSERT INTO `Cenniki` VALUES (5, '2023-06-03 00:00:00', '2023-06-03 00:00:00', 0, 'NOWY_CENNIK');

-- ----------------------------
-- Table structure for Elementy Koszyka
-- ----------------------------
DROP TABLE IF EXISTS `Elementy Koszyka`;
CREATE TABLE `Elementy Koszyka`  (
  `EKS_ID` int(11) NOT NULL AUTO_INCREMENT,
  `EKS_KSZ_ID` int(11) NULL DEFAULT NULL COMMENT 'Klucz obcy do koszyka',
  `EKS_PCN_ID` int(11) NOT NULL COMMENT 'klucz obcy do Cennika filmu',
  `EKS_AKTYWNY_OD` datetime NULL DEFAULT NULL COMMENT 'Data aktywacji filmu na koncie lub planowana data',
  `EKS_AKTYWNY_DO` datetime NULL DEFAULT NULL COMMENT 'Data zakończenia aktywnacji filmu',
  PRIMARY KEY (`EKS_ID`) USING BTREE,
  INDEX `fk_Elementy Koszyka_Koszyk_1`(`EKS_KSZ_ID`) USING BTREE,
  INDEX `fk_Elementy Koszyka_Pozycja Cennika_1`(`EKS_PCN_ID`) USING BTREE,
  CONSTRAINT `fk_Elementy Koszyka_Koszyk_1` FOREIGN KEY (`EKS_KSZ_ID`) REFERENCES `Koszyk i Platnosci` (`KSZ_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_Elementy Koszyka_Pozycja Cennika_1` FOREIGN KEY (`EKS_PCN_ID`) REFERENCES `Pozycja Cennika` (`PCN_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of Elementy Koszyka
-- ----------------------------
INSERT INTO `Elementy Koszyka` VALUES (1, 1, 1, '2021-07-01 20:15:46', '2021-07-02 20:15:46');
INSERT INTO `Elementy Koszyka` VALUES (2, 1, 11, '2023-06-14 13:05:27', '2023-06-21 13:05:31');

-- ----------------------------
-- Table structure for Faktury
-- ----------------------------
DROP TABLE IF EXISTS `Faktury`;
CREATE TABLE `Faktury`  (
  `FKT_ID` int(11) NOT NULL AUTO_INCREMENT,
  `FKT_PPL_ID` int(11) NULL DEFAULT NULL COMMENT 'Klucz do platnosci',
  `FKT_NUMER` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `FKT_PARAMETRY_ODBIORCY` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `FKT_PARAMETRY_DOSTAWCY` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `FKT_POZYCJE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'Wygenerowany opis na podstawie platnosci',
  `FKT_DATA_WYSTAWIENIA` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`FKT_ID`) USING BTREE,
  INDEX `fk_Faktury_Przetwarzanie Platnosci_1`(`FKT_PPL_ID`) USING BTREE,
  CONSTRAINT `fk_Faktury_Przetwarzanie Platnosci_1` FOREIGN KEY (`FKT_PPL_ID`) REFERENCES `Przetwarzanie Platnosci` (`PPL_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of Faktury
-- ----------------------------

-- ----------------------------
-- Table structure for Filmowcy
-- ----------------------------
DROP TABLE IF EXISTS `Filmowcy`;
CREATE TABLE `Filmowcy`  (
  `FLC_ID` int(11) NOT NULL AUTO_INCREMENT,
  `FLC_PROFIL` enum('Rezyser','Scenarzysta','Aktor') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `FLC_IMIE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `FLC_NAZWISKO` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `FLC_DOROBEK` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`FLC_ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of Filmowcy
-- ----------------------------
INSERT INTO `Filmowcy` VALUES (1, 'Rezyser', 'Stanley', 'Kubrick', 'tanley Kubrick was an American film director, producer and screenwriter. Widely considered one of the greatest filmmakers of all time');
INSERT INTO `Filmowcy` VALUES (2, 'Aktor', 'Andrew', 'Whitfield ', 'australijski aktor i model pochodzenia walijskiego, najlepiej znany z roli Spartakusa');
INSERT INTO `Filmowcy` VALUES (3, 'Scenarzysta', 'Dalton', 'Trumbo', 'Trumbo był utalentowanym scenarzystą, który był często aktywny w Hollywood w latach 40. i 50. XX wieku.');
INSERT INTO `Filmowcy` VALUES (4, 'Aktor', 'Malgorzata ', 'Buczowska', 'Małgorzata Buczkowska polska aktorka, urodzona w 1976, znana z Pokaż kotku, co masz w środku, Zero_jeden_zero, Kołysanka.');
INSERT INTO `Filmowcy` VALUES (5, 'Scenarzysta', 'Filip', 'Ochinski', 'Filip Ochiński aktor, urodzony w 1998, znany z Kołysanka, Nieruchomy poruszyciel, Kryminalni: Misja Śląska.');
INSERT INTO `Filmowcy` VALUES (6, 'Rezyser', 'Juliusz', 'Mahulski', 'Juliusz Machulski pochodzi z aktorskiej rodziny. Od dziecka był zafascynowany kinem, ale do szkoły reżyserskiej w Łodzi trafił dopiero w 1978 r., wcześniej studiował bowiem filologię polską na Uniwersytecie Warszawskim.');
INSERT INTO `Filmowcy` VALUES (7, 'Rezyser', 'Stanislaw', 'Bareja', 'Zmiennicy , Mis');

-- ----------------------------
-- Table structure for Filmy
-- ----------------------------
DROP TABLE IF EXISTS `Filmy`;
CREATE TABLE `Filmy`  (
  `FLM_ID` int(11) NOT NULL AUTO_INCREMENT,
  `FLM_GTN_ID` int(11) NOT NULL COMMENT 'Klucz obcy do gatunku',
  `FLM_JZK_ID` int(11) NOT NULL COMMENT 'Klucz obcy do oryginalego jezyka filmu',
  `FLM_NAZWA` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FLM_FLC_REZYSER_ID` int(11) NULL DEFAULT NULL COMMENT 'Klucz do filmowcow w roli rezyser',
  `FLM_OPIS` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`FLM_ID`) USING BTREE,
  INDEX `fk_Filmy_Jezyki_1`(`FLM_JZK_ID`) USING BTREE,
  INDEX `fk_Filmy_Gatunki_1`(`FLM_GTN_ID`) USING BTREE,
  INDEX `fk_Filmy_Filmowcy_1`(`FLM_FLC_REZYSER_ID`) USING BTREE,
  CONSTRAINT `fk_Filmy_Filmowcy_1` FOREIGN KEY (`FLM_FLC_REZYSER_ID`) REFERENCES `Filmowcy` (`FLC_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_Filmy_Gatunki_1` FOREIGN KEY (`FLM_GTN_ID`) REFERENCES `Gatunki` (`GTN_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_Filmy_Jezyki_1` FOREIGN KEY (`FLM_JZK_ID`) REFERENCES `Jezyki` (`JZK_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of Filmy
-- ----------------------------
INSERT INTO `Filmy` VALUES (1, 6, 2, 'Spartakus', 1, 'Historia buntu niewolników w Imperium Rzymskim pod przywództwem Spartakusa.   ');
INSERT INTO `Filmy` VALUES (2, 7, 1, 'Kolysanka', 6, 'Do małej wsi na Mazurach wprowadza się rodzina Makarewiczów. Wraz z ich przybyciem w niewyjaśnionych okolicznościach zaczynają ginąć ludzie.');
INSERT INTO `Filmy` VALUES (3, 3, 1, 'Mis', 7, 'Film Bareji');

-- ----------------------------
-- Table structure for Gatunki
-- ----------------------------
DROP TABLE IF EXISTS `Gatunki`;
CREATE TABLE `Gatunki`  (
  `GTN_ID` int(11) NOT NULL AUTO_INCREMENT,
  `GTN_GTN_ID` int(11) NULL DEFAULT NULL COMMENT 'Klucz do galezi wyzej',
  `GTN_NAZWA` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`GTN_ID`) USING BTREE,
  INDEX `fk_Gatunki_Gatunki_1`(`GTN_GTN_ID`) USING BTREE,
  CONSTRAINT `fk_Gatunki_Gatunki_1` FOREIGN KEY (`GTN_GTN_ID`) REFERENCES `Gatunki` (`GTN_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = 'Struktura drzewiasta gatunków' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of Gatunki
-- ----------------------------
INSERT INTO `Gatunki` VALUES (1, NULL, 'Akcja');
INSERT INTO `Gatunki` VALUES (2, 1, 'Szpiegowski');
INSERT INTO `Gatunki` VALUES (3, 1, 'Superbohaterski');
INSERT INTO `Gatunki` VALUES (4, NULL, 'Historyczny');
INSERT INTO `Gatunki` VALUES (5, 4, 'Biograficzny');
INSERT INTO `Gatunki` VALUES (6, 4, 'Historyczno-wojenny');
INSERT INTO `Gatunki` VALUES (7, NULL, 'Komedia');

-- ----------------------------
-- Table structure for Jezyki
-- ----------------------------
DROP TABLE IF EXISTS `Jezyki`;
CREATE TABLE `Jezyki`  (
  `JZK_ID` int(11) NOT NULL AUTO_INCREMENT,
  `JZK_NAZWA_JEZYKA` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`JZK_ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of Jezyki
-- ----------------------------
INSERT INTO `Jezyki` VALUES (1, 'Polski');
INSERT INTO `Jezyki` VALUES (2, 'English');
INSERT INTO `Jezyki` VALUES (3, 'Deutsch');

-- ----------------------------
-- Table structure for Konta
-- ----------------------------
DROP TABLE IF EXISTS `Konta`;
CREATE TABLE `Konta`  (
  `KNT_ID` int(11) NOT NULL AUTO_INCREMENT,
  `KNT_LOGIN` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `KNT_HASLO` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `KNT_IMIE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `KNT_NAZWISKO` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `KNT_CZY_PRACOWNIK` tinyint(1) NULL DEFAULT NULL,
  `KNT_DANE_KONTAKTOWE` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `KNT_E_MAIL` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`KNT_ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 131 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of Konta
-- ----------------------------
INSERT INTO `Konta` VALUES (1, 'adam2', 'xxxx', 'Adam', 'Kowalski', 0, '890 999 000', 'adam@poczta.pl');
INSERT INTO `Konta` VALUES (2, 'ewa3', 'sssss', 'Ewa', 'Nowak', 1, '111 111 111', 'ewa@poczta.pl');
INSERT INTO `Konta` VALUES (3, 'adgG', 'vvvvv', 'Aga', 'Grzeczna', 0, '111 222 222', 'aga@cos.com');
INSERT INTO `Konta` VALUES (4, 'konto1', 'haslo1', 'Michael', 'Smith', 0, '', 'user1@example.com');
INSERT INTO `Konta` VALUES (5, 'konto2', 'haslo2', 'Michael', 'Williams', 0, '', 'user2@example.com');
INSERT INTO `Konta` VALUES (6, 'konto3', 'haslo3', 'Sophia', 'Smith', 0, '', 'user3@example.com');
INSERT INTO `Konta` VALUES (7, 'konto4', 'haslo4', 'David', 'Williams', 0, '', 'user4@example.com');
INSERT INTO `Konta` VALUES (8, 'konto5', 'haslo5', 'Michael', 'Smith', 0, '', 'user5@example.com');
INSERT INTO `Konta` VALUES (9, 'konto6', 'haslo6', 'Michael', 'Williams', 0, '', 'user6@example.com');
INSERT INTO `Konta` VALUES (10, 'konto7', 'haslo7', 'Michael', 'Smith', 0, '', 'user7@example.com');
INSERT INTO `Konta` VALUES (11, 'konto8', 'haslo8', 'John', 'Smith', 0, '', 'user8@example.com');
INSERT INTO `Konta` VALUES (12, 'konto9', 'haslo9', 'John', 'Williams', 0, '', 'user9@example.com');
INSERT INTO `Konta` VALUES (13, 'konto10', 'haslo10', 'David', 'Johnson', 0, '', 'user10@example.com');
INSERT INTO `Konta` VALUES (14, 'konto11', 'haslo11', 'Michael', 'Brown', 0, '', 'user11@example.com');
INSERT INTO `Konta` VALUES (15, 'konto12', 'haslo12', 'Sophia', 'Brown', 0, '', 'user12@example.com');
INSERT INTO `Konta` VALUES (16, 'konto13', 'haslo13', 'David', 'Brown', 0, '', 'user13@example.com');
INSERT INTO `Konta` VALUES (17, 'konto14', 'haslo14', 'Emma', 'Smith', 0, '', 'user14@example.com');
INSERT INTO `Konta` VALUES (18, 'konto15', 'haslo15', 'David', 'Brown', 0, '', 'user15@example.com');
INSERT INTO `Konta` VALUES (19, 'konto16', 'haslo16', 'Sophia', 'Brown', 0, '', 'user16@example.com');
INSERT INTO `Konta` VALUES (20, 'konto17', 'haslo17', 'David', 'Jones', 0, '', 'user17@example.com');
INSERT INTO `Konta` VALUES (21, 'konto18', 'haslo18', 'David', 'Brown', 0, '', 'user18@example.com');
INSERT INTO `Konta` VALUES (22, 'konto19', 'haslo19', 'John', 'Jones', 0, '', 'user19@example.com');
INSERT INTO `Konta` VALUES (23, 'konto20', 'haslo20', 'John', 'Jones', 0, '', 'user20@example.com');
INSERT INTO `Konta` VALUES (24, 'konto21', 'haslo21', 'John', 'Williams', 0, '', 'user21@example.com');
INSERT INTO `Konta` VALUES (25, 'konto22', 'haslo22', 'Michael', 'Brown', 0, '', 'user22@example.com');
INSERT INTO `Konta` VALUES (26, 'konto23', 'haslo23', 'David', 'Jones', 0, '', 'user23@example.com');
INSERT INTO `Konta` VALUES (27, 'konto24', 'haslo24', 'Michael', 'Jones', 0, '', 'user24@example.com');
INSERT INTO `Konta` VALUES (28, 'konto25', 'haslo25', 'Michael', 'Johnson', 0, '', 'user25@example.com');
INSERT INTO `Konta` VALUES (29, 'konto26', 'haslo26', 'Sophia', 'Brown', 0, '', 'user26@example.com');
INSERT INTO `Konta` VALUES (30, 'konto27', 'haslo27', 'Sophia', 'Williams', 0, '', 'user27@example.com');
INSERT INTO `Konta` VALUES (31, 'konto28', 'haslo28', 'Michael', 'Smith', 0, '', 'user28@example.com');
INSERT INTO `Konta` VALUES (32, 'konto29', 'haslo29', 'John', 'Brown', 0, '', 'user29@example.com');
INSERT INTO `Konta` VALUES (33, 'konto30', 'haslo30', 'Sophia', 'Brown', 0, '', 'user30@example.com');
INSERT INTO `Konta` VALUES (34, 'konto31', 'haslo31', 'Michael', 'Brown', 0, '', 'user31@example.com');
INSERT INTO `Konta` VALUES (35, 'konto32', 'haslo32', 'Emma', 'Johnson', 0, '', 'user32@example.com');
INSERT INTO `Konta` VALUES (36, 'konto33', 'haslo33', 'John', 'Smith', 0, '', 'user33@example.com');
INSERT INTO `Konta` VALUES (37, 'konto34', 'haslo34', 'Emma', 'Williams', 0, '', 'user34@example.com');
INSERT INTO `Konta` VALUES (38, 'konto35', 'haslo35', 'David', 'Brown', 0, '', 'user35@example.com');
INSERT INTO `Konta` VALUES (39, 'konto36', 'haslo36', 'David', 'Williams', 0, '', 'user36@example.com');
INSERT INTO `Konta` VALUES (40, 'konto37', 'haslo37', 'Michael', 'Smith', 0, '', 'user37@example.com');
INSERT INTO `Konta` VALUES (41, 'konto38', 'haslo38', 'Michael', 'Johnson', 0, '', 'user38@example.com');
INSERT INTO `Konta` VALUES (42, 'konto39', 'haslo39', 'John', 'Brown', 0, '', 'user39@example.com');
INSERT INTO `Konta` VALUES (43, 'konto40', 'haslo40', 'Michael', 'Johnson', 0, '', 'user40@example.com');
INSERT INTO `Konta` VALUES (44, 'konto41', 'haslo41', 'John', 'Jones', 0, '', 'user41@example.com');
INSERT INTO `Konta` VALUES (45, 'konto42', 'haslo42', 'David', 'Jones', 0, '', 'user42@example.com');
INSERT INTO `Konta` VALUES (46, 'konto43', 'haslo43', 'Sophia', 'Johnson', 0, '', 'user43@example.com');
INSERT INTO `Konta` VALUES (47, 'konto44', 'haslo44', 'John', 'Jones', 0, '', 'user44@example.com');
INSERT INTO `Konta` VALUES (48, 'konto45', 'haslo45', 'Sophia', 'Williams', 0, '', 'user45@example.com');
INSERT INTO `Konta` VALUES (49, 'konto46', 'haslo46', 'Sophia', 'Williams', 0, '', 'user46@example.com');
INSERT INTO `Konta` VALUES (50, 'konto47', 'haslo47', 'David', 'Williams', 0, '', 'user47@example.com');
INSERT INTO `Konta` VALUES (51, 'konto48', 'haslo48', 'Emma', 'Brown', 0, '', 'user48@example.com');
INSERT INTO `Konta` VALUES (52, 'konto49', 'haslo49', 'Emma', 'Brown', 0, '', 'user49@example.com');
INSERT INTO `Konta` VALUES (53, 'konto50', 'haslo50', 'Emma', 'Jones', 0, '', 'user50@example.com');
INSERT INTO `Konta` VALUES (54, 'konto51', 'haslo51', 'Emma', 'Smith', 0, '', 'user51@example.com');
INSERT INTO `Konta` VALUES (55, 'konto52', 'haslo52', 'John', 'Brown', 0, '', 'user52@example.com');
INSERT INTO `Konta` VALUES (56, 'konto53', 'haslo53', 'Sophia', 'Smith', 0, '', 'user53@example.com');
INSERT INTO `Konta` VALUES (57, 'konto54', 'haslo54', 'David', 'Johnson', 0, '', 'user54@example.com');
INSERT INTO `Konta` VALUES (58, 'konto55', 'haslo55', 'Emma', 'Jones', 0, '', 'user55@example.com');
INSERT INTO `Konta` VALUES (59, 'konto56', 'haslo56', 'Michael', 'Smith', 0, '', 'user56@example.com');
INSERT INTO `Konta` VALUES (60, 'konto57', 'haslo57', 'Emma', 'Johnson', 0, '', 'user57@example.com');
INSERT INTO `Konta` VALUES (61, 'konto58', 'haslo58', 'Sophia', 'Jones', 0, '', 'user58@example.com');
INSERT INTO `Konta` VALUES (62, 'konto59', 'haslo59', 'Sophia', 'Johnson', 0, '', 'user59@example.com');
INSERT INTO `Konta` VALUES (63, 'konto60', 'haslo60', 'Michael', 'Williams', 0, '', 'user60@example.com');
INSERT INTO `Konta` VALUES (64, 'konto61', 'haslo61', 'Emma', 'Smith', 0, '', 'user61@example.com');
INSERT INTO `Konta` VALUES (65, 'konto62', 'haslo62', 'Michael', 'Johnson', 0, '', 'user62@example.com');
INSERT INTO `Konta` VALUES (66, 'konto63', 'haslo63', 'Sophia', 'Brown', 0, '', 'user63@example.com');
INSERT INTO `Konta` VALUES (67, 'konto64', 'haslo64', 'Sophia', 'Brown', 0, '', 'user64@example.com');
INSERT INTO `Konta` VALUES (68, 'konto65', 'haslo65', 'Sophia', 'Jones', 0, '', 'user65@example.com');
INSERT INTO `Konta` VALUES (69, 'konto66', 'haslo66', 'John', 'Williams', 0, '', 'user66@example.com');
INSERT INTO `Konta` VALUES (70, 'konto67', 'haslo67', 'Michael', 'Williams', 0, '', 'user67@example.com');
INSERT INTO `Konta` VALUES (71, 'konto68', 'haslo68', 'John', 'Williams', 0, '', 'user68@example.com');
INSERT INTO `Konta` VALUES (72, 'konto69', 'haslo69', 'John', 'Smith', 0, '', 'user69@example.com');
INSERT INTO `Konta` VALUES (73, 'konto70', 'haslo70', 'David', 'Johnson', 0, '', 'user70@example.com');
INSERT INTO `Konta` VALUES (74, 'konto71', 'haslo71', 'David', 'Johnson', 0, '', 'user71@example.com');
INSERT INTO `Konta` VALUES (75, 'konto72', 'haslo72', 'Michael', 'Smith', 0, '', 'user72@example.com');
INSERT INTO `Konta` VALUES (76, 'konto73', 'haslo73', 'Sophia', 'Smith', 0, '', 'user73@example.com');
INSERT INTO `Konta` VALUES (77, 'konto74', 'haslo74', 'John', 'Johnson', 0, '', 'user74@example.com');
INSERT INTO `Konta` VALUES (78, 'konto75', 'haslo75', 'John', 'Williams', 0, '', 'user75@example.com');
INSERT INTO `Konta` VALUES (79, 'konto76', 'haslo76', 'John', 'Williams', 0, '', 'user76@example.com');
INSERT INTO `Konta` VALUES (80, 'konto77', 'haslo77', 'Emma', 'Jones', 0, '', 'user77@example.com');
INSERT INTO `Konta` VALUES (81, 'konto78', 'haslo78', 'David', 'Williams', 0, '', 'user78@example.com');
INSERT INTO `Konta` VALUES (82, 'konto79', 'haslo79', 'David', 'Smith', 0, '', 'user79@example.com');
INSERT INTO `Konta` VALUES (83, 'konto80', 'haslo80', 'Emma', 'Smith', 0, '', 'user80@example.com');
INSERT INTO `Konta` VALUES (84, 'konto81', 'haslo81', 'John', 'Jones', 0, '', 'user81@example.com');
INSERT INTO `Konta` VALUES (85, 'konto82', 'haslo82', 'Emma', 'Brown', 0, '', 'user82@example.com');
INSERT INTO `Konta` VALUES (86, 'konto83', 'haslo83', 'Emma', 'Brown', 0, '', 'user83@example.com');
INSERT INTO `Konta` VALUES (87, 'konto84', 'haslo84', 'John', 'Brown', 0, '', 'user84@example.com');
INSERT INTO `Konta` VALUES (88, 'konto85', 'haslo85', 'Sophia', 'Johnson', 0, '', 'user85@example.com');
INSERT INTO `Konta` VALUES (89, 'konto86', 'haslo86', 'Emma', 'Smith', 0, '', 'user86@example.com');
INSERT INTO `Konta` VALUES (90, 'konto87', 'haslo87', 'Sophia', 'Brown', 0, '', 'user87@example.com');
INSERT INTO `Konta` VALUES (91, 'konto88', 'haslo88', 'David', 'Brown', 0, '', 'user88@example.com');
INSERT INTO `Konta` VALUES (92, 'konto89', 'haslo89', 'John', 'Smith', 0, '', 'user89@example.com');
INSERT INTO `Konta` VALUES (93, 'konto90', 'haslo90', 'Emma', 'Smith', 0, '', 'user90@example.com');
INSERT INTO `Konta` VALUES (94, 'konto91', 'haslo91', 'Emma', 'Brown', 0, '', 'user91@example.com');
INSERT INTO `Konta` VALUES (95, 'konto92', 'haslo92', 'David', 'Williams', 0, '', 'user92@example.com');
INSERT INTO `Konta` VALUES (96, 'konto93', 'haslo93', 'Sophia', 'Smith', 0, '', 'user93@example.com');
INSERT INTO `Konta` VALUES (97, 'konto94', 'haslo94', 'Emma', 'Williams', 0, '', 'user94@example.com');
INSERT INTO `Konta` VALUES (98, 'konto95', 'haslo95', 'David', 'Johnson', 0, '', 'user95@example.com');
INSERT INTO `Konta` VALUES (99, 'konto96', 'haslo96', 'David', 'Jones', 0, '', 'user96@example.com');
INSERT INTO `Konta` VALUES (100, 'konto97', 'haslo97', 'Emma', 'Williams', 0, '', 'user97@example.com');
INSERT INTO `Konta` VALUES (101, 'konto98', 'haslo98', 'John', 'Williams', 0, '', 'user98@example.com');
INSERT INTO `Konta` VALUES (102, 'konto99', 'haslo99', 'Emma', 'Johnson', 0, '', 'user99@example.com');
INSERT INTO `Konta` VALUES (103, 'konto100', 'haslo100', 'Michael', 'Williams', 0, '', 'user100@example.com');
INSERT INTO `Konta` VALUES (104, 'konto101', 'haslo101', 'Sophia', 'Johnson', 0, '', 'user101@example.com');
INSERT INTO `Konta` VALUES (105, 'konto102', 'haslo102', 'John', 'Jones', 0, '', 'user102@example.com');
INSERT INTO `Konta` VALUES (106, 'konto103', 'haslo103', 'Sophia', 'Johnson', 0, '', 'user103@example.com');
INSERT INTO `Konta` VALUES (107, 'konto104', 'haslo104', 'Michael', 'Jones', 0, '', 'user104@example.com');
INSERT INTO `Konta` VALUES (108, 'konto105', 'haslo105', 'John', 'Williams', 0, '', 'user105@example.com');
INSERT INTO `Konta` VALUES (109, 'konto106', 'haslo106', 'Emma', 'Smith', 0, '', 'user106@example.com');
INSERT INTO `Konta` VALUES (110, 'konto107', 'haslo107', 'David', 'Williams', 0, '', 'user107@example.com');
INSERT INTO `Konta` VALUES (111, 'konto108', 'haslo108', 'Sophia', 'Jones', 0, '', 'user108@example.com');
INSERT INTO `Konta` VALUES (112, 'konto109', 'haslo109', 'Sophia', 'Johnson', 0, '', 'user109@example.com');
INSERT INTO `Konta` VALUES (113, 'konto110', 'haslo110', 'John', 'Williams', 0, '', 'user110@example.com');
INSERT INTO `Konta` VALUES (114, 'konto111', 'haslo111', 'David', 'Brown', 0, '', 'user111@example.com');
INSERT INTO `Konta` VALUES (115, 'konto112', 'haslo112', 'Sophia', 'Smith', 0, '', 'user112@example.com');
INSERT INTO `Konta` VALUES (116, 'konto113', 'haslo113', 'Sophia', 'Johnson', 0, '', 'user113@example.com');
INSERT INTO `Konta` VALUES (117, 'konto114', 'haslo114', 'Sophia', 'Williams', 0, '', 'user114@example.com');
INSERT INTO `Konta` VALUES (118, 'konto115', 'haslo115', 'Sophia', 'Williams', 0, '', 'user115@example.com');
INSERT INTO `Konta` VALUES (119, 'konto116', 'haslo116', 'Sophia', 'Johnson', 0, '', 'user116@example.com');
INSERT INTO `Konta` VALUES (120, 'konto117', 'haslo117', 'Sophia', 'Jones', 0, '', 'user117@example.com');
INSERT INTO `Konta` VALUES (121, 'konto118', 'haslo118', 'Sophia', 'Smith', 0, '', 'user118@example.com');
INSERT INTO `Konta` VALUES (122, 'konto119', 'haslo119', 'Michael', 'Williams', 0, '', 'user119@example.com');
INSERT INTO `Konta` VALUES (123, 'konto120', 'haslo120', 'David', 'Johnson', 0, '', 'user120@example.com');
INSERT INTO `Konta` VALUES (124, 'konto121', 'haslo121', 'Emma', 'Williams', 0, '', 'user121@example.com');
INSERT INTO `Konta` VALUES (125, 'konto122', 'haslo122', 'John', 'Jones', 0, '', 'user122@example.com');
INSERT INTO `Konta` VALUES (126, 'konto123', 'haslo123', 'Emma', 'Jones', 0, '', 'user123@example.com');
INSERT INTO `Konta` VALUES (127, 'konto124', 'haslo124', 'Sophia', 'Williams', 0, '', 'user124@example.com');
INSERT INTO `Konta` VALUES (128, 'konto125', 'haslo125', 'John', 'Jones', 0, '', 'user125@example.com');

-- ----------------------------
-- Table structure for Koszyk i Platnosci
-- ----------------------------
DROP TABLE IF EXISTS `Koszyk i Platnosci`;
CREATE TABLE `Koszyk i Platnosci`  (
  `KSZ_ID` int(11) NOT NULL AUTO_INCREMENT,
  `KSZ_KNT_ID` int(11) NOT NULL,
  `KSZ_DATA_UTWORZENIA` datetime NOT NULL,
  `KSZ_OPLACONY` tinyint(1) NULL DEFAULT NULL,
  `KSZ_CZY_PLATNOSC` tinyint(1) NULL DEFAULT NULL,
  `KSZ_DATA_AKTUALIZACJI` datetime NULL DEFAULT NULL,
  `KSZ_WYMAGANA_AKCEPTACJA_CENY` tinyint(1) NULL DEFAULT NULL COMMENT 'Procedura nocna bedzie sprawdzac czy zmienila sie cena jak zmienjszyla sie to automatycznie podstawi sie nowa pozycja cennika. Gdyby wzrosla dodatkowa akceptacja.\r\n(DO ROZWAZENIA: czy flagowanie robic w nocy czy przy rozpoczeciu sesji uzytkownika by pozbyc sie problemu gdcy cena wzrosla a potem spadla do tej samej wartosci)',
  `KSZ_CENA_BRUTTO` decimal(10, 2) NULL DEFAULT NULL COMMENT 'Suma pozycji z podatkeim',
  PRIMARY KEY (`KSZ_ID`) USING BTREE,
  INDEX `fk_Koszyk_Konta_1`(`KSZ_KNT_ID`) USING BTREE,
  CONSTRAINT `fk_Koszyk_Konta_1` FOREIGN KEY (`KSZ_KNT_ID`) REFERENCES `Konta` (`KNT_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = 'W momencie oplacenia czesci koszyka tworzony jest nowy koszyk oplacony z elementow oplaconych a nie oplacone zostaja w koszyku.\r\nCo oznacza ze bedzie tylko jeden nieoplacony koszyk.\r\n\r\nPo wybraniu elementow z koszyka do oplaty na interfejsie uzytkownika bedzie widoczny koszyk oraz niewykonane platnosci.\r\nW przypadku problemu z platnoscia elementy bedzie mozna wrocic do koszyka uzunac cala platnosc lub pozostawic jako nie oplacona z mozliwosca ponowienia platnosci.\r\n' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of Koszyk i Platnosci
-- ----------------------------
INSERT INTO `Koszyk i Platnosci` VALUES (1, 1, '2021-07-01 20:13:38', 0, 0, '2021-07-01 20:13:38', 0, 0.00);

-- ----------------------------
-- Table structure for Obsada
-- ----------------------------
DROP TABLE IF EXISTS `Obsada`;
CREATE TABLE `Obsada`  (
  `OBS_ID` int(11) NOT NULL AUTO_INCREMENT,
  `OBS_FLC_ID` int(11) NULL DEFAULT NULL COMMENT 'Klucz do Filmowcow',
  `OBS_FLM_ID` int(11) NULL DEFAULT NULL COMMENT 'Klucz do Filmu w ktorym filmowiec pelni jakas funkcje',
  `OBS_ROLA` enum('Aktor_Plan_1','Aktor_Plan_2','Dzwiek','Scenarzysta') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `OBS_PRIORYTET` int(10) NULL DEFAULT NULL COMMENT 'Potrzebne do kolejnosci wyswietlania',
  PRIMARY KEY (`OBS_ID`) USING BTREE,
  INDEX `fk_Obsada_Filmowcy_1`(`OBS_FLC_ID`) USING BTREE,
  INDEX `fk_Obsada_Filmy_1`(`OBS_FLM_ID`) USING BTREE,
  CONSTRAINT `fk_Obsada_Filmowcy_1` FOREIGN KEY (`OBS_FLC_ID`) REFERENCES `Filmowcy` (`FLC_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_Obsada_Filmy_1` FOREIGN KEY (`OBS_FLM_ID`) REFERENCES `Filmy` (`FLM_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of Obsada
-- ----------------------------
INSERT INTO `Obsada` VALUES (1, 2, 1, 'Aktor_Plan_1', 1);
INSERT INTO `Obsada` VALUES (2, 3, 1, 'Scenarzysta', 2);
INSERT INTO `Obsada` VALUES (3, 5, 2, 'Aktor_Plan_2', 1);
INSERT INTO `Obsada` VALUES (4, 4, 2, 'Scenarzysta', 3);

-- ----------------------------
-- Table structure for Pozycja Cennika
-- ----------------------------
DROP TABLE IF EXISTS `Pozycja Cennika`;
CREATE TABLE `Pozycja Cennika`  (
  `PCN_ID` int(11) NOT NULL AUTO_INCREMENT,
  `PCN_CNN_ID` int(11) NOT NULL COMMENT 'klucz obcy do cennika',
  `PCN_FLM_ID` int(11) NOT NULL COMMENT 'klucz obcy do filmu',
  `PCN_LICZBA_DNI` int(11) NULL DEFAULT NULL,
  `PCN_CENA_NETTO` decimal(10, 2) NULL DEFAULT NULL COMMENT 'Cena wypozyczenia na dana liczbe dni',
  PRIMARY KEY (`PCN_ID`) USING BTREE,
  INDEX `fk_Pozycja Cennika_Cenniki_1`(`PCN_CNN_ID`) USING BTREE,
  INDEX `fk_Pozycja Cennika_Filmy_1`(`PCN_FLM_ID`) USING BTREE,
  CONSTRAINT `fk_Pozycja Cennika_Cenniki_1` FOREIGN KEY (`PCN_CNN_ID`) REFERENCES `Cenniki` (`CNN_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_Pozycja Cennika_Filmy_1` FOREIGN KEY (`PCN_FLM_ID`) REFERENCES `Filmy` (`FLM_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of Pozycja Cennika
-- ----------------------------
INSERT INTO `Pozycja Cennika` VALUES (1, 1, 1, 1, 1.00);
INSERT INTO `Pozycja Cennika` VALUES (2, 1, 1, 7, 3.00);
INSERT INTO `Pozycja Cennika` VALUES (3, 2, 1, 1, 1.10);
INSERT INTO `Pozycja Cennika` VALUES (4, 2, 1, 7, 3.30);
INSERT INTO `Pozycja Cennika` VALUES (5, 3, 1, 1, 1.00);
INSERT INTO `Pozycja Cennika` VALUES (6, 3, 1, 7, 3.00);
INSERT INTO `Pozycja Cennika` VALUES (8, 4, 1, 1, 2.50);
INSERT INTO `Pozycja Cennika` VALUES (9, 4, 1, 7, 4.50);
INSERT INTO `Pozycja Cennika` VALUES (11, 1, 3, 1, 1.10);
INSERT INTO `Pozycja Cennika` VALUES (12, 5, 1, 1, 1.00);
INSERT INTO `Pozycja Cennika` VALUES (13, 5, 1, 7, 3.00);
INSERT INTO `Pozycja Cennika` VALUES (14, 5, 3, 1, 1.10);

-- ----------------------------
-- Table structure for Przetwarzanie Platnosci
-- ----------------------------
DROP TABLE IF EXISTS `Przetwarzanie Platnosci`;
CREATE TABLE `Przetwarzanie Platnosci`  (
  `PPL_ID` int(11) NOT NULL AUTO_INCREMENT,
  `PPL_KSZ_ID` int(11) NOT NULL COMMENT 'Klucz do platnosci',
  `PPL_STATUS` enum('Oczekuje','Rozpoczeta','Odrzucona','Wykonana') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `PPL_KWOTA` decimal(10, 2) NULL DEFAULT NULL,
  `PPL_METODA_PLATNOSCI` enum('BLIK','Przelew','Karta kredytowa') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`PPL_ID`) USING BTREE,
  INDEX `fk_Przetwarzanie Platnosci_Koszyk i Platnosci_1`(`PPL_KSZ_ID`) USING BTREE,
  CONSTRAINT `fk_Przetwarzanie Platnosci_Koszyk i Platnosci_1` FOREIGN KEY (`PPL_KSZ_ID`) REFERENCES `Koszyk i Platnosci` (`KSZ_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of Przetwarzanie Platnosci
-- ----------------------------

-- ----------------------------
-- Table structure for Recenzje
-- ----------------------------
DROP TABLE IF EXISTS `Recenzje`;
CREATE TABLE `Recenzje`  (
  `RCN_ID` int(11) NOT NULL AUTO_INCREMENT,
  `RCN_KNT_ID` int(11) NOT NULL COMMENT 'Klucz do konta',
  `RCN_FLM_ID` int(11) NOT NULL COMMENT 'Klucz do filmu',
  `RCN_OCENA` int(1) UNSIGNED NULL DEFAULT NULL COMMENT 'OD 0 DO 10',
  `RCN_OPIS` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `RCN_DATA_RECENZJI` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`RCN_ID`) USING BTREE,
  INDEX `fk_Recenzje_Konta_1`(`RCN_KNT_ID`) USING BTREE,
  INDEX `fk_Recenzje_Filmy_1`(`RCN_FLM_ID`) USING BTREE,
  CONSTRAINT `fk_Recenzje_Filmy_1` FOREIGN KEY (`RCN_FLM_ID`) REFERENCES `Filmy` (`FLM_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_Recenzje_Konta_1` FOREIGN KEY (`RCN_KNT_ID`) REFERENCES `Konta` (`KNT_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 257 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of Recenzje
-- ----------------------------
INSERT INTO `Recenzje` VALUES (1, 1, 1, 10, 'Fajny', '2022-12-25 00:00:00');
INSERT INTO `Recenzje` VALUES (2, 2, 1, 7, 'Spoko', '2022-10-13 00:00:00');
INSERT INTO `Recenzje` VALUES (3, 3, 2, 10, 'Super', '2021-07-26 00:00:00');
INSERT INTO `Recenzje` VALUES (4, 101, 3, 4, 'Recenzja dla filmu 3', '2021-07-11 00:00:00');
INSERT INTO `Recenzje` VALUES (5, 6, 3, 1, 'Recenzja dla filmu 2', '2022-03-29 00:00:00');
INSERT INTO `Recenzje` VALUES (6, 69, 3, 2, 'Recenzja dla filmu 1', '2023-03-26 00:00:00');
INSERT INTO `Recenzje` VALUES (7, 121, 1, 2, 'Recenzja dla filmu 1', '2023-04-29 00:00:00');
INSERT INTO `Recenzje` VALUES (8, 63, 1, 4, 'Recenzja dla filmu 3', '2020-10-27 00:00:00');
INSERT INTO `Recenzje` VALUES (9, 23, 1, 3, 'Recenzja dla filmu 2', '2021-08-07 00:00:00');
INSERT INTO `Recenzje` VALUES (10, 64, 2, 2, 'Recenzja dla filmu 1', '2022-02-18 00:00:00');
INSERT INTO `Recenzje` VALUES (11, 58, 2, 3, 'Recenzja dla filmu 1', '2022-06-23 00:00:00');
INSERT INTO `Recenzje` VALUES (12, 58, 3, 3, 'Recenzja dla filmu 3', '2022-08-02 00:00:00');
INSERT INTO `Recenzje` VALUES (13, 45, 2, 3, 'Recenzja dla filmu 3', '2022-02-06 00:00:00');
INSERT INTO `Recenzje` VALUES (14, 27, 2, 4, 'Recenzja dla filmu 1', '2022-01-24 00:00:00');
INSERT INTO `Recenzje` VALUES (15, 27, 3, 3, 'Recenzja dla filmu 1', '2023-05-06 00:00:00');
INSERT INTO `Recenzje` VALUES (16, 7, 3, 1, 'Recenzja dla filmu 2', '2021-09-15 00:00:00');
INSERT INTO `Recenzje` VALUES (17, 70, 3, 5, 'Recenzja dla filmu 1', '2023-03-31 00:00:00');
INSERT INTO `Recenzje` VALUES (18, 123, 3, 5, 'Recenzja dla filmu 1', '2022-04-13 00:00:00');
INSERT INTO `Recenzje` VALUES (19, 106, 1, 5, 'Recenzja dla filmu 1', '2020-12-29 00:00:00');
INSERT INTO `Recenzje` VALUES (20, 127, 3, 4, 'Recenzja dla filmu 2', '2022-11-16 00:00:00');
INSERT INTO `Recenzje` VALUES (21, 128, 1, 1, 'Recenzja dla filmu 2', '2022-07-30 00:00:00');
INSERT INTO `Recenzje` VALUES (22, 44, 1, 3, 'Recenzja dla filmu 3', '2020-11-09 00:00:00');
INSERT INTO `Recenzje` VALUES (23, 111, 3, 2, 'Recenzja dla filmu 2', '2021-04-19 00:00:00');
INSERT INTO `Recenzje` VALUES (24, 40, 2, 1, 'Recenzja dla filmu 2', '2023-03-31 00:00:00');
INSERT INTO `Recenzje` VALUES (25, 26, 2, 5, 'Recenzja dla filmu 2', '2020-10-18 00:00:00');
INSERT INTO `Recenzje` VALUES (26, 49, 2, 4, 'Recenzja dla filmu 2', '2021-09-15 00:00:00');
INSERT INTO `Recenzje` VALUES (27, 14, 1, 4, 'Recenzja dla filmu 3', '2022-10-02 00:00:00');
INSERT INTO `Recenzje` VALUES (28, 87, 1, 2, 'Recenzja dla filmu 1', '2022-07-11 00:00:00');
INSERT INTO `Recenzje` VALUES (29, 7, 1, 2, 'Recenzja dla filmu 1', '2020-12-23 00:00:00');
INSERT INTO `Recenzje` VALUES (30, 63, 1, 4, 'Recenzja dla filmu 1', '2022-01-24 00:00:00');
INSERT INTO `Recenzje` VALUES (31, 59, 2, 2, 'Recenzja dla filmu 3', '2021-04-13 00:00:00');
INSERT INTO `Recenzje` VALUES (32, 65, 2, 3, 'Recenzja dla filmu 3', '2022-03-31 00:00:00');
INSERT INTO `Recenzje` VALUES (33, 64, 3, 5, 'Recenzja dla filmu 1', '2021-04-12 00:00:00');
INSERT INTO `Recenzje` VALUES (34, 82, 2, 1, 'Recenzja dla filmu 1', '2021-09-10 00:00:00');
INSERT INTO `Recenzje` VALUES (35, 90, 1, 3, 'Recenzja dla filmu 1', '2021-03-23 00:00:00');
INSERT INTO `Recenzje` VALUES (36, 50, 2, 1, 'Recenzja dla filmu 2', '2023-01-28 00:00:00');
INSERT INTO `Recenzje` VALUES (37, 80, 1, 2, 'Recenzja dla filmu 2', '2022-11-21 00:00:00');
INSERT INTO `Recenzje` VALUES (38, 47, 3, 2, 'Recenzja dla filmu 3', '2021-10-28 00:00:00');
INSERT INTO `Recenzje` VALUES (39, 106, 1, 3, 'Recenzja dla filmu 2', '2022-06-25 00:00:00');
INSERT INTO `Recenzje` VALUES (40, 11, 2, 4, 'Recenzja dla filmu 3', '2020-10-31 00:00:00');
INSERT INTO `Recenzje` VALUES (41, 44, 3, 5, 'Recenzja dla filmu 3', '2021-06-19 00:00:00');
INSERT INTO `Recenzje` VALUES (42, 73, 1, 1, 'Recenzja dla filmu 1', '2021-06-09 00:00:00');
INSERT INTO `Recenzje` VALUES (43, 29, 1, 5, 'Recenzja dla filmu 2', '2022-02-09 00:00:00');
INSERT INTO `Recenzje` VALUES (44, 45, 3, 4, 'Recenzja dla filmu 1', '2022-11-01 00:00:00');
INSERT INTO `Recenzje` VALUES (45, 94, 1, 4, 'Recenzja dla filmu 3', '2021-09-27 00:00:00');
INSERT INTO `Recenzje` VALUES (46, 107, 3, 3, 'Recenzja dla filmu 3', '2022-03-25 00:00:00');
INSERT INTO `Recenzje` VALUES (47, 52, 1, 3, 'Recenzja dla filmu 1', '2022-07-12 00:00:00');
INSERT INTO `Recenzje` VALUES (48, 88, 3, 4, 'Recenzja dla filmu 3', '2022-07-22 00:00:00');
INSERT INTO `Recenzje` VALUES (49, 20, 1, 3, 'Recenzja dla filmu 1', '2021-10-19 00:00:00');
INSERT INTO `Recenzje` VALUES (50, 122, 3, 2, 'Recenzja dla filmu 3', '2023-05-15 00:00:00');
INSERT INTO `Recenzje` VALUES (51, 23, 1, 4, 'Recenzja dla filmu 3', '2022-08-13 00:00:00');
INSERT INTO `Recenzje` VALUES (52, 115, 3, 4, 'Recenzja dla filmu 1', '2022-04-17 00:00:00');
INSERT INTO `Recenzje` VALUES (53, 57, 3, 5, 'Recenzja dla filmu 1', '2022-12-08 00:00:00');
INSERT INTO `Recenzje` VALUES (54, 20, 1, 3, 'Recenzja dla filmu 2', '2021-09-12 00:00:00');
INSERT INTO `Recenzje` VALUES (55, 119, 2, 2, 'Recenzja dla filmu 2', '2021-09-18 00:00:00');
INSERT INTO `Recenzje` VALUES (56, 55, 2, 1, 'Recenzja dla filmu 1', '2022-10-17 00:00:00');
INSERT INTO `Recenzje` VALUES (57, 92, 3, 4, 'Recenzja dla filmu 1', '2022-09-19 00:00:00');
INSERT INTO `Recenzje` VALUES (58, 72, 3, 1, 'Recenzja dla filmu 3', '2021-10-23 00:00:00');
INSERT INTO `Recenzje` VALUES (59, 29, 3, 1, 'Recenzja dla filmu 1', '2022-12-09 00:00:00');
INSERT INTO `Recenzje` VALUES (60, 41, 1, 5, 'Recenzja dla filmu 2', '2023-02-24 00:00:00');
INSERT INTO `Recenzje` VALUES (61, 43, 3, 1, 'Recenzja dla filmu 1', '2020-10-28 00:00:00');
INSERT INTO `Recenzje` VALUES (62, 112, 3, 4, 'Recenzja dla filmu 1', '2022-02-17 00:00:00');
INSERT INTO `Recenzje` VALUES (63, 14, 3, 2, 'Recenzja dla filmu 1', '2022-01-28 00:00:00');
INSERT INTO `Recenzje` VALUES (64, 18, 1, 4, 'Recenzja dla filmu 1', '2023-04-22 00:00:00');
INSERT INTO `Recenzje` VALUES (65, 1, 2, 4, 'Recenzja dla filmu 1', '2021-06-24 00:00:00');
INSERT INTO `Recenzje` VALUES (66, 33, 2, 5, 'Recenzja dla filmu 3', '2022-03-21 00:00:00');
INSERT INTO `Recenzje` VALUES (67, 48, 2, 5, 'Recenzja dla filmu 3', '2023-04-07 00:00:00');
INSERT INTO `Recenzje` VALUES (68, 2, 2, 1, 'Recenzja dla filmu 2', '2020-11-06 00:00:00');
INSERT INTO `Recenzje` VALUES (69, 12, 2, 1, 'Recenzja dla filmu 1', '2021-12-01 00:00:00');
INSERT INTO `Recenzje` VALUES (70, 41, 2, 5, 'Recenzja dla filmu 2', '2020-12-02 00:00:00');
INSERT INTO `Recenzje` VALUES (71, 6, 1, 2, 'Recenzja dla filmu 3', '2020-11-19 00:00:00');
INSERT INTO `Recenzje` VALUES (72, 4, 3, 1, 'Recenzja dla filmu 1', '2020-12-26 00:00:00');
INSERT INTO `Recenzje` VALUES (73, 32, 1, 3, 'Recenzja dla filmu 2', '2021-08-03 00:00:00');
INSERT INTO `Recenzje` VALUES (74, 50, 1, 1, 'Recenzja dla filmu 3', '2021-08-06 00:00:00');
INSERT INTO `Recenzje` VALUES (75, 5, 1, 1, 'Recenzja dla filmu 2', '2022-07-13 00:00:00');
INSERT INTO `Recenzje` VALUES (76, 29, 2, 3, 'Recenzja dla filmu 2', '2021-10-02 00:00:00');
INSERT INTO `Recenzje` VALUES (77, 6, 2, 4, 'Recenzja dla filmu 1', '2023-03-17 00:00:00');
INSERT INTO `Recenzje` VALUES (78, 75, 2, 4, 'Recenzja dla filmu 3', '2021-12-15 00:00:00');
INSERT INTO `Recenzje` VALUES (79, 48, 3, 3, 'Recenzja dla filmu 3', '2022-03-11 00:00:00');
INSERT INTO `Recenzje` VALUES (80, 51, 1, 2, 'Recenzja dla filmu 1', '2021-09-11 00:00:00');
INSERT INTO `Recenzje` VALUES (81, 21, 3, 4, 'Recenzja dla filmu 2', '2021-03-24 00:00:00');
INSERT INTO `Recenzje` VALUES (82, 117, 1, 3, 'Recenzja dla filmu 3', '2023-01-27 00:00:00');
INSERT INTO `Recenzje` VALUES (83, 106, 3, 1, 'Recenzja dla filmu 1', '2022-11-12 00:00:00');
INSERT INTO `Recenzje` VALUES (84, 32, 1, 2, 'Recenzja dla filmu 1', '2021-09-18 00:00:00');
INSERT INTO `Recenzje` VALUES (85, 15, 3, 5, 'Recenzja dla filmu 2', '2022-01-03 00:00:00');
INSERT INTO `Recenzje` VALUES (86, 56, 2, 4, 'Recenzja dla filmu 2', '2021-07-03 00:00:00');
INSERT INTO `Recenzje` VALUES (87, 6, 3, 2, 'Recenzja dla filmu 1', '2020-10-25 00:00:00');
INSERT INTO `Recenzje` VALUES (88, 10, 2, 1, 'Recenzja dla filmu 1', '2021-08-09 00:00:00');
INSERT INTO `Recenzje` VALUES (89, 85, 1, 4, 'Recenzja dla filmu 1', '2022-03-05 00:00:00');
INSERT INTO `Recenzje` VALUES (90, 72, 3, 5, 'Recenzja dla filmu 3', '2022-08-29 00:00:00');
INSERT INTO `Recenzje` VALUES (91, 89, 1, 3, 'Recenzja dla filmu 2', '2023-05-22 00:00:00');
INSERT INTO `Recenzje` VALUES (92, 78, 3, 1, 'Recenzja dla filmu 2', '2022-11-08 00:00:00');
INSERT INTO `Recenzje` VALUES (93, 61, 1, 2, 'Recenzja dla filmu 1', '2020-09-13 00:00:00');
INSERT INTO `Recenzje` VALUES (94, 12, 3, 5, 'Recenzja dla filmu 3', '2022-06-01 00:00:00');
INSERT INTO `Recenzje` VALUES (95, 47, 2, 3, 'Recenzja dla filmu 1', '2021-02-21 00:00:00');
INSERT INTO `Recenzje` VALUES (96, 28, 2, 1, 'Recenzja dla filmu 2', '2023-03-20 00:00:00');
INSERT INTO `Recenzje` VALUES (97, 106, 3, 3, 'Recenzja dla filmu 3', '2021-02-12 00:00:00');
INSERT INTO `Recenzje` VALUES (98, 79, 1, 3, 'Recenzja dla filmu 3', '2020-09-06 00:00:00');
INSERT INTO `Recenzje` VALUES (99, 118, 3, 2, 'Recenzja dla filmu 1', '2022-02-05 00:00:00');
INSERT INTO `Recenzje` VALUES (100, 76, 3, 5, 'Recenzja dla filmu 2', '2022-05-01 00:00:00');
INSERT INTO `Recenzje` VALUES (101, 15, 3, 1, 'Recenzja dla filmu 3', '2021-12-20 00:00:00');
INSERT INTO `Recenzje` VALUES (102, 74, 2, 5, 'Recenzja dla filmu 2', '2022-03-05 00:00:00');
INSERT INTO `Recenzje` VALUES (103, 127, 1, 1, 'Recenzja dla filmu 1', '2021-07-25 00:00:00');
INSERT INTO `Recenzje` VALUES (104, 50, 2, 2, 'Recenzja dla filmu 3', '2023-05-03 00:00:00');
INSERT INTO `Recenzje` VALUES (105, 57, 3, 1, 'Recenzja dla filmu 2', '2023-03-01 00:00:00');
INSERT INTO `Recenzje` VALUES (106, 65, 1, 2, 'Recenzja dla filmu 3', '2022-06-02 00:00:00');
INSERT INTO `Recenzje` VALUES (107, 53, 1, 4, 'Recenzja dla filmu 3', '2021-11-30 00:00:00');
INSERT INTO `Recenzje` VALUES (108, 112, 2, 3, 'Recenzja dla filmu 3', '2021-08-23 00:00:00');
INSERT INTO `Recenzje` VALUES (109, 71, 1, 1, 'Recenzja dla filmu 1', '2021-10-14 00:00:00');
INSERT INTO `Recenzje` VALUES (110, 126, 2, 5, 'Recenzja dla filmu 1', '2023-04-28 00:00:00');
INSERT INTO `Recenzje` VALUES (111, 113, 3, 3, 'Recenzja dla filmu 1', '2022-06-05 00:00:00');
INSERT INTO `Recenzje` VALUES (112, 8, 3, 3, 'Recenzja dla filmu 1', '2021-06-26 00:00:00');
INSERT INTO `Recenzje` VALUES (113, 101, 2, 5, 'Recenzja dla filmu 2', '2022-03-07 00:00:00');
INSERT INTO `Recenzje` VALUES (114, 27, 3, 4, 'Recenzja dla filmu 1', '2023-01-19 00:00:00');
INSERT INTO `Recenzje` VALUES (115, 25, 2, 3, 'Recenzja dla filmu 2', '2022-08-11 00:00:00');
INSERT INTO `Recenzje` VALUES (116, 53, 3, 1, 'Recenzja dla filmu 3', '2023-03-20 00:00:00');
INSERT INTO `Recenzje` VALUES (117, 42, 1, 2, 'Recenzja dla filmu 2', '2022-02-18 00:00:00');
INSERT INTO `Recenzje` VALUES (118, 118, 2, 2, 'Recenzja dla filmu 2', '2023-01-22 00:00:00');
INSERT INTO `Recenzje` VALUES (119, 92, 2, 5, 'Recenzja dla filmu 2', '2022-10-13 00:00:00');
INSERT INTO `Recenzje` VALUES (120, 38, 1, 3, 'Recenzja dla filmu 3', '2021-05-05 00:00:00');
INSERT INTO `Recenzje` VALUES (121, 48, 1, 3, 'Recenzja dla filmu 2', '2023-02-10 00:00:00');
INSERT INTO `Recenzje` VALUES (122, 33, 3, 4, 'Recenzja dla filmu 2', '2022-09-14 00:00:00');
INSERT INTO `Recenzje` VALUES (123, 107, 2, 5, 'Recenzja dla filmu 2', '2020-10-13 00:00:00');
INSERT INTO `Recenzje` VALUES (124, 88, 1, 1, 'Recenzja dla filmu 2', '2023-04-12 00:00:00');
INSERT INTO `Recenzje` VALUES (125, 112, 1, 4, 'Recenzja dla filmu 1', '2022-07-01 00:00:00');
INSERT INTO `Recenzje` VALUES (126, 6, 2, 1, 'Recenzja dla filmu 2', '2021-12-24 00:00:00');
INSERT INTO `Recenzje` VALUES (127, 25, 2, 5, 'Recenzja dla filmu 2', '2021-09-19 00:00:00');
INSERT INTO `Recenzje` VALUES (128, 17, 3, 5, 'Recenzja dla filmu 1', '2021-12-21 00:00:00');
INSERT INTO `Recenzje` VALUES (131, 64, 1, 4, 'Recenzja dla filmu 3', '2021-04-26 00:00:00');
INSERT INTO `Recenzje` VALUES (132, 32, 1, 2, 'Recenzja dla filmu 1', '2022-09-12 00:00:00');
INSERT INTO `Recenzje` VALUES (133, 97, 2, 1, 'Recenzja dla filmu 1', '2020-09-17 00:00:00');
INSERT INTO `Recenzje` VALUES (134, 117, 2, 6, 'Recenzja dla filmu 1', '2022-12-06 00:00:00');
INSERT INTO `Recenzje` VALUES (135, 8, 3, 0, 'Recenzja dla filmu 1', '2020-12-22 00:00:00');
INSERT INTO `Recenzje` VALUES (136, 112, 2, 7, 'Recenzja dla filmu 1', '2020-11-01 00:00:00');
INSERT INTO `Recenzje` VALUES (137, 124, 2, 4, 'Recenzja dla filmu 1', '2023-04-13 00:00:00');
INSERT INTO `Recenzje` VALUES (138, 15, 2, 0, 'Recenzja dla filmu 2', '2022-05-14 00:00:00');
INSERT INTO `Recenzje` VALUES (139, 63, 3, 8, 'Recenzja dla filmu 1', '2021-04-21 00:00:00');
INSERT INTO `Recenzje` VALUES (140, 34, 2, 2, 'Recenzja dla filmu 3', '2021-06-14 00:00:00');
INSERT INTO `Recenzje` VALUES (141, 14, 1, 2, 'Recenzja dla filmu 2', '2022-08-31 00:00:00');
INSERT INTO `Recenzje` VALUES (142, 99, 2, 5, 'Recenzja dla filmu 2', '2022-11-11 00:00:00');
INSERT INTO `Recenzje` VALUES (143, 25, 1, 5, 'Recenzja dla filmu 3', '2022-12-03 00:00:00');
INSERT INTO `Recenzje` VALUES (144, 75, 1, 8, 'Recenzja dla filmu 1', '2022-08-16 00:00:00');
INSERT INTO `Recenzje` VALUES (145, 30, 2, 6, 'Recenzja dla filmu 3', '2020-12-18 00:00:00');
INSERT INTO `Recenzje` VALUES (146, 81, 3, 3, 'Recenzja dla filmu 3', '2021-09-12 00:00:00');
INSERT INTO `Recenzje` VALUES (147, 31, 3, 9, 'Recenzja dla filmu 2', '2022-03-16 00:00:00');
INSERT INTO `Recenzje` VALUES (148, 95, 3, 6, 'Recenzja dla filmu 2', '2022-07-13 00:00:00');
INSERT INTO `Recenzje` VALUES (149, 27, 1, 1, 'Recenzja dla filmu 2', '2022-08-22 00:00:00');
INSERT INTO `Recenzje` VALUES (150, 20, 3, 7, 'Recenzja dla filmu 2', '2022-03-21 00:00:00');
INSERT INTO `Recenzje` VALUES (151, 37, 1, 3, 'Recenzja dla filmu 3', '2022-06-30 00:00:00');
INSERT INTO `Recenzje` VALUES (152, 94, 1, 5, 'Recenzja dla filmu 1', '2022-06-03 00:00:00');
INSERT INTO `Recenzje` VALUES (153, 42, 2, 9, 'Recenzja dla filmu 3', '2021-03-25 00:00:00');
INSERT INTO `Recenzje` VALUES (154, 17, 3, 1, 'Recenzja dla filmu 2', '2020-11-29 00:00:00');
INSERT INTO `Recenzje` VALUES (155, 100, 2, 3, 'Recenzja dla filmu 3', '2022-11-27 00:00:00');
INSERT INTO `Recenzje` VALUES (156, 14, 3, 5, 'Recenzja dla filmu 2', '2022-12-22 00:00:00');
INSERT INTO `Recenzje` VALUES (157, 7, 1, 4, 'Recenzja dla filmu 1', '2022-10-04 00:00:00');
INSERT INTO `Recenzje` VALUES (158, 59, 2, 1, 'Recenzja dla filmu 1', '2021-06-19 00:00:00');
INSERT INTO `Recenzje` VALUES (159, 12, 3, 8, 'Recenzja dla filmu 1', '2021-02-04 00:00:00');
INSERT INTO `Recenzje` VALUES (160, 87, 3, 6, 'Recenzja dla filmu 3', '2023-02-10 00:00:00');
INSERT INTO `Recenzje` VALUES (161, 63, 3, 1, 'Recenzja dla filmu 3', '2020-09-23 00:00:00');
INSERT INTO `Recenzje` VALUES (162, 53, 2, 2, 'Recenzja dla filmu 3', '2021-10-08 00:00:00');
INSERT INTO `Recenzje` VALUES (163, 58, 2, 10, 'Recenzja dla filmu 3', '2023-04-08 00:00:00');
INSERT INTO `Recenzje` VALUES (164, 40, 3, 4, 'Recenzja dla filmu 3', '2022-03-16 00:00:00');
INSERT INTO `Recenzje` VALUES (165, 111, 3, 1, 'Recenzja dla filmu 2', '2023-04-05 00:00:00');
INSERT INTO `Recenzje` VALUES (166, 91, 1, 1, 'Recenzja dla filmu 1', '2020-11-10 00:00:00');
INSERT INTO `Recenzje` VALUES (167, 117, 2, 2, 'Recenzja dla filmu 3', '2021-12-25 00:00:00');
INSERT INTO `Recenzje` VALUES (168, 19, 1, 4, 'Recenzja dla filmu 3', '2021-03-25 00:00:00');
INSERT INTO `Recenzje` VALUES (169, 50, 2, 3, 'Recenzja dla filmu 2', '2022-03-26 00:00:00');
INSERT INTO `Recenzje` VALUES (170, 20, 3, 7, 'Recenzja dla filmu 1', '2021-05-11 00:00:00');
INSERT INTO `Recenzje` VALUES (171, 54, 3, 3, 'Recenzja dla filmu 3', '2022-02-19 00:00:00');
INSERT INTO `Recenzje` VALUES (172, 59, 3, 0, 'Recenzja dla filmu 1', '2023-03-18 00:00:00');
INSERT INTO `Recenzje` VALUES (173, 127, 2, 1, 'Recenzja dla filmu 3', '2020-10-27 00:00:00');
INSERT INTO `Recenzje` VALUES (174, 65, 3, 8, 'Recenzja dla filmu 3', '2021-12-07 00:00:00');
INSERT INTO `Recenzje` VALUES (175, 9, 1, 7, 'Recenzja dla filmu 1', '2021-02-06 00:00:00');
INSERT INTO `Recenzje` VALUES (176, 53, 3, 7, 'Recenzja dla filmu 3', '2021-09-26 00:00:00');
INSERT INTO `Recenzje` VALUES (177, 56, 3, 8, 'Recenzja dla filmu 1', '2021-12-26 00:00:00');
INSERT INTO `Recenzje` VALUES (178, 79, 2, 10, 'Recenzja dla filmu 1', '2021-04-26 00:00:00');
INSERT INTO `Recenzje` VALUES (179, 96, 2, 7, 'Recenzja dla filmu 2', '2022-08-30 00:00:00');
INSERT INTO `Recenzje` VALUES (180, 28, 1, 3, 'Recenzja dla filmu 1', '2023-04-05 00:00:00');
INSERT INTO `Recenzje` VALUES (181, 108, 3, 2, 'Recenzja dla filmu 1', '2022-03-11 00:00:00');
INSERT INTO `Recenzje` VALUES (182, 116, 1, 9, 'Recenzja dla filmu 1', '2023-03-21 00:00:00');
INSERT INTO `Recenzje` VALUES (183, 59, 2, 8, 'Recenzja dla filmu 2', '2020-09-08 00:00:00');
INSERT INTO `Recenzje` VALUES (184, 126, 2, 10, 'Recenzja dla filmu 3', '2021-03-30 00:00:00');
INSERT INTO `Recenzje` VALUES (185, 12, 2, 7, 'Recenzja dla filmu 2', '2020-10-06 00:00:00');
INSERT INTO `Recenzje` VALUES (186, 10, 2, 0, 'Recenzja dla filmu 3', '2022-02-16 00:00:00');
INSERT INTO `Recenzje` VALUES (187, 74, 2, 9, 'Recenzja dla filmu 2', '2022-03-28 00:00:00');
INSERT INTO `Recenzje` VALUES (188, 63, 1, 5, 'Recenzja dla filmu 1', '2021-05-29 00:00:00');
INSERT INTO `Recenzje` VALUES (189, 23, 1, 5, 'Recenzja dla filmu 1', '2022-05-11 00:00:00');
INSERT INTO `Recenzje` VALUES (190, 82, 2, 6, 'Recenzja dla filmu 2', '2021-06-19 00:00:00');
INSERT INTO `Recenzje` VALUES (191, 125, 3, 4, 'Recenzja dla filmu 3', '2022-04-12 00:00:00');
INSERT INTO `Recenzje` VALUES (192, 52, 3, 7, 'Recenzja dla filmu 1', '2020-11-22 00:00:00');
INSERT INTO `Recenzje` VALUES (193, 102, 3, 7, 'Recenzja dla filmu 3', '2022-05-15 00:00:00');
INSERT INTO `Recenzje` VALUES (194, 87, 3, 2, 'Recenzja dla filmu 1', '2023-01-22 00:00:00');
INSERT INTO `Recenzje` VALUES (195, 103, 2, 10, 'Recenzja dla filmu 3', '2022-01-31 00:00:00');
INSERT INTO `Recenzje` VALUES (196, 85, 3, 7, 'Recenzja dla filmu 3', '2023-04-10 00:00:00');
INSERT INTO `Recenzje` VALUES (197, 34, 2, 5, 'Recenzja dla filmu 1', '2021-04-16 00:00:00');
INSERT INTO `Recenzje` VALUES (198, 117, 2, 7, 'Recenzja dla filmu 1', '2021-05-18 00:00:00');
INSERT INTO `Recenzje` VALUES (199, 26, 2, 1, 'Recenzja dla filmu 2', '2022-05-03 00:00:00');
INSERT INTO `Recenzje` VALUES (200, 89, 2, 4, 'Recenzja dla filmu 2', '2021-06-11 00:00:00');
INSERT INTO `Recenzje` VALUES (201, 78, 1, 2, 'Recenzja dla filmu 3', '2022-03-29 00:00:00');
INSERT INTO `Recenzje` VALUES (202, 50, 1, 2, 'Recenzja dla filmu 3', '2020-10-04 00:00:00');
INSERT INTO `Recenzje` VALUES (203, 68, 1, 9, 'Recenzja dla filmu 1', '2021-10-27 00:00:00');
INSERT INTO `Recenzje` VALUES (204, 72, 2, 2, 'Recenzja dla filmu 2', '2020-09-20 00:00:00');
INSERT INTO `Recenzje` VALUES (205, 28, 3, 6, 'Recenzja dla filmu 1', '2022-11-20 00:00:00');
INSERT INTO `Recenzje` VALUES (206, 63, 2, 6, 'Recenzja dla filmu 3', '2020-09-25 00:00:00');
INSERT INTO `Recenzje` VALUES (207, 38, 2, 4, 'Recenzja dla filmu 3', '2022-06-21 00:00:00');
INSERT INTO `Recenzje` VALUES (208, 19, 2, 10, 'Recenzja dla filmu 2', '2021-04-29 00:00:00');
INSERT INTO `Recenzje` VALUES (209, 18, 2, 9, 'Recenzja dla filmu 1', '2021-04-02 00:00:00');
INSERT INTO `Recenzje` VALUES (210, 5, 2, 6, 'Recenzja dla filmu 3', '2021-08-08 00:00:00');
INSERT INTO `Recenzje` VALUES (211, 87, 1, 10, 'Recenzja dla filmu 2', '2020-11-11 00:00:00');
INSERT INTO `Recenzje` VALUES (212, 70, 1, 0, 'Recenzja dla filmu 1', '2021-07-14 00:00:00');
INSERT INTO `Recenzje` VALUES (213, 127, 3, 0, 'Recenzja dla filmu 2', '2021-09-10 00:00:00');
INSERT INTO `Recenzje` VALUES (214, 91, 3, 9, 'Recenzja dla filmu 1', '2023-03-08 00:00:00');
INSERT INTO `Recenzje` VALUES (215, 107, 2, 9, 'Recenzja dla filmu 1', '2022-01-03 00:00:00');
INSERT INTO `Recenzje` VALUES (216, 26, 2, 4, 'Recenzja dla filmu 3', '2022-07-13 00:00:00');
INSERT INTO `Recenzje` VALUES (217, 100, 3, 0, 'Recenzja dla filmu 2', '2023-03-24 00:00:00');
INSERT INTO `Recenzje` VALUES (218, 118, 3, 10, 'Recenzja dla filmu 1', '2022-06-08 00:00:00');
INSERT INTO `Recenzje` VALUES (219, 81, 3, 0, 'Recenzja dla filmu 1', '2021-10-24 00:00:00');
INSERT INTO `Recenzje` VALUES (220, 76, 3, 9, 'Recenzja dla filmu 1', '2021-01-28 00:00:00');
INSERT INTO `Recenzje` VALUES (221, 28, 1, 2, 'Recenzja dla filmu 2', '2021-12-25 00:00:00');
INSERT INTO `Recenzje` VALUES (222, 2, 2, 3, 'Recenzja dla filmu 2', '2023-04-15 00:00:00');
INSERT INTO `Recenzje` VALUES (223, 97, 2, 1, 'Recenzja dla filmu 1', '2021-08-30 00:00:00');
INSERT INTO `Recenzje` VALUES (224, 52, 3, 0, 'Recenzja dla filmu 1', '2023-03-13 00:00:00');
INSERT INTO `Recenzje` VALUES (225, 20, 3, 6, 'Recenzja dla filmu 2', '2022-03-04 00:00:00');
INSERT INTO `Recenzje` VALUES (226, 117, 3, 4, 'Recenzja dla filmu 1', '2023-04-22 00:00:00');
INSERT INTO `Recenzje` VALUES (227, 51, 1, 3, 'Recenzja dla filmu 2', '2021-03-09 00:00:00');
INSERT INTO `Recenzje` VALUES (228, 76, 1, 0, 'Recenzja dla filmu 1', '2020-10-08 00:00:00');
INSERT INTO `Recenzje` VALUES (229, 41, 1, 9, 'Recenzja dla filmu 1', '2022-04-25 00:00:00');
INSERT INTO `Recenzje` VALUES (230, 26, 3, 7, 'Recenzja dla filmu 2', '2023-02-26 00:00:00');
INSERT INTO `Recenzje` VALUES (231, 19, 3, 5, 'Recenzja dla filmu 2', '2022-09-21 00:00:00');
INSERT INTO `Recenzje` VALUES (232, 35, 1, 2, 'Recenzja dla filmu 3', '2020-10-02 00:00:00');
INSERT INTO `Recenzje` VALUES (233, 57, 1, 6, 'Recenzja dla filmu 2', '2023-01-24 00:00:00');
INSERT INTO `Recenzje` VALUES (234, 39, 1, 10, 'Recenzja dla filmu 1', '2021-07-12 00:00:00');
INSERT INTO `Recenzje` VALUES (235, 50, 2, 2, 'Recenzja dla filmu 1', '2023-03-11 00:00:00');
INSERT INTO `Recenzje` VALUES (236, 62, 1, 7, 'Recenzja dla filmu 2', '2022-07-17 00:00:00');
INSERT INTO `Recenzje` VALUES (237, 73, 3, 3, 'Recenzja dla filmu 3', '2022-06-18 00:00:00');
INSERT INTO `Recenzje` VALUES (238, 41, 3, 3, 'Recenzja dla filmu 1', '2021-04-17 00:00:00');
INSERT INTO `Recenzje` VALUES (239, 35, 3, 3, 'Recenzja dla filmu 1', '2021-02-09 00:00:00');
INSERT INTO `Recenzje` VALUES (240, 25, 1, 0, 'Recenzja dla filmu 3', '2020-12-26 00:00:00');
INSERT INTO `Recenzje` VALUES (241, 12, 1, 10, 'Recenzja dla filmu 2', '2020-12-01 00:00:00');
INSERT INTO `Recenzje` VALUES (242, 8, 2, 0, 'Recenzja dla filmu 2', '2020-12-14 00:00:00');
INSERT INTO `Recenzje` VALUES (243, 58, 2, 3, 'Recenzja dla filmu 3', '2021-05-01 00:00:00');
INSERT INTO `Recenzje` VALUES (244, 108, 1, 1, 'Recenzja dla filmu 1', '2023-02-10 00:00:00');
INSERT INTO `Recenzje` VALUES (245, 51, 1, 5, 'Recenzja dla filmu 2', '2022-09-29 00:00:00');
INSERT INTO `Recenzje` VALUES (246, 39, 3, 0, 'Recenzja dla filmu 3', '2020-12-30 00:00:00');
INSERT INTO `Recenzje` VALUES (247, 108, 1, 5, 'Recenzja dla filmu 3', '2021-07-01 00:00:00');
INSERT INTO `Recenzje` VALUES (248, 88, 3, 0, 'Recenzja dla filmu 1', '2021-02-06 00:00:00');
INSERT INTO `Recenzje` VALUES (249, 69, 2, 2, 'Recenzja dla filmu 3', '2023-01-19 00:00:00');
INSERT INTO `Recenzje` VALUES (250, 35, 2, 4, 'Recenzja dla filmu 3', '2023-02-15 00:00:00');
INSERT INTO `Recenzje` VALUES (251, 81, 3, 4, 'Recenzja dla filmu 2', '2023-01-29 00:00:00');
INSERT INTO `Recenzje` VALUES (252, 85, 2, 10, 'Recenzja dla filmu 1', '2022-08-14 00:00:00');
INSERT INTO `Recenzje` VALUES (253, 75, 3, 2, 'Recenzja dla filmu 1', '2023-03-07 00:00:00');
INSERT INTO `Recenzje` VALUES (254, 96, 1, 3, 'Recenzja dla filmu 2', '2021-12-06 00:00:00');
INSERT INTO `Recenzje` VALUES (255, 33, 3, 7, 'Recenzja dla filmu 1', '2022-02-26 00:00:00');

-- ----------------------------
-- Table structure for Recenzje Historyczne
-- ----------------------------
DROP TABLE IF EXISTS `Recenzje Historyczne`;
CREATE TABLE `Recenzje Historyczne`  (
  `RCH_ID` int(11) NOT NULL AUTO_INCREMENT,
  `RCH_KNT_ID` int(11) NULL DEFAULT NULL,
  `RCH_FLM_ID` int(11) NULL DEFAULT NULL,
  `RCH_OPIS` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `RCH_DATA_RECENZJI` datetime NOT NULL,
  PRIMARY KEY (`RCH_ID`, `RCH_DATA_RECENZJI`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 128 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic PARTITION BY RANGE (year(`RCH_DATA_RECENZJI`))
PARTITIONS 4
(PARTITION `p2020` VALUES LESS THAN (2021) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p2021` VALUES LESS THAN (2022) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p2022` VALUES LESS THAN (2023) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p2023` VALUES LESS THAN (MAXVALUE) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 )
;

-- ----------------------------
-- Records of Recenzje Historyczne
-- ----------------------------
INSERT INTO `Recenzje Historyczne` VALUES (3, 63, 1, 'Recenzja dla filmu 3', '2020-10-27 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (6, 106, 1, 'Recenzja dla filmu 1', '2020-12-29 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (7, 44, 1, 'Recenzja dla filmu 3', '2020-11-09 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (9, 26, 2, 'Recenzja dla filmu 2', '2020-10-18 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (11, 7, 1, 'Recenzja dla filmu 1', '2020-12-23 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (17, 11, 2, 'Recenzja dla filmu 3', '2020-10-31 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (25, 43, 3, 'Recenzja dla filmu 1', '2020-10-28 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (27, 2, 2, 'Recenzja dla filmu 2', '2020-11-06 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (29, 41, 2, 'Recenzja dla filmu 2', '2020-12-02 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (30, 6, 1, 'Recenzja dla filmu 3', '2020-11-19 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (31, 4, 3, 'Recenzja dla filmu 1', '2020-12-26 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (40, 6, 3, 'Recenzja dla filmu 1', '2020-10-25 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (42, 61, 1, 'Recenzja dla filmu 1', '2020-09-13 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (45, 79, 1, 'Recenzja dla filmu 3', '2020-09-06 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (53, 107, 2, 'Recenzja dla filmu 2', '2020-10-13 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (58, 97, 2, 'Recenzja dla filmu 1', '2020-09-17 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (59, 8, 3, 'Recenzja dla filmu 1', '2020-12-22 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (60, 112, 2, 'Recenzja dla filmu 1', '2020-11-01 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (63, 30, 2, 'Recenzja dla filmu 3', '2020-12-18 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (66, 17, 3, 'Recenzja dla filmu 2', '2020-11-29 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (69, 63, 3, 'Recenzja dla filmu 3', '2020-09-23 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (71, 91, 1, 'Recenzja dla filmu 1', '2020-11-10 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (75, 127, 2, 'Recenzja dla filmu 3', '2020-10-27 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (81, 59, 2, 'Recenzja dla filmu 2', '2020-09-08 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (83, 12, 2, 'Recenzja dla filmu 2', '2020-10-06 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (86, 52, 3, 'Recenzja dla filmu 1', '2020-11-22 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (90, 50, 1, 'Recenzja dla filmu 3', '2020-10-04 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (92, 72, 2, 'Recenzja dla filmu 2', '2020-09-20 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (93, 63, 2, 'Recenzja dla filmu 3', '2020-09-25 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (97, 87, 1, 'Recenzja dla filmu 2', '2020-11-11 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (105, 76, 1, 'Recenzja dla filmu 1', '2020-10-08 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (106, 35, 1, 'Recenzja dla filmu 3', '2020-10-02 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (110, 25, 1, 'Recenzja dla filmu 3', '2020-12-26 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (111, 12, 1, 'Recenzja dla filmu 2', '2020-12-01 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (112, 8, 2, 'Recenzja dla filmu 2', '2020-12-14 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (114, 39, 3, 'Recenzja dla filmu 3', '2020-12-30 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (1, 3, 2, 'Super', '2021-07-26 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (2, 101, 3, 'Recenzja dla filmu 3', '2021-07-11 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (4, 23, 1, 'Recenzja dla filmu 2', '2021-08-07 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (5, 7, 3, 'Recenzja dla filmu 2', '2021-09-15 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (8, 111, 3, 'Recenzja dla filmu 2', '2021-04-19 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (10, 49, 2, 'Recenzja dla filmu 2', '2021-09-15 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (12, 59, 2, 'Recenzja dla filmu 3', '2021-04-13 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (13, 64, 3, 'Recenzja dla filmu 1', '2021-04-12 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (14, 82, 2, 'Recenzja dla filmu 1', '2021-09-10 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (15, 90, 1, 'Recenzja dla filmu 1', '2021-03-23 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (16, 47, 3, 'Recenzja dla filmu 3', '2021-10-28 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (18, 44, 3, 'Recenzja dla filmu 3', '2021-06-19 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (19, 73, 1, 'Recenzja dla filmu 1', '2021-06-09 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (20, 94, 1, 'Recenzja dla filmu 3', '2021-09-27 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (21, 20, 1, 'Recenzja dla filmu 1', '2021-10-19 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (22, 20, 1, 'Recenzja dla filmu 2', '2021-09-12 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (23, 119, 2, 'Recenzja dla filmu 2', '2021-09-18 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (24, 72, 3, 'Recenzja dla filmu 3', '2021-10-23 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (26, 1, 2, 'Recenzja dla filmu 1', '2021-06-24 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (28, 12, 2, 'Recenzja dla filmu 1', '2021-12-01 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (32, 32, 1, 'Recenzja dla filmu 2', '2021-08-03 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (33, 50, 1, 'Recenzja dla filmu 3', '2021-08-06 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (34, 29, 2, 'Recenzja dla filmu 2', '2021-10-02 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (35, 75, 2, 'Recenzja dla filmu 3', '2021-12-15 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (36, 51, 1, 'Recenzja dla filmu 1', '2021-09-11 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (37, 21, 3, 'Recenzja dla filmu 2', '2021-03-24 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (38, 32, 1, 'Recenzja dla filmu 1', '2021-09-18 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (39, 56, 2, 'Recenzja dla filmu 2', '2021-07-03 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (41, 10, 2, 'Recenzja dla filmu 1', '2021-08-09 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (43, 47, 2, 'Recenzja dla filmu 1', '2021-02-21 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (44, 106, 3, 'Recenzja dla filmu 3', '2021-02-12 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (46, 15, 3, 'Recenzja dla filmu 3', '2021-12-20 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (47, 127, 1, 'Recenzja dla filmu 1', '2021-07-25 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (48, 53, 1, 'Recenzja dla filmu 3', '2021-11-30 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (49, 112, 2, 'Recenzja dla filmu 3', '2021-08-23 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (50, 71, 1, 'Recenzja dla filmu 1', '2021-10-14 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (51, 8, 3, 'Recenzja dla filmu 1', '2021-06-26 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (52, 38, 1, 'Recenzja dla filmu 3', '2021-05-05 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (54, 6, 2, 'Recenzja dla filmu 2', '2021-12-24 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (55, 25, 2, 'Recenzja dla filmu 2', '2021-09-19 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (56, 17, 3, 'Recenzja dla filmu 1', '2021-12-21 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (57, 64, 1, 'Recenzja dla filmu 3', '2021-04-26 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (61, 63, 3, 'Recenzja dla filmu 1', '2021-04-21 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (62, 34, 2, 'Recenzja dla filmu 3', '2021-06-14 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (64, 81, 3, 'Recenzja dla filmu 3', '2021-09-12 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (65, 42, 2, 'Recenzja dla filmu 3', '2021-03-25 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (67, 59, 2, 'Recenzja dla filmu 1', '2021-06-19 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (68, 12, 3, 'Recenzja dla filmu 1', '2021-02-04 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (70, 53, 2, 'Recenzja dla filmu 3', '2021-10-08 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (72, 117, 2, 'Recenzja dla filmu 3', '2021-12-25 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (73, 19, 1, 'Recenzja dla filmu 3', '2021-03-25 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (74, 20, 3, 'Recenzja dla filmu 1', '2021-05-11 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (76, 65, 3, 'Recenzja dla filmu 3', '2021-12-07 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (77, 9, 1, 'Recenzja dla filmu 1', '2021-02-06 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (78, 53, 3, 'Recenzja dla filmu 3', '2021-09-26 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (79, 56, 3, 'Recenzja dla filmu 1', '2021-12-26 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (80, 79, 2, 'Recenzja dla filmu 1', '2021-04-26 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (82, 126, 2, 'Recenzja dla filmu 3', '2021-03-30 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (84, 63, 1, 'Recenzja dla filmu 1', '2021-05-29 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (85, 82, 2, 'Recenzja dla filmu 2', '2021-06-19 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (87, 34, 2, 'Recenzja dla filmu 1', '2021-04-16 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (88, 117, 2, 'Recenzja dla filmu 1', '2021-05-18 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (89, 89, 2, 'Recenzja dla filmu 2', '2021-06-11 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (91, 68, 1, 'Recenzja dla filmu 1', '2021-10-27 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (94, 19, 2, 'Recenzja dla filmu 2', '2021-04-29 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (95, 18, 2, 'Recenzja dla filmu 1', '2021-04-02 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (96, 5, 2, 'Recenzja dla filmu 3', '2021-08-08 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (98, 70, 1, 'Recenzja dla filmu 1', '2021-07-14 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (99, 127, 3, 'Recenzja dla filmu 2', '2021-09-10 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (100, 81, 3, 'Recenzja dla filmu 1', '2021-10-24 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (101, 76, 3, 'Recenzja dla filmu 1', '2021-01-28 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (102, 28, 1, 'Recenzja dla filmu 2', '2021-12-25 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (103, 97, 2, 'Recenzja dla filmu 1', '2021-08-30 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (104, 51, 1, 'Recenzja dla filmu 2', '2021-03-09 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (107, 39, 1, 'Recenzja dla filmu 1', '2021-07-12 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (108, 41, 3, 'Recenzja dla filmu 1', '2021-04-17 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (109, 35, 3, 'Recenzja dla filmu 1', '2021-02-09 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (113, 58, 2, 'Recenzja dla filmu 3', '2021-05-01 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (115, 108, 1, 'Recenzja dla filmu 3', '2021-07-01 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (116, 88, 3, 'Recenzja dla filmu 1', '2021-02-06 00:00:00');
INSERT INTO `Recenzje Historyczne` VALUES (117, 96, 1, 'Recenzja dla filmu 2', '2021-12-06 00:00:00');

-- ----------------------------
-- Table structure for Recenzje_Historyczne_backup
-- ----------------------------
DROP TABLE IF EXISTS `Recenzje_Historyczne_backup`;
CREATE TABLE `Recenzje_Historyczne_backup`  (
  `RCH_ID` int(11) NOT NULL DEFAULT 0,
  `RCH_KNT_ID` int(11) NULL DEFAULT NULL,
  `RCH_FLM_ID` int(11) NULL DEFAULT NULL,
  `RCH_OPIS` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `RCH_DATA_RECENZJI` datetime NOT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic PARTITION BY SYSTEM_TIME (unix_timestamp(`row_end`))
PARTITIONS 2
(PARTITION `p_aktualnie` ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p_historia` ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 )
;

-- ----------------------------
-- Records of Recenzje_Historyczne_backup
-- ----------------------------
INSERT INTO `Recenzje_Historyczne_backup` VALUES (3, 63, 1, 'Recenzja dla filmu 3', '2020-10-27 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (6, 106, 1, 'Recenzja dla filmu 1', '2020-12-29 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (7, 44, 1, 'Recenzja dla filmu 3', '2020-11-09 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (9, 26, 2, 'Recenzja dla filmu 2', '2020-10-18 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (11, 7, 1, 'Recenzja dla filmu 1', '2020-12-23 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (17, 11, 2, 'Recenzja dla filmu 3', '2020-10-31 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (25, 43, 3, 'Recenzja dla filmu 1', '2020-10-28 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (27, 2, 2, 'Recenzja dla filmu 2', '2020-11-06 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (29, 41, 2, 'Recenzja dla filmu 2', '2020-12-02 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (30, 6, 1, 'Recenzja dla filmu 3', '2020-11-19 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (31, 4, 3, 'Recenzja dla filmu 1', '2020-12-26 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (40, 6, 3, 'Recenzja dla filmu 1', '2020-10-25 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (42, 61, 1, 'Recenzja dla filmu 1', '2020-09-13 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (45, 79, 1, 'Recenzja dla filmu 3', '2020-09-06 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (53, 107, 2, 'Recenzja dla filmu 2', '2020-10-13 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (58, 97, 2, 'Recenzja dla filmu 1', '2020-09-17 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (59, 8, 3, 'Recenzja dla filmu 1', '2020-12-22 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (60, 112, 2, 'Recenzja dla filmu 1', '2020-11-01 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (63, 30, 2, 'Recenzja dla filmu 3', '2020-12-18 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (66, 17, 3, 'Recenzja dla filmu 2', '2020-11-29 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (69, 63, 3, 'Recenzja dla filmu 3', '2020-09-23 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (71, 91, 1, 'Recenzja dla filmu 1', '2020-11-10 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (75, 127, 2, 'Recenzja dla filmu 3', '2020-10-27 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (81, 59, 2, 'Recenzja dla filmu 2', '2020-09-08 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (83, 12, 2, 'Recenzja dla filmu 2', '2020-10-06 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (86, 52, 3, 'Recenzja dla filmu 1', '2020-11-22 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (90, 50, 1, 'Recenzja dla filmu 3', '2020-10-04 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (92, 72, 2, 'Recenzja dla filmu 2', '2020-09-20 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (93, 63, 2, 'Recenzja dla filmu 3', '2020-09-25 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (97, 87, 1, 'Recenzja dla filmu 2', '2020-11-11 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (105, 76, 1, 'Recenzja dla filmu 1', '2020-10-08 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (106, 35, 1, 'Recenzja dla filmu 3', '2020-10-02 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (110, 25, 1, 'Recenzja dla filmu 3', '2020-12-26 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (111, 12, 1, 'Recenzja dla filmu 2', '2020-12-01 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (112, 8, 2, 'Recenzja dla filmu 2', '2020-12-14 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (114, 39, 3, 'Recenzja dla filmu 3', '2020-12-30 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (1, 3, 2, 'Super', '2021-07-26 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (2, 101, 3, 'Recenzja dla filmu 3', '2021-07-11 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (4, 23, 1, 'Recenzja dla filmu 2', '2021-08-07 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (5, 7, 3, 'Recenzja dla filmu 2', '2021-09-15 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (8, 111, 3, 'Recenzja dla filmu 2', '2021-04-19 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (10, 49, 2, 'Recenzja dla filmu 2', '2021-09-15 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (12, 59, 2, 'Recenzja dla filmu 3', '2021-04-13 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (13, 64, 3, 'Recenzja dla filmu 1', '2021-04-12 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (14, 82, 2, 'Recenzja dla filmu 1', '2021-09-10 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (15, 90, 1, 'Recenzja dla filmu 1', '2021-03-23 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (16, 47, 3, 'Recenzja dla filmu 3', '2021-10-28 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (18, 44, 3, 'Recenzja dla filmu 3', '2021-06-19 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (19, 73, 1, 'Recenzja dla filmu 1', '2021-06-09 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (20, 94, 1, 'Recenzja dla filmu 3', '2021-09-27 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (21, 20, 1, 'Recenzja dla filmu 1', '2021-10-19 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (22, 20, 1, 'Recenzja dla filmu 2', '2021-09-12 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (23, 119, 2, 'Recenzja dla filmu 2', '2021-09-18 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (24, 72, 3, 'Recenzja dla filmu 3', '2021-10-23 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (26, 1, 2, 'Recenzja dla filmu 1', '2021-06-24 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (28, 12, 2, 'Recenzja dla filmu 1', '2021-12-01 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (32, 32, 1, 'Recenzja dla filmu 2', '2021-08-03 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (33, 50, 1, 'Recenzja dla filmu 3', '2021-08-06 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (34, 29, 2, 'Recenzja dla filmu 2', '2021-10-02 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (35, 75, 2, 'Recenzja dla filmu 3', '2021-12-15 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (36, 51, 1, 'Recenzja dla filmu 1', '2021-09-11 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (37, 21, 3, 'Recenzja dla filmu 2', '2021-03-24 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (38, 32, 1, 'Recenzja dla filmu 1', '2021-09-18 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (39, 56, 2, 'Recenzja dla filmu 2', '2021-07-03 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (41, 10, 2, 'Recenzja dla filmu 1', '2021-08-09 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (43, 47, 2, 'Recenzja dla filmu 1', '2021-02-21 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (44, 106, 3, 'Recenzja dla filmu 3', '2021-02-12 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (46, 15, 3, 'Recenzja dla filmu 3', '2021-12-20 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (47, 127, 1, 'Recenzja dla filmu 1', '2021-07-25 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (48, 53, 1, 'Recenzja dla filmu 3', '2021-11-30 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (49, 112, 2, 'Recenzja dla filmu 3', '2021-08-23 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (50, 71, 1, 'Recenzja dla filmu 1', '2021-10-14 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (51, 8, 3, 'Recenzja dla filmu 1', '2021-06-26 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (52, 38, 1, 'Recenzja dla filmu 3', '2021-05-05 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (54, 6, 2, 'Recenzja dla filmu 2', '2021-12-24 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (55, 25, 2, 'Recenzja dla filmu 2', '2021-09-19 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (56, 17, 3, 'Recenzja dla filmu 1', '2021-12-21 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (57, 64, 1, 'Recenzja dla filmu 3', '2021-04-26 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (61, 63, 3, 'Recenzja dla filmu 1', '2021-04-21 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (62, 34, 2, 'Recenzja dla filmu 3', '2021-06-14 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (64, 81, 3, 'Recenzja dla filmu 3', '2021-09-12 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (65, 42, 2, 'Recenzja dla filmu 3', '2021-03-25 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (67, 59, 2, 'Recenzja dla filmu 1', '2021-06-19 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (68, 12, 3, 'Recenzja dla filmu 1', '2021-02-04 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (70, 53, 2, 'Recenzja dla filmu 3', '2021-10-08 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (72, 117, 2, 'Recenzja dla filmu 3', '2021-12-25 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (73, 19, 1, 'Recenzja dla filmu 3', '2021-03-25 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (74, 20, 3, 'Recenzja dla filmu 1', '2021-05-11 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (76, 65, 3, 'Recenzja dla filmu 3', '2021-12-07 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (77, 9, 1, 'Recenzja dla filmu 1', '2021-02-06 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (78, 53, 3, 'Recenzja dla filmu 3', '2021-09-26 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (79, 56, 3, 'Recenzja dla filmu 1', '2021-12-26 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (80, 79, 2, 'Recenzja dla filmu 1', '2021-04-26 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (82, 126, 2, 'Recenzja dla filmu 3', '2021-03-30 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (84, 63, 1, 'Recenzja dla filmu 1', '2021-05-29 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (85, 82, 2, 'Recenzja dla filmu 2', '2021-06-19 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (87, 34, 2, 'Recenzja dla filmu 1', '2021-04-16 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (88, 117, 2, 'Recenzja dla filmu 1', '2021-05-18 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (89, 89, 2, 'Recenzja dla filmu 2', '2021-06-11 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (91, 68, 1, 'Recenzja dla filmu 1', '2021-10-27 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (94, 19, 2, 'Recenzja dla filmu 2', '2021-04-29 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (95, 18, 2, 'Recenzja dla filmu 1', '2021-04-02 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (96, 5, 2, 'Recenzja dla filmu 3', '2021-08-08 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (98, 70, 1, 'Recenzja dla filmu 1', '2021-07-14 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (99, 127, 3, 'Recenzja dla filmu 2', '2021-09-10 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (100, 81, 3, 'Recenzja dla filmu 1', '2021-10-24 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (101, 76, 3, 'Recenzja dla filmu 1', '2021-01-28 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (102, 28, 1, 'Recenzja dla filmu 2', '2021-12-25 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (103, 97, 2, 'Recenzja dla filmu 1', '2021-08-30 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (104, 51, 1, 'Recenzja dla filmu 2', '2021-03-09 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (107, 39, 1, 'Recenzja dla filmu 1', '2021-07-12 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (108, 41, 3, 'Recenzja dla filmu 1', '2021-04-17 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (109, 35, 3, 'Recenzja dla filmu 1', '2021-02-09 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (113, 58, 2, 'Recenzja dla filmu 3', '2021-05-01 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (115, 108, 1, 'Recenzja dla filmu 3', '2021-07-01 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (116, 88, 3, 'Recenzja dla filmu 1', '2021-02-06 00:00:00');
INSERT INTO `Recenzje_Historyczne_backup` VALUES (117, 96, 1, 'Recenzja dla filmu 2', '2021-12-06 00:00:00');

-- ----------------------------
-- Table structure for Wersje Jezykowe
-- ----------------------------
DROP TABLE IF EXISTS `Wersje Jezykowe`;
CREATE TABLE `Wersje Jezykowe`  (
  `WJZ_ID` int(11) NOT NULL AUTO_INCREMENT,
  `WJZ_JZK_ID` int(11) NOT NULL COMMENT 'Klucz obcy do slownika jezykow',
  `WJZ_FLM_ID` int(11) NOT NULL COMMENT 'Klucz obcy do filmu',
  `WJZ_DUBBING` tinyint(1) NULL DEFAULT NULL,
  `WJZ_NAPISY` tinyint(1) NULL DEFAULT NULL,
  `WJZ_IVONA` tinyint(1) NULL DEFAULT NULL,
  PRIMARY KEY (`WJZ_ID`) USING BTREE,
  INDEX `fk_Wersje Jezykowe_Filmy_1`(`WJZ_FLM_ID`) USING BTREE,
  INDEX `fk_Wersje Jezykowe_Jezyki_1`(`WJZ_JZK_ID`) USING BTREE,
  CONSTRAINT `fk_Wersje Jezykowe_Filmy_1` FOREIGN KEY (`WJZ_FLM_ID`) REFERENCES `Filmy` (`FLM_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_Wersje Jezykowe_Jezyki_1` FOREIGN KEY (`WJZ_JZK_ID`) REFERENCES `Jezyki` (`JZK_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of Wersje Jezykowe
-- ----------------------------
INSERT INTO `Wersje Jezykowe` VALUES (1, 1, 1, 1, 1, 1);
INSERT INTO `Wersje Jezykowe` VALUES (2, 2, 1, 1, 1, 1);
INSERT INTO `Wersje Jezykowe` VALUES (3, 3, 1, 0, 1, 1);

-- ----------------------------
-- View structure for recenzje_podsumowanie
-- ----------------------------
DROP VIEW IF EXISTS `recenzje_podsumowanie`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `recenzje_podsumowanie` AS select `Filmy`.`FLM_ID` AS `FLM_ID`,`Filmy`.`FLM_NAZWA` AS `FLM_NAZWA`,avg(`Recenzje`.`RCN_OCENA`) AS `Srednia_ocen`,count(`Recenzje`.`RCN_OCENA`) AS `liczba_ocen`,`Znajdz_Pierwszo_Planowa_Postac`(`Filmy`.`FLM_ID`) AS `Postac_PierwszoPlanowa` from (`Filmy` left join `Recenzje` on(`Recenzje`.`RCN_FLM_ID` = `Filmy`.`FLM_ID`)) group by `Filmy`.`FLM_ID`,`Filmy`.`FLM_NAZWA`;

-- ----------------------------
-- Procedure structure for Kupiuj_Cennik
-- ----------------------------
DROP PROCEDURE IF EXISTS `Kupiuj_Cennik`;
delimiter ;;
CREATE PROCEDURE `Kupiuj_Cennik`(IN `V_CNN_ID` int, in `V_nazwa` VARCHAR(255))
BEGIN
	DECLARE nowy_identyfikator INT;
	
	set SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	START TRANSACTION;
		
		
		INSERT INTO Cenniki VALUES(NULL,(CURRENT_DATE),(CURRENT_DATE),0,V_nazwa);
		
		set nowy_identyfikator = LAST_INSERT_ID();
		
		INSERT INTO `Pozycja Cennika` 
		SELECT NULL, nowy_identyfikator, PCN_FLM_ID, PCN_LICZBA_DNI, PCN_CENA_NETTO
		FROM `Pozycja Cennika` WHERE PCN_CNN_ID = V_CNN_ID;
	
	COMMIT;
	
	

END
;;
delimiter ;

-- ----------------------------
-- Function structure for Znajdz_Pierwszo_Planowa_Postac
-- ----------------------------
DROP FUNCTION IF EXISTS `Znajdz_Pierwszo_Planowa_Postac`;
delimiter ;;
CREATE FUNCTION `Znajdz_Pierwszo_Planowa_Postac`(`V_FLM_ID` int)
 RETURNS varchar(1000) CHARSET utf8mb3 COLLATE utf8mb3_general_ci
BEGIN
	DECLARE nazwa VARCHAR(1000);
	DECLARE CUR_1 CURSOR FOR
		SELECT CONCAT(FLC_IMIE ,' ', FLC_NAZWISKO ) Akt_1_plan
		FROM Filmowcy, Obsada
		WHERE Filmowcy.FLC_ID = Obsada.OBS_FLC_ID
		AND OBS_FLM_ID = V_FLM_ID
		AND OBS_ROLA = 'Aktor_Plan_1'
		ORDER BY OBS_PRIORYTET;
	
	DECLARE CUR_2 CURSOR FOR
		SELECT CONCAT(FLC_IMIE ,' ', FLC_NAZWISKO ) Akt_1_plan
		FROM Filmowcy, Obsada
		WHERE Filmowcy.FLC_ID = Obsada.OBS_FLC_ID
		AND OBS_FLM_ID = V_FLM_ID
		ORDER BY OBS_PRIORYTET;
		
		
	DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        SET nazwa = 'Nie wiadomo kto tu gra';
    END;
		
	open CUR_1;

	FETCH CUR_1 into nazwa;
		CLOSE CUR_1;
	
	
	IF nazwa = 'Nie wiadomo kto tu gra' THEN
		open CUR_2;
		FETCH CUR_2 into nazwa;
			CLOSE CUR_2;
			return nazwa;
	END IF;


	
	RETURN nazwa;
END
;;
delimiter ;

-- ----------------------------
-- Event structure for UsuwanieRecenzji
-- ----------------------------
DROP EVENT IF EXISTS `UsuwanieRecenzji`;
delimiter ;;
CREATE EVENT `UsuwanieRecenzji`
ON SCHEDULE
EVERY '1' MONTH STARTS '2023-07-03 00:03:08'
DO BEGIN
    DECLARE currentDate DATE;
    SET currentDate = CURDATE();
    
    DELETE FROM `Recenzje Historyczne`
    WHERE DATEDIFF(currentDate, RCH_DATA_RECENZJI) > 5 * 365; -- Usuń recenzje starsze niż 5 lat
    
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table Cenniki
-- ----------------------------
DROP TRIGGER IF EXISTS `Walidacja_Cennika`;
delimiter ;;
CREATE TRIGGER `Walidacja_Cennika` BEFORE UPDATE ON `Cenniki` FOR EACH ROW BEGIN
	DECLARE finished INT DEFAULT 0;
	DECLARE Liczba_filmow INT;
	DECLARE KSZ_ID_Do_flagi INT;
	
	
	# Sprawdza czy po UPDATEcie wszystkie filmy które są w nie opłaconych koszykach mają nową cennę w Nowym Aktualnym CENNIKU
	DECLARE CUR_1 CURSOR FOR
		SELECT COUNT(FLM_ID)  FROM (
			SELECT DISTINCT(PCN_FLM_ID) FLM_ID from `Koszyk i Platnosci` , `Elementy Koszyka` , `Pozycja Cennika`
			WHERE PCN_ID = EKS_PCN_ID AND EKS_KSZ_ID = KSZ_ID 
			AND KSZ_OPLACONY = 0 # Podzapytanie zwraca unikalne identyfikator filmów które są w nie opłaconych koszykach.
			) DISTFILM
		WHERE NOT EXISTS (SELECT PCN_ID FROM `Pozycja Cennika` WHERE PCN_CNN_ID = NEW.CNN_ID AND PCN_FLM_ID = FLM_ID); # Sprawdza czy w aktualnym cenniku jest film.

	DECLARE CUR_2 CURSOR FOR
		SELECT DISTINCT(KSZ_ID) #KSZ_ID, PCN_FLM_ID, PCN_LICZBA_DNI, PCN_CENA_NETTO, EKS_ID , NEW_LICZBA_DNI , NEW_CENA_NETTO 
		FROM `Koszyk i Platnosci` , `Elementy Koszyka` , `Pozycja Cennika`,
		
			(SELECT PCN_FLM_ID NEW_FLM_ID, PCN_LICZBA_DNI NEW_LICZBA_DNI, PCN_CENA_NETTO NEW_CENA_NETTO FROM `Pozycja Cennika` WHERE PCN_CNN_ID = NEW.CNN_ID) nowe_pozycje
			
		WHERE PCN_ID = EKS_PCN_ID 
		AND EKS_KSZ_ID = KSZ_ID 
		AND SYSDATE() - KSZ_DATA_UTWORZENIA > 10
		AND KSZ_OPLACONY = 0
		AND NEW_FLM_ID = PCN_FLM_ID
		AND NEW_LICZBA_DNI = PCN_LICZBA_DNI
		AND NEW_CENA_NETTO  > PCN_CENA_NETTO;

	
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1; -- obsługa braku wyników
	
	IF OLD.CNN_AKTYWNY = 0 AND NEW.CNN_AKTYWNY = 1 THEN
		#sprawdzamy czy w cenniku który chcę aktywować są wsstkie filmy które są w nie opłaconych koszykach.
		
		OPEN CUR_1;
		FETCH CUR_1 into liczba_filmow;
		IF liczba_filmow > 0 then 
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NIE MOZANA AKTYWOWAC CENNIKA BO W KOSZYKACH SA FILMY DLA KTORYCH NIE ZDEFINOWANO NOWEJ CENY'; 
			# Nie sprawdzam czy liczba dni w koszyku zgadza sie z aktywowanym cennikiem
		ELSE 
		
			OPEN CUR_2;
			FETCH CUR_2 into KSZ_ID_Do_flagi;
			
			WHILE finished = 0 DO
				BEGIN
					-- wykonaj operację aktualizacji
					UPDATE `Koszyk i Platnosci`
					SET KSZ_WYMAGANA_AKCEPTACJA_CENY = 1
					WHERE KSZ_ID = KSZ_ID_Do_flagi ;

					FETCH CUR_2 INTO KSZ_ID_Do_flagi; -- wyciągnij kolejną wartość KSZ_ID z kursora i przypisz do zmiennej
				END;
			END WHILE;
			CLOSE CUR_2;
			
			#Powinna istniec taka funkcja ale nie pozwala nam na to MARIADB

			#BEGIN
			#    IF OLD.CNN_AKTYWNY = 0 AND NEW.CNN_AKTYWNY = 1 THEN
			#        UPDATE Cenniki
			#        SET CNN_AKTYWNY = 0
			#        WHERE CNN_ID <> NEW.CNN_ID
			#        AND CNN_AKTYWNY = 1;
			#    END IF;
			#END;
			
			
		END IF;
	END IF;

END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
