variable "region" {
  type    = string
  default = "us-east-1"
}

variable "state_bucket_name" {
  description = "Unique S3 bucket name for terraform state (must be globally unique)"
  type        = string
}

variable "lock_table_name" {
  description = "DynamoDB table name for terraform locking"
  type        = string
  default     = "terraform-state-locks"
}
