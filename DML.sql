/*
***********************************************************
Name: PinPointParking
Content: Data Manipulation Language (DML)
User-stories: db_admin, medewerker, bedrijf, particulier

Queries medewerker:
M1. Als een medewerker wil ik de exacte parkeerkosten weten van een reservering zodat ik de factuur kan berekenen
M2. Als een medewerker wil ik alle facturen ophalen met naam en adres zodat ik zie wie facturen moet krijgen
M2. Als een medewerker wil ik alle parkeeromgevingen opsommen van veel naar weinig gebruikt zodat ik weet waar mogelijk behoefte is aan extra parkeergelegenheid
M3. Als een medewerker wil ik de klant ophalen die het meest heeft geparkeerd zodat we daarmee rekening kunnen houden met kortingacties
M4. Als een medewerker wil ik de bedrijven zien met het aantal medewerkers van veel naar weinig  zodat we daarmee rekening kunnen houden met abonnementsaanbiedingen
M5. Als een medewerker wil ik een beknopt overzicht van klant, kenteken en het aantal sessies per klant zodat we snel zien hoe vaak klanten PPP gebruiken

Queries db_admin:
---> A1. Als admin wil ik de processlist zien van alle users zodat ... - ??

Queries bedrijf:
B1. Als bedrijfsmedewerker wil ik de factuur van een medewerker ophalen inclusief de parkeerkosten zodat we specifieke kosten in kaart kunnen brengen
B3. Als bedrijfsmedewerker wil ik een overzicht met alle NAW-gegevens van alle medewerkers die PPP gebruiken zodat we overzicht houden over de administratie

Queries particulier:
---> P1. Als particulier wil ik al mijn parkeersessies zien zodat ik weet hoeveel facturen ik nog zal ontvangen
P2. Als particulier wil ik mijn adres wijzigen zodat de gegevens kloppen na mijn verhuizing
---> P3. Als particulier wil ik mijn account verwijderen zodat ik controle heb over mijn persoonsgegevens 

Stored Procedures:
SP1. getAllParkeersessies() Simpele test om alle parkeersessies op te halen 
SP2. parkeerKostenFactuurNr(FactuurNr) Parkeerkosten (inclusief gratis uren) van factuurnummer X - nog niet opgelost met dubbele parkeersessies op 1 factuur 
SP3. kostenParkeerPlaatsId1(ReserveringsNr) bereken parkeerkosten exclusief de gratis parkerentijden - nog niet opgelost als iemand van 23:00 tot 06:00 uur parkeert

Events:
---> E1.

Triggers
---> T1.

Versie 1.2
+ Stored Procedures toegevoegd
Versie 1.1
+ Userstories toegevoegd
***********************************************************
*/

/**
* M1. Exacte parkeerkosten (totale parkeertijd - gratis parkeertijd) ReserveringsNr 3.
*/
CALL parkeerKostenFactuurNr(3);

/**
* M2. Alle facturen met naam en adres 
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
* M3. Alle parkeerplaatsen van veel naar weinig gebruikt 
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
* M4. Klant die het meest heeft geparkeerd 
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
* M5. Ik wil de bedrijven zien met het aantal medewerkers van veel naar weinig 
*/
SELECT
    BedrijfsNaam,
    COUNT(KlantId) AS AantalMedewerkers
FROM Zakelijk Z
LEFT JOIN Klant K ON Z.KvkNummer = K.KvkNummer
GROUP BY BedrijfsNaam
ORDER BY AantalMedewerkers DESC;

/**
* A1. Laat de processlist zien van alle users
*/
SHOW PROCESSLIST;

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
* B3. Overzicht met alle NAW-gegevens van alle medewerkers van bedrijf Henneken die PPP gebruiken 
*/
SELECT
    CONCAT_WS(' ', Voornaam, Tussenvoegsel, Achternaam) AS Medewerker,
    CONCAT_WS(' ', Straat, HuisNr) AS Adres,
    Postcode,
    Stad,
    Mobiel,
    TelefoonVast
FROM Klant K
LEFT JOIN Zakelijk Z ON K.KvkNummer = Z.KvkNummer
LEFT JOIN Adres A ON K.KlantId = A.KlantId
WHERE K.KvkNummer = 12345678;

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
* P3. Ik wil mijn account verwijderen (KlantId 20)
*/


/*******************
* STORED PROCEDURES
**/

/**
* SP1. getAllParkeersessies() Simpele test om alle parkeersessies op te halen 
*/
DELIMITER $$

CREATE PROCEDURE getAllParkeersessies()
BEGIN
    SELECT *
    FROM ParkeerSessie;
END $$

DELIMITER ;

/*
CALL getAllParkeersessies();
*/

/**
* SP2. parkeerKostenFactuurNr(FactuurNr) Parkeerkosten (inclusief gratis uren) van factuurnummer X - nog niet opgelost met dubbele parkeersessies op 1 factuur 
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
* SP3. kostenParkeerPlaatsId1(ReserveringsNr) bereken parkeerkosten exclusief de gratis parkerentijden - nog niet opgelost als iemand van 23:00 tot 06:00 uur parkeert (SP zet einddatum dan terug waardoor deze eerder begint dan de begindatum. Nog oplossen)
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
CALL kostenParkeerPlaatsId1(1);
CALL kostenParkeerPlaatsId1(2);
CALL kostenParkeerPlaatsId1(3);
CALL kostenParkeerPlaatsId1(14);
CALL kostenParkeerPlaatsId1(22);
*/