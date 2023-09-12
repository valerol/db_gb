CREATE TABLE IF NOT EXISTS log (
 timecreate datetime,
 tablename char(20)
)
ENGINE=ARCHIVE;

DELIMITER //
CREATE TRIGGER IF NOT EXISTS add_log_users AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO log 
		(timecreate, tablename) 
	VALUES 
		(NOW(), 'users');
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER IF NOT EXISTS add_log_communities AFTER INSERT ON communities
FOR EACH ROW
BEGIN
	INSERT INTO log 
		(timecreate, tablename) 
	VALUES 
		(NOW(), 'communities');
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER IF NOT EXISTS add_log_messages AFTER INSERT ON messages
FOR EACH ROW
BEGIN
	INSERT INTO log 
		(timecreate, tablename) 
	VALUES 
		(NOW(), 'messages');
END//
DELIMITER ;

INSERT INTO users (firstname, lastname, email) VALUES
('Test', 'Test', 'valerol27@example.com');

INSERT INTO messages (from_user_id, to_user_id, body, created_at) VALUES 
(1, 2, 'Voluptatem ut quaerat quia. Pariatur esse amet ratione qui quia. In necessitatibus reprehenderit et. Nam accusantium aut qui quae nesciunt non.',  DATE_ADD(NOW(), INTERVAL 1 MINUTE));

INSERT INTO communities (`name`) VALUES ('valerol');

SELECT * FROM log;
