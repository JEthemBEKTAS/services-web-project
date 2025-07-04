FROM php:8.0-apache

RUN apt-get update && apt-get install -y wget unzip default-mysql-client \
 && docker-php-ext-install mysqli pdo_mysql \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html
RUN wget https://wordpress.org/latest.zip \
 && unzip latest.zip \
 && mv wordpress/* . \
 && rm -rf latest.zip wordpress \
 && chown -R www-data:www-data . \
 && find . -type d -exec chmod 755 {} \; \
 && find . -type f -exec chmod 644 {} \;

COPY src/wp-config.php .

EXPOSE 80
