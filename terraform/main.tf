locals {
  name = var.project
  tags = merge(
    {
      Project     = var.project
      ManagedBy   = "Terraform"
      Environment = "dev"
    },
    var.tags
  )
}

provider "aws" {
  region = var.aws_region
}

# --- (Optionnel) Providers k8s/helm si on voulait post-config (ici on laisse la CI Helm prendre le relai) ---
# provider "kubernetes" { host = "https://example" } # non utilisé ici
# provider "helm" { kubernetes { host = "https://example" } } # non utilisé ici

# -----------------------
# 1) Réseau VPC minimal
# -----------------------
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.5"

  name = "${local.name}-vpc"
  cidr = var.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.tags
}

# -----------------------
# 2) EKS (coût optimisé)
# -----------------------
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.8"

  cluster_name    = "${local.name}-eks"
  cluster_version = var.eks_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      name           = "default"
      min_size       = var.node_min
      max_size       = var.node_max
      desired_size   = var.node_desired
      instance_types = var.instance_types
      capacity_type  = var.capacity_type # ON_DEMAND ou SPOT
      disk_size      = 20                # petit disque gp3
    }
  }

  tags = local.tags
}

# ------------------------------------------------
# 3) IAM Role pour AWS Load Balancer Controller
# ------------------------------------------------
module "alb_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.39"

  role_name = "${local.name}-alb-lbc"

  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }

  tags = local.tags
}

# ------------------------------------------------
# 4) ACM Public certificate pour app_domain
# ------------------------------------------------
# Si on choisit de laisser Terraform gérer le cert ET que l’on possède la zone Route53
resource "aws_acm_certificate" "app" {
  count             = var.create_acm && var.manage_route53 ? 1 : 0
  domain_name       = var.app_domain
  validation_method = "DNS"
  tags              = local.tags
  lifecycle { create_before_destroy = true }
}

data "aws_route53_zone" "main" {
  count        = var.create_acm && var.manage_route53 ? 1 : 0
  name         = var.root_domain
  private_zone = false
}

resource "aws_route53_record" "app_cert_validation" {
  count   = var.create_acm && var.manage_route53 ? length(aws_acm_certificate.app[0].domain_validation_options) : 0
  zone_id = data.aws_route53_zone.main[0].zone_id

  name    = aws_acm_certificate.app[0].domain_validation_options[count.index].resource_record_name
  type    = aws_acm_certificate.app[0].domain_validation_options[count.index].resource_record_type
  records = [aws_acm_certificate.app[0].domain_validation_options[count.index].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "app" {
  count = var.create_acm && var.manage_route53 ? 1 : 0
  certificate_arn         = aws_acm_certificate.app[0].arn
  validation_record_fqdns = [for r in aws_route53_record.app_cert_validation : r.fqdn]
}

# Cas DNS externe (zone non-Route53) :
# - Soit on laisse Terraform *créer le cert* (count=1 sur aws_acm_certificate) mais on ne peut pas poser la CNAME automatiquement :
#   tu devras poser manuellement le CNAME de validation.
# - Soit on ne crée PAS de cert ici (create_acm=false) et tu fournis existing_acm_arn (cert déjà validé côté console).

# ------------------------------------------------
# 5) Budget AWS (contrôle coûts)
# ------------------------------------------------
resource "aws_budgets_budget" "monthly_cost" {
  count       = var.enable_budget ? 1 : 0
  name        = "${local.name}-monthly-cost"
  budget_type = "COST"

  time_unit   = "MONTHLY"
  limit_amount = var.budget_limit_usd
  limit_unit   = "USD"

  cost_types {
    include_credit             = true
    include_discount           = true
    include_other_subscription = true
    include_recurring          = true
    include_refund             = true
    include_subscription       = true
    include_support            = true
    include_tax                = true
    include_upfront            = true
    use_amortized              = false
    use_blended                = false
  }

  # Alerte PREVISIONNELLE 80%
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = var.budget_emails
  }

  # Alerte REELLE 100%
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = var.budget_emails
  }

  tags = local.tags
}
