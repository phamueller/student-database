USE student_db;

-- Hier ein vereindfachtes Beispiel
-- einer Tabelle zum speichern von Sensordaten
DROP TABLE IF EXISTS sensordaten;
CREATE TABLE sensordaten (
    messung_id INT AUTO_INCREMENT PRIMARY KEY,
    sensor_id INT NOT NULL,
    zeitpunkt DATETIME,
    messwert FLOAT,
    ort VARCHAR(50)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- Versuchen wir das Beispiel etwas zu vertiefen
-- und erstellen eine allgemeine Datenstruktur 
-- zur Speicherung von Sensordaten 

DROP TABLE IF EXISTS iot_standort;
CREATE TABLE iot_standort (
    standort_id INT AUTO_INCREMENT PRIMARY KEY,
    standort_name VARCHAR(100),
    stadt VARCHAR(50),
    land VARCHAR(50)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS iot_sensor;
CREATE TABLE iot_sensor (
    sensor_id INT AUTO_INCREMENT PRIMARY KEY,
    sensor_typ VARCHAR(50),
    hersteller VARCHAR(50),
    standort_id INT NOT NULL,
    JSON_informationen JSON,
    FOREIGN KEY (standort_id) REFERENCES iot_standort(standort_id)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS iot_messung;
CREATE TABLE iot_messung (
    messung_id INT AUTO_INCREMENT PRIMARY KEY,
    sensor_id INT NOT NULL,
    zeitstempel DATETIME,
    messwert FLOAT,
    FOREIGN KEY (sensor_id) REFERENCES iot_sensor(sensor_id)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS iot_maschine;
CREATE TABLE iot_maschine (
    maschinen_id INT AUTO_INCREMENT PRIMARY KEY,
    maschinenname VARCHAR(50),
    produktionslinie VARCHAR(50)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS iot_maschinen_sensor;
CREATE TABLE iot_maschinen_sensor (
    maschinen_id INT NOT NULL,
    sensor_id INT NOT NULL,
    PRIMARY KEY (maschinen_id, sensor_id),
    FOREIGN KEY (maschinen_id) REFERENCES iot_maschine(maschinen_id),
    FOREIGN KEY (sensor_id) REFERENCES iot_sensor(sensor_id)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS iot_maschinen_sensor;
DROP TABLE IF EXISTS iot_messung;
DROP TABLE IF EXISTS iot_sensor;
DROP TABLE IF EXISTS iot_maschine;
DROP TABLE IF EXISTS iot_standort;

TRUNCATE TABLE iot_standort;
INSERT INTO iot_standort (standort_name, stadt, land) VALUES 
('Fertigungshalle A', 'Freiburg', 'Baden-Württemberg'),
('Fertigungshalle B', 'Freiburg', 'Baden-Württemberg');
SELECT * FROM iot_standort;

-- Lade die CSV-Daten aus der Datei in die Tabelle
LOAD DATA INFILE '...\student_db\sensor_data_master.csv'
INTO TABLE sensor
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES; -- Um die Header-Zeile zu ignorieren, wenn vorhanden


-- Lade die JSON-Daten aus der Datei in die Tabelle
LOAD DATA INFILE '...\student_db\sensor_data.json'
INTO TABLE iot_sensor
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(@json)
SET
  sensor_typ = JSON_UNQUOTE(JSON_EXTRACT(@json, '$.sensor_typ')),
  hersteller = JSON_UNQUOTE(JSON_EXTRACT(@json, '$.hersteller')),
  standort_id = JSON_UNQUOTE(JSON_EXTRACT(@json, '$.standort_id')),
  weitere_informationen = JSON_UNQUOTE(JSON_EXTRACT(@json, '$.weitere_informationen'));

 
 -- Die Einheit "hPa" steht für "Hektopascal", was eine Maßeinheit für den Luftdruck ist. Der Ausdruck "±1 hPa" bedeutet "plus oder minus 1 Hektopascal". Der Hektopascal ist eine SI-Einheit des Drucks und entspricht einem Pascal, multipliziert mit 100.

 -- Lade die CSV-Daten aus der Datei in die Tabelle
LOAD DATA INFILE '...\student_db\sensor_data.csv'
INTO TABLE messung
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES; -- Um die Header-Zeile zu ignorieren, wenn vorhanden
 

SELECT * FROM iot_sensor;

-- Das Beispiel enthält drei Messdatensätze mit den folgenden Informationen:
-- Sensor mit ID 1, gemessen um 08:30 Uhr am 25. Dezember 2023, Messwert 25,5.
-- Sensor mit ID 1, gemessen um 09:15 Uhr am 25. Dezember 2023, Messwert 65,2.
-- Sensor mit ID 1, gemessen um 10:00 Uhr am 25. Dezember 2023, Messwert 1013,2.


DROP TEMPORARY TABLE IF EXISTS iot_test;
CREATE TEMPORARY TABLE iot_test(
    test_id INT 
)AUTO_INCREMENT=1;


SELECT * FROM information_schema.routines;


DROP PROCEDURE IF EXISTS iot_test;
CREATE PROCEDURE iot_test()
BEGIN
	DECLARE var INT DEFAULT 1;

	WHILE var <= 1000 DO
		INSERT INTO iot_test (test_id)
		VALUES (var);
		SET var = var + 1;
	END WHILE;
END

CALL iot_test();
SELECT COUNT(*) FROM iot_test;

INSERT INTO iot_messung (sensor_id, zeitstempel, messwert)
SELECT
	1,
	NOW() - INTERVAL FLOOR(RAND() * 365) DAY,
	(RAND() * (1200 - 25)) + 25
FROM iot_test; -- LIMIT 1000;

-- TRUNCATE TABLE iot_messung;
SELECT * FROM iot_messung;
SELECT COUNT(*), MAX(messwert), MIN(messwert) FROM iot_messung;
SELECT COUNT(*), MAX(zeitstempel), MIN(zeitstempel) FROM iot_messung;

-- FLOOR(RAND() * 10) + 1 as sensor_id -- Zufällige Sensor-ID zwischen 1 und 10
-- Zufälliges Datum der letzten 365 Tage
-- Zufälliger Messwert zwischen 25 und 1200 (als FLOAT)