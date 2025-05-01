-- 0-uniq_users.sql
-- Creates the table 'users' with id, email (unique), and name columns.
-- The script does not fail if the table already exists.

CREATE TABLE IF NOT EXISTS users (
    id INT NOT NULL AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255),
    PRIMARY KEY (id)
);
