provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
}

data "aws_availability_zones" "available" {}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "services-web-cluster"
  cluster_version = "1.24"
  vpc_id          = aws_vpc.main.id
  subnets         = aws_subnet.subnet[*].id

  node_groups = {
    workers = {
      desired_capacity = 2
      instance_type    = "t3.medium"
    }
  }
}
