bucket         = "your-unique-bucket-name"    # from bootstrap output
key            = "envs/dev/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform-state-locks"      # from bootstrap output
encrypt        = true