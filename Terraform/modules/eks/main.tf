terraform {
  required_providers {
    aws = { source = "hashicorp/aws" }
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = "${var.env}-eks"
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.subnets

  # Create OIDC provider for IRSA
  create_oidc_provider = true

  # CloudWatch cluster control-plane logs
  enable_cluster_log_types = var.cluster_log_types
  cloudwatch_log_group_name = var.cluster_log_group_name

  # Managed node group example
  eks_managed_node_groups = {
    default = {
      name           = "${var.env}-node-group"
      desired_size   = var.node_desired
      min_size       = var.node_min
      max_size       = var.node_max
      instance_types = var.instance_types
      subnet_ids     = var.subnets
      additional_security_group_ids = var.additional_security_group_ids
    }
  }

  tags = merge(
    { "Environment" = var.env },
    var.tags
  )
}

# Output a few useful values
output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_oidc_issuer" {
  value = module.eks.cluster_oidc_issuer
}

output "node_role_arn" {
  value = module.eks.node_groups["default"].iam_role_arn
}
