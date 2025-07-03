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
define( 'AUTH_KEY',         'YeE]f 6PoD=yDve8]$g:FlK-Q/?fnI$0iUG]k.@C_S.EH *nbFlB.-z(6suuc|!R' );
define( 'SECURE_AUTH_KEY',  'PF!;tqI<>O7lUcjT=qcs/Raxy!p9j?:~n8 r7FiNN[c[&){X:ghm!C:}A] }PDwq' );
define( 'LOGGED_IN_KEY',    '?aTpiSl1_~=vgK!t@DfZTw+lWM+0rgPENU_GdV4=8o|!rxh}ivqH+M@@x`^Mv.MD' );
define( 'NONCE_KEY',        '5ZO{@[y;oar>N0-W>H(Dt?B5h0<0T-8h3<WdoLe5xo{XQSugD#D$q]ai[K^yhvBh' );
define( 'AUTH_SALT',        'z9c7Qnx=P8W~-#wvxz%&owqE+kKrAa~ --0`jj%^@wwYQbY^p-|+,*>.it5F(23R' );
define( 'SECURE_AUTH_SALT', '5irk9O3/AlJy#2fX~#-:,yv{Niinf3+bR0;svpZ2x({=mvYR;]<=~wFOh&L$d_J#' );
define( 'LOGGED_IN_SALT',   '[tq6deZ+z&N @+ #}I=6#L5l??@Z|Q@0$_l|c|qT4$AVQQL!mQXRKLPjcZes4U,L' );
define( 'NONCE_SALT',       'ZGD|3;oRvFDf?iuQ&2jw0]EBVOQ))mZh/ ||k*::gE&IiK5kxK3h]cIFq>]K55do' );

// Préfixe des tables
$table_prefix = 'wp_';

// Mode debug
define( 'WP_DEBUG', false );

// Chemin absolu vers WordPress
if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';
