USE student_db;

-- Hier ein vereindfachtes Beispiel
-- einer Tabelle zum speichern von Sensordaten
DROP TABLE IF EXISTS sensordaten;
CREATE TABLE sensordaten (
    messung_id INT PRIMARY KEY,
    sensor_id INT,
    zeitpunkt DATETIME,
    messwert FLOAT,
    ort VARCHAR(50)
);

-- Versuchen wir das Beispiel etwas zu vertiefen
-- und erstellen eine allgemeine Datenstruktur 
-- zur Speicherung von Sensordaten 

DROP TABLE IF EXISTS iot_standort;
CREATE TABLE iot_standort (
    standort_id INT PRIMARY KEY,
    standort_name VARCHAR(100),
    stadt VARCHAR(50),
    land VARCHAR(50)
);

DROP TABLE IF EXISTS iot_sensor;
CREATE TABLE iot_sensor (
    sensor_id INT PRIMARY KEY,
    sensor_typ VARCHAR(50),
    hersteller VARCHAR(50),
    standort_id INT,
    FOREIGN KEY (standort_id) REFERENCES iot_standort(standort_id)
);

DROP TABLE IF EXISTS iot_messung;
CREATE TABLE iot_messung (
    messung_id INT PRIMARY KEY,
    sensor_id INT,
    zeitstempel DATETIME,
    messwert FLOAT,
    FOREIGN KEY (sensor_id) REFERENCES iot_sensor(sensor_id)
);

DROP TABLE IF EXISTS iot_maschine;
CREATE TABLE iot_maschine (
    maschinen_id INT PRIMARY KEY,
    maschinenname VARCHAR(50),
    produktionslinie VARCHAR(50)
);

DROP TABLE IF EXISTS iot_maschinen_sensor;
CREATE TABLE iot_maschinen_sensor (
    maschinen_id INT,
    sensor_id INT,
    PRIMARY KEY (maschinen_id, sensor_id),
    FOREIGN KEY (maschinen_id) REFERENCES iot_maschine(maschinen_id),
    FOREIGN KEY (sensor_id) REFERENCES iot_sensor(sensor_id)
);

DROP TABLE IF EXISTS iot_standort;
DROP TABLE IF EXISTS iot_sensor;
DROP TABLE IF EXISTS iot_messung;
DROP TABLE IF EXISTS iot_maschine;
DROP TABLE IF EXISTS iot_maschinen_sensor;

