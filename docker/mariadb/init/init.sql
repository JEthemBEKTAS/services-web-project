CREATE DATABASE wordpress_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'wp_user'@'%' IDENTIFIED BY 'motdepasse_securise';
GRANT SELECT, INSERT, UPDATE, EXECUTE ON wordpress_db.* TO 'wp_user'@'%';
FLUSH PRIVILEGES;
