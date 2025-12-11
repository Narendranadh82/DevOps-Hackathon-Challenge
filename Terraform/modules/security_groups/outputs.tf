output "eks_cluster_sg" { value = aws_security_group.eks_cluster.id }
output "eks_nodes_sg" { value = aws_security_group.eks_nodes.id }
