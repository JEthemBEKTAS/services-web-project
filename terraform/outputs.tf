output "aws_region" {
  value       = var.aws_region
  description = "Région du cluster"
}

output "cluster_name" {
  value       = module.eks.cluster_name
  description = "Nom du cluster EKS"
}

# ARN du certificat ACM à utiliser par l'Ingress ALB
output "acm_arn" {
  description = "ARN du certificat ACM pour l'Ingress"
  value = (
    var.create_acm && var.manage_route53
      ? aws_acm_certificate.app[0].arn
      : (var.existing_acm_arn != "" ? var.existing_acm_arn : null)
  )
}

# IAM Role pour le service account du AWS Load Balancer Controller (IRSA)
output "lbc_role_arn" {
  value       = module.alb_irsa.iam_role_arn
  description = "IAM Role ARN pour aws-load-balancer-controller (annotation IRSA)"
}

# Subnets/vpc utiles si besoin
output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "ID du VPC"
}

output "private_subnets" {
  value       = module.vpc.private_subnets
  description = "Subnets privés"
}

output "public_subnets" {
  value       = module.vpc.public_subnets
  description = "Subnets publics"
}
