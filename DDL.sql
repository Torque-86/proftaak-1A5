/*
***********************************************************
Name: PinPointParking
Content: Data Definition Language (DDL) and dummy data
Version 2.0
+ added comments
+ merged DDL and database data
***********************************************************
*/

/* Create database pinpointparking */
DROP DATABASE IF EXISTS pinpointparking;
CREATE DATABASE pinpointparking CHARACTER SET UTF8;
USE pinpointparking;

/* Create table ZAKELIJK */
CREATE TABLE ZAKELIJK (
    BedrijfsId INT(10) PRIMARY KEY AUTO_INCREMENT,
    BedrijfsNaam VARCHAR(60),
    BtwNummer VARCHAR(14),
    KvkNummer INT(8)
);

/* Insert dummy data table ZAKELIJK */

INSERT INTO ZAKELIJK
VALUES 
    (DEFAULT, 'Schadebo', 'NL001234567B01', 12345678),
    (DEFAULT, 'FC Kip', 'NL003456789B02', 87654321);

/* Create table KLANT */
CREATE TABLE KLANT (
    KlantId INT(10) PRIMARY KEY AUTO_INCREMENT,
    Registratiedatum TIMESTAMP,
    Mailadres VARCHAR(60) NOT NULL UNIQUE,
    Wachtwoord VARCHAR(60) NOT NULL,
    Voornaam VARCHAR(20) NOT NULL,
    Tussenvoegsel VARCHAR(10),
    Achternaam VARCHAR(60) NOT NULL,
    Mobiel CHAR(10) NOT NULL UNIQUE,
    BedrijfsId INT(10),

    CONSTRAINT zakelijkeKlantFK
    FOREIGN KEY (BedrijfsId)
    REFERENCES ZAKELIJK (BedrijfsId)
    ON DELETE RESTRICT
);

/* Insert dummy data table KLANT */
INSERT INTO KLANT
VALUES
    (DEFAULT, DEFAULT, 'info@schadebo.nl', 'Wachtwoord1234', 'Henk', NULL, 'Vogel', '0612345678', '1'),
    (DEFAULT, DEFAULT, 'karin@ziggo.nl', 'Wachtwoord5678', 'Karin', 'van de', 'Oosterdijk', '0687654321', NULL),
    (DEFAULT, DEFAULT, 'info@fckip.nl', 'Wachtwoord9012', 'Corrie', 'van de', 'Leg', '0698761234', 2);

/* CREATE table ADRES */
CREATE TABLE ADRES (
    AdresId INT(10) PRIMARY KEY AUTO_INCREMENT,
    Straat VARCHAR(60) NOT NULL,
    HuisNr VARCHAR(60) NOT NULL,
    Postcode VARCHAR(6) NOT NULL,
    Stad VARCHAR(60) NOT NULL,
    Land VARCHAR(60) DEFAULT 'Nederland',
    TelefoonVast CHAR(10) UNIQUE,
    KlantId INT(10) NOT NULL,

    CONSTRAINT klantAdresFK
    FOREIGN KEY (KlantId)
    REFERENCES KLANT (KlantId)
    ON DELETE RESTRICT
);

/* Insert dummy data table ADRES */
INSERT INTO ADRES
VALUES
    (DEFAULT, 'Oosterstraat', 29, '5242KL', 'Den Bosch', DEFAULT, '0735212345', 1),
    (DEFAULT, 'Kerkstraat', 99, '4842DN', 'Breda', DEFAULT, NULL, 2),
    (DEFAULT, 'Laan van Columbus', 1, '9797PC', 'Thesigne', DEFAULT, '0501234567', 3);

/* Create table VOERTUIG */
CREATE TABLE VOERTUIG (
    Kenteken VARCHAR(8) PRIMARY KEY,
    KlantId INT(10) NOT NULL,

    CONSTRAINT klantVoertuigFK
    FOREIGN KEY (KlantId)
    REFERENCES KLANT (KlantId)
    ON DELETE RESTRICT
);

/* Insert dummy data table VOERTUIG */
INSERT INTO VOERTUIG
VALUES 
    ('XD-43-LK', 1),
    ('7-GHT-34', 2),
    ('NL-72-PK', 3);

/* Create table PARKEEROMGEVING */
CREATE TABLE PARKEEROMGEVING (
    ParkeerOmgevingId INT(10) PRIMARY KEY AUTO_INCREMENT,
    Postcode VARCHAR(6) NOT NULL,
    Straat VARCHAR(60) NOT NULL,
    HuisNr INT(4),
    Stad VARCHAR(60) NOT NULL,
    TariefUur DOUBLE(3,2) NOT NULL,
    MaxDuur SMALLINT(1),
    BeginBetaaldParkerenDag TIME,
    EindeBetaaldParkerenDag TIME
);

/* Insert dummy data table PARKEEROMGEVING */
INSERT INTO PARKEEROMGEVING
VALUES
    (DEFAULT, '5200LM', 'Leeghmanstraat', NULL, 'Den Bosch', '2.99', 10, '08:00:00', '18:00:00'),
    (DEFAULT, '4815DK', 'Tuinlaan', 56, 'Breda', '3.10', 24, '00:00:00', '00:00:00'),
    (DEFAULT, '9711KZ', 'Rademarkt', 7, 'Groningen', '2.49', 12, '08:00:00', '20:00:00');

/* Create table PARKEERSESSIE */
CREATE TABLE PARKEERSESSIE (
    ReserveringsNr INT(10) PRIMARY KEY AUTO_INCREMENT,
    BeginTijd DATETIME NOT NULL,
    EindTijd DATETIME NOT NULL,
    Kenteken VARCHAR(8) NOT NULL,
    ParkeerOmgeving INT(10) NOT NULL,

    CONSTRAINT kentekenParkeerSessieFK1
    FOREIGN KEY (Kenteken)
    REFERENCES VOERTUIG(Kenteken)
    ON DELETE RESTRICT,

    CONSTRAINT parkeerOmgevingSessieFK2
    FOREIGN KEY (ParkeerOmgeving)
    REFERENCES PARKEEROMGEVING(ParkeerOmgevingId)
    ON DELETE RESTRICT
);

/* Insert dummy data table PARKEERSESSIE */
INSERT INTO PARKEERSESSIE
VALUES 
    (DEFAULT, '2019-11-13 15:02:45', '2019-11-13 16:31:20', 'XD-43-LK', 1),
    (DEFAULT, '2019-11-29 08:22:05', '2019-11-29 09:23:43', '7-GHT-34', 2),
    (DEFAULT, '2019-12-01 23:02:45', '2019-12-02 08:43:08', 'NL-72-PK', 3),
    (DEFAULT, '2019-12-11 09:33:01', '2019-12-13 13:57:42',   '7-GHT-34', 2),
    (DEFAULT, '2019-11-29 10:52:41', '2019-11-29 22:01:09', 'XD-43-LK', 2),
    (DEFAULT, '2019-12-12 11:56:45', '2019-12-12 21:34:01', '7-GHT-34', 1);

/* Create table FACTUUR */
CREATE TABLE FACTUUR (
    FactuurNr INT(10) PRIMARY KEY AUTO_INCREMENT,
    FactuurDatum DATE NOT NULL,
    KlantId INT(10) NOT NULL,
    KlantAdres INT(10) NOT NULL,

    CONSTRAINT klantIdFactuurFK1
    FOREIGN KEY (KlantId)
    REFERENCES KLANT(KlantId)
    ON DELETE RESTRICT,

    CONSTRAINT klantadresFactuurFK2
    FOREIGN KEY (KlantAdres)
    REFERENCES ADRES(AdresId)
    ON DELETE RESTRICT
);

/* Insert dummy data table FACTUUR */
INSERT INTO FACTUUR
VALUES 
    (DEFAULT, '2019-11-14', 1, 1),
    (DEFAULT, '2019-11-30', 2, 2),
    (DEFAULT, '2019-12-03', 3, 3),
    (DEFAULT, '2019-12-12', 2, 2),
    (DEFAULT, '2019-11-30', 1, 1),
    (DEFAULT, '2019-12-13', 2, 2);

/* Create table FACTUURREGELS */
CREATE TABLE FACTUURREGELS (
    FactuurNr INT(10) NOT NULL,
    Kenteken VARCHAR(8) NOT NULL,
    ParkeerSessie INT(10) NOT NULL,
    ParkeerOmgeving INT(10) NOT NULL,

    CONSTRAINT factuurNrFK1
    FOREIGN KEY (FactuurNr)
    REFERENCES FACTUUR(FactuurNr)
    ON DELETE RESTRICT,

    CONSTRAINT kentekenFactuurFK2
    FOREIGN KEY (Kenteken)
    REFERENCES VOERTUIG(Kenteken)
    ON DELETE RESTRICT,

    CONSTRAINT parkeersessieFactuurFK3
    FOREIGN KEY (ParkeerSessie)
    REFERENCES ParkeerSessie(ReserveringsNr)
    ON DELETE RESTRICT,

    CONSTRAINT parkeeromgevingFactuurFK4
    FOREIGN KEY (ParkeerOmgeving)
    REFERENCES ParkeerOmgeving(ParkeerOmgevingId)
    ON DELETE RESTRICT
);

/* Insert dummy data table FACTUURREGELS */
INSERT INTO FACTUURREGELS
VALUES 
    (1, 'XD-43-LK', 1, 1),
    (2, '7-GHT-34', 2, 2),
    (3, 'NL-72-PK', 3, 3),
    (4, '7-GHT-34', 4, 2),
    (5, 'XD-43-LK', 5, 2),
    (6, '7-GHT-34', 6, 1);