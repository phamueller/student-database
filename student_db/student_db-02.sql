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

