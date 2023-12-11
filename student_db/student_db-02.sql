USE student_db;

DROP TABLE IF EXISTS artikel;

CREATE TABLE artikel (
  artikel_id int NOT NULL AUTO_INCREMENT,
  artikel_nr varchar(45),
  preis double,
  name varchar(45),
  verfuegbarkeit varchar(45),
  PRIMARY KEY (artikel_id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- SHOW VARIABLES LIKE 'auto_inc%';
-- ALTER TABLE artikel AUTO_INCREMENT = 1;

INSERT INTO artikel (artikel_nr, preis, name, verfuegbarkeit) VALUES
('UZEHN78126',10.99,'Auf dem Weg ins Nichts','sofort'),
('ZHBH789123',13.99,'Hinter uns','sofort'),
('KJNSM7873',9.99,'Help you','in 3 Tagen'),
('UIHJKHSD7',8.99,'Around the Planet','in 2 Tagen');

SELECT * FROM artikel;

DROP TABLE IF EXISTS film;

CREATE TABLE film (
  film_id int NOT NULL AUTO_INCREMENT,
  regisseur	varchar(45),
  sprachen varchar(45),
  untertitel varchar(45),
  anzahl_discs int,
  studio varchar(45),
  medium varchar(45),
  artikel_id int,
  PRIMARY KEY (film_id),
  FOREIGN KEY (artikel_id) REFERENCES artikel(artikel_id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8; 

INSERT INTO film (regisseur, sprachen, untertitel, anzahl_discs, studio, medium, artikel_id) VALUES
('Sophie Little','DE, EN, FR','DE, EN', 1, 'DreamPictures','DVD',1),
('Fred van Heldt','EN, FR','EN, FR, DE', 2, 'MovieFactory','DVD',2);

SELECT * FROM film;


/** JOINs **/
SELECT 
	a.name, 
	f.regisseur,
	a.preis,
	a.verfuegbarkeit	
FROM artikel a 
JOIN film f ON a.artikel_id = f.artikel_id
ORDER by a.preis;

SELECT 
	a.*, f.*
FROM artikel a 
JOIN film f ON a.artikel_id = f.artikel_id;

SELECT 
	anzahl_Discs,
	-- verfuegbarkeit 
	COUNT(*) AS Anzahl 
FROM artikel a 
JOIN film f ON a.artikel_id = f.artikel_id;

SELECT 
	anzahl_Discs,
	COUNT(*) AS Anzahl 
FROM artikel NATURAL JOIN film
WHERE verfuegbarkeit = 'sofort' 
AND anzahl_discs > 1 
GROUP BY anzahl_discs ;

SELECT *
FROM artikel 
INNER JOIN film
ON artikel.artikel_id=film.artikel_id;

SELECT * 
FROM artikel
NATURAL JOIN film;

SELECT * 
FROM artikel 
INNER JOIN film USING(artikel_id);


/** VIEWs **/
DROP VIEW IF EXISTS v_sofort_verfuegbare_filme;

CREATE VIEW v_sofort_verfuegbare_filme AS 
	SELECT * 
	FROM artikel a INNER JOIN film f USING(artikel_id)
	WHERE a.verfuegbarkeit = 'sofort' 
	ORDER BY a.name;

SELECT * 
FROM v_sofort_verfuegbare_filme
WHERE sprachen LIKE '%DE%' OR sprachen LIKE 'DE%';

ALTER VIEW v_sofort_verfuegbare_filme AS 
	SELECT * 
	FROM artikel a INNER JOIN film f USING(artikel_id)
	WHERE a.verfuegbarkeit = 'in 3 Tagen' 
	ORDER BY a.name;	