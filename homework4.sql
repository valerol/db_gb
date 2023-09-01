/* Подсчитать общее количество лайков, которые получили пользователи младше 12 лет. */
SELECT COUNT(*) FROM likes as l 
	LEFT JOIN profiles p ON l.user_id = p.user_id 
    WHERE DATEDIFF(CURDATE(), p.birthday) < 12 * 365;

/* Определить кто больше поставил лайков (всего): мужчины или женщины. */
SELECT COUNT(*) INTO @f FROM likes as l 
	LEFT JOIN profiles p ON l.user_id = p.user_id WHERE p.gender = 'f';
SELECT COUNT(*) INTO @m FROM likes as l 
	LEFT JOIN profiles p ON l.user_id = p.user_id WHERE p.gender = 'm';
SELECT CASE
	WHEN @m > @f THEN 'men'
    WHEN @m < @f THEN 'women'
    ELSE 'equal'
END as 'who likes more';

# Или (короче, но не учитывает возможность равенства) #
SELECT gender as greater_liker FROM (
	SELECT COUNT(*) as count, p.gender 
		FROM likes as l 
        LEFT JOIN profiles p ON l.user_id = p.user_id 
        GROUP BY p.gender 
        ORDER BY count DESC LIMIT 1
	) as CG;

# Вывести всех пользователей, которые не отправляли сообщения.
SELECT u.* FROM users u LEFT JOIN messages m ON u.id = m.from_user_id WHERE m.id IS NULL;

# Пусть задан некоторый пользователь. Из всех друзей этого пользователя 
# найдите человека, который больше всех написал ему сообщений.
SELECT u.id INTO @user_id FROM friend_requests fr LEFT JOIN users u ON u.id = fr.target_user_id ORDER BY RAND() LIMIT 1;
SELECT CF.from_user_id FROM (
	SELECT COUNT(*) as count, from_user_id FROM messages WHERE to_user_id = @user_id AND from_user_id IN (
		SELECT initiator_user_id FROM friend_requests WHERE target_user_id = @user_id
	) GROUP BY from_user_id ORDER BY count DESC LIMIT 1
) AS CF;