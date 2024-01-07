USE student_db;

/** Typenkonvertierung **/
DROP TABLE IF EXISTS test_t;
CREATE TABLE test_t (
	i INTEGER, 
	d DECIMAL(5,2), 
	f FLOAT, 
	c VARCHAR(3), 
	b BOOLEAN
);

INSERT INTO test_t VALUES (1, 123.45, 78.46723, 'abc', TRUE);
INSERT INTO test_t VALUES (1.5, 12345.678, 78.46723456789, 'abcdefghij', 23);

-- Warning!
-- Out of range value for column 'd' at row 1
-- Data truncated for column 'c' at row 1

SELECT * FROM test_t;

-- Quelle: https://mariadb.com/kb/en/numeric-data-type-overview/
-- TINYINT = 1 byte (8 bit)
-- SMALLINT = 2 bytes (16 bit)
-- MEDIUMINT = 3 bytes (24 bit)
-- INT = 4 bytes (32 bit)
-- BIGINT = 8 bytes (64 bit)


/** Komplexe Datentypen **/
DROP TABLE IF EXISTS test_k;
CREATE TABLE test_k (
	datumNull DATE, 
	zeitNull TIME, 
	zeitpunktNull TIMESTAMP,
	datumNotNull DATE NOT NULL, 
	zeitNotNull TIME NOT NULL,
	zeitpunktNotNull TIMESTAMP NOT NULL
);

INSERT INTO test_k VALUES 
('2014–11–11', '12:12:12', '2014–11–11 12:12:12', '2014–11–11', '12:12:12', '2014–11–11 12:12:12'),
('2014', '122X', '2014 122', '2014', '122', '2014 122');

SELECT * FROM test_k;
