variable "project"       { description = "Nom du projet (préfixes des ressources)" type = string }
variable "aws_region"    { description = "Région AWS" type = string }
variable "root_domain"   { description = "Domaine racine (Route53 si manage_route53=true)" type = string }
variable "app_domain"    { description = "FQDN de l'app (ex: prod.example.com)" type = string }
variable "eks_version"   { description = "Version EKS" type = string default = "1.30" }

# Réseau (tu peux garder ces defaults pour un petit VPC dev)
variable "vpc_cidr"        { description = "CIDR du VPC" type = string default = "10.0.0.0/16" }
variable "azs"             { description = "AZs" type = list(string) }
variable "private_subnets" { description = "Subnets privés" type = list(string) }
variable "public_subnets"  { description = "Subnets publics" type = list(string) }

# Node group (coût optimisé : 1 t3.small on-demand ; possibilité SPOT)
variable "node_desired"    { type = number default = 1 }
variable "node_min"        { type = number default = 1 }
variable "node_max"        { type = number default = 2 }
variable "instance_types"  { type = list(string) default = ["t3.small"] }
variable "capacity_type"   { type = string default = "ON_DEMAND" } # ou "SPOT"

# Gestion DNS/ACM
variable "manage_route53"  { description = "true si la zone DNS est dans Route53" type = bool default = true }
variable "create_acm"      { description = "true si on veut créer le certificat ACM" type = bool default = true }
variable "existing_acm_arn"{ description = "ARN ACM si on n'en crée pas" type = string default = "" }

# Budget mensuel
variable "enable_budget"   { description = "Activer un budget mensuel" type = bool default = true }
variable "budget_limit_usd"{ description = "Limite budget mensuelle en USD" type = string default = "20" } # petit plafond pour dev
variable "budget_emails"   { description = "Emails à notifier" type = list(string) }

# Tags
variable "tags" {
  description = "Tags communs"
  type = map(string)
  default = {}
}



variable "eks_cluster_name" {
  type        = string
  description = "Nom du cluster EKS (doit correspondre au module EKS de 19.4)"
}
