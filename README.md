# proftaak-1A5


## Documentatie Relationele database

### Tabellen: Klant, Zakelijk, Adres, Voertuig, ParkeerSessie, ParkeerPlaats, Factuur en FactuurRegels

#### Klant
_KlantId_ – deze interger word gekoppeld aan een persoon en alle data kan via deze Id worden opgeroepen.
_Regristratiedatum_ – Wanneer zich een potentiele lek vind in de database kunnen we alle gebruikers die voor de datum van lekkage geregristreerd hebben op de hoogte stellen o.i.d.
_Mailadres_ – Dit is nodig om de klant up to date te houden met facturen & mogelijk nieuws.
_Wachtwoord_ – Dit is een varchar128 waar in een sha zal worden opgeslagen.
_Naam & achternaam_ – Redelijk vanzelfsprekende gegevens.
_Mobiel_ – Mocht het mail adres niet meer werken of als de klant niet reageert op mails enzovoort, gewoon een backup contactmogelijkheid.
_Zakelijk_ – Deze boolean geeft aan of de klant een bedrijf is of een particulier.
_KvkNummer_ – Deze is gekoppeld aan de tabel Zakelijk, als een klant niet zakelijk is blijft deze null.
_MachtegingAutoInc_ – Dit is om aan te geven of de machtiging nog actief is.
_MachtigingDatum_ – De datum wanneer de machtiging laatst is afgegeven.
_IBAN_ – Vanzelfsprekend bankrekeningnummer van de klant.

#### Zakelijk
_KvkNummer_ – Uniek bedrijfsnummer wat gekoppeld is aan de klant tabel.
_BedrijfsNaam_ – Naam van het bedrijf, om de factuur wat persoonlijker te maken en bij troubleshooting een erg handige extra.
_BtwNummer_ – Een uniek niet verplicht nummer, om het bedrijf te verifieren

#### Adres
_AdresId_ – Intergers communiceren sneller met elkaar, waardoor we hier hebben gekozen voor een int ipv een unieke varchar of composite key. Mochten we ook met meerdere adressen willen gaan werken dan gaat dat ook gemakkelijker nu.
De rest van de gegevens zijn vanzelfsprekend, dit zijn adresgegevens voor de factuur we hebben ook geen adres nodig om iets naar toe te sturen.

#### Voertuig
_VoertuigId_ – Auto’s kunnen gedeeld worden, daarom hebben we een Id aangemaakt ipv het kenteken te gebruiken. Ook is een interger die met interger gelinked is sneller.
_Kenteken_ – Deze is nodig voor de factuur zodat de klant weet voor welk voertuig de factuur is.
_KlantId_ – De koppeling tussen klant en voertuig, dit is ook een 1 op meer relatie omdat een klant ook meerdere voertuigen kan hebben.

#### ParkeerSessie
_ReserveringsNr_ – Een voertuig kan maar 1 Parkeersessie hebben tegelijk (dit word tegen gehouden in de code) maar wel meerdere Parkeersessies in een dag/week enzovoort. 
_BeginTijd_ – De begintijd van de parkeersessie om te berekenen wat de kosten zijn
_EindTijd_ – Vanzelfsprekend om de kosten te berekenen

#### ParkeerPlaats
_ParkeerPlaatsId_ – Voor de snelle link tussen de tabellen en een uniek nummer. 
_Straat, Postcode, Stad_ – Word gebruikt om een soort parkeeromgeving te hebben waar de kosten worden berekend voor de omgeving.
_HuisNR_ – Is niet verplicht omdat er soms garages zijn / grotere parkeerplaatsen.
_ParkeerTerrein_ – Is het een terrein of niet.
_ParkeerGarrage_ – Is het een garage of niet.
_TariefUur_ – De kosten op de parkeerplaats/garage om te berekenen.
_MaxDuur_ – Op sommige parkeerplaatsen geld een parkeerlimiet, met deze optionele optie word dat dan aangegeven.
_BeginBetaaldParkerenDag_ – De begintijd van het betaald parkeren, nodig om te berekenen wanneer de betaling in zal gaan of nodig zal zijn.
_EindBetaaldParkerenDag_ – De eindtijd van het betaald parkeren.

#### Factuur
_KlantId_ – De klant kan meerdere facturen hebben daarom zit er een link tussen de klanten tabel en de factuur tabel. 
In deze hele tabel worden de gegevens plat opgeslagen, ze worden op een moment opgehaald, wanneer de factuur word gemaakt (bijvoorbeeld aan het einde van een maand). Op dat moment slaat alles op en krijgt het een factuurnummer. Deze is dan weer gekoppeld aan het KlantId
_FactuurNr_ – Dit nummer is nodig voor de overheid en is ook een mooi nummer om als primary key te gebruiken.
De rest van de gegevens worden opgehaald uit de andere tabellen: Klant, Zakelijk, Adres. 

#### FactuurRegels
_FactuurNr_ – Deze heeft een meer op 1 relatie met Factuur omdat via FactuurRegels meerdere sessies worden opgehaald dus meerdere sessies worden vervolgens weergeven in de factuur waar een totaalprijs word opgemaakt van alle sessies(factuurregels). Bijvoorbeeld: Factuur 10001 heeft 5 parkeersessies met 5 verschillende reserveringsnummers.
_ReserveringsNr_ – Deze word opgehaald van de tabel: ParkeerSessie>ReserveringsNr, er zit geen link in de database omdat deze gegevens veranderen en je voor de factuur een soort snapshot moet hebben. 
_Kenteken_ – Deze word opgehaald bij de sessies via het ReserveringsNR>VoertuigId nodig voor de factuur, per sessie is er een kenteken dit is zodat iemand meerdere autos in een maand op zijn factuur kan hebben.
_BeginTijd, EindTijd, TariefUur, MaxDuur, BeginBetaaldParkerenDag en EindBetaaldParkerenDag – Deze worden gebruikt om te berekenen wat de prijs zal worden voor de sessie, dit word dan wel gedaan via de code maar deze gegevens zouden genoeg moeten zijn. Ook als prijzen in de toekomst veranderen, zullen hier alsnog de prijzen staan die het toen waren.
Straat, HuisNr, Stad, Postcode_ – Dit zijn de gegevens van waar er geparkeerd is in de sessie
