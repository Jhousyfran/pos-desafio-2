output "eks_subnet_public_1a_id" {
  description = "ID da sub-rede pública 1a para EKS"
  value       = aws_subnet.eks_subnet_public_1a.id

}

output "eks_subnet_public_1b_id" {
  description = "ID da sub-rede pública 1b para EKS"
  value       = aws_subnet.eks_subnet_public_1b.id

}
output "eks_subnet_private_1a_id" {
  description = "ID da sub-rede privada 1a para EKS"
  value       = aws_subnet.eks_subnet_private_1a.id

}

output "eks_subnet_private_1b_id" {
  description = "ID da sub-rede privada 1b para EKS"
  value       = aws_subnet.eks_subnet_private_1b.id

}
