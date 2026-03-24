
variable "project" {
  description = "Nome do projeto"
  type        = string
}

variable "tags" {
  description = "Tags para aplicar aos recursos"
  type        = map(string)
  default     = {}
}


variable "eks_cluster_name" {
  description = "Nome do cluster EKS"
  type        = string

}

variable "oidc" {
  description = "OIDC issuer do cluster EKS"
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
