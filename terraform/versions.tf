terraform {
  required_version = ">= 1.5.0"

  backend "s3" {} # Les paramètres (bucket, key, table, region) sont passés via `terraform init -backend-config=...`

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.29"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13"
    }
  }
}
