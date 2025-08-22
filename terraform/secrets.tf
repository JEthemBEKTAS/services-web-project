variable "project" { type = string }
variable "region"  { type = string }

# Mots de passe aléatoires
resource "random_password" "db_root" { length = 24 special = true }
resource "random_password" "db_app"  { length = 24 special = true }

# ---- Secret 1 : DB (JSON)
resource "aws_secretsmanager_secret" "app_db" {
  name        = "/${var.project}/app/db"
  description = "DB credentials for ${var.project}"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "app_db_v" {
  secret_id     = aws_secretsmanager_secret.app_db.id
  secret_string = jsonencode({
    username     = "wp_user"
    database     = "wordpress"
    root-password= random_password.db_root.result
    wp-password  = random_password.db_app.result
  })
}

# ---- Salts aléatoires
locals {
  salt_keys = [
    "AUTH_KEY","SECURE_AUTH_KEY","LOGGED_IN_KEY","NONCE_KEY",
    "AUTH_SALT","SECURE_AUTH_SALT","LOGGED_IN_SALT","NONCE_SALT"
  ]
}
resource "random_password" "salt" {
  for_each = toset(local.salt_keys)
  length   = 64
  special  = true
}

# ---- Secret 2 : SALTS (JSON)
resource "aws_secretsmanager_secret" "app_salts" {
  name        = "/${var.project}/app/salts"
  description = "WordPress salts for ${var.project}"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "app_salts_v" {
  secret_id     = aws_secretsmanager_secret.app_salts.id
  secret_string = jsonencode({
    for k, v in random_password.salt : k => v.result
  })
}

# Expose ARNs pour la policy IRSA
output "secret_arn_db"    { value = aws_secretsmanager_secret.app_db.arn }
output "secret_arn_salts" { value = aws_secretsmanager_secret.app_salts.arn }
