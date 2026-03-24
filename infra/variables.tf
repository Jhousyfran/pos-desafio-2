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

variable "route53_zone_id" {
  description = "Hosted Zone ID do Route53 para o dominio do ArgoCD"
  type        = string
}

variable "argocd_domain" {
  description = "Dominio completo para o ArgoCD (ex: argocd.exemplo.com)"
  type        = string
}

variable "apps_domain" {
  description = "Dominio completo para as apps (ex: desafio.exemplo.com)"
  type        = string
}

variable "argocd_server_addr" {
  description = "Endereco do ArgoCD (ex: https://argocd.exemplo.com)"
  type        = string
}

variable "argocd_auth_token" {
  description = "Token de autenticacao para o provider do ArgoCD"
  type        = string
  sensitive   = true
}

variable "argocd_insecure" {
  description = "Permitir TLS inseguro no provider do ArgoCD"
  type        = bool
  default     = true
}

variable "argocd_repo_url" {
  description = "Repositorio Git com os manifests das apps"
  type        = string
}
