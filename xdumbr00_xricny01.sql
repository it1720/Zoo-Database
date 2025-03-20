DROP TRIGGER zrus_vybeh;
DROP TRIGGER zmena_mereni;
DROP PROCEDURE umrti;
DROP PROCEDURE spatna_osoba;
DROP MATERIALIZED VIEW seznam_zivocichu;
DROP INDEX idx_velikost;
DROP TABLE mereni;
DROP TABLE zivocich;
DROP TABLE vybeh;
DROP TABLE spravce;
DROP TABLE uzivatel;
DROP TABLE zamestnanec;
DROP TABLE osoba;
DROP TABLE druh;
DROP TABLE rod;
DROP TABLE celed;
DROP TABLE rad;
DROP TABLE trida;

DROP SEQUENCE idVybehS;
DROP SEQUENCE idZivocichS;
DROP SEQUENCE idOsobaS;
DROP SEQUENCE idMereniS;

CREATE SEQUENCE idVybehS START WITH 1 INCREMENT by 1;
CREATE SEQUENCE idZivocichS START WITH 1 INCREMENT by 1;
CREATE SEQUENCE idOsobaS START WITH 1 INCREMENT by 1;
CREATE SEQUENCE idMereniS START WITH 1 INCREMENT by 1;

CREATE TABLE trida (
    jmeno_t VARCHAR(255) PRIMARY KEY
);

CREATE TABLE rad(
    jmeno_rad VARCHAR(255) PRIMARY KEY,
    trida_jmeno VARCHAR(255) NOT NULL,
    CONSTRAINT trida_jmeno_fk FOREIGN KEY (trida_jmeno) REFERENCES trida(jmeno_t)
            ON DELETE CASCADE
);

CREATE TABLE celed(
    jmeno_c VARCHAR(255) PRIMARY KEY,
    rad_jmeno VARCHAR(255) NOT NULL,
    CONSTRAINT rad_jmeno_fk
        FOREIGN KEY (rad_jmeno) REFERENCES  rad(jmeno_rad)
            ON DELETE CASCADE
);

CREATE TABLE rod(
    jmeno_rod VARCHAR(255) PRIMARY KEY,
    celed_jmeno VARCHAR(255) NOT NULL,
     CONSTRAINT celed_jmeno_fk
        FOREIGN KEY (celed_jmeno) REFERENCES  celed(jmeno_c)
            ON DELETE CASCADE
);

CREATE TABLE druh(
    jmeno VARCHAR(255) PRIMARY KEY,
    rod_jmeno VARCHAR(255) NOT NULL,
     CONSTRAINT rod_jmeno_fk
        FOREIGN KEY (rod_jmeno) REFERENCES  rod(jmeno_rod)
            ON DELETE CASCADE
);

CREATE TABLE vybeh(
    id INT DEFAULT idVybehS.nextval PRIMARY KEY,
    typ varchar(255) NOT NULL
);

CREATE TABLE zivocich(
    id INT DEFAULT idZivocichS.nextval PRIMARY KEY,
    narozeni DATE NOT NULL,
    jmeno VARCHAR(255) NOT NULL,
    umrti DATE,
    vybeh_id INT,
    druh_jmeno VARCHAR(255) NOT NULL,
    CONSTRAINT vybeh_id_fk
        FOREIGN KEY (vybeh_id) REFERENCES  vybeh(id)
            ON DELETE CASCADE,
    CONSTRAINT druh_jmeno_fk
        FOREIGN KEY (druh_jmeno) REFERENCES  druh(jmeno)
            ON DELETE CASCADE
);

CREATE TABLE osoba(
    id INT DEFAULT idOsobaS.nextval PRIMARY KEY,
    rodneCislo CHAR(11) CONSTRAINT osoba_rCislo_NN NOT NULL CONSTRAINT osoba_rCislo_RC CHECK(mod(rodneCislo,11) = 0),
    datumNarozeni DATE NOT NULL,
    jmeno VARCHAR(255) NOT NULL,
    prijmeni VARCHAR(255) NOT NULL
);

CREATE TABLE mereni(
    id INT DEFAULT idMereniS.nextval PRIMARY KEY,
    datum DATE NOT NULL,
    rozmer FLOAT NOT NULL,
    hmotnost FLOAT NOT NULL,
    osoba_id INT NOT NULL,
    zivocich_id INT NOT NULL,
    CONSTRAINT osoba_id_fk
        FOREIGN KEY (osoba_id) REFERENCES  osoba(id)
            ON DELETE CASCADE,
    CONSTRAINT zivocich_id_fk
        FOREIGN KEY (zivocich_id) REFERENCES  zivocich(id)
            ON DELETE CASCADE
);

--syni rodice 'osoba' dedi primarni klic

CREATE TABLE uzivatel(
    oblibeneZvire VARCHAR(255),
    osoba_id INT PRIMARY KEY,
        FOREIGN KEY (osoba_id) REFERENCES  osoba(id)
            ON DELETE CASCADE
);

CREATE TABLE zamestnanec(
    datumNastupu DATE,
    plat INT,
    ulice VARCHAR(255) NOT NULL,
    mesto VARCHAR(255) NOT NULL,
    psc INT NOT NULL,
    osoba_id INT PRIMARY KEY,
        FOREIGN KEY (osoba_id) REFERENCES  osoba(id)
            ON DELETE CASCADE
);

CREATE TABLE spravce(
    zamereni VARCHAR(255),
    osoba_id INT PRIMARY KEY,
        FOREIGN KEY (osoba_id) REFERENCES  osoba(id)
            ON DELETE CASCADE
);

INSERT INTO osoba VALUES (idOsobaS.nextval, '0110045815', TO_DATE('2001-10-04', 'yyyy-mm-dd'), 'David', 'Dumbrovsky');
INSERT INTO osoba VALUES (idOsobaS.nextval, '0201105817', TO_DATE('2002-01-10', 'yyyy-mm-dd'), 'Matej', 'Ricny');
INSERT INTO osoba VALUES (idOsobaS.nextval, '0201105828', TO_DATE('2002-01-10', 'yyyy-mm-dd'), 'Mike', 'Litoris');

INSERT INTO uzivatel VALUES ('kachna obecna', 2);
INSERT INTO zamestnanec VALUES (NULL, NULL, 'Za Humny', 'Opava', 74705,3);
INSERT INTO spravce VALUES ('admin', 1);


INSERT INTO vybeh VALUES (idVybehS.nextval, 'pavilon');
INSERT INTO vybeh VALUES (idVybehS.nextval, 'volny vybeh');
INSERT INTO vybeh VALUES (idVybehS.nextval, 'klec');
INSERT INTO vybeh VALUES (idVybehS.nextval, 'akvarium');
INSERT INTO vybeh VALUES (idVybehS.nextval, 'terarium');

INSERT INTO trida VALUES ('ptaci');
INSERT INTO rad VALUES ('vrubozubi', 'ptaci');
INSERT INTO rad VALUES ('dravci', 'ptaci');
INSERT INTO rad VALUES ('pevci', 'ptaci');
INSERT INTO rad VALUES ('pelikani', 'ptaci');
INSERT INTO rad VALUES ('papousci', 'ptaci');
INSERT INTO celed VALUES ('kachnoviti', 'vrubozubi');
INSERT INTO rod VALUES ('kachna', 'kachnoviti');
INSERT INTO druh VALUES ('kachna divoka', 'kachna');
INSERT INTO zivocich VALUES (idZivocichS.nextval, TO_DATE('2001-10-04', 'yyyy-mm-dd'), 'kachnicka', NULL, 2, 'kachna divoka');


INSERT INTO trida VALUES ('savci');
INSERT INTO trida VALUES ('plazi');
INSERT INTO trida VALUES ('ryby');

INSERT INTO rad VALUES ('selmy', 'savci');
INSERT INTO rad VALUES ('zelvy', 'plazi');
INSERT INTO rad VALUES ('zralouni', 'ryby');

INSERT INTO celed VALUES ('kockoviti', 'selmy');
INSERT INTO celed VALUES ('testudoviti', 'zelvy');
INSERT INTO celed VALUES ('modrounoviti', 'zralouni');

INSERT INTO rod VALUES ('tygr', 'kockoviti');
INSERT INTO rod VALUES ('zelva', 'testudoviti');
INSERT INTO rod VALUES ('zralok', 'modrounoviti');

INSERT INTO druh VALUES ('tygr obecny', 'tygr');
INSERT INTO druh VALUES ('zelva paprscita', 'zelva');
INSERT INTO druh VALUES ('zralok tygri', 'zralok');

INSERT INTO zivocich VALUES (idZivocichS.nextval,TO_DATE('20.02.2001','dd-mm-yyyy'),'tygrik',NULL, 2, 'tygr obecny');
INSERT INTO zivocich VALUES (idZivocichS.nextval,TO_DATE('12.01.2001','dd-mm-yyyy'),'maja',NULL, 5, 'zelva paprscita');
INSERT INTO zivocich VALUES (idZivocichS.nextval,TO_DATE('10.01.2001','dd-mm-yyyy'),'Donatello',TO_DATE('10.01.2019','dd-mm-yyyy'), NULL, 'zelva paprscita');
INSERT INTO zivocich VALUES (idZivocichS.nextval,TO_DATE('10.01.2010','dd-mm-yyyy'),'patrik',NULL, 4, 'zralok tygri');
INSERT INTO zivocich VALUES (idZivocichS.nextval,TO_DATE('11.01.2012','dd-mm-yyyy'),'petra',NULL, 4, 'zralok tygri');

INSERT INTO mereni VALUES (idMereniS.nextval,TO_DATE('20.02.2001','dd-mm-yyyy'),22,50,3,2);
INSERT INTO mereni VALUES (idMereniS.nextval,TO_DATE('20.12.2001','dd-mm-yyyy'),25,150,3,3);
INSERT INTO mereni VALUES (idMereniS.nextval,TO_DATE('20.12.2008','dd-mm-yyyy'),500,542,3,5);
INSERT INTO mereni VALUES (idMereniS.nextval,TO_DATE('21.12.2008','dd-mm-yyyy'),501,550,3,5);
INSERT INTO mereni VALUES (idMereniS.nextval,TO_DATE('22.12.2008','dd-mm-yyyy'),555,600,3,6);
INSERT INTO mereni VALUES (idMereniS.nextval,TO_DATE('22.12.2008','dd-mm-yyyy'),555,604,3,6);
INSERT INTO mereni VALUES (idMereniS.nextval,TO_DATE('22.12.2004','dd-mm-yyyy'),555,300,3,6);
INSERT INTO mereni VALUES (idMereniS.nextval,TO_DATE('22.12.2005','dd-mm-yyyy'),555,404,3,6);
INSERT INTO mereni VALUES (idMereniS.nextval,TO_DATE('22.12.2006','dd-mm-yyyy'),555,504,3,6);
INSERT INTO mereni VALUES (idMereniS.nextval,TO_DATE('22.12.2007','dd-mm-yyyy'),555,554,3,6);


--vypsani vsech zivocichu, a ve kterem vybehu se nachazi
--spojeni dvou tabulek pomoci INNER JOIN - spoji tabulky se stejnymi hodnotami - v tomto pripade pomoci ciziho klice
SELECT ZIVOCICH.DRUH_JMENO AS "Druh zvirete", ZIVOCICH.JMENO AS "Jmeno zvirete", VYBEH.TYP AS "Nachazi se v"
    FROM ZIVOCICH
    INNER JOIN VYBEH ON ZIVOCICH.VYBEH_ID = VYBEH.ID;

--vypsani vsech uzivatelu a jejich oblibenych zvirat
--spojeni dvou tabulek pomoci INNER JOIN - spoji tabulky se stejnymi hodnotami - v tomto pripade pomoci ciziho klice
SELECT OSOBA.JMENO AS "Jmeno", OSOBA.PRIJMENI AS "Prijmeni", UZIVATEL.OBLIBENEZVIRE AS "oblibene zvire"
    FROM OSOBA
    INNER JOIN UZIVATEL ON UZIVATEL.OSOBA_ID=OSOBA.ID;

--vypsani vsech mereni
--spojeni tri tabulek pomoci INNER JOIN - spoji tabulky se stejnymi hodnotami - v tomto pripade pomoci na cizich klicu
SELECT osoba.JMENO AS "Meril", ZIVOCICH.JMENO AS "Byl meren", MERENI.DATUM AS "Dne"
    FROM MERENI 
    INNER JOIN ZIVOCICH ON MERENI.ZIVOCICH_ID=ZIVOCICH.ID
    INNER JOIN OSOBA ON MERENI.OSOBA_ID = OSOBA.ID;

--vypsani nevetsiho zivocicha
--spojeni tabulek pomoci INNER JOIN, v klauzuli WHERE nastaveni vypsani pouze nejvetsiho zivocicha
SELECT ZIVOCICH.JMENO AS "Jmeno", ZIVOCICH.DRUH_JMENO AS "Druh", MAX(MERENI.ROZMER) AS "Delka"
    FROM ZIVOCICH
    INNER JOIN MERENI ON ZIVOCICH.ID=MERENI.ZIVOCICH_ID
    WHERE MERENI.ROZMER = (SELECT MAX(MERENI.ROZMER)FROM MERENI)
    GROUP BY ZIVOCICH.JMENO, ZIVOCICH.DRUH_JMENO;

--vypsani poctu zvirat v jednotlivych vybezich
--spojeni tabulek pomoci INNER JOIN, vypsane zestupne
SELECT VYBEH.TYP AS "Vybeh", COUNT(ZIVOCICH.VYBEH_ID) AS "Pocet ve vybehu"
    FROM VYBEH
    INNER JOIN ZIVOCICH ON VYBEH.ID = ZIVOCICH.VYBEH_ID
    GROUP BY VYBEH.TYP
    ORDER BY COUNT(ZIVOCICH.VYBEH_ID) DESC;

--vypsani vsech neprazdnych vybehu
SELECT VYBEH.TYP AS "Vybeh"
FROM VYBEH
WHERE EXISTS (SELECT * FROM ZIVOCICH WHERE VYBEH.ID = ZIVOCICH.VYBEH_ID);

--vypsani vsech zivocichu, kteri uz byly zmereni
SELECT ZIVOCICH.JMENO AS "Jmeno", ZIVOCICH.DRUH_JMENO AS "Druh"
FROM ZIVOCICH
WHERE ZIVOCICH.ID IN (SELECT MERENI.ZIVOCICH_ID FROM MERENI);

-- SELECT ZIVOCICH.JMENO AS "Jmeno", ZIVOCICH.DRUH_JMENO AS "Druh", MAX(MERENI.HMOTNOST) as "Hmotnost"
--     FROM ZIVOCICH
--     INNER JOIN MERENI ON ZIVOCICH.ID=MERENI.ZIVOCICH_ID
--     GROUP BY ZIVOCICH.JMENO, ZIVOCICH.DRUH_JMENO;


EXPLAIN PLAN FOR (SELECT ZIVOCICH.JMENO AS "Jmeno", ZIVOCICH.DRUH_JMENO AS "Druh", MAX(MERENI.ROZMER) AS "Delka"
    FROM ZIVOCICH
    INNER JOIN MERENI ON ZIVOCICH.ID=MERENI.ZIVOCICH_ID
    WHERE MERENI.ROZMER > 300
    GROUP BY ZIVOCICH.JMENO, ZIVOCICH.DRUH_JMENO);

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

CREATE INDEX idx_velikost ON MERENI(ROZMER);

EXPLAIN PLAN FOR (SELECT ZIVOCICH.JMENO AS "Jmeno", ZIVOCICH.DRUH_JMENO AS "Druh", MAX(MERENI.ROZMER) AS "Delka"
    FROM ZIVOCICH
    INNER JOIN MERENI ON ZIVOCICH.ID=MERENI.ZIVOCICH_ID
    WHERE MERENI.ROZMER > 300
    GROUP BY ZIVOCICH.JMENO, ZIVOCICH.DRUH_JMENO);

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);


GRANT SELECT ON ZIVOCICH TO XRICNY01;

CREATE MATERIALIZED VIEW seznam_zivocichu
REFRESH COMPLETE
AS 
SELECT ZIVOCICH.JMENO AS "Jmeno", ZIVOCICH.DRUH_JMENO AS "Druh"
FROM ZIVOCICH;

GRANT SELECT ON seznam_zivocichu to XRICNY01;


-- trigger

CREATE OR REPLACE TRIGGER zrus_vybeh
    AFTER DELETE ON VYBEH
    FOR EACH ROW
BEGIN
    UPDATE zivocich SET zivocich.vybeh_id= NULL
    WHERE zivocich.vybeh_id = :old.id;
END;
/

-- datum posledni zmeny v tabulce mereni
ALTER TABLE mereni ADD datum_zmena_mereni DATE;

SELECT * FROM mereni;

CREATE OR REPLACE TRIGGER zmena_mereni
	BEFORE INSERT OR UPDATE ON mereni
	FOR EACH ROW
BEGIN
	:NEW.datum_zmena_mereni := SYSDATE;
END;
/
-- zmena prvniho radku tabulky MERENI
-- rozmer bude 20 a datum_zmena_mereni dnesni datum
UPDATE mereni SET rozmer=20 WHERE id = 1;
select * from mereni;

-- spatne datum narozeni

-- PROCEDURE
-- pridani umrti
CREATE OR REPLACE PROCEDURE umrti (umrti_id zivocich.id%TYPE,datum_umrti DATE)AS
    CURSOR ziv IS SELECT * FROM zivocich;
    zi ziv%ROWTYPE;
    invalid_date EXCEPTION;
    BEGIN
        OPEN ziv;
        LOOP
            FETCH ziv INTO zi;
            EXIT WHEN ziv%NOTFOUND;
            IF zi.id = umrti_id THEN
                dbms_output.put_line('Umrti zivocicha: ' || zi.jmeno);
                IF datum_umrti IS NULL THEN
                    UPDATE zivocich SET umrti = SYSDATE WHERE id = umrti_id;
                    dbms_output.put_line('Dne: ' || SYSDATE);
                ELSE
                    IF datum_umrti < zi.narozeni THEN
                        RAISE invalid_date;
                    END IF;
                    UPDATE zivocich SET umrti = datum_umrti WHERE id = umrti_id;
                    dbms_output.put_line('Dne: ' || datum_umrti);
                END IF;
                
            END IF;
        END LOOP;
        CLOSE ziv;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20003,'Zivocich nenalezen');
            when invalid_date THEN
                RAISE_APPLICATION_ERROR(-20005,'Datum narozeni je starsi nez datum umrti');
            WHEN others THEN 
                dbms_output.put_line('Error!'); 
        END;
    /

--BEGIN umrti(1,NULL); END;

CREATE OR REPLACE PROCEDURE spatna_osoba AS
    CURSOR osoby IS SELECT * FROM osoba;
    osob osoby%ROWTYPE;
    BEGIN
        OPEN osoby;
        LOOP
            FETCH osoby INTO osob;
            EXIT WHEN osoby%NOTFOUND;
            IF osob.jmeno IS NULL THEN
                dbms_output.put_line('Osoba s id: ' || osob.id || ' nema zadano jmeno');
            END IF;
            IF osob.prijmeni IS NULL THEN
                dbms_output.put_line('Osoba s id: ' || osob.id || ' nema zadano prijmeni');
            END IF;
        END LOOP;
        CLOSE osoby;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20003,'Osoba nenalezena');
            WHEN others THEN 
                RAISE_APPLICATION_ERROR(-20000,'Error!'); 
        END;
    /

--BEGIN spatna_osoba(); END;

-- SELECT
-- vsechny mereni, kde byla namerena hmotnost nadprumerna
WITH tmpTable(avgValue) AS (
    SELECT AVG(hmotnost) AS avgValue
    FROM mereni
)
SELECT zivocich.jmeno, zivocich.narozeni, mereni.hmotnost
FROM mereni
INNER JOIN zivocich ON mereni.zivocich_id = zivocich.id
INNER JOIN DRUH ON ZIVOCICH.DRUH_JMENO = DRUH.JMENO
CROSS JOIN tmpTable
WHERE mereni.hmotnost > tmpTable.avgValue
ORDER BY mereni.hmotnost, 
CASE zivocich.jmeno
when NULL
THEN druh.jmeno
ELSE zivocich.jmeno
END;


