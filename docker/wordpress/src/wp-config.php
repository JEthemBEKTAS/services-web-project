<?php
/**
 * Configuration de base de WordPress pour Docker + Kubernetes
 */

// Réglages MySQL (injection via variables d'environnement Kubernetes)
define( 'DB_NAME',     getenv('WORDPRESS_DB_NAME')     ?: 'wordpress_db' );
define( 'DB_USER',     getenv('WORDPRESS_DB_USER'));
define( 'DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD'));
define( 'DB_HOST',     getenv('WORDPRESS_DB_HOST')     ?: 'mariadb-service:3306' );
define( 'DB_CHARSET',  'utf8mb4' );
define( 'DB_COLLATE',  '' );

// Clés d'authentification uniques et salage
// Générez-les sur https://api.wordpress.org/secret-key/1.1/salt/
// SALT WordPress injectées par Kubernetes via env
define( 'AUTH_KEY',         getenv('AUTH_KEY') );
define( 'SECURE_AUTH_KEY',  getenv('SECURE_AUTH_KEY') );
define( 'LOGGED_IN_KEY',    getenv('LOGGED_IN_KEY') );
define( 'NONCE_KEY',        getenv('NONCE_KEY') );
define( 'AUTH_SALT',        getenv('AUTH_SALT') );
define( 'SECURE_AUTH_SALT', getenv('SECURE_AUTH_SALT') );
define( 'LOGGED_IN_SALT',   getenv('LOGGED_IN_SALT') );
define( 'NONCE_SALT',       getenv('NONCE_SALT') );

// Préfixe des tables
$table_prefix = 'wp_';

// Mode debug
define( 'WP_DEBUG', false );

// Chemin absolu vers WordPress
if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';
