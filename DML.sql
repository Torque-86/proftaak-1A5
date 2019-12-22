/*
***********************************************************
Name: PinPointParking
Content: Data Manipulation Language (DML)

Query-overzicht:
1. Wat zijn de parkeerkosten voor Reserveringsnummer 2
2. Haal factuur op voor factuurnummer 2 inclusief berekening parkeerkosten
3. Haal alle facturen op met naam en adres
4. Haal alle facturen met factuurregels op met naam en adres
5. Som de parkeeromgevingen op van veel naar weinig gebruikt
6. Haal de klant op die het meest heeft geparkeerd
7. Welk bedrijf heeft de meeste medewerkers die van PPP gebruik maken

Stored Procedures:
A. GetAllCustomers()
***********************************************************
*/

/***
* Vergeten de Begin- en EindBetaaldParkerenDag mee te nemen  * in de berekening. Probeer ik nog.
***/

/* 1. Wat zijn de parkeerkosten voor Reserveringsnummer 2 */
SELECT TariefUur / 3600 * (SELECT TIMEDIFF(EindTijd, BeginTijd) 
                           FROM PARKEERSESSIE 
                           WHERE ReserveringsNr = 2) 
                           AS ParkeerKosten
FROM PARKEEROMGEVING
WHERE ParkeerOmgevingId = 2;

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
    CONCAT_WS(' ', Voornaam, Tussenvoegsel, Achternaam) AS Naam,
    CONCAT_WS(' ', Straat, HuisNr, Stad) AS Adres,
    Parkeersessie,
    ParkeerOmgeving
FROM FACTUUR F
LEFT JOIN FACTUURREGELS FR ON F.FactuurNr = FR.FactuurNr
LEFT JOIN ADRES A ON F.KlantAdres = A.AdresId
LEFT JOIN KLANT K ON F.KlantId = K.KlantId;

/* 4. Haal alle facturen met factuurregels op met naam en adres */
SELECT
    F.FactuurNr,
    F.FactuurDatum,
    FR.Kenteken,
    CONCAT_WS(' ', Voornaam, Tussenvoegsel, Achternaam) AS KlantNaam,
    CONCAT_WS(' ', A.Straat, A.HuisNr, A.Stad) AS KlantAdres,
    PS.BeginTijd,
    PS.EindTijd,
    CONCAT_WS(' ', PO.Straat, PO.HuisNr, PO.Stad) AS ParkeerOmgeving
FROM FACTUUR F
LEFT JOIN FACTUURREGELS FR ON F.FactuurNr = FR.FactuurNr
LEFT JOIN ADRES A ON F.KlantAdres = A.AdresId
LEFT JOIN KLANT K ON F.KlantId = K.KlantId
LEFT JOIN PARKEERSESSIE PS ON FR.Kenteken = PS.Kenteken
LEFT JOIN PARKEEROMGEVING PO ON PS.ParkeerOmgeving = PO.ParkeerOmgevingId;

/* 5. Som de parkeeromgevingen op van veel naar weinig gebruikt */
SELECT 
    ParkeerOmgevingId AS Id,
	CONCAT_WS(' ', Straat, HuisNr, Stad) AS ParkeerOmgeving,
    COUNT(PS.ParkeerOmgeving) AS AantalKeer
FROM PARKEEROMGEVING PO
LEFT JOIN PARKEERSESSIE PS ON PO.ParkeerOmgevingId = PS.ParkeerOmgeving
GROUP BY ParkeerOmgeving
ORDER BY AantalKeer DESC;

/* 6. Haal de klant op die het meest heeft geparkeerd */
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


/* 7. Welk bedrijf heeft de meeste medewerkers die van PPP gebruik maken */



/* A. GetAllCustomers() */