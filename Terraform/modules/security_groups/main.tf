resource "aws_security_group" "eks_cluster" {
  name        = "${var.env}-eks-cluster-sg"
  vpc_id      = var.vpc_id
  description = "EKS Control Plane SG"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "eks_nodes" {
  name        = "${var.env}-eks-nodes-sg"
  vpc_id      = var.vpc_id
  description = "EKS Worker Nodes SG"

  ingress {
    description = "Allow node-to-node"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

}
