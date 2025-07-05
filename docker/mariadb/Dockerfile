FROM mariadb:10.5

# 1. Copier le template et exposer le port
COPY init/init.sql.tpl /docker-entrypoint-initdb.d/init.sql.tpl
COPY entrypoint/docker-entrypoint.sh /usr/local/bin/docker-entrypoint-init.sh
EXPOSE 3306

# 2. Installer gettext-base (pour envsubst) et générer init.sql
RUN apt-get update \
 && apt-get install -y --no-install-recommends gettext-base \
 && rm -rf /var/lib/apt/lists/*

# 3. Définir notre nouveau point d'entrée
ENTRYPOINT ["/usr/local/bin/docker-entrypoint-init.sh"]
CMD ["mysqld"]
