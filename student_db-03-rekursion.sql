USE student_db;

-- Allgemeines CTE-Schema
WITH [RECURSIVE] with_query [, ...]
SELECT ...


DROP TABLE IF EXISTS mgt_personal;

CREATE TABLE mgt_personal (
	personal_id INTEGER AUTO_INCREMENT,
	level int,
	name VARCHAR (45) NOT NULL,
	manager_id int,	
	PRIMARY KEY (personal_id) 	
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

INSERT INTO mgt_personal (level, name, manager_id) VALUES 
(0, 'Veronika', NULL),
(1, 'Hans', 1),
(2, 'Bernd', 2),
(2, 'Nina', 2);


SELECT * FROM mgt_personal;

DROP VIEW IF EXISTS v_mgt_personal_topmanager;
CREATE VIEW v_mgt_personal_topmanager AS (
	SELECT 
		personal_id, 
		name, 
		manager_id 
	FROM mgt_personal WHERE manager_id IS NULL	
);
SELECT * FROM v_mgt_personal_topmanager;


-- Beispiel einer Hierarchieabbildung
SELECT 
	level, LPAD (' ', 2 * (level- 1)) || name AS 'employee', 
	personal_id, 
	manager_id AS 'manager'
FROM mgt_personal 
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
    mgt_personal p1
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
    mgt_personal p2
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


DROP VIEW IF EXISTS v_mgt_personal_hierarchie;
CREATE VIEW v_mgt_personal_hierarchie AS (
	SELECT
	  e1.personal_id,
	  e1.level,
	  e1.name,
	  e1.manager_id
	FROM
	  mgt_personal e1
	-- ein JOIN pro Hierarchieebenen
	LEFT JOIN
	  mgt_personal e2 ON e1.manager_id = e2.personal_id
	LEFT JOIN
	  mgt_personal e3 ON e2.manager_id = e3.personal_id
	LEFT JOIN
	  mgt_personal e4 ON e3.manager_id = e4.personal_id	
	ORDER BY
	  e1.level, e1.personal_id
);


DROP VIEW IF EXISTS v_mgt_personal_hierarchie_rec;
CREATE VIEW v_mgt_personal_hierarchie_rec AS 
	WITH RECURSIVE PersonalCTE AS (
	  SELECT
	    personal_id,
	    level,
	    name,
	    manager_id
	  FROM
	    mgt_personal
	  WHERE
	    manager_id IS NULL -- Für die oberste Hierarchieebene
	
	  UNION ALL
	
	  SELECT
	    p.personal_id,
	    p.level,
	    p.name,
	    p.manager_id
	  FROM
	    mgt_personal p
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

SELECT * FROM v_mgt_personal_hierarchie_rec;
