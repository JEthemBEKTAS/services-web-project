FROM php:8.0-apache

# 1.1 Installer wget et unzip pour récupérer WordPress
RUN apt-get update && apt-get install -y wget unzip \
    && rm -rf /var/lib/apt/lists/*

# 1.2  Installer et activer mysqli + pdo_mysql
RUN apt-get update \
 && apt-get install -y wget unzip default-mysql-client \
 && docker-php-ext-install mysqli pdo pdo_mysql \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

# 1.3 Télécharger et extraire WordPress
RUN wget https://wordpress.org/latest.zip \
    && unzip latest.zip \
    && mv wordpress/* . \
    && rmdir wordpress \
    && rm latest.zip

# 1.4 Copier la configuration personnalisée
COPY src/wp-config.php .

# 1.5 Fixer les permissions pour Apache
RUN chown -R www-data:www-data . \
    && find . -type d -exec chmod 755 {} \; \
    && find . -type f -exec chmod 644 {} \;

EXPOSE 80
CMD ["apache2-foreground"]
