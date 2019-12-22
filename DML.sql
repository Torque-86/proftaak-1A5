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
    CONCAT_WS(' ', PO.Straat, PO.HuisNr, PO.Stad) AS ParkeerOmgeving,
    BeginTijd,
    EindTijd,
    TariefUur / 3600 * (SELECT TIME_TO_SEC(TIMEDIFF      
                        (EindTijd, BeginTijd)) 
                        FROM PARKEERSESSIE 
                        WHERE ReserveringsNr = 2) 
                        AS ParkeerKosten
FROM PARKEERSESSIE PS
LEFT JOIN PARKEEROMGEVING PO ON PS.ParkeerOmgeving = PO.ParkeerOmgevingId
WHERE ReserveringsNr = 2;

/* 1a Controle van de berekening parkeerkosten */
SELECT 
	ReserveringsNr,
    ParkeerOmgeving,
	TIMEDIFF(EindTijd, BeginTijd) AS Duur,
    TIME_TO_SEC(TIMEDIFF(EindTijd, BeginTijd)) AS Seconden
FROM PARKEERSESSIE 
WHERE ReserveringsNr = 2;
                        
SELECT 
    ParkeerOmgevingId,
	TariefUur AS Uurtarief,
    TariefUur / 3600 AS Rekentarief
FROM ParkeerOmgeving
WHERE ParkeerOmgevingId = 2;

SELECT 
    ReserveringsNr,
    ParkeerOmgevingId,
    TariefUur / 3600 * (SELECT TIME_TO_SEC(TIMEDIFF      
                        (EindTijd, BeginTijd)) 
                        FROM PARKEERSESSIE 
                        WHERE ReserveringsNr = 2) 
                        AS ParkeerKosten
FROM PARKEERSESSIE PS
LEFT JOIN PARKEEROMGEVING PO ON PS.ParkeerOmgeving = PO.ParkeerOmgevingId
WHERE ReserveringsNr = 2;

/* 2. Haal factuur op voor factuurnummer 2 inclusief berekening parkeerkosten */
SELECT
    F.FactuurNr,
    F.FactuurDatum,
    FR.Kenteken,
    CONCAT_WS(' ', Voornaam, Tussenvoegsel, Achternaam) AS KlantNaam,
    CONCAT_WS(' ', A.Straat, A.HuisNr, A.Stad) AS KlantAdres,
    Parkeersessie,
    ParkeerOmgeving,
    (SELECT TariefUur / 3600 * (SELECT TIMEDIFF(EindTijd, BeginTijd) 
                                FROM PARKEERSESSIE 
                                WHERE ReserveringsNr = 2) 
     FROM PARKEEROMGEVING 
     WHERE ParkeerOmgevingId = 2) 
     AS ParkeerKosten
FROM FACTUUR F
LEFT JOIN FACTUURREGELS FR ON F.FactuurNr = FR.FactuurNr
LEFT JOIN ADRES A ON F.KlantAdres = A.AdresId
LEFT JOIN KLANT K ON F.KlantId = K.KlantId
WHERE F.FactuurNr = 2;

/* 3. Haal alle facturen op met naam en adres */
SELECT
    F.FactuurNr,
    F.FactuurDatum,
    FR.Kenteken,
    CONCAT_WS(' ', Voornaam, Tussenvoegsel, Achternaam) AS KlantNaam,
    CONCAT_WS(' ', A.Straat, A.HuisNr, A.Stad) AS KlantAdres,
    CONCAT_WS(' ', PO.Straat, PO.HuisNr, PO.Stad) AS ParkeerOmgeving,
    BeginTijd,
    EindTijd
FROM FACTUUR F
LEFT JOIN FACTUURREGELS FR ON F.FactuurNr = FR.FactuurNr
LEFT JOIN ADRES A ON F.KlantAdres = A.AdresId
LEFT JOIN KLANT K ON F.KlantId = K.KlantId
LEFT JOIN PARKEEROMGEVING PO ON FR.ParkeerOmgeving = PO.ParkeerOmgevingId
LEFT JOIN PARKEERSESSIE PS ON FR.ParkeerSessie = PS.ReserveringsNr;

/* 4. Som de parkeeromgevingen op van veel naar weinig gebruikt */
SELECT 
    ParkeerOmgevingId AS Id,
	CONCAT_WS(' ', Straat, HuisNr, Stad) AS ParkeerOmgeving,
    COUNT(PS.ParkeerOmgeving) AS AantalKeer
FROM PARKEEROMGEVING PO
LEFT JOIN PARKEERSESSIE PS ON PO.ParkeerOmgevingId = PS.ParkeerOmgeving
GROUP BY ParkeerOmgeving
ORDER BY AantalKeer DESC;

/* 5. Haal de klant op die het meest heeft geparkeerd */
SELECT 
    PS.Kenteken,
    CONCAT_WS(' ', Voornaam, Tussenvoegsel, Achternaam) AS KlantNaam,
    COUNT(PS.Kenteken) AS AantalKeer
FROM PARKEERSESSIE PS
LEFT JOIN VOERTUIG V ON PS.Kenteken = V.Kenteken
LEFT JOIN KLANT K ON V.KlantId = K.KlantId
GROUP BY PS.Kenteken
ORDER BY AantalKeer DESC
LIMIT 1;


/* 6. Welk bedrijf heeft de meeste medewerkers die van PPP gebruik maken */
