-- 10-div.sql
-- Creates a function SafeDiv that divides the first number by the second
-- or returns 0 if the second number is 0.
-- Takes a INT, b INT as input. Returns FLOAT or INT.

DELIMITER //

CREATE FUNCTION SafeDiv (a INT, b INT)
RETURNS FLOAT
DETERMINISTIC -- Indicates the function returns the same result for the same inputs
BEGIN
    IF b = 0 THEN
        RETURN 0;
    ELSE
        RETURN a / b;
    END IF;
END;

//

DELIMITER ;
