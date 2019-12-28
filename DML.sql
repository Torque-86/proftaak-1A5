/*
***********************************************************
Name: PinPointParking
Content: Data Manipulation Language (DML)
User-stories: db_admin, medewerker, bedrijf, particulier

Queries medewerker:
M1. Ik wil alle facturen ophalen met naam en adres
M2. Ik wil alle parkeeromgevingen opsommen van veel naar weinig gebruikt
M3. Ik wil de klant ophalen die het meest heeft geparkeerd
---> M4. Ik wil het bedrijf zien met de meeste medewerkers die PPP gebruiken
M5. Ik wil een beknopt overzicht van klant, kenteken en het aantal sessies per klant

Queries db_admin:
---> A1. 

Queries bedrijf:
B1. Ik wil de parkeerkosten zien voor reserveringsnummer 2
B2. Ik wil de factuur ophalen voor factuurnummer 2 inclusief de parkeerkosten
---> B3. Ik wil een overzicht met alle NAW-gegevens van alle medewerkers die PPP gebruiken

Queries particulier:
---> P1. Ik wil al mijn parkeersessies zien
P2. Ik wil mijn adres wijzigen
---> P3. Ik wil mijn account verwijderen

Versie 1.2
+ Stored Procedures toegevoegd
Versie 1.1
+ Userstories toegevoegd
***********************************************************
*/

/* M1. Alle facturen met naam en adres */
SELECT 
	F.FactuurNr,
    F.FactuurDatum,
	CONCAT_WS(' ', Voornaam, Tussenvoegsel, Achternaam) AS Naam,
    BeginTijd,
    EindTijd,
    CONCAT_WS(' ', FR.Straat, FR.HuisNr, FR.Stad) AS Parkeerplaats
FROM Factuur F
LEFT JOIN FactuurRegel FR ON F.FactuurNr = FR.FactuurNr;

/* M2. Alle parkeerplaatsen van veel naar weinig gebruikt */
SELECT 
    ParkeerPlaatsId AS Id,
	CONCAT_WS(' ', Straat, HuisNr, Stad) AS ParkeerPlaats,
    COUNT(PS.ParkeerPlaats) AS AantalKeer
FROM ParkeerPlaats PP
LEFT JOIN ParkeerSessie PS ON PP.ParkeerPlaatsId = PS.ParkeerPlaats
GROUP BY ParkeerPlaats
ORDER BY AantalKeer DESC;

/* M3. Klant die het meest heeft geparkeerd */
SELECT 
    V.Kenteken,
    CONCAT_WS(' ', Voornaam, Tussenvoegsel, Achternaam) AS KlantNaam,
    COUNT(PS.VoertuigId) AS AantalKeer
FROM ParkeerSessie PS
LEFT JOIN Voertuig V ON PS.VoertuigId = V.VoertuigId
LEFT JOIN Klant K ON V.KlantId = K.KlantId
GROUP BY PS.VoertuigId
ORDER BY AantalKeer DESC
LIMIT 1;

/* M4. Ik wil het bedrijf zien met de meeste medewerkers die PPP gebruiken */
    
/* B1. Parkeerkosten reserveringsnummer 2 */

/***
* Nog niet uitgevogeld hoe je Begin- en EindBetaaldParkerenDag mee moet nemen in de berekening.
*/

SELECT 
    ReserveringsNr,
    CONCAT_WS(' ', PP.Straat, PP.HuisNr, PP.Stad) AS ParkeerPlaats,
    BeginTijd,
    EindTijd,
    TIMEDIFF(EindTijd, BeginTijd) AS Parkeertijd,
    TariefUur / 3600 * (SELECT TIME_TO_SEC(TIMEDIFF      
                        (EindTijd, BeginTijd)) 
                        FROM ParkeerSessie 
                        WHERE ReserveringsNr = 2) 
                        AS ParkeerKosten
FROM ParkeerSessie PS
LEFT JOIN ParkeerPlaats PP ON PS.ParkeerPlaats = PP.ParkeerPlaatsId
WHERE ReserveringsNr = 2;

/* B2. Factuurnummer 2 inclusief parkeerkosten */
SELECT
    F.FactuurNr,
    F.FactuurDatum,
    FR.Kenteken,
    CONCAT_WS(' ', Voornaam, Tussenvoegsel, Achternaam) AS KlantNaam,
    CONCAT_WS(' ', A.Straat, A.HuisNr, A.Stad) AS KlantAdres,
    CONCAT_WS(' ', PP.Straat, PP.HuisNr, PP.Stad) AS ParkeerPlaats,
    (SELECT TariefUur / 3600 * (SELECT TIMEDIFF(EindTijd,   
                                BeginTijd) 
                                FROM ParkeerSessie 
                                WHERE ReserveringsNr = 2) 
     FROM ParkeerPlaats 
     WHERE ParkeerPlaatsId = 2) 
     AS ParkeerKosten
FROM Factuur F
LEFT JOIN FactuurRegel FR ON F.FactuurNr = FR.FactuurNr
LEFT JOIN Adres A ON F.AdresId = A.AdresId
LEFT JOIN Klant K ON F.KlantId = K.KlantId
LEFT JOIN ParkeerPlaats PP ON FR.ParkeerPlaats =  PP.ParkeerPlaatsId
WHERE F.FactuurNr = 2;

/* B3. Ik wil een overzicht met alle NAW-gegevens van alle medewerkers die PPP gebruiken */

/* P1. Ik wil al mijn parkeersessies zien */

/* P2. Adres wijzigen */
UPDATE adres
SET 
    Straat = 'Westerstraat',
    HuisNr = '65',
    Postcode = '5988WT',
    Stad = 'Tilburg'
WHERE klantId = 1;

/* P3. Ik wil mijn account verwijderen */

/**
* STORED PROCEDURES
**/
DELIMITER //
/* Stored Procedure: simpele test om alle parkeersessies op te halen */
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
 



