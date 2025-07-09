variable "aws_region" {
  description = "Région AWS"
  type        = string
  default     = "eu-west-1"
}

variable "cluster_name" {
  description = "Nom du cluster EKS"
  type        = string
  default     = "services-web-cluster"
}

variable "cluster_version" {
  description = "Version Kubernetes du cluster"
  type        = string
  default     = "1.24"
}

variable "vpc_cidr" {
  description = "CIDR block du VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Liste des CIDR pour sous-réseaux publics"
  type        = list(string)
  default     = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "node_group_instance_type" {
  description = "Type d'instance pour les nodes"
  type        = string
  default     = "t2.micro"
}

variable "node_group_desired_capacity" {
  description = "Nombre de nœuds désiré"
  type        = number
  default     = 1
}
