terraform {
  required_providers {
    aws = { source = "hashicorp/aws" }
  }
	
  # NOTE: backend is configured at init using -backend-config (see README)
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "../../modules/vpc"
  name   = "dev-vpc"
  cidr   = "10.10.0.0/16"

  azs             = [ "${var.region}a", "${var.region}b" ]
  public_subnets  = [ "10.10.1.0/24", "10.10.2.0/24" ]
  private_subnets = [ "10.10.3.0/24", "10.10.4.0/24" ]

  tags = { Environment = "dev" }
}

module "security" {
  source = "../../modules/security"
  env    = "dev"
  vpc_id = module.vpc.vpc_id
  tags   = { Environment = "dev" }
}

module "iam" {
  source = "../../modules/iam"

  name                   = "dev-example-role"
  assume_role_policy_json = data.aws_iam_policy_document.ec2_assume_role.json
  managed_policy_arns    = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]

  tags = { Environment = "dev" }
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
