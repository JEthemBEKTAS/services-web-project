#!/usr/bin/env sh
set -e

# Si le template existe, générer init.sql
if [ -f /docker-entrypoint-initdb.d/init.sql.tpl ]; then
  envsubst '${MYSQL_ROOT_PASSWORD}' \
    < /docker-entrypoint-initdb.d/init.sql.tpl \
    > /docker-entrypoint-initdb.d/init.sql
fi

# Appeler l’entrypoint original
exec docker-entrypoint.sh "$@"
