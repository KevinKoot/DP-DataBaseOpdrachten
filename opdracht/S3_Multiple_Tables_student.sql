-- ------------------------------------------------------------------------
-- Data & Persistency
-- Opdracht S3: Multiple Tables
--
-- (c) 2020 Hogeschool Utrecht
-- Tijmen Muller (tijmen.muller@hu.nl)
-- André Donk (andre.donk@hu.nl)
--
--
-- Opdracht: schrijf SQL-queries om onderstaande resultaten op te vragen,
-- aan te maken, verwijderen of aan te passen in de database van de
-- bedrijfscasus.
--
-- Codeer je uitwerking onder de regel 'DROP VIEW ...' (bij een SELECT)
-- of boven de regel 'ON CONFLICT DO NOTHING;' (bij een INSERT)
-- Je kunt deze eigen query selecteren en los uitvoeren, en wijzigen tot
-- je tevreden bent.
--
-- Vervolgens kun je je uitwerkingen testen door de testregels
-- (met [TEST] erachter) te activeren (haal hiervoor de commentaartekens
-- weg) en vervolgens het hele bestand uit te voeren. Hiervoor moet je de
-- testsuite in de database hebben geladen (bedrijf_postgresql_test.sql).
-- NB: niet alle opdrachten hebben testregels.
--
-- Lever je werk pas in op Canvas als alle tests slagen.
-- ------------------------------------------------------------------------


-- S3.1.
-- Produceer een overzicht van alle cursusuitvoeringen; geef de
-- code, de begindatum, de lengte en de naam van de docent.
DROP VIEW IF EXISTS s3_1; CREATE OR REPLACE VIEW s3_1 AS
--
select code, begindatum, lengte, naam from uitvoeringen
                                               inner join medewerkers on uitvoeringen.docent = medewerkers.mnr
                                               inner join cursussen on uitvoeringen.cursus = cursussen.code


-- S3.2.
-- Geef in twee kolommen naast elkaar de achternaam van elke cursist (`cursist`)
-- van alle S02-cursussen, met de achternaam van zijn cursusdocent (`docent`).
DROP VIEW IF EXISTS s3_2; CREATE OR REPLACE VIEW s3_2 AS

select  m1.naam as cursist, m2.naam as docent
from inschrijvingen
         inner join medewerkers as m1 on inschrijvingen.cursist = m1.mnr
         inner join uitvoeringen on inschrijvingen.cursus = uitvoeringen.cursus
    and uitvoeringen.begindatum = inschrijvingen.begindatum
         inner join medewerkers as m2 on uitvoeringen.docent = m2.mnr
where inschrijvingen.cursus = 'S02';


-- S3.3.
-- Geef elke afdeling (`afdeling`) met de naam van het hoofd van die
-- afdeling (`hoofd`).
DROP VIEW IF EXISTS s3_3; CREATE OR REPLACE VIEW s3_3 AS
--
SELECT afdelingen.naam, medewerkers.naam AS hoofd
FROM afdelingen
         INNER JOIN medewerkers ON afdelingen.hoofd = medewerkers.mnr;


-- S3.4.
-- Geef de namen van alle medewerkers, de naam van hun afdeling (`afdeling`)
-- en de bijbehorende locatie.
DROP VIEW IF EXISTS s3_4; CREATE OR REPLACE VIEW s3_4 AS
--
select medewerkers.naam, afdelingen.naam as afdelingen_naam, afdelingen.locatie from medewerkers
                                                                                         inner join afdelingen on medewerkers.afd = afdelingen.anr


-- S3.5.
-- Geef de namen van alle cursisten die staan ingeschreven voor de cursus S02 van 12 april 2019
DROP VIEW IF EXISTS s3_5; CREATE OR REPLACE VIEW s3_5 AS
select medewerkers.naam from inschrijvingen
                                 inner join medewerkers on inschrijvingen.cursist = medewerkers.mnr where begindatum = '2019-04-12' and cursus = 'S02'
--
-- [TEST]


-- S3.6.
-- Geef de namen van alle medewerkers en hun toelage.
DROP VIEW IF EXISTS s3_6; CREATE OR REPLACE VIEW s3_6 AS
--
select medewerkers.naam, schalen.toelage from medewerkers
                                                  inner join schalen on medewerkers.maandsal between schalen.ondergrens and schalen.bovengrens[TEST]



-- -------------------------[ HU TESTRAAMWERK ]--------------------------------
-- Met onderstaande query kun je je code testen. Zie bovenaan dit bestand
-- voor uitleg.

SELECT * FROM test_select('S3.1') AS resultaat
UNION
SELECT * FROM test_select('S3.2') AS resultaat
UNION
SELECT * FROM test_select('S3.3') AS resultaat
UNION
SELECT * FROM test_select('S3.4') AS resultaat
UNION
SELECT * FROM test_select('S3.5') AS resultaat
UNION
SELECT * FROM test_select('S3.6') AS resultaat
ORDER BY resultaat;

