/*
***********************************************************
Name: PinPointParking
Content: Data Manipulation Language (DML)

Query-overzicht:
1. Wat zijn de parkeerkosten voor Reserveringsnummer 2
1a. Controle-overzicht van de berekening parkeerkosten
2. Haal factuur op voor factuurnummer 2 inclusief berekening parkeerkosten
3. Haal alle facturen op met naam en adres
4. Som de parkeeromgevingen op van veel naar weinig gebruikt
5. Haal de klant op die het meest heeft geparkeerd
6. Welk bedrijf heeft de meeste medewerkers die van PPP gebruik maken

***********************************************************
*/

/***
* Nog niet uitgevogeld hoe je Begin- en EindBetaaldParkerenDag mee moet nemen in de berekening.
*/

/* 1. Wat zijn de parkeerkosten voor Reserveringsnummer 2 */
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

/* 1a Controle van de berekening parkeerkosten */
SELECT 
	ReserveringsNr,
    ParkeerPlaats,
	TIMEDIFF(EindTijd, BeginTijd) AS Duur,
    TIME_TO_SEC(TIMEDIFF(EindTijd, BeginTijd)) AS Seconden
FROM ParkeerSessie 
WHERE ReserveringsNr = 2;
                        
SELECT 
    ParkeerPlaatsId,
	TariefUur AS Uurtarief,
    TariefUur / 3600 AS Rekentarief
FROM ParkeerPlaats
WHERE ParkeerPlaatsId = 2;

SELECT 
    ReserveringsNr,
    ParkeerPlaatsId,
    TariefUur / 3600 * (SELECT TIME_TO_SEC(TIMEDIFF      
                        (EindTijd, BeginTijd)) 
                        FROM PARKEERSESSIE 
                        WHERE ReserveringsNr = 2) 
                        AS ParkeerKosten
FROM ParkeerSessie PS
LEFT JOIN ParkeerPlaats PP ON PS.ParkeerPlaats = PP.ParkeerPlaatsId
WHERE ReserveringsNr = 2;

/* 2. Haal factuur op voor factuurnummer 2 inclusief berekening parkeerkosten */
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

/* 3. Haal alle facturen op met naam en adres */
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

/* 4. Som de parkeeromgevingen op van veel naar weinig gebruikt */
SELECT 
    ParkeerPlaatsId AS Id,
	CONCAT_WS(' ', Straat, HuisNr, Stad) AS ParkeerPlaats,
    COUNT(PS.ParkeerPlaats) AS AantalKeer
FROM ParkeerPlaats PP
LEFT JOIN ParkeerSessie PS ON PP.ParkeerPlaatsId = PS.ParkeerPlaats
GROUP BY ParkeerPlaats
ORDER BY AantalKeer DESC;

/* 5. Haal de klant op die het meest heeft geparkeerd */
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


/* 6. Welk bedrijf heeft de meeste medewerkers die van PPP gebruik maken */
