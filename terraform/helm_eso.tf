#############################################
# terraform/helm_eso.tf
#############################################

# Récupérer infos du cluster EKS (module/outputs existants côté 19.4)
data "aws_eks_cluster" "this" {
  name = var.eks_cluster_name
}
data "aws_eks_cluster_auth" "this" {
  name = var.eks_cluster_name
}

# Provider Helm relié au cluster
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

# Namespace cible
resource "kubernetes_namespace" "external_secrets" {
  metadata { name = "external-secrets" }
}

# Release Helm External Secrets Operator
resource "helm_release" "external_secrets" {
  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  # ✅ Fige une version stable (à ajuster si besoin)
  version          = "0.9.17"
  namespace        = kubernetes_namespace.external_secrets.metadata[0].name
  create_namespace = false

  # Valeurs du chart (YAML encodé)
  values = [
    yamlencode({
      installCRDs   = true
      serviceAccount = {
        create = true
        name   = "eso"
        annotations = {
          # Annotation IRSA — rôle créé dans terraform/iam_eso.tf
          "eks.amazonaws.com/role-arn" = aws_iam_role.eso_irsa_role.arn
        }
      }
      # Comportement recommandé en prod : un seul réplica suffit pour ce projet
      replicaCount = 1
    })
  ]

  depends_on = [
    aws_iam_role.eso_irsa_role,              # IRSA prêt
    aws_iam_role_policy_attachment.eso_attach
  ]
}
