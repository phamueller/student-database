USE student_db;

/** NOT NULL UNIQUE **/
DROP TABLE IF EXISTS gutscheinaktion;
CREATE TABLE gutscheinaktion (
	aktions_id INTEGER AUTO_INCREMENT,
	beginnaktion TIMESTAMP NOT NULL,
	endeaktion TIMESTAMP NOT NULL,
	titel VARCHAR (500) NOT NULL,
	beschreibung TEXT,
	gutscheincode VARCHAR(100) NOT NULL UNIQUE,
	PRIMARY KEY (aktions_id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

INSERT INTO gutscheinaktion 
	(beginnaktion, endeaktion, titel, gutscheincode) VALUES 
	('2023-12-20', '2023-12-26', 'Weihnachtsspecial', '1223-CHSP');

SELECT * FROM gutscheinaktion;

UPDATE gutscheinaktion 
	SET endeaktion = '2023-12-31'
	-- SET endeaktion = '2023-12-26'
WHERE gutscheincode = '1223-CHSP';

SELECT * FROM gutscheinaktion;

SELECT
    titel AS Gutschein_Titel,
    DATEDIFF(endeaktion, beginnaktion) AS Differenz_in_Tagen
FROM
    gutscheinaktion;

INSERT INTO gutscheinaktion 
	(beginnaktion, endeaktion, titel, gutscheincode)
SELECT beginnaktion, '2024-02-01', 'Neujahrsspecial', '0124-NJSP' 
	FROM gutscheinaktion 
WHERE gutscheincode = '1223-CHSP';

DELETE FROM gutscheinaktion WHERE gutscheincode = '0124-NJSP';

SELECT * FROM gutscheinaktion;

UPDATE gutscheinaktion 
	SET beginnaktion = '2024-01-01'
WHERE gutscheincode = '0124-NJSP';

-- SHOW PROCESSLIST;
-- ANALYZE TABLE gutscheinaktion;


/** Typenkonvertierung **/
DROP TABLE IF EXISTS t;
CREATE TABLE t (
	i INTEGER, 
	d DECIMAL(5,2), 
	f FLOAT, 
	c VARCHAR(3), 
	b BOOLEAN
);

INSERT INTO t VALUES (1, 123.45, 78.46723, 'abc', TRUE);
INSERT INTO t VALUES (1.5, 12345.678, 78.46723456789, 'abcdefghij', 23);

-- Warning!
-- Out of range value for column 'd' at row 1
-- Data truncated for column 'c' at row 1

SELECT * FROM t;

-- Quelle: https://mariadb.com/kb/en/numeric-data-type-overview/
-- TINYINT = 1 byte (8 bit)
-- SMALLINT = 2 bytes (16 bit)
-- MEDIUMINT = 3 bytes (24 bit)
-- INT = 4 bytes (32 bit)
-- BIGINT = 8 bytes (64 bit)


/** Komplexe Datentypen **/
DROP TABLE IF EXISTS k;
CREATE TABLE k (
	datumNull DATE, 
	zeitNull TIME, 
	zeitpunktNull TIMESTAMP,
	datumNotNull DATE NOT NULL, 
	zeitNotNull TIME NOT NULL,
	zeitpunktNotNull TIMESTAMP NOT NULL
);

INSERT INTO k VALUES 
('2014–11–11', '12:12:12', '2014–11–11 12:12:12', '2014–11–11', '12:12:12', '2014–11–11 12:12:12'),
('2014', '122X', '2014 122', '2014', '122', '2014 122');

SELECT * FROM k;

-- Allgemeines INSERT INTO-Schema
INSERT INTO tabelle2 (spalte1,…,spalteN)
SELECT spalte1,…,spalteN FROM tabelle1 WHERE bedingung;

-- Allgemeines CTE-Schema
WITH [RECURSIVE] with_query [, ...]
SELECT ...


DROP TABLE IF EXISTS personal;

CREATE TABLE personal (
	personal_id INTEGER AUTO_INCREMENT,
	level int,
	name VARCHAR (45) NOT NULL,
	manager_id int,	
	PRIMARY KEY (personal_id) 	
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

INSERT INTO personal (level, name, manager_id) VALUES 
(0, 'Veronika', NULL),
(1, 'Hans', 1),
(2, 'Bernd', 2),
(2, 'Nina', 2);


SELECT * FROM personal;

DROP VIEW IF EXISTS v_personal_topmanager;
CREATE VIEW v_personal_topmanager AS (
	SELECT 
		personal_id, 
		name, 
		manager_id 
	FROM personal WHERE manager_id IS NULL	
);
SELECT * FROM v_personal_topmanager;


-- Beispiel einer Hierarchieabbildung
SELECT 
	level, LPAD (' ', 2 * (level- 1)) || name AS 'employee', 
	personal_id, 
	manager_id AS 'manager'
FROM personal 
START WITH manager_id IS NULL
CONNECT BY PRIOR personal_id = manager_id;
-- Connect By wird von MariaDB nicht unterstützt


-- Eine rekursive Abfrage zur Abbildung der Hierarchieebenen
WITH RECURSIVE HierarchicalCTE (level, name, personal_id, manager_id) AS (
  SELECT
    p1.level,
	CONCAT(LPAD(' ', 2 + p1.level), p1.name),
    -- LPAD(p1.name, 2, '.'),
	-- p1.name,
    p1.personal_id,
    p1.manager_id
  FROM
    personal p1
  WHERE
    p1.manager_id IS NULL
  UNION ALL
  SELECT
    p2.level,
	CONCAT(LPAD(' ', 2 + p2.level), p2.name),
    -- p2.name,
    p2.personal_id,
    p2.manager_id
  FROM
    personal p2
  INNER JOIN
    HierarchicalCTE cte ON p2.manager_id = cte.personal_id
)
SELECT 
	level, 
	name, 
	personal_id, 
	manager_id
FROM
	HierarchicalCTE
ORDER BY
	level, personal_id;


DROP VIEW IF EXISTS v_personal_hierarchie;
CREATE VIEW v_personal_hierarchie AS (
	SELECT
	  e1.personal_id,
	  e1.level,
	  e1.name,
	  e1.manager_id
	FROM
	  personal e1
	-- ein JOIN pro Hierarchieebenen
	LEFT JOIN
	  personal e2 ON e1.manager_id = e2.personal_id
	LEFT JOIN
	  personal e3 ON e2.manager_id = e3.personal_id
	LEFT JOIN
	  personal e4 ON e3.manager_id = e4.personal_id	
	ORDER BY
	  e1.level, e1.personal_id
);


DROP VIEW IF EXISTS v_personal_hierarchie_rec;
CREATE VIEW v_personal_hierarchie_rec AS 
	WITH RECURSIVE PersonalCTE AS (
	  SELECT
	    personal_id,
	    level,
	    name,
	    manager_id
	  FROM
	    personal
	  WHERE
	    manager_id IS NULL -- Für die oberste Hierarchieebene
	
	  UNION ALL
	
	  SELECT
	    p.personal_id,
	    p.level,
	    p.name,
	    p.manager_id
	  FROM
	    personal p
	  INNER JOIN
	    PersonalCTE cte ON p.manager_id = cte.personal_id
	)
	SELECT
	  personal_id,
	  level,
	  name,
	  manager_id
	FROM
	  PersonalCTE
	ORDER BY
	  level, personal_id;

SELECT * FROM v_personal_hierarchie_rec;







