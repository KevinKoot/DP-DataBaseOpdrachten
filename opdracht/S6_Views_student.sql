-- ------------------------------------------------------------------------
-- Data & Persistency
-- Opdracht S6: Views
--
-- (c) 2020 Hogeschool Utrecht
-- Tijmen Muller (tijmen.muller@hu.nl)
-- André Donk (andre.donk@hu.nl)
-- ------------------------------------------------------------------------


-- S6.1.
-- 1. Maak een view met de naam "deelnemers" waarmee je de volgende gegevens uit de tabellen inschrijvingen en uitvoering combineert:
--    inschrijvingen.cursist, inschrijvingen.cursus, inschrijvingen.begindatum, uitvoeringen.docent, uitvoeringen.locatie

CREATE OR REPLACE VIEW deelnemers AS
SELECT  inschrijvingen.cursist,
        inschrijvingen.cursus,
        inschrijvingen.begindatum,
        uitvoeringen.docent,
        uitvoeringen.locatie
FROM inschrijvingen
         JOIN uitvoeringen ON inschrijvingen.cursus = uitvoeringen.cursus
    AND inschrijvingen.begindatum = uitvoeringen.begindatum;

-- 2. Gebruik de view in een query waarbij je de "deelnemers" view combineert met de "personeels" view (behandeld in de les):
CREATE OR REPLACE VIEW personeel AS
SELECT mnr, voorl, naam AS medewerker, afd, functie
FROM medewerkers;

SELECT deelnemers.cursist,
       deelnemers.cursus,
       deelnemers.begindatum,
       personeel.medewerker AS docent_naam,
       personeel.afd AS docent_afdeling,
       deelnemers.locatie
FROM deelnemers
         JOIN personeel ON deelnemers.docent = personeel.mnr;

-- 3. Is de view "deelnemers" updatable? Waarom?
-- Nee, omdat de view gebaseerd is op meerdere tabellen, waar een JOIN is gebruikt.
nee, omdat de view gebaseerd is meerdere tafels, waar ik join heb gebruik


-- S6.2.
-- 1. Maak een view met de naam "dagcursussen". Deze view dient de gegevens op te halen:
--    code, omschrijving en type uit de tabel cursussen met als voorwaarde dat de lengte = 1. Toon aan dat de view werkt.
CREATE OR REPLACE VIEW dagcursussen AS
SELECT code, omschrijving, type
FROM cursussen
WHERE lengte = 1;

-- 2. Maak een tweede view met de naam "daguitvoeringen".
--    Deze view dient de uitvoeringsgegevens op te halen voor de "dagcursussen" (gebruik ook de view "dagcursussen"). Toon aan dat de view werkt.
CREATE OR REPLACE VIEW daguitvoeringen AS
SELECT uitvoeringen.cursus,
       uitvoeringen.begindatum,
       uitvoeringen.locatie,
       uitvoeringen.docent
FROM uitvoeringen
         JOIN dagcursussen ON uitvoeringen.cursus = dagcursussen.code;

-- 3. Verwijder de views en laat zien wat de verschillen zijn bij DROP VIEW <viewnaam> CASCADE en bij DROP VIEW <viewnaam> RESTRICT
DROP VIEW IF EXISTS daguitvoeringen CASCADE;
DROP VIEW IF EXISTS dagcursussen CASCADE;

 Bij RESTRICT verwijder je de view alleen als deze niet afhankelijk is van andere objecten,

 terwijl je bij CASCADE ook alle afhankelijkheden erbij verwijderd.
