/*
***********************************************************
Name: PinPointParking
Content: Data Manipulation Language (DML)
User-stories: db_admin, medewerker, bedrijf, gebruiker

Queries medewerker:
M1. Ik wil alle facturen ophalen met naam en adres
M2. Ik wil alle parkeeromgevingen opsommen van veel naar weinig gebruikt
M3. Ik wil de klant ophalen die het meest heeft geparkeerd
---> M4. Ik wil het bedrijf zien met de meeste medewerkers die PPP gebruiken

Queries db_admin:
---> A1. 

Queries bedrijf:
B1. Ik wil de parkeerkosten zien voor reserveringsnummer 2
B2. Ik wil de factuur ophalen voor factuurnummer 2 inclusief de parkeerkosten
---> B3. Ik wil een overzicht met alle NAW-gegevens van alle medewerkers die PPP gebruiken

Queries gebruiker:
---> G1. Ik wil al mijn parkeersessies zien
G2. Ik wil mijn adres wijzigen
---> G3. Ik wil mijn account verwijderen


Versie: 1.1
+ DML aangepast
+ DML toegevoegd
+ Users toegevoegd
***********************************************************
*/

/* M1. Alle facturen met naam en adres */
SELECT
    F.FactuurNr,
    F.FactuurDatum,
    FR.Kenteken,
    CONCAT_WS(' ', Voornaam, Tussenvoegsel, Achternaam) AS KlantNaam,
    CONCAT_WS(' ', A.Straat, A.HuisNr, A.Stad) AS KlantAdres,
    CONCAT_WS(' ', PP.Straat, PP.HuisNr, PP.Stad) AS ParkeerPlaats,
    BeginTijd,
    EindTijd
FROM Factuur F
LEFT JOIN FactuurRegel FR ON F.FactuurNr = FR.FactuurNr
LEFT JOIN Adres A ON F.AdresId = A.AdresId
LEFT JOIN Klant K ON F.KlantId = K.KlantId
LEFT JOIN ParkeerPlaats PP ON FR.ParkeerPlaats = PP.ParkeerPlaatsId
LEFT JOIN ParkeerSessie PS ON FR.ParkeerSessie = PS.ReserveringsNr;

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
    PS.Kenteken,
    CONCAT_WS(' ', Voornaam, Tussenvoegsel, Achternaam) AS KlantNaam,
    COUNT(PS.Kenteken) AS AantalKeer
FROM ParkeerSessie PS
LEFT JOIN Voertuig V ON PS.Kenteken = V.Kenteken
LEFT JOIN Klant K ON V.KlantId = K.KlantId
GROUP BY PS.Kenteken
ORDER BY AantalKeer DESC
LIMIT 1;

/* B1. Parkeerkosten reserveringsnummer 2 */

/***
* Nog niet uitgevogeld hoe je Begin- en EindBetaaldParkerenDag mee moet nemen in de berekening.
*/

SELECT 
    ReserveringsNr,
    CONCAT_WS(' ', PP.Straat, PP.HuisNr, PP.Stad) AS ParkeerPlaats,
    BeginTijd,
    EindTijd,
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

/* G2. Adres wijzigen */
UPDATE adres
SET 
    Straat = 'Westerstraat',
    HuisNr = '65',
    Postcode = '5988WT',
    Stad = 'Tilburg'
WHERE klantId = 1;