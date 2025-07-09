provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "subnet" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.subnet[*].id

  eks_managed_node_groups = {
    workers = {
      desired_capacity = var.node_group_desired_capacity
      instance_types   = [var.node_group_instance_type]
      subnet_ids       = aws_subnet.subnet[*].id
    }
  }
}
