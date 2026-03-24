variable "prefix" {
  description = "Prefix para nomear os recursos"
  type        = string
  default     = "terraform"
}

variable "environment" {
  description = "Ambiente onde os recursos serão criados"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Nome do projeto"
  type        = string
  default     = "eks-setup"
}

variable "aws_region" {
  description = "Região AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
  default     = "eks-cluster"
}

variable "cidr_block" {
  description = "Bloco CIDR para a VPC"
  type        = string
}


