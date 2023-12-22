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


-- DELETE FROM gutscheinaktion WHERE 1=1;
INSERT INTO gutscheinaktion 
	(beginnaktion, endeaktion, titel, gutscheincode) VALUES 
	('2023-12-20', '2023-12-26', 'Weihnachtsspecial', '1223-CHSP');

SELECT * FROM gutscheinaktion;
-- Was passiert mit dem Datensatz wenn ein Datensatz gelöscht wird?
-- Wie kann die Löschung des Datensatzes an die Tabelle marketingaktionmarketingaktio weiter gegeben werden?

DROP TABLE IF EXISTS marketingaktion;
CREATE TABLE marketingaktion (
	aktions_id INTEGER AUTO_INCREMENT,
	beginnaktion TIMESTAMP NOT NULL,
	endeaktion TIMESTAMP NOT NULL,
	beschreibung TEXT,
	status BOOLEAN DEFAULT TRUE,
	fk_id INTEGER,
	PRIMARY KEY (aktions_id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


CREATE DEFINER=`ws23inf`@`%` TRIGGER ai_action
AFTER INSERT
ON gutscheinaktion FOR EACH ROW
BEGIN
    INSERT INTO marketingaktion (beginnaktion, endeaktion, beschreibung, fk_id)
    VALUES (NEW.beginnaktion, NEW.endeaktion, 'Eine E-Mail-Aktion als Weihnachtsspecial', NEW.aktions_id);
END;

-- DELETE FROM marketingaktion WHERE 1=1;
SELECT * FROM marketingaktion;



CREATE TRIGGER ad_action
AFTER DELETE
ON gutscheinaktion FOR EACH ROW
BEGIN
    UPDATE marketingaktion
    SET status = FALSE
    WHERE fk_id = OLD.aktions_id;
END








