
-- Erstelle eine temporäre Tabelle zum Generieren von Testdaten
DROP TEMPORARY TABLE IF EXISTS temp_gutscheinaktion;
CREATE TEMPORARY TABLE temp_gutscheinaktion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    beginnaktion TIMESTAMP NOT NULL,
    endeaktion TIMESTAMP NOT NULL,
    titel VARCHAR (500) NOT NULL,
    beschreibung TEXT,
    gutscheincode VARCHAR(100) NOT NULL -- UNIQUE
);

SET @counter = 0;
INSERT INTO temp_gutscheinaktion (beginnaktion, endeaktion, titel, beschreibung, gutscheincode)
SELECT
    NOW(),
    NOW() + INTERVAL FLOOR(RAND() * 30) DAY,
    CONCAT('Gutschein ', number),
    CONCAT('Beschreibung ', number),
    CONCAT('CODE', number)
FROM
    (SELECT @counter := @counter + 1 AS number FROM information_schema.tables LIMIT 100) AS numbers;

SELECT * FROM temp_gutscheinaktion;

EXPLAIN information_schema.tables;
SELECT * FROM information_schema.tables;
SELECT * FROM information_schema.views;
SELECT * FROM information_schema.triggers;

