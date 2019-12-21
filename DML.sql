/*
***********************************************************
Name: PinPointParking
Content: Data Manipulation Language (DML)
***********************************************************
*/

/* Wat zijn de parkeerkosten voor Reserveringsnummer 2 */
SELECT TariefUur / 3600 * (SELECT TIMEDIFF(EindTijd, BeginTijd) 
FROM PARKEERSESSIE WHERE ReserveringsNr = 2) AS ParkeerKosten
FROM PARKEEROMGEVING
WHERE ParkeerOmgevingId = 2;


/* Hoe vaak is elke parkeervoorziening gebruikt en welke is het meest populair? */

/* Welke klant heeft het vaakst geparkeerd en voor hoeveel geld in totaal? */

/* Welk bedrijf heeft de meeste medewerkers die parkeren met PPP? */




