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
B1. Ik wil de factuur ophalen voor factuurnummer 13 inclusief de parkeerkosten
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

/**
* M1. Alle facturen met naam en adres 
*/
SELECT 
	F.FactuurNr,
    F.FactuurDatum,
	CONCAT_WS(' ', Voornaam, Tussenvoegsel, Achternaam) AS Naam,
    BeginTijd,
    EindTijd,
    CONCAT_WS(' ', FR.Straat, FR.HuisNr, FR.Stad) AS Parkeerplaats
FROM Factuur F
LEFT JOIN FactuurRegel FR ON F.FactuurNr = FR.FactuurNr;

/**
* M2. Alle parkeerplaatsen van veel naar weinig gebruikt 
*/
SELECT 
    ParkeerPlaatsId AS Id,
	CONCAT_WS(' ', Straat, HuisNr, Stad) AS ParkeerPlaats,
    COUNT(PS.ParkeerPlaats) AS AantalKeer
FROM ParkeerPlaats PP
LEFT JOIN ParkeerSessie PS ON PP.ParkeerPlaatsId = PS.ParkeerPlaats
GROUP BY ParkeerPlaats
ORDER BY AantalKeer DESC;

/**
* M3. Klant die het meest heeft geparkeerd 
*/
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

/**
* M4. Ik wil het bedrijf zien met de meeste medewerkers die PPP gebruiken 
*/
    
/**
* B1. Factuurnummer 13 inclusief parkeerkosten - nog niet opgelost hoe je meerdere parkeerregels kunt toevoegen  
*/
SELECT
    F.FactuurNr,
    F.FactuurDatum,
    FR.Kenteken,
    CONCAT_WS(' ', F.Voornaam, F.Tussenvoegsel, F.Achternaam) AS KlantNaam,
    CONCAT_WS(' ', F.Straat, F.HuisNr, F.Stad) AS KlantAdres,
    CONCAT_WS(' ', FR.Straat, FR.HuisNr, FR.Stad) AS ParkeerPlaats,
    BeginTijd,
    EindTijd,
    TIMEDIFF(EindTijd, BeginTijd) AS Parkeertijd,
    TariefUur AS Uurtarief,
    (SELECT TariefUur / 3600 * (TIME_TO_SEC(TIMEDIFF(EindTijd,   
                                BeginTijd)))
                                FROM FactuurRegel 
                                WHERE FactuurNr = 13) AS ParkeerKosten
FROM Factuur F
LEFT JOIN FactuurRegel FR ON F.FactuurNr = FR.FactuurNr
WHERE F.FactuurNr = 13;

/**
* B3. Ik wil een overzicht met alle NAW-gegevens van alle medewerkers die PPP gebruiken 
*/

/**
* P1. Ik wil al mijn parkeersessies zien 
*/

/**
* P2. Adres wijzigen 
*/
UPDATE adres
SET 
    Straat = 'Westerstraat',
    HuisNr = '65',
    Postcode = '5988WT',
    Stad = 'Tilburg'
WHERE klantId = 1;

/**
* P3. Ik wil mijn account verwijderen 
*/

/*******************
* STORED PROCEDURES
**/

/**
* 1 Stored Procedure: simpele test om alle parkeersessies op te halen 
*/
DELIMITER $$

CREATE PROCEDURE GetAllParkeersessies()
BEGIN
    SELECT *
    FROM ParkeerSessie;
END $$

DELIMITER ;

/*
CALL GetAllParkeersessies();
*/

/**
* 2 Stored Procedure: parkeerkosten (inclusief gratis uren) van factuurnummer X - nog niet opgelost met dubbele parkeersessies op 1 factuur 
*/
DELIMITER $$

CREATE PROCEDURE parkeerKostenFactuurNr(
    IN sp_FactuurNr INT(10)
)
BEGIN
    SELECT
        F.FactuurNr,
        F.FactuurDatum,
        FR.Kenteken,
        CONCAT_WS(' ', F.Voornaam, F.Tussenvoegsel, F.Achternaam) AS KlantNaam,
        CONCAT_WS(' ', F.Straat, F.HuisNr, F.Stad) AS KlantAdres,
        CONCAT_WS(' ', FR.Straat, FR.HuisNr, FR.Stad) AS ParkeerPlaats,
        BeginTijd,
        EindTijd,
        TIMEDIFF(EindTijd, BeginTijd) AS Parkeertijd,
        TariefUur AS Uurtarief,
        (SELECT TariefUur / 3600 * (TIME_TO_SEC(TIMEDIFF(EindTijd,   
                                    BeginTijd)))
                                    FROM FactuurRegel 
                                    WHERE FactuurNr = sp_FactuurNr) AS ParkeerKosten
    FROM Factuur F
    LEFT JOIN FactuurRegel FR ON F.FactuurNr = FR.FactuurNr
    WHERE F.FactuurNr = sp_FactuurNr;
END $$
 
DELIMITER ;

/* 
CALL parkeerKostenFactuurNr(7);
*/

/**
* 3. Stored Procedure: bereken parkeerkosten exclusief de gratis parkerentijden - nog niet opgelost als iemand van 23:00 tot 06:00 uur parkeert (SP zet einddatum dan terug waardoor deze eerder begint dan de begindatum. Nog oplossen)
*/
DELIMITER $$
CREATE PROCEDURE kostenParkeerPlaatsId1 ( 
    IN SP_ReserveringsNr INT )
BEGIN

-- Declareer de variabelen die we nodig hebben
    DECLARE starttime_time time;
    DECLARE starttime_date date;
    DECLARE endtime_time time;
    DECLARE endtime_date date;

    DECLARE starttime_time_checked time;
    DECLARE starttime_date_checked date;
    DECLARE starttime_day_difference int;
    DECLARE endtime_time_checked time;
    DECLARE endtime_date_checked date;
    DECLARE endtime_day_difference int;

    DECLARE paytime_time int;
    DECLARE paytime_fulldays int;


-- Haal de gegevens uit de database. Ik splits het hier gelijk in 
-- datum en tijd voor de duidelijkheid, maar dat kan je ook later 
-- doen natuurlijk zodat je geen vier queries nodig hebt.    
    SET @starttime_time = ( SELECT TIME (BeginTijd) FROM ParkeerSessie WHERE ReserveringsNr = SP_ReserveringsNr );
    SET @starttime_date = ( SELECT DATE (BeginTijd) FROM ParkeerSessie WHERE ReserveringsNr = SP_ReserveringsNr );

    SET @endtime_time = ( SELECT TIME (eindtijd) FROM ParkeerSessie WHERE ReserveringsNr = SP_ReserveringsNr );
    SET @endtime_date = ( SELECT DATE (eindtijd) FROM ParkeerSessie WHERE ReserveringsNr = SP_ReserveringsNr );

-- We gaan eerst de eindtijd terugbrengen tot de laatste tijdstip waar nog 
-- voor betaald moet worden.
-- 
-- Als de tijd bijvoorbeeld 20.00 uur 's avonds is, moet de eindtijd 17.00 uur
-- worden. Maar ook als de eindtijd 03.15 uur 's achts is, moet de eindtijd
-- 17.00 uur morden en moet de datum een dag teruggezet worden naar de vorige dag.
    SET @endtime_day_difference = 0;
    IF @endtime_time > '17:00:00' THEN 
        SET @endtime_time_checked = '17:00:00';
    ELSEIF  @endtime_time < '09:00:00' THEN
        SET @endtime_time_checked = '17:00:00';
        SET @endtime_day_difference = -1;
    ELSE 
        SET @endtime_time_checked = @endtime_time;
    END IF;
    -- Pas de datum aan als de tijd teruggezet wordt naar de eindtijd van de vorige dag.
    SET @endtime_date_checked = DATE_ADD( @endtime_date, INTERVAL @endtime_day_difference DAY) ; 

-- We hebben nu de eindtijd teruggebracht tot de laatste tijd waarvoor nog betaald moet worden.
-- Nu gaan we hetzelfde doen met de begintijd. 
    SET @starttime_day_difference = 0;
    IF @starttime_time < '09:00:00' THEN 
        SET @starttime_time_checked = '09:00:00';
    ELSEIF  @starttime_time > '17:00:00' THEN
        SET @starttime_time_checked = '09:00:00';
        SET @starttime_day_difference = 1;
    ELSE 
        SET @starttime_time_checked = @starttime_time;
    END IF;
    -- Pas de datum aan als de tijd teruggezet wordt naar de eindtijd van de vorige dag.
    SET @starttime_date_checked = DATE_ADD( @starttime_date, INTERVAL @starttime_day_difference DAY) ; 

-- Omdat we de begintijd en eindtijd hebben teruggebracht tot de tijdstippen waarvoor betaald moet worden,
-- is het verschil in tijd de tijd waarvoor ook daadwerkelijk betaald moet worden.
-- maar let op: Als de starttijd groter is dan de eindtijd, zit er dus een nacht tussen en moeten we
-- daar dus rekening mee houden. We tellen dan de tijd vanaf starttijd tot 17:00 en vanaf 08:00 tot eindtijd.
-- De einddatum zetten we één dag terug, omdat er niet nog voor een volle dag betaald hoeft te worden. 
    IF @starttime_time_checked < @endtime_time_checked THEN
        SET @paytime_time =  TIME_TO_SEC( TIMEDIFF( @endtime_time_checked, @starttime_time_checked  ));
    ELSE
        SET @paytime_time =  TIME_TO_SEC( TIMEDIFF( '17:00:00', @starttime_time_checked ) ) + TIME_TO_SEC( TIMEDIFF( @endtime_time_checked, '09:00:00' ));
        SET @endtime_date_checked = DATE_ADD( @endtime_date, INTERVAL -1 DAY ); 
    END IF;

-- We hebben nu het tijdsverschil berekend, maar in de parkeertijd die betaald moet worden nog geen
-- rekening gehouden met het aantal volledige dagen dat er geparkeerd stond. Per dag moet het volle
--  tarief van 9 uur * uurtarief worden betaald. 
    SET @paytime_fulldays = DATEDIFF( @endtime_date_checked, @starttime_date_checked);

-- Ziehier het resultaat van de tijdsberekening.
    SELECT 
        KlantId,
        CONCAT_WS(' ', Straat, HuisNr, Stad) AS Parkeerplaats,
        BeginBetaaldParkerenDag AS BeginBetaaldParkeren,
        EindeBetaaldParkerenDag AS EindeBetaaldParkeren,
        BeginTijd,
        EindTijd,
        TIMEDIFF(EindTijd, BeginTijd) AS TotaleParkeertijd,
        @paytime_time / 3600 AS Betaaltijd, 
        PP.TariefUur AS Uurtarief,
        (@paytime_time * (PP.TariefUur / 3600)) + (@paytime_fulldays * (PP.TariefUur * 24)) AS Parkeerkosten
    FROM ParkeerSessie PS
    LEFT JOIN ParkeerPlaats PP ON PS.ParkeerPlaats = PP.ParkeerPlaatsId
    WHERE ReserveringsNr = SP_ReserveringsNr;
END $$
DELIMITER ;

/*
CALL kostenParkeerPlaatsId1(14);
*/


