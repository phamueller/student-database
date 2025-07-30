
-- Einfügen der Stammdaten
-- zuerst die Datensätz auf die verwiesen wird (zu 1)
-- dann die Datensätze die 1 bis n Datensätze abbilden können

INSERT INTO iot_stadt (stadt, bundesland) VALUES ('Freiburg', 'Baden-Württemberg');
SELECT * FROM iot_stadt;
INSERT INTO iot_standort (stadt_id, standort_name, einheit_id) VALUES (1, 'Vorentwicklung', NULL);
SELECT * FROM iot_standort;
INSERT INTO iot_einheit (einheit_beschreibung) VALUES ('hPa'); -- Hektopascal, 1 Hektopascal (hPa) = 100 Pascal (Pa)
SELECT * FROM iot_einheit;
INSERT INTO iot_hersteller (hersteller_name) VALUES ('PressureTech');
SELECT * FROM iot_hersteller;
INSERT INTO iot_software (software_version, installation_datum, software_aktuell) VALUES ('23.3.1.202312241705', (SELECT CAST(NOW() AS DATE)), 1);
SELECT * FROM iot_software;
INSERT INTO iot_maschine (maschine_name) VALUES ('Schrauber');
SELECT * FROM iot_maschine;

INSERT INTO iot_sensor (standort_id, hersteller_id, einheit_id, herstellung_datum, sensor_typ, konfiguration) VALUES 
(1, 1, 1, (SELECT CAST('20231200' AS DATE)), 'Drucksensor', '{"genauigkeit": "±1 hPa", "maximaler_druck": 1200, "minimaler_druck": 800}');
SELECT * FROM iot_sensor;

INSERT INTO iot_sensor2software (software_id, sensor_id) VALUES (1, 1);
SELECT * FROM iot_sensor2software;
INSERT INTO iot_maschinen2sensor (maschine_id, sensor_id) VALUES (1, 1);
SELECT * FROM iot_maschinen2sensor;
INSERT INTO iot_schwellwert (sensor_id, min, max) VALUES (1, 1200, 800);
SELECT * FROM iot_schwellwert;


-- Für die Bewegungsdaten erstellen wir eine Hilfskonstruktion 
-- eine Prozedur zur Generierung von Testdaten, 
-- da wir davon ausgehen können, das die Applikationslogik mehrfach getestet werden wird. 

-- Wir erstellen eine allgemein nutzbare Prozedur zur Erzeugung
-- einer (beschränkt) beliebigen Anzahl von Datensätzen 
DROP PROCEDURE IF EXISTS iot_proc_test;
DELIMITER //
CREATE PROCEDURE iot_proc_test()
BEGIN
	DECLARE counter INT DEFAULT 1;
	WHILE counter <= 1000 DO
		INSERT INTO iot_test_tmp (test_id) VALUES (counter);
		SET counter = counter + 1;
	END WHILE;
END //

SELECT * FROM information_schema.routines;

-- Wir befüllen mit Hilfe der Prozedur die temporäre Tabelle
CALL iot_proc_test();

-- Die Anzahl der zu erzeugenden Datensätze wird in einer temporären Tabelle gespeichert
DROP TEMPORARY TABLE IF EXISTS iot_test_tmp;
CREATE TEMPORARY TABLE iot_test_tmp(
    test_id INT 
)AUTO_INCREMENT=1 ENGINE=INNODB;

SELECT COUNT(*) FROM iot_test_tmp;


-- Einfügen der 1000 Testdaten aus der temporären Tabelle in die Tabelle iot_messung
INSERT INTO iot_messung (sensor_id, zeitstempel, messwert)
SELECT
	1,
	NOW() - INTERVAL FLOOR(RAND() * 365) DAY,
	(RAND() * (1200 - 800)) + 800
FROM iot_test_tmp;

-- TRUNCATE TABLE iot_messung;
SELECT * FROM iot_messung;
SELECT COUNT(*), MAX(messwert), MIN(messwert) FROM iot_messung;
SELECT COUNT(*), MAX(zeitstempel), MIN(zeitstempel), DATEDIFF(MAX(zeitstempel), MIN(zeitstempel)) AS DIFF FROM iot_messung;

-- FLOOR(RAND() * 10) + 1 as sensor_id -- Zufällige Sensor-ID zwischen 1 und 10
-- Zufälliges Datum der letzten 365 Tage
-- Zufälliger Messwert zwischen 25 und 1200 (als FLOAT)

