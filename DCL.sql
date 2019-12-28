/*
********************************************************
Name: PinPointParking
Content: Data Control Language (DCL) for users and roles

Users and roles: 
- db_admin (ALL PRIVILIGES)
- medewerker (SELECT, DELETE)
- bedrijf (SELECT, INSERT, UPDATE, DELETE)
- particulier (SELECT, INSERT, UPDATE, DELETE)
********************************************************
*/

/** 
* 1. Create user db_admin and priviliges 
*/
    CREATE USER IF NOT EXISTS db_admin@localhost
    IDENTIFIED BY 'HG-738_2fh!ee';

    /* Check settings priviliges */
    /* SHOW GRANTS FOR db_admin@localhost; */

    GRANT ALL
    ON pinpointparking.* 
    TO db_admin@localhost;

    /* Check new priviliges */
    /* SHOW GRANTS FOR db_admin@localhost; */

/**
* 2. Create user medewerker and priviliges 
*/
    CREATE USER IF NOT EXISTS medewerker@localhost
    IDENTIFIED BY 'HFee_342-2fh#f34e';

    /* Check settings priviliges */
    /* SHOW GRANTS FOR medewerker@localhost; */

    GRANT SELECT
    ON pinpointparking.* 
    TO medewerker@localhost;

    GRANT DELETE
    ON pinpointparking.Klant
    TO medewerker@localhost;

    GRANT DELETE
    ON pinpointparking.Zakelijk
    TO medewerker@localhost;

    GRANT DELETE
    ON pinpointparking.Adres
    TO medewerker@localhost;
        
    GRANT DELETE
    ON pinpointparking.Voertuig
    TO medewerker@localhost;

    /* Medewerker kan berekeningen met de stored procedure uitvoeren */
    GRANT EXECUTE 
    ON PROCEDURE kostenParkeerPlaatsId1 
    TO medewerker@localhost;
    
/* Check new priviliges */
/* SHOW GRANTS FOR medewerker@localhost; */

/**
* 3. Create user bedrijf Henneken and priviliges 
*/
    CREATE USER IF NOT EXISTS bedrijfHenneken@localhost
    IDENTIFIED BY '11-1#1';

    /* Check settings priviliges */
    /* SHOW GRANTS FOR bedrijfHenneken@localhost; */

    /* Create Views first: user bedrijf Henneken */
    CREATE VIEW klantHenneken AS
    SELECT *
    FROM Klant
    WHERE KvkNummer = 12345678;

    CREATE VIEW zakelijkHenneken AS
    SELECT *
    FROM Zakelijk
    WHERE KvkNummer = 12345678;

    CREATE VIEW adresHenneken AS
    SELECT 
        AdresId,
        Straat,
        HuisNr,
        Postcode,
        Stad,
        Land,
        TelefoonVast
    FROM Adres A
    LEFT JOIN klant K ON A.KlantId = K.KlantId
    WHERE KvkNummer = 12345678;

    CREATE VIEW voertuigHenneken AS
    SELECT 
        VoertuigId, 
        Kenteken
    FROM Voertuig V
    LEFT JOIN Klant K ON V.KlantId = K.KlantId
    WHERE KvkNummer = 12345678;

    /* SELECT * FROM klantHenneken;
    SELECT * FROM zakelijkHenneken; 
    SELECT * FROM adresHenneken;
    SELECT * FROM voertuigHenneken; */

    /* Only grant rows from view klantHenneken, zakelijkHenneken en adresHenneken */
    GRANT SELECT, INSERT, UPDATE, DELETE
    ON pinpointparking.klantHenneken
    TO bedrijfHenneken@localhost;

    GRANT SELECT, UPDATE, DELETE
    ON pinpointparking.zakelijkHenneken
    TO bedrijfHenneken@localhost;

    GRANT SELECT, INSERT, UPDATE, DELETE
    ON pinpointparking.adresHenneken
    TO bedrijfHenneken@localhost;

    GRANT SELECT, INSERT, UPDATE, DELETE
    ON pinpointparking.voertuigHenneken
    TO bedrijfHenneken@localhost;

    /* Check new priviliges */
    /* SHOW GRANTS FOR bedrijfHenneken@localhost; */

/**
* 4. Create new user (userinput) particulier and priviliges
*/
    CREATE USER IF NOT EXISTS newparticulier@localhost
    IDENTIFIED BY '22-2#2';

    /* Check settings priviliges */
    /* SHOW GRANTS FOR newparticulier@localhost; */

    /* Only grant insertion */
    GRANT INSERT
    ON pinpointparking.klant
    TO newparticulier@localhost;

    GRANT INSERT
    ON pinpointparking.adres
    TO newparticulier@localhost;

    GRANT INSERT
    ON pinpointparking.voertuig
    TO newparticulier@localhost;

/**
* 5. Create existing user particulier klantId1 and priviliges 
*/
    CREATE USER IF NOT EXISTS klantId1@localhost
    IDENTIFIED BY '1_1-1#1';

    /* Check settings priviliges */
    /* SHOW GRANTS FOR klantId1@localhost; */

    /* Create Views first: user particulier klantId1 */
    CREATE VIEW klantId1 AS
    SELECT *
    FROM Klant
    WHERE KlantId = 1;

    CREATE VIEW adresKlantId1 AS
    SELECT 
        AdresId,
        Straat,
        HuisNr,
        Postcode,
        Stad,
        Land,
        TelefoonVast
    FROM Adres A
    LEFT JOIN klant K ON A.KlantId = K.KlantId
    WHERE A.KlantId = 1;

    CREATE VIEW voertuigKlantId1 AS
    SELECT 
        VoertuigId, 
        Kenteken
    FROM Voertuig V
    LEFT JOIN Klant K ON V.KlantId = K.KlantId
    WHERE V.KlantId = 1;

    /* SELECT * FROM klantId1;
    SELECT * FROM adresKlantId1;
    SELECT * FROM voertuigKlantId1; */

    /* Only grant rows from view klantId1, adresKlantId1 en voertuigKlantId1 */
    GRANT SELECT, UPDATE, DELETE
    ON pinpointparking.klantId1
    TO klantId1@localhost;

    GRANT SELECT, UPDATE, DELETE
    ON pinpointparking.adresKlantId1
    TO klantId1@localhost;

    GRANT SELECT, INSERT, UPDATE, DELETE
    ON pinpointparking.voertuigKlantId1
    TO klantId1@localhost;

    /* Check new priviliges */
    /* SHOW GRANTS FOR klantId1@localhost; */