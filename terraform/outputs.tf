output "cluster_endpoint" {
  description = "URL d'accès à l'API du cluster EKS"
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "Données CA pour communiquer avec l'API du cluster"
  value       = module.eks.cluster_certificate_authority_data
}
