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

SELECT * FROM gutscheinaktion;


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

INSERT INTO tabelle2 (spalte1,…,spalteN)
SELECT spalte1,…,spalteN FROM tabelle1 WHERE bedingung;


WITH [RECURSIVE] with_query [, ...]
SELECT ...


SELECT LEVEL, LPAD (' ', 2 * (LEVEL - 1)) || ename "employee", empno, mgr "manager"
FROM emp START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr;


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
