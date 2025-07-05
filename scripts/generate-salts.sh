#!/usr/bin/env bash
set -euo pipefail

# Génère un Secret wordpress-salts avec des SALT aléatoires
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: wordpress-salts
type: Opaque
stringData:
  AUTH_KEY:         "$(openssl rand -base64 32)"
  SECURE_AUTH_KEY:  "$(openssl rand -base64 32)"
  LOGGED_IN_KEY:    "$(openssl rand -base64 32)"
  NONCE_KEY:        "$(openssl rand -base64 32)"
  AUTH_SALT:        "$(openssl rand -base64 32)"
  SECURE_AUTH_SALT: "$(openssl rand -base64 32)"
  LOGGED_IN_SALT:   "$(openssl rand -base64 32)"
  NONCE_SALT:       "$(openssl rand -base64 32)"
EOF
