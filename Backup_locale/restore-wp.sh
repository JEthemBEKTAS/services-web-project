#!/usr/bin/env bash
set -euo pipefail

BASE="$HOME/project_unzip/services-web-project/Backup_locale"
SAVE="$BASE/save"

NS="${NS:-default}"
FILE="${1:-}"

if [ -z "$FILE" ]; then
  FILE="$(ls -1t "$SAVE"/wpdb_${NS}_*.sql.gz 2>/dev/null | head -n1 || true)"
fi
[ -f "$FILE" ] || { echo "usage: $0 /chemin/vers/dump.sql.gz (ou rien pour le plus récent)"; exit 1; }

USER=$(kubectl get secret db-credentials -n "$NS" -o jsonpath='{.data.username}' | base64 -d)
PASS=$(kubectl get secret db-credentials -n "$NS" -o jsonpath='{.data.wp-password}' | base64 -d)
DB=$(kubectl get secret db-credentials -n "$NS" -o jsonpath='{.data.database}' | base64 -d)
MDB=$(kubectl get pod -n "$NS" -l app=mariadb -o jsonpath='{.items[0].metadata.name}')

echo "[restore] $FILE -> DB=$DB (ns=$NS)"
gzip -dc "$FILE" | kubectl exec -n "$NS" -i "$MDB" -- sh -lc "MYSQL_PWD='$PASS' mysql -h 127.0.0.1 -u'$USER' '$DB'"
echo "[restore] Terminé"
