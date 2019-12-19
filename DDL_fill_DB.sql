# PinpointParking
# Data Definition Language Fill Database

INSERT INTO ZAKELIJK
VALUES 
    (DEFAULT, 'Schadebo', 'NL001234567B01', 12345678),
    (DEFAULT, 'FC Kip', 'NL003456789B02', 87654321);

INSERT INTO KLANT
VALUES
    (DEFAULT, DEFAULT, 'info@schadebo.nl', 'Wachtwoord1234', 'Henk', NULL, 'Vogel', '0612345678', '1'),
    (DEFAULT, DEFAULT, 'karin@ziggo.nl', 'Wachtwoord5678', 'Karin', 'van de', 'Oosterdijk', '0687654321', NULL),
    (DEFAULT, DEFAULT, 'info@fckip.nl', 'Wachtwoord9012', 'Corrie', 'van de', 'Leg', '0698761234', 2);

INSERT INTO ADRES
VALUES
    (DEFAULT, 'Oosterstraat', 29, '5242KL', 'Den Bosch', DEFAULT, '0735212345', 1),
    (DEFAULT, 'Kerkstraat', 99, '4842DN', 'Breda', DEFAULT, NULL, 2),
    (DEFAULT, 'Laan van Columbus', 1, '9797PC', 'Thesigne', DEFAULT, '0501234567', 3);

INSERT INTO VOERTUIG
VALUES 
    ('XD-43-LK', 1),
    ('7-GHT-34', 2),
    ('NL-72-PK', 3);

INSERT INTO PARKEEROMGEVING
VALUES
    (DEFAULT, '5200LM', 'Leeghmanstraat', NULL, 'Den Bosch', '2.99', 10, '08:00:00', '18:00:00'),
    (DEFAULT, '4815DK', 'Tuinlaan', 56, 'Breda', '3.10', 24, '00:00:00', '00:00:00'),
    (DEFAULT, '9711KZ', 'Rademarkt', 7, 'Groningen', '2.49', 12, '08:00:00', '20:00:00');

INSERT INTO PARKEERSESSIE
VALUES 
    (DEFAULT, '2019-11-13 15:02:45', '2019-11-13 16:31:20', 'XD-43-LK', 1),
    (DEFAULT, '2019-11-29 08:22:05', '2019-11-29 09:23:43', '7-GHT-34', 2),
    (DEFAULT, '2019-12-01 23:02:45', '2019-12-02 08:43:08', 'NL-72-PK', 3);

INSERT INTO FACTUUR
VALUES 
    (DEFAULT, '2019-11-14', 1, 1),
    (DEFAULT, '2019-11-30', 2, 2),
    (DEFAULT, '2019-12-03', 3, 3);

INSERT INTO FACTUURREGELS
VALUES 
    (1, 'XD-43-LK', 1, 1),
    (2, '7-GHT-34', 2, 2),
    (3, 'NL-72-PK', 3, 3);