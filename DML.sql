/*
***********************************************************
Name: PinPointParking
Content: Data Manipulation Language (DML)

Query-overzicht:
1. Wat zijn de parkeerkosten voor Reserveringsnummer 2
2. Draai factuur uit voor factuurnummer 2 inclusief berekening parkeerkosten
3. Draai alle facturen uit met naam en adres
4. Hoe vaak is elke parkeervoorziening gebruikt en welke is het meest populair?
5. Welke klant heeft het vaakst geparkeerd en voor hoeveel geld in totaal? 
6. Welk bedrijf heeft de meeste medewerkers die parkeren met PPP?
***********************************************************
*/

/* 1. Wat zijn de parkeerkosten voor Reserveringsnummer 2 */
SELECT TariefUur / 3600 * (SELECT TIMEDIFF(EindTijd, BeginTijd) FROM PARKEERSESSIE WHERE ReserveringsNr = 2) AS ParkeerKosten
FROM PARKEEROMGEVING
WHERE ParkeerOmgevingId = 2;

/* 2. Draai factuur uit voor factuurnummer 2 inclusief berekening parkeerkosten

Ik heb nog even tabelaliassen meegegeven om zelf niet in de war te raken. Kunnen straks weer weg */
SELECT
    F.FactuurNr,
    F.FactuurDatum,
    FR.Kenteken,
    K.Voornaam,
    K.Tussenvoegsel,
    K.Achternaam,
    A.Straat,
    A.HuisNr,
    FR.Parkeersessie,
    FR.ParkeerOmgeving,
    (SELECT TariefUur / 3600 * (SELECT TIMEDIFF(EindTijd, BeginTijd) FROM PARKEERSESSIE WHERE ReserveringsNr = 2)  FROM PARKEEROMGEVING WHERE ParkeerOmgevingId = 2) AS ParkeerKosten
FROM FACTUUR F
LEFT JOIN FACTUURREGELS FR ON F.FactuurNr = FR.FactuurNr
LEFT JOIN ADRES A ON F.KlantAdres = A.AdresId
LEFT JOIN KLANT K ON F.KlantId = K.KlantId
WHERE F.FactuurNr = 2;

/* 3. Draai alle facturen uit met naam en adres */
SELECT
    F.FactuurNr,
    F.FactuurDatum,
    FR.Kenteken,
    K.Voornaam,
    K.Tussenvoegsel,
    K.Achternaam,
    A.Straat,
    A.HuisNr,
    FR.Parkeersessie,
    FR.ParkeerOmgeving
FROM FACTUUR F
LEFT JOIN FACTUURREGELS FR ON F.FactuurNr = FR.FactuurNr
LEFT JOIN ADRES A ON F.KlantAdres = A.AdresId
LEFT JOIN KLANT K ON F.KlantId = K.KlantId;


/* 4. Hoe vaak is elke parkeervoorziening gebruikt en welke is het meest populair? */

/* 5. Welke klant heeft het vaakst geparkeerd en voor hoeveel geld in totaal? */

/* 6. Welk bedrijf heeft de meeste medewerkers die parkeren met PPP? */




