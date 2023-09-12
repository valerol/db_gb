USE semimar_4;

CREATE TABLE IF NOT EXISTS users_old LIKE users;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS user_transfer(user_id INT)
BEGIN
	START TRANSACTION;
	SELECT firstname, lastname, email 
		INTO @firstname, @lastname, @email 
		FROM users 
		WHERE id = user_id;
	IF ((SELECT COUNT(*) FROM users_old WHERE firstname = @firstname 
				AND lastname = @lastname 
				AND @email = email) = 0) THEN
		INSERT INTO users_old (firstname, lastname, email) VALUES (@firstname, @lastname, @email);
		DELETE FROM users WHERE id = user_id;
	END IF;
	IF ((SELECT COUNT(*) FROM users_old WHERE firstname = @firstname 
				AND lastname = @lastname 
				AND @email = email) = 1)
			AND ((SELECT COUNT(*) FROM users WHERE firstname = @firstname 
				AND lastname = @lastname 
				AND @email = email) = 0)
		THEN COMMIT;
	ELSE ROLLBACK;
    END IF;
END//
DELIMITER ;

CALL user_transfer(54);
SELECT * FROM users_old UNION SELECT * FROM users;
