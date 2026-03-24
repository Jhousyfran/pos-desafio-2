resource "aws_security_group_rule" "eks_cluster_inbound" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
  description       = "Allow inbound HTTPS traffic to EKS cluster"

  cidr_blocks = [
    "0.0.0.0/0"
  ]
}
