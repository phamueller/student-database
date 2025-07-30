USE student_db;

-- Hier ein vereindfachtes Sensor-Beispiel
-- einer Tabelle zum speichern von Sensordaten

DROP TABLE IF EXISTS sen_standort;
CREATE TABLE sen_standort (
    standort_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS sen_sensor;
CREATE TABLE sen_sensor (
    sensor_id INT AUTO_INCREMENT PRIMARY KEY,
    sensor_typ VARCHAR(50),
    hersteller VARCHAR(50),
    standort_id INT NOT NULL,
    konfiguration JSON,
    FOREIGN KEY (standort_id) REFERENCES sen_standort (standort_id)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS sen_messung;
CREATE TABLE sen_messung (
    messung_id INT AUTO_INCREMENT PRIMARY KEY,
    sensor_id INT NOT NULL,
    zeitstempel INT NOT NULL,
    zeitpunkt DATETIME,
    messwert FLOAT,
    ort VARCHAR(50),
    FOREIGN KEY (sensor_id) REFERENCES sen_sensor (sensor_id)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


INSERT INTO sen_standort (name) VALUE ('Freiburg');
-- Versuchen wir das Insert -Statement ein weiteres Mal auszuführen
SELECT * FROM sen_standort;


DROP TABLE IF EXISTS sen_messung;
DROP TABLE IF EXISTS sen_standort;
DROP TABLE IF EXISTS sen_sensor;


-- Lade die CSV-Daten aus der Datei in die Tabelle
LOAD DATA INFILE '...\sensor_data_master.csv'
INTO TABLE sen_sensor
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES; -- Um die Header-Zeile zu ignorieren, wenn vorhanden


-- Lade die JSON-Daten aus der Datei in die Tabelle
LOAD DATA INFILE '...\sensor_data.json'
INTO TABLE sen_messung
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
LOAD DATA INFILE '...\sensor_data.csv'
INTO TABLE messung
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES; -- Um die Header-Zeile zu ignorieren, wenn vorhanden
 

SELECT * FROM sensor;
SELECT * FROM messung;

-- Das Beispiel enthält drei Messdatensätze mit den folgenden Informationen:
-- Sensor mit ID 1, gemessen um 08:30 Uhr am 25. Dezember 2023, Messwert 25,5.
-- Sensor mit ID 1, gemessen um 09:15 Uhr am 25. Dezember 2023, Messwert 65,2.
-- Sensor mit ID 1, gemessen um 10:00 Uhr am 25. Dezember 2023, Messwert 1013,2.
