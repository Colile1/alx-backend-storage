-- 5-valid_email.sql
-- Creates a trigger that resets the 'valid_email' attribute to 0
-- only when the 'email' attribute has been changed.

DELIMITER //

CREATE TRIGGER reset_valid_email
BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    -- Check if the email column is being updated to a new value
    IF OLD.email <> NEW.email THEN
        -- Reset valid_email to 0 (false)
        SET NEW.valid_email = 0;
    END IF;
END;

//

DELIMITER ;
