/*
********************************************************
Name: PinPointParking
Content: Data Control Language (DCL) for users and roles

Users and roles: 
1 db_admin (ALL PRIVILIGES) met role ppp_dev
  Geen restrictions
2 Medewerker (SELECT, DELETE) met role ppp_medewerker
  Userrestriction tables
3 Bedrijf (SELECT, INSERT, UPDATE, DELETE)
  Views voor userrestriction
4 Particulier (SELECT, INSERT, UPDATE, DELETE)
  Algemene user voor nieuwe entrees en per bestaande klant met Views voor userrestriction
********************************************************
*/

/* Aanmaken van usernames met passwords zou normaal niet in een file staan, lijkt me maar dit is nu voor het tonen in de proftaak. Daarnaast gekozen voor hele makkelijke wachtwoorden voor het testen in CMD */

/** 
* 1. Create user db_admin and priviliges 
*/
    CREATE USER IF NOT EXISTS db_admin@localhost
    IDENTIFIED BY '11-11#11';

    CREATE USER IF NOT EXISTS db_admin2@localhost
    IDENTIFIED BY '22-22#22';

    /* Check settings priviliges */
    /* SHOW GRANTS FOR db_admin@localhost;
    SHOW GRANTS FOR db_admin2@localhost;  */

    /* Create Role voor alle db_admin accounts */
    CREATE ROLE ppp_dev;

    /* Set Grants for role ppp_dev */
    GRANT ALL 
    ON pinpointparking.* 
    TO ppp_dev;

    /* Check new priviliges voor role ppp_dev
    SHOW GRANTS FOR ppp_dev; */
    
    /* Grant role to db_admin users */
    GRANT ppp_dev 
    TO db_admin@localhost, 
       db_admin2@localhost;

    /* Check new priviliges */
    /* SHOW GRANTS FOR db_admin@localhost;
    SHOW GRANTS FOR db_admin2@localhost; */
    
    /* To revoke grants */
    /* REVOKE ALL PRIVILEGES, 
    GRANT OPTION 
    FROM db_admin@localhost; */

    /* To drop roles */
    /* DROP ROLE ppp_dev */

/**
* 2. Create user medewerker and priviliges 
*/
    CREATE USER IF NOT EXISTS medewerker@localhost
    IDENTIFIED BY '1-11#1';

    CREATE USER IF NOT EXISTS medewerker2@localhost
    IDENTIFIED BY '2-22#2';

    CREATE USER IF NOT EXISTS medewerker3@localhost
    IDENTIFIED BY '3-33#3';

    /* Check settings priviliges */
    /* SHOW GRANTS FOR medewerker@localhost;
    SHOW GRANTS FOR medewerker2@localhost;
    SHOW GRANTS FOR medewerker3@localhost; */

    /* Create role voor alle medewerker accounts */
    CREATE ROLE ppp_medewerker;

    /* Set Grants for role ppp_medewerker
     */
    GRANT SELECT
    ON pinpointparking.* 
    TO ppp_medewerker;

    GRANT DELETE
    ON pinpointparking.Klant
    TO ppp_medewerker;

    GRANT DELETE
    ON pinpointparking.Zakelijk
    TO ppp_medewerker;

    GRANT DELETE
    ON pinpointparking.Adres
    TO ppp_medewerker;
        
    GRANT DELETE
    ON pinpointparking.Voertuig
    TO ppp_medewerker;

    /* Medewerker kan berekeningen met de stored procedure uitvoeren */
    GRANT EXECUTE 
    ON PROCEDURE pinpointparking.kostenParkeerPlaatsId1 
    TO ppp_medewerker;
    
    /* Grant role to medewerker users */
    GRANT ppp_medewerker 
    TO medewerker@localhost, 
        medewerker2@localhost,
        medewerker3@localhost;

    /* Check new priviliges */
    /* SHOW GRANTS FOR medewerker@localhost;
    SHOW GRANTS FOR medewerker2@localhost;
    SHOW GRANTS FOR medewerker3@localhost; */

    /* To revoke grants */
    /* REVOKE ALL PRIVILEGES, 
    GRANT OPTION 
    FROM medewerker@localhost; */

    /* To drop role */
    /* DROP ROLE ppp_medewerker */
    
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

    /* Check results from Views */
    /* SELECT * FROM klantHenneken;
    SELECT * FROM zakelijkHenneken; 
    SELECT * FROM adresHenneken;
    SELECT * FROM voertuigHenneken; */

    /* Only grant permissions from Views klantHenneken, zakelijkHenneken en adresHenneken */
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

    /* Only grant permission to insert */
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

    /* Check results from Views */
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