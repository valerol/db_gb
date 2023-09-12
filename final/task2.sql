DELIMITER //

DROP FUNCTION IF EXISTS hello;
CREATE FUNCTION hello() RETURNS CHAR(20) DETERMINISTIC
BEGIN
   RETURN
    IF(TIMEDIFF(CURTIME(), "06:00:00") < '06:00:00', "Доброе утро", 
		IF(TIMEDIFF(CURTIME(), "12:00:00") < '06:00:00', "Добрый день", 
			IF(TIMEDIFF(CURTIME(), "18:00:00") < '06:00:00', "Добрый вечер", "Доброй ночи")
		)
	);
END//

DELIMITER ;

SELECT hello();
