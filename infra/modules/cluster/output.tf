output "eks_vpc_config" {
  description = "Configuração VPC do cluster EKS"
  value       = aws_eks_cluster.eks_cluster.vpc_config

}

output "oidc" {
  value = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

output "eks_cluster_name" {
  description = "Nome do cluster EKS"
  value       = aws_eks_cluster.eks_cluster.id

}

output "eks_cluster_endpoint" {
  description = "Endpoint do cluster EKS"
  value       = aws_eks_cluster.eks_cluster.endpoint

}

output "eks_certificate_authority" {
  description = "Dados da autoridade certificadora do cluster EKS"
  value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data

}
