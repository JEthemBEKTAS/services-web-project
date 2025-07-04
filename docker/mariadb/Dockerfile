FROM mariadb:10.5

# 1. Copier le template et exposer le port
COPY init/init.sql.tpl /docker-entrypoint-initdb.d/init.sql.tpl
EXPOSE 3306

# 2. Installer gettext-base (pour envsubst) et générer init.sql
RUN apt-get update && apt-get install -y gettext-base \
 && envsubst '${MYSQL_ROOT_PASSWORD}' \
    < /docker-entrypoint-initdb.d/init.sql.tpl \
    > /docker-entrypoint-initdb.d/init.sql \
 && rm /docker-entrypoint-initdb.d/init.sql.tpl
