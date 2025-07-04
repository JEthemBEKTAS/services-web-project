#!/usr/bin/env bash
set -euo pipefail

# Génère 8 clés aléatoires pour WordPress salts
SALTS=(
  AUTH_KEY
  SECURE_AUTH_KEY
  LOGGED_IN_KEY
  NONCE_KEY
  AUTH_SALT
  SECURE_AUTH_SALT
  LOGGED_IN_SALT
  NONCE_SALT
)

# Crée le YAML du Secret
echo "apiVersion: v1
kind: Secret
metadata:
  name: wordpress-salts
type: Opaque
stringData:" > k8s/wordpress-salts.yaml

for KEY in \"\${SALTS[@]}\"; do
  VAL=\$(openssl rand -base64 32)
  echo \"  \$KEY: '\$VAL'\" >> k8s/wordpress-salts.yaml
done

# Applique directement dans k8s
kubectl apply -f k8s/wordpress-salts.yaml
