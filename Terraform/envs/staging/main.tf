terraform {
  required_providers {
    aws = { source = "hashicorp/aws" }
  }
  # backend will be configured during `terraform init -backend-config=...`
}

provider "aws" {
  region = var.region
}

# VPC (2 AZs)
module "vpc" {
  source = "../../modules/vpc"
  name   = "staging-vpc"
  cidr   = "10.20.0.0/16"

  azs             = ["${var.region}a", "${var.region}b"]
  public_subnets  = ["10.20.1.0/24", "10.20.2.0/24"]
  private_subnets = ["10.20.3.0/24", "10.20.4.0/24"]

  tags = { Environment = var.env }
}

# Security (SGs)
module "security" {
  source = "../../modules/security"
  env    = var.env
  vpc_id = module.vpc.vpc_id
  tags   = { Environment = var.env }
}

# Logging
module "logging" {
  source = "../../modules/logging"
  cluster_log_group_name = "/aws/eks/${var.env}/cluster"
  app_log_group_name     = "/${var.env}/app/logs"
  retention_in_days      = 30
}

# ECR
module "ecr" {
  source = "../../modules/ecr"
  env    = var.env
  name   = "app"
  tags   = { Environment = var.env }
}

# EKS
module "eks" {
  source = "../../modules/eks"
  env     = var.env
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.private_subnets

  cluster_log_group_name = module.logging.cluster_log_group
  cluster_log_types      = ["api","audit","authenticator","controllerManager","scheduler"]

  node_desired = 2
  node_min     = 1
  node_max     = 3
  instance_types = ["t3.large"]

  additional_security_group_ids = [
    module.security.eks_nodes_sg
  ]

  tags = { Environment = var.env }
}

output "ecr_url" { value = module.ecr.repository_url }
output "eks_endpoint" { value = module.eks.cluster_endpoint }
output "vpc_id" { value = module.vpc.vpc_id }
