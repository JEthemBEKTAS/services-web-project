#!/usr/bin/env bash
set -euo pipefail
umask 077

# Chemins figés (pas de DEST)
BASE="$HOME/project_unzip/services-web-project/Backup_locale"
SAVE="$BASE/save"

NS="${NS:-default}"
TS="$(date +%F_%H%M%S)"
RET_DAYS=7    # modifiable en éditant le script

# Récup infos DB depuis le Secret K8s créé par le chart
USER=$(kubectl get secret db-credentials -n "$NS" -o jsonpath='{.data.username}' | base64 -d)
PASS=$(kubectl get secret db-credentials -n "$NS" -o jsonpath='{.data.password}' | base64 -d)
DB=$(kubectl get secret db-credentials -n "$NS" -o jsonpath='{.data.database}' | base64 -d)

MDB=$(kubectl get pod -n "$NS" -l app=mariadb -o jsonpath='{.items[0].metadata.name}')

mkdir -p "$SAVE"
OUT="$SAVE/wpdb_${NS}_${TS}.sql.gz"
echo "[backup] dump -> $OUT"
kubectl exec -n "$NS" "$MDB" -- sh -lc "MYSQL_PWD='$PASS' mysqldump -h 127.0.0.1 -u'$USER' '$DB'" \
  | gzip -9 > "$OUT"

# Rétention
find "$SAVE" -type f -name "wpdb_${NS}_*.sql.gz" -mtime +${RET_DAYS} -delete || true
echo "[backup] OK"
