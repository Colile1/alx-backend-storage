-- 1-country_users.sql
-- Creates the table 'users' with id, email (unique), name,
-- and country (ENUM 'US', 'CO', 'TN', default 'US') columns.
-- The script does not fail if the table already exists.

CREATE TABLE IF NOT EXISTS users (
    id INT NOT NULL AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255),
    country ENUM('US', 'CO', 'TN') NOT NULL DEFAULT 'US',
    PRIMARY KEY (id)
);
