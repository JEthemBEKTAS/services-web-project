CREATE DATABASE wordpress_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'wp_user'@'%' IDENTIFIED BY 'motdepasse_securise';
# Grant only the privileges required by WordPress for managing its tables
GRANT SELECT, INSERT, UPDATE, DELETE,
      CREATE, DROP, ALTER, INDEX,
      CREATE TEMPORARY TABLES
  ON wordpress_db.* TO 'wp_user'@'%';
FLUSH PRIVILEGES;
