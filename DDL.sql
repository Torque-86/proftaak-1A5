/*
****************************************************
Name: PinPointParking
Content: Data Definition Language (DDL), dummy data, 
stored procedures

Version 1.2
+ DDL aangepast n.a.v. overleg RM
Version 1.1
+ Added comments
+ Merged DDL and database data
****************************************************
*/

/**
* DDL AND DUMMY DATA
**/

/* Create database pinpointparking */
DROP DATABASE IF EXISTS pinpointparking;
CREATE DATABASE pinpointparking CHARACTER SET UTF8;
USE pinpointparking;

/* Create table Zakelijk */
DROP TABLE IF EXISTS Zakelijk;
CREATE TABLE Zakelijk (
    KvkNummer INT(8) PRIMARY KEY,
    BedrijfsNaam VARCHAR(60),
    BtwNummer CHAR(14) UNIQUE
);

/* Insert dummy data table Zakelijk */
INSERT INTO Zakelijk
VALUES 
    (12345678, 'Henneken', 'NL001234567B01'),
    (87654321, 'FC Kip', 'NL003456789B02'),
    (56435654, 'Mora', 'NL767654543B44'),
    (87612342, 'Intratuin', 'NL123456789B32'),
    (77656543, 'Heijmans', 'NL796540870B66'),
    (98709876, 'Mediamarkt', 'NL675291876B54'),
    (12232122, 'Gamma', 'NL097872365B74'),
    (76298701, '''t Gasteltje', 'NL859871432B82'),
    (12676512, 'Albert Heijn', 'NL098987876B11'),
    (09876787, 'Glaudemans', 'NL784456789B99');

/* Create table Klant */
DROP TABLE IF EXISTS Klant;
CREATE TABLE Klant (
    KlantId INT(10) PRIMARY KEY AUTO_INCREMENT,
    Registratiedatum DATETIME,
    Mailadres VARCHAR(60) NOT NULL UNIQUE,
    Wachtwoord VARCHAR(128) NOT NULL,
    Voornaam VARCHAR(20) NOT NULL,
    Tussenvoegsel VARCHAR(10),
    Achternaam VARCHAR(60) NOT NULL,
    Mobiel VARCHAR(15) NOT NULL UNIQUE,
    Zakelijk BOOLEAN NOT NULL,
    KvkNummer INT(8),
    MachtigingAutoInc BOOLEAN NOT NULL,
    MachtigingDatum DATETIME,
    IBAN VARCHAR(10),

    CONSTRAINT zakelijkeKlantFK
    FOREIGN KEY (KvkNummer)
    REFERENCES Zakelijk (KvkNummer)
    ON DELETE RESTRICT
);

/* Insert dummy data table Klant */
INSERT INTO Klant
VALUES
    (DEFAULT, '2019-10-20', 'h.vogel@henneken.org', 'WW=1234', 'Henk', NULL, 'Vogel', '0612345678', TRUE, 12345678, TRUE, '2019-10-25', 'NL20INGB0001234567'),
    (DEFAULT, '2019-10-20', 't.vandepaddestoel@henneken.org', 'WW=5678', 'Truus', 'van de', 'Paddestoel', '0698765432', TRUE, 12345678, TRUE, '2019-10-25', 'NL20INGB0001234567'),
    (DEFAULT, '2019-10-20', 'h.vanhezelswerd@henneken.org', 'WW=9012', 'Halina', 'van', 'Hezelswerd', '0667589876', TRUE, 12345678, TRUE, '2019-10-25', 'NL20INGB0001234567'),
    (DEFAULT, '2019-10-20', 'r.karrel@henneken.org', 'WW=3456', 'Rudi', NULL, 'Karrel', '0613567854', TRUE, 12345678, TRUE, '2019-10-25', 'NL20INGB0001234567'),
    (DEFAULT, '2019-10-20', 'karin@ziggo.nl', 'Wachtwoord2134', 'Karin', 'van de', 'Oosterdijk', '0687654321', FALSE, NULL, FALSE, NULL, NULL),
    (DEFAULT, '2019-10-20', 'imanuel@lassibi.nl', 'Wachtwoord5678', 'Imanuël', NULL, 'Lassibi', '0673980090', FALSE, NULL, FALSE, NULL, NULL),
    (DEFAULT, '2019-10-20', 'karin@hotmail.com', 'Wachtwoord5678', 'Karin', NULL, 'Vanmechelse', '0032477654321', FALSE, NULL, FALSE, NULL, NULL),
    (DEFAULT, '2019-10-20', 'c.vandeleg@fckip.com', 'Wachtwoord9012', 'Corrie', 'van de', 'Leg', '0607630098', TRUE, 87654321, TRUE, '2019-10-25', 'NL20TRIO9781234567'),
    (DEFAULT, '2019-10-20', 't.delabout@fckip.com', 'Wachtwoord1234', 'Tiny', 'de la', 'Bout', '0656556598', TRUE, 87654321, TRUE, '2019-10-25', 'NL20TRIO9781234567'),
    (DEFAULT, '2019-10-20', 'harry@freedom.nl', 'Wachtwoord3322', 'Harry', 'van de', 'Haverzee', '0662819273', FALSE, NULL, FALSE, NULL, NULL),
    (DEFAULT, '2019-10-20', 'info@mora.nl', 'WW=12345678', 'Marina', 'van', 'Mora', '0683728190', TRUE, 56435654, TRUE, '2019-10-25', 'NL20ABNA2345679781'),
    (DEFAULT, '2019-10-20', 't.vlaarhoven@intratuin.nl', '1234haha', 'Tinus', 'van', 'Laarhoven', '0634343434', TRUE, 87612342, TRUE, '2019-10-25', 'NL20RABO6792345781'),
    (DEFAULT, '2019-10-20', 'vandebouwput@heijmans.nl', 'DezeRaadJeNiet123', 'Berend', 'van de', 'Bouwput', '0642526254', TRUE, 77656543, TRUE, '2019-10-25', 'NL20RABO6791234578'),
    (DEFAULT, '2019-10-20', 'vdoever@ikbentochnietgek.nl', 'WW=98672', 'River', 'van den', 'Oever', '0673618291', TRUE, 98709876, TRUE, '2019-10-25', 'NL20INGB1231234578'),
    (DEFAULT, '2019-10-20', 'hamers@gamma.nl', 'W34234W', 'Nely', NULL, 'Hamers', '0610938946', TRUE, 12232122, TRUE, '2019-10-25', 'NL20INGB9874512378'),
    (DEFAULT, '2019-10-20', 'dionaysa@gasteltje.nl', 'DiamondsR4ever', 'Dionaysa', NULL, 'Bling', '0678334568', TRUE, 76298701, TRUE, '2019-10-25', 'NL20RABO9800212378'),
    (DEFAULT, '2019-10-20', 'nick@ah.nl', 'W827282W', 'Nick', NULL, 'Schilder', '0682718394', TRUE, 12676512, TRUE, '2019-10-25', 'NL20RABO2123798008'),
    (DEFAULT, '2019-10-20', 'rachid@ah.nl', 'Wechtwurd2', 'Rachid', NULL, 'Albahezi', '004976898798910', TRUE, 12676512, TRUE, '2019-10-25', 'NL20RABO2123798008'),
    (DEFAULT, '2019-10-20', 'pryssy@outlook.com', 'Wacht1234', 'Prycilla', 'Van Den', 'Elzen', '0032477123456', FALSE, NULL, FALSE, NULL, NULL),
    (DEFAULT, '2019-10-20', 'raphy@gmail.com', 'W5678', 'Raphaël', NULL, 'Rhizzouana', '0687879809', FALSE, NULL, FALSE, NULL, NULL);

/* CREATE table Adres */
DROP TABLE IF EXISTS Adres;
CREATE TABLE Adres (
    AdresId INT(10) PRIMARY KEY AUTO_INCREMENT,
    Straat VARCHAR(60) NOT NULL,
    HuisNr VARCHAR(8) NOT NULL,
    Postcode VARCHAR(6) NOT NULL,
    Stad VARCHAR(60) NOT NULL,
    Land VARCHAR(60) DEFAULT 'Nederland',
    TelefoonVast VARCHAR(15),
    KlantId INT(10) NOT NULL,

    CONSTRAINT klantAdresFK
    FOREIGN KEY (KlantId)
    REFERENCES Klant (KlantId)
    ON DELETE RESTRICT
);

/* Insert dummy data table Adres */
INSERT INTO Adres
VALUES
    (DEFAULT, 'Oosterstraat', '29', '5288KL', '''s-Hertogenbosch', DEFAULT, '0735212345', 1),
    (DEFAULT, 'Kerkstraat', '99A', '4842DN', '''s-Hertogenbosch', DEFAULT, NULL, 2),
    (DEFAULT, 'Middellaan', '89', '5270MS', 'Vlijmen', DEFAULT, NULL, 3),
    (DEFAULT, 'Lange van de Lindenlaan', '67C', '5201HJ', 'Berlicum', DEFAULT, '0736789789', 4),
    (DEFAULT, 'Laan van Columbus', '1', '9711PC', 'Groningen', DEFAULT, '0501234567', 5),
    (DEFAULT, 'Alpensteeg', '3', '2456MK', 'Hoek van Holland', DEFAULT, NULL, 6),
    (DEFAULT, 'Dr. Frankenplein', '110', '4321', 'Antwerpen', 'België', '0032304567654', 7),
    (DEFAULT, 'Willem de Zwijgerlaan', '13', '2323MN', 'Amsterdam', DEFAULT, NULL, 8),
    (DEFAULT, 'Rijkerstraat', '98', '2320ML', 'Amsterdam', DEFAULT, NULL, 9),
    (DEFAULT, 'Witte de Withlaan', '4', '1234WK', 'Maastricht', DEFAULT, '0345465767', 10),
    (DEFAULT, 'Schoolstraat', '211C', '3232HB', 'Utrecht', DEFAULT, NULL, 11),
    (DEFAULT, 'Dordrechterstraat', '23', '4810TR', 'Breda', DEFAULT, '0765465768', 12),
    (DEFAULT, 'Ubbergsestraat', '55', '3423CC', 'Nijmegen', DEFAULT, NULL, 13),
    (DEFAULT, 'Levensweg', '98', '1298TR', 'Zierikzee', DEFAULT, NULL, 14),
    (DEFAULT, 'Van Groesbeekseweg', '55', '2376BB', 'Schiedam', DEFAULT, NULL, 15),
    (DEFAULT, 'Schierlaan', '11', '2300KM', 'Vlaardingen', DEFAULT, '0107656789', 16),
    (DEFAULT, 'Hengelose Baan', '343', '8887MM', 'Oldenzaal', DEFAULT, NULL, 17),
    (DEFAULT, 'Kleiner Weg', '4', '48455', 'Bad Bentheim', 'Duitsland', '004933045432145', 18),
    (DEFAULT, 'Urbanusplein', '1', '3222', 'Antwerpen', 'België', '0032304767674', 19),
    (DEFAULT, 'Strandpad', '3A', '1098FG', 'Middelburg', DEFAULT, NULL, 20);

/* Create table Voertuig */
DROP TABLE IF EXISTS Voertuig;
CREATE TABLE Voertuig (
    VoertuigId INT(10) PRIMARY KEY AUTO_INCREMENT,
    Kenteken VARCHAR(8) NOT NULL,
    KlantId INT(10) NOT NULL,

    CONSTRAINT klantVoertuigFK
    FOREIGN KEY (KlantId)
    REFERENCES Klant (KlantId)
    ON DELETE RESTRICT
);

/* Insert dummy data table Voertuig */
INSERT INTO Voertuig
VALUES 
    (DEFAULT, 'XD-43-LK', 1),
    (DEFAULT, 'XD-43-LK', 2), /* deelt auto van de zaak met 1 */
    (DEFAULT, '7-GHT-34', 3),
    (DEFAULT, '7-GHT-34', 4), /* deelt auto van de zaak met 3*/
    (DEFAULT, 'NL-72-PK', 5),
    (DEFAULT, 'RT-22-FV', 6),
    (DEFAULT, '3-THG-882', 7),
    (DEFAULT, '6-WTC-41', 8),
    (DEFAULT, 'NH-54-LP', 9),
    (DEFAULT, 'SP-12-CV', 10),
    (DEFAULT, '1-RZF-14', 11),
    (DEFAULT, 'NG-17-MK', 12),
    (DEFAULT, 'LL-13-KK', 13), /* nieuwe klant*/
    (DEFAULT, '2-HGG-87', 14),
    (DEFAULT, 'LR-61-XX', 15),
    (DEFAULT, '6-RTG-34', 16),
    (DEFAULT, 'AAC AP53', 17),
    (DEFAULT, '1-XXX-341', 18),
    (DEFAULT, 'TT-33-BC', 19),
    (DEFAULT, 'GH-12-KL', 20);

/* Create table ParkeerPlaats */
DROP TABLE IF EXISTS ParkeerPlaats;
CREATE TABLE ParkeerPlaats (
    ParkeerPlaatsId INT(10) PRIMARY KEY AUTO_INCREMENT,
    Straat VARCHAR(60) NOT NULL,
    HuisNr VARCHAR(8),
    Postcode VARCHAR(6) NOT NULL,
    Stad VARCHAR(60) NOT NULL,
    ParkeerTerrein BOOLEAN NOT NULL,
    ParkeerGarage BOOLEAN NOT NULL,
    TariefUur DOUBLE(3,2) NOT NULL,
    MaxDuur SMALLINT(1),
    BeginBetaaldParkerenDag TIME,
    EindeBetaaldParkerenDag TIME
);

/* Insert dummy data table ParkeerPlaats */
INSERT INTO ParkeerPlaats
VALUES
    (DEFAULT, 'Leeghmanstraat', '3', '5200LM', '''s-Hertogenbosch', TRUE, FALSE, '2.99', 24, '09:00:00', '17:00:00'),
    (DEFAULT, 'Rademarkt', '7', '9711KZ', 'Groningen', FALSE, TRUE, '2.49', 24, '08:00:00', '20:00:00'),
    (DEFAULT, 'Kirkmanlaan', '303', '2300RL', 'Rotterdam', FALSE, TRUE, '3.99', 24, '00:00:00', '23:59:59'),
    (DEFAULT, 'Tuinlaan', '56', '4815DK', 'Breda', FALSE, TRUE, '3.10', 24, '00:00:00', '23:59:59'),
    (DEFAULT, 'Kerkplein', NULL, '6711KZ', 'Amsterdam', FALSE, FALSE, '4.99', 2, '00:00:00', '23:59:59'),
    (DEFAULT, 'Pieter Polderstraat', '6', '1240WK', 'Maastricht', FALSE, TRUE, '2.50', 24, '08:00:00', '20:00:00'),
    (DEFAULT, 'Dr. Polderplein', NULL, '3476HM', 'Utrecht', FALSE, FALSE, '3.89', 2, '08:00:00', '22:00:00'),
    (DEFAULT, 'Lindelinie', NULL, '6700LM', 'Arnhem', FALSE, FALSE, '2.69', 24, '08:00:00', '22:00:00'),
    (DEFAULT, 'Elzenstraat', '56', '4815DK', 'Middelburg', TRUE, FALSE, '3.10', 24, '00:00:00', '23:59:59'),
    (DEFAULT, 'Willem de la Hueweg', '2', '8715DK', 'Enschede', TRUE, FALSE, '1.80', 24, '00:00:00', '23:59:59');

/* Create table ParkeerSessie */
DROP TABLE IF EXISTS ParkeerSessie;
CREATE TABLE ParkeerSessie (
    ReserveringsNr INT(10) PRIMARY KEY AUTO_INCREMENT,
    KlantId INT(10) NOT NULL,
    VoertuigId INT(10) NOT NULL,
    BeginTijd DATETIME NOT NULL,
    EindTijd DATETIME NOT NULL,
    ParkeerPlaats INT(10) NOT NULL,

    CONSTRAINT kentekenParkeerSessieFK1
    FOREIGN KEY (KlantId)
    REFERENCES Klant (KlantId)
    ON DELETE RESTRICT,

    CONSTRAINT kentekenParkeerSessieFK2
    FOREIGN KEY (VoertuigId)
    REFERENCES Voertuig (VoertuigId)
    ON DELETE RESTRICT,

    CONSTRAINT parkeerPlaatsSessieFK3
    FOREIGN KEY (ParkeerPlaats)
    REFERENCES ParkeerPlaats (ParkeerPlaatsId)
    ON DELETE RESTRICT
);

/* Insert dummy data table ParkeerSessie */
INSERT INTO ParkeerSessie
VALUES 
    (DEFAULT, 1, 1, '2019-11-01 15:02:45', '2019-11-01 16:31:20', 1),
    (DEFAULT, 1, 1, '2019-11-08 10:52:41', '2019-11-08 22:01:09', 1),
    (DEFAULT, 2, 2, '2019-11-09 12:12:23', '2019-12-09 14:41:23', 1),
    (DEFAULT, 3, 3, '2019-11-02 08:22:05', '2019-11-02 09:23:43', 2),
    (DEFAULT, 3, 3, '2019-11-03 18:12:14', '2019-11-03 22:55:13', 2),
    (DEFAULT, 5, 5, '2019-11-04 23:02:45', '2019-11-05 08:43:08', 3), 
    (DEFAULT, 6, 6, '2019-11-11 09:33:01', '2019-11-13 13:57:42', 4), 
    (DEFAULT, 7, 7, '2019-11-29 10:52:41', '2019-11-29 22:01:09', 5), 
    (DEFAULT, 8, 8, '2019-11-30 11:56:45', '2019-11-30 13:34:01', 6),
    (DEFAULT, 9, 9, '2019-12-01 15:02:45', '2019-12-03 16:31:20', 7),
    (DEFAULT, 10, 10,'2019-12-02 08:22:05', '2019-12-02 09:23:43',  8),
    (DEFAULT, 11, 11, '2019-12-04 23:02:45', '2019-12-06 08:43:08', 9),
    (DEFAULT, 12, 12, '2019-12-07 09:33:01', '2019-12-07 13:57:42', 10),
    (DEFAULT, 2, 2, '2019-12-08 10:52:41', '2019-12-08 22:01:09', 1),
    (DEFAULT, 4, 4, '2019-12-09 08:02:11', '2019-12-09 13:51:06', 2),
    (DEFAULT, 14, 14, '2019-12-10 07:56:45', '2019-12-11 21:34:31', 3),
    (DEFAULT, 15, 15, '2019-12-12 11:56:45', '2019-12-12 19:34:01', 4),
    (DEFAULT, 16, 16, '2019-12-13 11:12:34', '2019-12-23 15:01:34', 5),
    (DEFAULT, 17, 17, '2019-12-14 05:56:45', '2019-12-14 14:12:56', 6),
    (DEFAULT, 18, 18, '2019-12-15 12:16:45', '2019-12-17 19:12:44', 7),
    (DEFAULT, 19, 19, '2019-12-16 17:56:45', '2019-12-20 07:34:01', 8),
    (DEFAULT, 20, 20, '2019-12-17 16:45:32', '2019-12-21 23:31:20', 1);

/* Create table Factuur */
DROP TABLE IF EXISTS Factuur;
CREATE TABLE Factuur (
    FactuurNr INT(10) PRIMARY KEY AUTO_INCREMENT,
    FactuurDatum DATE NOT NULL,
    Voornaam VARCHAR(20) NOT NULL,
    Tussenvoegsel VARCHAR(10),
    Achternaam VARCHAR(60) NOT NULL,
    Mobiel VARCHAR(15) NOT NULL,
    Straat VARCHAR(60) NOT NULL,
    HuisNr VARCHAR(8) NOT NULL,
    Postcode VARCHAR(6) NOT NULL,
    Stad VARCHAR(60) NOT NULL,
    Land VARCHAR(60) DEFAULT 'Nederland',
    TelefoonVast VARCHAR(15),
    KlantId INT(10) NOT NULL,

    CONSTRAINT klantIdFactuurFK1
    FOREIGN KEY (KlantId)
    REFERENCES Klant (KlantId)
    ON DELETE RESTRICT
);

/* Insert dummy data table Factuur */
INSERT INTO Factuur
VALUES 
    (DEFAULT, '2019-11-30', 'Henk', NULL, 'Vogel', '0612345678', 'Oosterstraat', '29', '5288KL', '''s-Hertogenbosch', DEFAULT, '0735212345', 1),
    (DEFAULT, '2019-11-30', 'Truus', 'van de', 'Paddestoel', '0698765432', 'Kerkstraat', '99A', '4842DN', '''s-Hertogenbosch', DEFAULT, NULL, 2),
    (DEFAULT, '2019-11-30', 'Halina', 'van', 'Hezelswerd', '0667589876', 'Middellaan', '89', '5270MS', 'Vlijmen', DEFAULT, NULL, 3), 
    (DEFAULT, '2019-11-30', 'Karin', 'van de', 'Oosterdijk', '0687654321', 'Laan van Columbus', '1', '9711PC', 'Groningen', DEFAULT, '0501234567', 5),
    (DEFAULT, '2019-11-30', 'Imanuël', NULL, 'Lassibi', '0673980090', 'Alpensteeg', '3', '2456MK', 'Hoek van Holland', DEFAULT, NULL, 6), 
    (DEFAULT, '2019-11-30', 'Karin', NULL, 'Vanmechelse', '0032477654321', 'Dr. Frankenplein', '110', '4321', 'Antwerpen', 'België', '0032304567654', 7),
    (DEFAULT, '2019-11-30', 'Corrie', 'van de', 'Leg', '0607630098', 'Willem de Zwijgerlaan', '13', '2323MN', 'Amsterdam', DEFAULT, NULL, 8), 
    (DEFAULT, '2019-12-30', 'Tiny', 'de la', 'Bout', '0656556598', 'Rijkerstraat', '98', '2320ML', 'Amsterdam', DEFAULT, NULL, 9),
    (DEFAULT, '2019-12-30', 'Harry', 'van de', 'Haverzee', '0662819273', 'Witte de Withlaan', '4', '1234WK', 'Maastricht', DEFAULT, '0345465767', 10), 
    (DEFAULT, '2019-12-30', 'Marina', 'van', 'Mora', '0683728190', 'Schoolstraat', '211C', '3232HB', 'Utrecht', DEFAULT, NULL, 11),
    (DEFAULT, '2019-12-30', 'Tinus', 'van', 'Laarhoven', '0634343434', 'Dordrechterstraat', '23', '4810TR', 'Breda', DEFAULT, '0765465768', 12), 
    (DEFAULT, '2019-12-30', 'Nely', NULL, 'Hamers', '0610938946', 'Van Groesbeekseweg', '55', '2376BB', 'Schiedam', DEFAULT, NULL, 15),
    (DEFAULT, '2019-12-30', 'Truus', 'van de', 'Paddestoel', '0698765432', 'Kerkstraat', '99A', '4842DN', '''s-Hertogenbosch', DEFAULT, NULL, 2), 
    (DEFAULT, '2019-12-30', 'Rudi', NULL, 'Karrel', '0613567854', 'Lange van de Lindenlaan', '67C', '5201HJ', 'Berlicum', DEFAULT, '0736789789', 4),
    (DEFAULT, '2019-12-30', 'River', 'van den', 'Oever', '0673618291', 'Levensweg', '98', '1298TR', 'Zierikzee', DEFAULT, NULL, 14), 
    (DEFAULT, '2019-12-30', 'Nely', NULL, 'Hamers', '0610938946', 'Van Groesbeekseweg', '55', '2376BB', 'Schiedam', DEFAULT, NULL, 15),
    (DEFAULT, '2019-12-30', 'Dionaysa', NULL, 'Bling', '0678334568', 'Schierlaan', '11', '2300KM', 'Vlaardingen', DEFAULT, '0107656789', 16),
    (DEFAULT, '2019-12-30', 'Nick', NULL, 'Schilder', '0682718394', 'Hengelose Baan', '343', '8887MM', 'Oldenzaal', DEFAULT, NULL, 17),
    (DEFAULT, '2019-12-30', 'Rachid', NULL, 'Albahezi', '004976898798910', 'Kleiner Weg', '4', '48455', 'Bad Bentheim', 'Duitsland', '004933045432145', 18), 
    (DEFAULT, '2019-12-30', 'Prycilla', 'Van Den', 'Elzen', '0032477654321', 'Urbanusplein', '1', '3222', 'Antwerpen', 'België', '0032304767674', 19),
    (DEFAULT, '2019-12-30', 'Raphaël', NULL, 'Rhizzouana', '0687879809', 'Strandpad', '3A', '1098FG', 'Middelburg', DEFAULT, NULL, 20); 

/* Create table Factuurregel */
DROP TABLE IF EXISTS FactuurRegel;
CREATE TABLE FactuurRegel (
    FactuurNr INT(10) NOT NULL,
    Kenteken VARCHAR(8) NOT NULL,
    BeginTijd DATETIME NOT NULL,
    EindTijd DATETIME NOT NULL,
    Straat VARCHAR(60) NOT NULL,
    HuisNr VARCHAR(8),
    Postcode VARCHAR(6) NOT NULL,
    Stad VARCHAR(60) NOT NULL,
    ParkeerTerrein BOOLEAN NOT NULL,
    ParkeerGarage BOOLEAN NOT NULL,
    TariefUur DOUBLE(3,2) NOT NULL,
    MaxDuur SMALLINT(1),
    BeginBetaaldParkerenDag TIME,
    EindeBetaaldParkerenDag TIME,

    CONSTRAINT factuurNrFK
    FOREIGN KEY (FactuurNr)
    REFERENCES Factuur (FactuurNr)
    ON DELETE RESTRICT
);

/* Insert dummy data table FactuurRegel */
INSERT INTO FactuurRegel
VALUES 
    (1, 'XD-43-LK', '2019-11-01 15:02:45', '2019-11-01 16:31:20', 'Leeghmanstraat','3', '5200LM', '''s-Hertogenbosch', TRUE, FALSE, '2.99', 24, '09:00:00', '17:00:00'),
    (1, 'XD-43-LK', '2019-11-08 10:52:41', '2019-12-08 22:01:09', 'Leeghmanstraat','3', '5200LM', '''s-Hertogenbosch', TRUE, FALSE, '2.99', 24, '09:00:00', '17:00:00'),
    (2, 'XD-43-LK', '2019-11-09 12:12:23', '2019-12-09 14:41:23', 'Leeghmanstraat','3', '5200LM', '''s-Hertogenbosch', TRUE, FALSE, '2.99', 24, '09:00:00', '17:00:00'),
    (3, '7-GHT-34', '2019-11-02 08:22:05', '2019-11-02 09:23:43', 'Rademarkt', '7', '9711KZ', 'Groningen', FALSE, TRUE, '2.49', 24, '08:00:00', '20:00:00'),
    (3, '7-GHT-34', '2019-11-03 18:12:14', '2019-11-03 22:55:13', 'Rademarkt', '7', '9711KZ', 'Groningen', FALSE, TRUE, '2.49', 24, '08:00:00', '20:00:00'),
    (4, 'NL-72-PK', '2019-11-04 23:02:45', '2019-11-05 08:43:08', 'Kirkmanlaan', '303', '2300RL', 'Rotterdam', FALSE, TRUE, '3.99', 24, '00:00:00', '23:59:59'),
    (5, 'RT-22-FV', '2019-11-11 09:33:01', '2019-11-13 13:57:42', 'Tuinlaan', '56', '4815DK', 'Breda', FALSE, TRUE, '3.10', 24, '00:00:00', '23:59:59'),
    (6, '3-THG-882', '2019-11-29 10:52:41', '2019-11-29 22:01:09', 'Kerkplein', NULL, '6711KZ', 'Amsterdam', FALSE, FALSE, '4.99', 2, '00:00:00', '23:59:59'),
    (7, '6-WTC-41', '2019-11-30 11:56:45', '2019-11-30 13:34:01', 'Pieter Polderstraat', '6', '1240WK', 'Maastricht', FALSE, TRUE, '2.50', 24, '08:00:00', '20:00:00'),
    (8, 'NH-54-LP', '2019-12-01 15:02:45', '2019-12-03 16:31:20', 'Dr. Polderplein', NULL, '3476HM', 'Utrecht', FALSE, FALSE, '3.89', 2, '08:00:00', '22:00:00'),
    (9, 'SP-12-CV','2019-12-02 08:22:05', '2019-12-02 09:23:43', 'Lindelinie', NULL, '6700LM', 'Arnhem', FALSE, FALSE, '2.69', 24, '08:00:00', '22:00:00'),
    (10, '1-RZF-14', '2019-12-04 23:02:45', '2019-12-06 08:43:08', 'Elzenstraat', '56', '4815DK', 'Middelburg', TRUE, FALSE, '3.10', 24, '00:00:00', '23:59:59'),
    (11, 'NG-17-MK', '2019-12-07 09:33:01', '2019-12-07 13:57:42', 'Willem de la Hueweg', '2', '8715DK', 'Enschede', TRUE, FALSE, '1.80', 24, '00:00:00', '23:59:59'),
    (12, 'XD-43-LK', '2019-12-08 10:52:41', '2019-12-08 22:01:09', 'Leeghmanstraat', '3', '5200LM', '''s-Hertogenbosch', TRUE, FALSE, '2.99', 24, '09:00:00', '17:00:00'),
    (13, '7-GHT-34', '2019-12-09 08:02:11', '2019-12-09 13:51:06', 'Rademarkt', '7', '9711KZ', 'Groningen', FALSE, TRUE, '2.49', 24, '08:00:00', '20:00:00'),
    (14, '2-HGG-87', '2019-12-10 07:56:45', '2019-12-11 21:34:31', 'Kirkmanlaan', '303', '2300RL', 'Rotterdam', FALSE, TRUE, '3.99', 24, '00:00:00', '23:59:59'),
    (15, 'LR-61-XX', '2019-12-12 11:56:45', '2019-12-12 19:34:01', 'Tuinlaan', '56', '4815DK', 'Breda', FALSE, TRUE, '3.10', 24, '00:00:00', '23:59:59'),
    (16, '6-RTG-34', '2019-12-13 11:12:34', '2019-12-23 15:01:34', 'Kerkplein', NULL, '6711KZ', 'Amsterdam', FALSE, FALSE, '4.99', 2, '00:00:00', '23:59:59'),
    (17, 'AAC AP53', '2019-12-14 05:56:45', '2019-12-14 14:12:56', 'Pieter Polderstraat', '6', '1240WK', 'Maastricht', FALSE, TRUE, '2.50', 24, '08:00:00', '20:00:00'),
    (18, '1-XXX-341', '2019-12-15 12:16:45', '2019-12-17 19:12:44', 'Dr. Polderplein', NULL, '3476HM', 'Utrecht', FALSE, FALSE, '3.89', 2, '08:00:00', '22:00:00'),
    (19, 'TT-33-BC', '2019-12-16 17:56:45', '2019-12-20 07:34:01', 'Lindelinie', NULL, '6700LM', 'Arnhem', FALSE, FALSE, '2.69', 24, '08:00:00', '22:00:00'),
    (20, 'XD-43-LK', '2019-12-17 16:45:32', '2019-12-21 23:31:20', 'Leeghmanstraat', '3', '5200LM', '''s-Hertogenbosch', TRUE, FALSE, '2.99', 24, '09:00:00', '17:00:00');