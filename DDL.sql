/*
****************************************************
Name: PinPointParking
Content: Data Definition Language (DDL), dummy data, 
stored procedures

Version 1.2
+ added stored procedures
Version 1.1
+ added comments
+ merged DDL and database data
****************************************************
*/

/**
* DDL AND DUMMY DATA
**/

/* Create database pinpointparking */
DROP DATABASE IF EXISTS pinpointparking;
CREATE DATABASE pinpointparking CHARACTER SET UTF8;
USE pinpointparking;

/* Create table ZAKELIJK */
CREATE TABLE Zakelijk (
    KvkNummer INT(8) PRIMARY KEY,
    BedrijfsNaam VARCHAR(60),
    BtwNummer CHAR(14)
);

/* Insert dummy data table ZAKELIJK */

INSERT INTO Zakelijk
VALUES 
    (12345678, 'Schadebo', 'NL001234567B01'),
    (87654321, 'FC Kip', 'NL003456789B02');

/* Create table KLANT */
CREATE TABLE Klant (
    KlantId INT(10) PRIMARY KEY AUTO_INCREMENT,
    Registratiedatum TIMESTAMP,
    Mailadres VARCHAR(60) NOT NULL UNIQUE,
    Wachtwoord VARCHAR(128) NOT NULL,
    Voornaam VARCHAR(20) NOT NULL,
    Tussenvoegsel VARCHAR(10),
    Achternaam VARCHAR(60) NOT NULL,
    Mobiel CHAR(10) NOT NULL UNIQUE,
    KvkNummer INT(8),

    CONSTRAINT zakelijkeKlantFK
    FOREIGN KEY (KvkNummer)
    REFERENCES Zakelijk (KvkNummer)
    ON DELETE RESTRICT
);

/* Insert dummy data table KLANT */
INSERT INTO Klant
VALUES
    (DEFAULT, DEFAULT, 'info@schadebo.nl', 'Wachtwoord1234', 'Henk', NULL, 'Vogel', '0612345678', 12345678),
    (DEFAULT, DEFAULT, 'karin@ziggo.nl', 'Wachtwoord5678', 'Karin', 'van de', 'Oosterdijk', '0687654321', NULL),
    (DEFAULT, DEFAULT, 'info@fckip.nl', 'Wachtwoord9012', 'Corrie', 'van de', 'Leg', '0698761234', 87654321);

/* CREATE table ADRES */
CREATE TABLE Adres (
    AdresId INT(10) PRIMARY KEY AUTO_INCREMENT,
    Straat VARCHAR(60) NOT NULL,
    HuisNr VARCHAR(8) NOT NULL,
    Postcode CHAR(6) NOT NULL,
    Stad VARCHAR(60) NOT NULL,
    Land VARCHAR(60) DEFAULT 'Nederland',
    TelefoonVast CHAR(10) UNIQUE,
    KlantId INT(10) NOT NULL,

    CONSTRAINT klantAdresFK
    FOREIGN KEY (KlantId)
    REFERENCES Klant (KlantId)
    ON DELETE RESTRICT
);

/* Insert dummy data table ADRES */
INSERT INTO Adres
VALUES
    (DEFAULT, 'Oosterstraat', '29', '5242KL', 'Den Bosch', DEFAULT, '0735212345', 1),
    (DEFAULT, 'Kerkstraat', '99A', '4842DN', 'Breda', DEFAULT, NULL, 2),
    (DEFAULT, 'Laan van Columbus', '1', '9797PC', 'Thesigne', DEFAULT, '0501234567', 3);

/* Create table VOERTUIG */
CREATE TABLE Voertuig (
    Kenteken CHAR(8) PRIMARY KEY,
    KlantId INT(10) NOT NULL,

    CONSTRAINT klantVoertuigFK
    FOREIGN KEY (KlantId)
    REFERENCES Klant (KlantId)
    ON DELETE RESTRICT
);

/* Insert dummy data table VOERTUIG */
INSERT INTO Voertuig
VALUES 
    ('XD-43-LK', 1),
    ('7-GHT-34', 2),
    ('NL-72-PK', 3);

/* Create table PARKEEROMGEVING */
CREATE TABLE ParkeerPlaats (
    ParkeerPlaatsId INT(10) PRIMARY KEY AUTO_INCREMENT,
    Straat VARCHAR(60) NOT NULL,
    HuisNr VARCHAR(8),
    Postcode CHAR(6) NOT NULL,
    Stad VARCHAR(60) NOT NULL,
    ParkeerTerrein BOOLEAN NOT NULL,
    ParkeerGarage BOOLEAN NOT NULL,
    TariefUur DOUBLE(3,2) NOT NULL,
    MaxDuur SMALLINT(1),
    BeginBetaaldParkerenDag TIME,
    EindeBetaaldParkerenDag TIME
);

/* Insert dummy data table PARKEEROMGEVING */
INSERT INTO ParkeerPlaats
VALUES
    (DEFAULT, 'Leeghmanstraat', NULL, '5200LM', '''s-Hertogenbosch', FALSE, FALSE, '2.99', '10', '09:00:00', '17:00:00'),
    (DEFAULT, 'Tuinlaan', '56', '4815DK', 'Breda', FALSE, TRUE, '3.10', 24, '00:00:00', '23:59:59'),
    (DEFAULT, 'Rademarkt', '7', '9711KZ', 'Groningen',  FALSE, TRUE, '2.49', 12, '08:00:00', '20:00:00');

/* Create table PARKEERSESSIE */
CREATE TABLE ParkeerSessie (
    ReserveringsNr INT(10) PRIMARY KEY AUTO_INCREMENT,
    BeginTijd DATETIME NOT NULL,
    EindTijd DATETIME NOT NULL,
    Kenteken CHAR(8) NOT NULL,
    ParkeerPlaats INT(10) NOT NULL,

    CONSTRAINT kentekenParkeerSessieFK1
    FOREIGN KEY (Kenteken)
    REFERENCES Voertuig (Kenteken)
    ON DELETE RESTRICT,

    CONSTRAINT parkeerPlaatsSessieFK2
    FOREIGN KEY (ParkeerPlaats)
    REFERENCES ParkeerPlaats (ParkeerPlaatsId)
    ON DELETE RESTRICT
);

/* Insert dummy data table PARKEERSESSIE */
INSERT INTO ParkeerSessie
VALUES 
    (DEFAULT, '2019-11-13 15:02:45', '2019-11-13 16:31:20', 'XD-43-LK', 1),
    (DEFAULT, '2019-11-29 08:22:05', '2019-11-29 09:23:43', '7-GHT-34', 2),
    (DEFAULT, '2019-12-01 23:02:45', '2019-12-02 08:43:08', 'NL-72-PK', 3),
    (DEFAULT, '2019-12-11 09:33:01', '2019-12-13 13:57:42',   '7-GHT-34', 2),
    (DEFAULT, '2019-11-29 10:52:41', '2019-11-29 22:01:09', 'XD-43-LK', 2),
    (DEFAULT, '2019-12-12 11:56:45', '2019-12-12 21:34:01', '7-GHT-34', 1);

/* Create table FACTUUR */
CREATE TABLE Factuur (
    FactuurNr INT(10) PRIMARY KEY AUTO_INCREMENT,
    FactuurDatum DATE NOT NULL,
    KlantId INT(10) NOT NULL,
    AdresId INT(10) NOT NULL,

    CONSTRAINT klantIdFactuurFK1
    FOREIGN KEY (KlantId)
    REFERENCES Klant (KlantId)
    ON DELETE RESTRICT,

    CONSTRAINT klantAdresFactuurFK2
    FOREIGN KEY (AdresId)
    REFERENCES Adres (AdresId)
    ON DELETE RESTRICT
);

/* Insert dummy data table FACTUUR */
INSERT INTO Factuur
VALUES 
    (DEFAULT, '2019-11-14', 1, 1),
    (DEFAULT, '2019-11-30', 2, 2),
    (DEFAULT, '2019-12-03', 3, 3),
    (DEFAULT, '2019-12-12', 2, 2),
    (DEFAULT, '2019-11-30', 1, 1),
    (DEFAULT, '2019-12-13', 2, 2);

/* Create table FACTUURREGELS */
CREATE TABLE FactuurRegel (
    FactuurNr INT(10) NOT NULL,
    Kenteken CHAR(8) NOT NULL,
    ParkeerSessie INT(10) NOT NULL,
    ParkeerPlaats INT(10) NOT NULL,

    CONSTRAINT factuurNrFK1
    FOREIGN KEY (FactuurNr)
    REFERENCES Factuur (FactuurNr)
    ON DELETE RESTRICT,

    CONSTRAINT kentekenFactuurFK2
    FOREIGN KEY (Kenteken)
    REFERENCES Voertuig (Kenteken)
    ON DELETE RESTRICT,

    CONSTRAINT parkeerSessieFactuurFK3
    FOREIGN KEY (ParkeerSessie)
    REFERENCES ParkeerSessie (ReserveringsNr)
    ON DELETE RESTRICT,

    CONSTRAINT parkeerPlaatsFactuurFK4
    FOREIGN KEY (ParkeerPlaats)
    REFERENCES ParkeerPlaats (ParkeerPlaatsId)
    ON DELETE RESTRICT
);

/* Insert dummy data table FACTUURREGELS */
INSERT INTO FactuurRegel
VALUES 
    (1, 'XD-43-LK', 1, 1),
    (2, '7-GHT-34', 2, 2),
    (3, 'NL-72-PK', 3, 3),
    (4, '7-GHT-34', 4, 2),
    (5, 'XD-43-LK', 5, 2),
    (6, '7-GHT-34', 6, 1);

/**
* STORED PROCEDURES
**/
DELIMITER //
/* Simpele test SP om alle parkeersessies op te halen */
CREATE PROCEDURE GetAllParkeersessies()
BEGIN
    SELECT *
    FROM ParkeerSessie;
END //

CREATE PROCEDURE GetParkeersessieFromParkeeromgeving(
    IN ParkeerOmgevingId INT(10)
)
BEGIN
    SELECT * 
    FROM ParkeerSessie
    WHERE ParkeerOmgeving = ParkeerOmgevingId;
END //
 
/* Stored Procedure Parkeerplaats 1 parkeerkosten zonder de gratis tijdstippen */
CREATE PROCEDURE KostenParkeerPlaats1(
    IN spReserveringsNr INT,
    OUT spParkeerkosten DOUBLE(3,2)
)

BEGIN 
SELECT 
    ReserveringsNr,
	BeginTijd,
    EindTijd,
    TIME_TO_SEC(TIMEDIFF(EindTijd, BeginTijd)) / 3600 AS UrenTotaal,
    TIME_TO_SEC(TIMEDIFF(EindTijd, BeginTijd)) / 3600 
    - DATEDIFF(EindTijd, BeginTijd) * 16 AS UrenBetaald,
    TariefUur,
    (TIME_TO_SEC(TIMEDIFF(EindTijd, BeginTijd)) / 3600 
    - DATEDIFF(EindTijd, BeginTijd) * 16) * TariefUur AS Kosten
FROM ParkeerSessie PS
LEFT JOIN ParkeerPlaats PP ON PS.ParkeerPlaats = PP.ParkeerPlaatsId
WHERE ReserveringsNr = spReserveringsNr;
END //

/* Stored Procedure Parkeerplaats 3 parkeerkosten zonder de gratis tijdstippen */
CREATE PROCEDURE KostenParkeerPlaats3(
    IN spReserveringsNr INT,
    OUT spParkeerkosten DOUBLE(3,2)
)

BEGIN 
SELECT 
    ReserveringsNr,
	BeginTijd,
    EindTijd,
    TIME_TO_SEC(TIMEDIFF(EindTijd, BeginTijd)) / 3600 AS UrenTotaal,
    TIME_TO_SEC(TIMEDIFF(EindTijd, BeginTijd)) / 3600 
    - DATEDIFF(EindTijd, BeginTijd) * 12 AS UrenBetaald,
    TariefUur,
    (TIME_TO_SEC(TIMEDIFF(EindTijd, BeginTijd)) / 3600 
    - DATEDIFF(EindTijd, BeginTijd) * 12) * TariefUur AS Kosten
FROM ParkeerSessie PS
LEFT JOIN ParkeerPlaats PP ON PS.ParkeerPlaats = PP.ParkeerPlaatsId
WHERE ReserveringsNr = spReserveringsNr;
END //

DELIMITER ;