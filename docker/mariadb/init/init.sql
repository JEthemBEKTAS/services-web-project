-- Création de la base et de l’utilisateur avec droits limités
CREATE DATABASE wordpress_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'wp_user'@'%' IDENTIFIED BY 'motdepasse_securise';

-- Privilèges nécessaires à WordPress (pas de DROP DATABASE global)
GRANT 
  SELECT, INSERT, UPDATE, DELETE,
  CREATE, DROP, ALTER, INDEX,
  CREATE TEMPORARY TABLES
ON wordpress_db.* TO 'wp_user'@'%';

FLUSH PRIVILEGES;
