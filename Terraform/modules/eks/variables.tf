variable "env" {}

variable "cluster_version" {
  default = "1.30"
}

variable "vpc_id" {}
variable "subnets" { type = list(string) }

variable "cluster_log_types" {
  type = list(string)
  default = ["api","audit","authenticator","controllerManager","scheduler"]
}

variable "cluster_log_group_name" {
  default = "/aws/eks/cluster"
}

variable "node_desired" { default = 2 }
variable "node_min"     { default = 1 }
variable "node_max"     { default = 3 }
variable "instance_types" {
  type = list(string)
  default = ["t3.medium"]
}

variable "additional_security_group_ids" {
  type = list(string)
  default = []
}

variable "tags" {
  type = map(string)
  default = {}
}
