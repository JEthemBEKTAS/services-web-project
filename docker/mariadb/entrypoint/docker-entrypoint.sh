#!/usr/bin/env bash
set -euo pipefail

log() { echo "[entrypoint] $*"; }

# Variables attendues (provenant du Secret via env du Pod)
: "${MYSQL_DATABASE:?}"
: "${MYSQL_WP_USER:?}"
: "${MYSQL_WP_PASSWORD:?}"

# 1) Génération du SQL AU PREMIER BOOT (dossier vide = init)
if [ ! -d /var/lib/mysql/mysql ]; then
  log "Premier boot → génération 99-init-wp.sql"
  envsubst < /docker-entrypoint-initdb.d/init.sql.tpl > /docker-entrypoint-initdb.d/99-init-wp.sql

  # Très important: lisible par l'utilisateur mysql (mariadb docker exécute le init en 'mysql')
  chown mysql:mysql /docker-entrypoint-initdb.d/99-init-wp.sql
  chmod 0640        /docker-entrypoint-initdb.d/99-init-wp.sql
else
  log "Données déjà présentes, pas de (re)génération SQL"
fi

# 2) Chaîner sur l'entrypoint officiel
exec /usr/local/bin/docker-entrypoint.sh "$@"
