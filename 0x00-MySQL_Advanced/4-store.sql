-- 4-store.sql
-- Creates a trigger that decreases the quantity of an item
-- in the 'items' table after adding a new order to the 'orders' table.

DELIMITER //

CREATE TRIGGER decrease_item_quantity
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    -- Update the quantity in the items table for the ordered item
    UPDATE items
    SET quantity = quantity - NEW.number
    WHERE name = NEW.item_name;
END;

//

DELIMITER ;
