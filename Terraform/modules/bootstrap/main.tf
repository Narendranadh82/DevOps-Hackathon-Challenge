# bootstrap/main.tf
terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = { source = "hashicorp/aws" }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "tf_state" {
  bucket = var.state_bucket_name

  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    id      = "prevent-delete"
    enabled = true
    abort_incomplete_multipart_upload_days = 7

    noncurrent_version_expiration {
      days = 90
    }
  }

  tags = {
    Name        = var.state_bucket_name
    Environment = "bootstrap"
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.tf_state.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "tf_locks" {
  name         = var.lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Environment = "bootstrap"
  }
}

output "bucket" {
  value = aws_s3_bucket.tf_state.bucket
}

output "dynamo_table" {
  value = aws_dynamodb_table.tf_locks.name
}
