# Additional Requirements 

USE GymManagement; 

# Queries with GROUP BY and HAVING 
# 1. How many instructors in each city (only display the cities that have at least two instructor)? 

SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', '')); 

SELECT COUNT(i.Instructor_ID), i.City 
FROM Instructors i 
GROUP BY i.City
HAVING COUNT(i.Instructor_ID) > 1
ORDER BY COUNT(i.Instructor_ID) DESC; 

# 2. How many males and females joined the gym after 2015  (only display if more than 3 members have joined in this period)?

SELECT COUNT(m.Member_ID), m.Gender
FROM Members m 
WHERE m.Joining_Date > '2015-01-01'
GROUP BY m.Gender
HAVING COUNT(m.Member_ID) > 3;  

# Create a STORED PROCEDURE 

# 1. Update Users table if a user has update their password  

DELIMITER // 
CREATE PROCEDURE UpdatePwd
(IN id_of_user INT, 
IN user_password VARCHAR(25))
BEGIN 
    UPDATE Users
    SET `Password` = user_password
    WHERE User_ID = id_of_user;
END //
DELIMITER ; 

CALL UpdatePwd(109, 'abcdefghi'); 
    
SELECT *
FROM Users; 

# Create a TRIGGER 

# 1. When updating user's password, if the NEW password is null or empty string then update it back to the OLD password

DROP TRIGGER IF EXISTS UpdatePwdTrigger; 

DELIMITER // 
CREATE TRIGGER UpdatePwdTrigger
BEFORE UPDATE 
ON Users
FOR EACH ROW 
BEGIN 
	IF (NEW.`Password` IS NULL OR NEW.`Password` = '') THEN 
		SET NEW.`Password` = OLD.`Password`; 
    ELSE 
		SET NEW.`Password` = `Password`(NEW.`Password`); 
	END IF; 
END // 
DELIMITER ; 

UPDATE Users 
SET `Password` = ''
WHERE User_ID = 109; 

SELECT * 
FROM Users; 
