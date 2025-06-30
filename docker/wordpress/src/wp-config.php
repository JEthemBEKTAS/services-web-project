<?php
/**
 * Configuration de base de WordPress pour Docker + Kubernetes
 */

// Réglages MySQL (injection via variables d'environnement Kubernetes)
define( 'DB_NAME',     getenv('WORDPRESS_DB_NAME')     ?: 'wordpress_db' );
define( 'DB_USER',     getenv('WORDPRESS_DB_USER')     ?: 'wp_user' );
define( 'DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD') ?: 'motdepasse_securise' );
define( 'DB_HOST',     getenv('WORDPRESS_DB_HOST')     ?: 'mariadb-service:3306' );
define( 'DB_CHARSET',  'utf8mb4' );
define( 'DB_COLLATE',  '' );

// Clés d'authentification uniques et salage
// Générez-les sur https://api.wordpress.org/secret-key/1.1/salt/
define( 'AUTH_KEY',         'mettez-ici-votre-clé-unique' );
define( 'SECURE_AUTH_KEY',  'mettez-ici-votre-clé-unique' );
define( 'LOGGED_IN_KEY',    'mettez-ici-votre-clé-unique' );
define( 'NONCE_KEY',        'mettez-ici-votre-clé-unique' );
define( 'AUTH_SALT',        'mettez-ici-votre-clé-unique' );
define( 'SECURE_AUTH_SALT', 'mettez-ici-votre-clé-unique' );
define( 'LOGGED_IN_SALT',   'mettez-ici-votre-clé-unique' );
define( 'NONCE_SALT',       'mettez-ici-votre-clé-unique' );

// Préfixe des tables
\$table_prefix = 'wp_';

// Mode debug
define( 'WP_DEBUG', false );

// Chemin absolu vers WordPress
if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';
