# PinPointParking
# Data Definition Language

DROP DATABASE IF EXISTS pinpointparking;
CREATE DATABASE pinpointparking CHARACTER SET UTF8;
USE pinpointparking;

CREATE TABLE ZAKELIJK (
    BedrijfsId INT(10) PRIMARY KEY AUTO_INCREMENT,
    BedrijfsNaam VARCHAR(60),
    BtwNummer VARCHAR(14),
    KvkNummer INT(8)
);

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

CREATE TABLE VOERTUIG (
    Kenteken VARCHAR(8) PRIMARY KEY,
    KlantId INT(10) NOT NULL,

    CONSTRAINT klantVoertuigFK
    FOREIGN KEY (KlantId)
    REFERENCES KLANT (KlantId)
    ON DELETE RESTRICT
);

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
