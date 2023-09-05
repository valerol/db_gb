USE semimar_4;

# 1. Создайте представление, в которое попадет информация о пользователях 
# (имя, фамилия, город и пол), которые не старше 20 лет

CREATE OR REPLACE view users_up_20 as
  SELECT u.firstname, u.lastname, p.gender, p.hometown FROM users as u 
  LEFT JOIN profiles as p ON u.id = p.user_id
  WHERE DATEDIFF(CURDATE(), p.birthday) <  20 * 365;
SELECT * FROM users_up_20;

# 2. Найдите кол-во отправленных сообщений каждым пользователем и выведите
# ранжированный список пользователей, указав имя и фамилию пользователя, количество
# отправленных сообщений и место в рейтинге (первое место у пользователя с максимальным
# количеством сообщений). (используйте DENSE_RANK)

CREATE OR REPLACE view user_messages_count as
	SELECT u.firstname, u.lastname, 
	SUM(m.from_user_id) as m_count
	FROM users as u
	JOIN messages as m ON u.id = m.from_user_id 
	GROUP BY m.from_user_id;
    
SELECT *, DENSE_RANK() OVER (ORDER BY m_count DESC) m_rank FROM user_messages_count;

# 3. Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления
# (created_at) и найдите разницу дат отправления между соседними сообщениями, получившегося
# списка. (используйте LEAD или LAG)

SELECT *, 
	TIMEDIFF(created_at, LAG(created_at, 1) OVER()) as prev_message_date_diff, 
	TIMEDIFF(LEAD(created_at, 1) OVER (), created_at) as next_message_date_diff
	FROM messages ORDER BY created_at;