
-- Versuchen wir das IOT-Beispiel etwas zu vertiefen
-- und erstellen eine allgemeine Datenstruktur 
-- zur Speicherung von Sensordaten 

DROP TABLE IF EXISTS iot_stadt;
CREATE TABLE iot_stadt (
    stadt_id INT AUTO_INCREMENT PRIMARY KEY,
    stadt VARCHAR(50) NOT NULL UNIQUE,
    bundesland VARCHAR(50)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
-- ALTER TABLE student_db.iot_stadt ADD CONSTRAINT iot_stadt_unique UNIQUE (stadt);

DROP TABLE IF EXISTS iot_standort;
CREATE TABLE iot_standort (
    standort_id INT AUTO_INCREMENT PRIMARY KEY,
    stadt_id INT NOT NULL,
    standort_name VARCHAR(100),
    FOREIGN KEY (stadt_id) REFERENCES iot_stadt(stadt_id)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
-- ALTER TABLE student_db.iot_standort ADD einheit_id INT DEFAULT 1;

DROP TABLE IF EXISTS iot_hersteller;
CREATE TABLE iot_hersteller (
    hersteller_id INT AUTO_INCREMENT PRIMARY KEY,
    hersteller_name VARCHAR(50)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS iot_einheit;
CREATE TABLE iot_einheit (
    einheit_id INT AUTO_INCREMENT PRIMARY KEY,
    einheit_beschreibung VARCHAR(50)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS iot_software;
CREATE TABLE iot_software (
    software_id INT AUTO_INCREMENT PRIMARY KEY,
    software_version VARCHAR(50),
    installation_datum DATE,
    software_aktuell BOOL DEFAULT TRUE
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS iot_sensor;
CREATE TABLE iot_sensor (
    sensor_id INT AUTO_INCREMENT PRIMARY KEY,
    standort_id INT NOT NULL,
    hersteller_id INT NOT NULL,
    einheit_id INT NOT NULL,
    herstellung_datum DATE,
    sensor_typ VARCHAR(50),    
    konfiguration JSON,
    FOREIGN KEY (standort_id) REFERENCES iot_standort(standort_id),
    FOREIGN KEY (hersteller_id) REFERENCES iot_hersteller(hersteller_id),
    FOREIGN KEY (einheit_id) REFERENCES iot_einheit(einheit_id)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS iot_schwellwert;
CREATE TABLE iot_schwellwert (
    iot_schwellwert_id INT AUTO_INCREMENT PRIMARY KEY,
    sensor_id INT NOT NULL,
    min DOUBLE,
    max DOUBLE,
    FOREIGN KEY (sensor_id) REFERENCES iot_sensor(sensor_id)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS iot_sensor2software;
CREATE TABLE iot_sensor2software (
    sensor2software_id INT AUTO_INCREMENT PRIMARY KEY,
    software_id INT NOT NULL,
    sensor_id INT NOT NULL,
    FOREIGN KEY (software_id) REFERENCES iot_software(software_id),
    FOREIGN KEY (sensor_id) REFERENCES iot_sensor(sensor_id)
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
    maschine_id INT AUTO_INCREMENT PRIMARY KEY,
    maschine_name VARCHAR(50)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS iot_maschinen2sensor;
CREATE TABLE iot_maschinen2sensor (
    maschine_id INT NOT NULL,
    sensor_id INT NOT NULL,
    PRIMARY KEY (maschine_id, sensor_id),
    FOREIGN KEY (maschine_id) REFERENCES iot_maschine(maschine_id),
    FOREIGN KEY (sensor_id) REFERENCES iot_sensor(sensor_id)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS iot_sensor2software;
DROP TABLE IF EXISTS iot_maschinen2sensor;
DROP TABLE IF EXISTS iot_messung;
DROP TABLE IF EXISTS iot_maschine;
DROP TABLE IF EXISTS iot_software;
DROP TABLE IF EXISTS iot_schwellwert;
DROP TABLE IF EXISTS iot_sensor;
DROP TABLE IF EXISTS iot_einheit;
DROP TABLE IF EXISTS iot_hersteller;
DROP TABLE IF EXISTS iot_stadt;
DROP TABLE IF EXISTS iot_standort;
DROP TABLE IF EXISTS iot_key_value;


-- Eine Erweiterung des Modells um einen Key-Value-Store
-- zur Speicherung weiterer Konfigurationsdaten

DROP TABLE IF EXISTS iot_key_value;
CREATE TABLE iot_key_value (
    column_key INT NOT NULL,
    column_value VARCHAR(50)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

