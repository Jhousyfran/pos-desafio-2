variable "argocd_repo_url" {
  description = "Repositorio Git com os manifests das apps"
  type        = string
}

variable "apps" {
  description = "Lista de apps para deploy via ArgoCD"
  type = list(object({
    name        = string
    namespace   = string
    path        = string
    path_prefix = string
    port        = number
  }))
}

variable "argocd_project" {
  description = "Projeto do ArgoCD"
  type        = string
  default     = "default"
}

variable "target_revision" {
  description = "Branch/tag/commit para o ArgoCD"
  type        = string
  default     = "HEAD"
}

variable "apps_domain" {
  description = "Dominio completo para as apps"
  type        = string
}

variable "ingress_class_name" {
  description = "IngressClass usado pelas apps"
  type        = string
  default     = "nginx"
}
