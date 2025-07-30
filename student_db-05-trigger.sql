USE student_db;

/** NOT NULL UNIQUE **/
DROP TABLE IF EXISTS mgt_gutscheinaktion;
CREATE TABLE mgt_gutscheinaktion (
	aktions_id INTEGER AUTO_INCREMENT,
	beginnaktion TIMESTAMP NOT NULL,
	endeaktion TIMESTAMP NOT NULL,
	titel VARCHAR (500) NOT NULL,
	beschreibung TEXT,
	gutscheincode VARCHAR(100) NOT NULL UNIQUE,
	PRIMARY KEY (aktions_id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- TRUNCATE TABLE mgt_gutscheinaktion;
-- DELETE FROM mgt_gutscheinaktion WHERE gutscheincode='1223-CHSP';
INSERT INTO mgt_gutscheinaktion 
	(beginnaktion, endeaktion, titel, gutscheincode) VALUES 
	('2023-12-20', '2023-12-26', 'Weihnachtsspecial', '1223-CHSP');

-- Rechnen mit dem Datentyp TIMESTAMP
SELECT
    titel AS Gutschein_Titel,
    DATEDIFF(endeaktion, beginnaktion) AS Differenz_in_Tagen
FROM
    mgt_gutscheinaktion;

-- Einfügen eines neuen Datensatzes mit INSERT FROM TABLE
INSERT INTO mgt_gutscheinaktion 
	(beginnaktion, endeaktion, titel, gutscheincode)
SELECT beginnaktion, '2024-02-01', 'Neujahrsspecial', '0124-NJSP' 
	FROM mgt_gutscheinaktion 
WHERE gutscheincode = '1223-CHSP';

DELETE FROM mgt_gutscheinaktion WHERE gutscheincode = '0124-NJSP';

SELECT * FROM mgt_gutscheinaktion;

UPDATE mgt_gutscheinaktion 
	SET beginnaktion = '2024-01-01'
WHERE gutscheincode = '0124-NJSP';

-- Einfügen eines neuen Datensatzes mit INSERT VALUES
INSERT INTO mgt_gutscheinaktion 
	(beginnaktion, endeaktion, titel, gutscheincode) VALUES
	('2023-12-20', '2024-02-01', 'Neujahrsspecial', '0124-NJSP');


SELECT * FROM mgt_gutscheinaktion;
-- Was passiert mit dem Datensatz wenn ein Datensatz gelöscht wird?
-- Wie kann die Löschung des Datensatzes an die Tabelle marketingaktionmarketingaktio weiter gegeben werden?
-- Was passiert bei einem Update, wenn sich beispielsweise das Beginn- oder Ende_Datum verändert?


DROP TABLE IF EXISTS mgt_marketingaktion;
CREATE TABLE mgt_marketingaktion (
	aktions_id INTEGER AUTO_INCREMENT,
	beginnaktion TIMESTAMP NOT NULL,
	endeaktion TIMESTAMP NOT NULL,
	beschreibung TEXT,
	status BOOLEAN DEFAULT TRUE,
	fk_id INTEGER,
	PRIMARY KEY (aktions_id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


CREATE TRIGGER ai_action
AFTER INSERT
ON mgt_gutscheinaktion FOR EACH ROW
BEGIN
    INSERT INTO mgt_marketingaktion (beginnaktion, endeaktion, beschreibung, fk_id)
    VALUES (NEW.beginnaktion, NEW.endeaktion, CONCAT('Eine E-Mail-Aktion als ', NEW.titel), NEW.aktions_id);
END;

-- TRUNCATE TABLE mgt_marketingaktion;
-- DELETE FROM mgt_marketingaktion WHERE 1=1;
SELECT * FROM mgt_marketingaktion;


CREATE TRIGGER ad_action
AFTER DELETE
ON mgt_gutscheinaktion FOR EACH ROW
BEGIN
    UPDATE mgt_marketingaktion
    SET status = FALSE, beschreibung = 'Datensatz in Tabelle gutscheinaktion wurde gelöscht'
    WHERE fk_id = OLD.aktions_id;
END
