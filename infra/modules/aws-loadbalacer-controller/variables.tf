variable "prefix" {
  description = "Prefix para nomear os recursos"
  type        = string
}

variable "project" {
  description = "Nome do projeto"
  type        = string
}

variable "tags" {
  description = "Tags para aplicar aos recursos"
  type        = map(string)
  default     = {}
}

variable "oidc" {
  description = "HTTPS URL  OIDC do cluster EKS"
  type        = string
}

variable "eks_cluster_name" {
  description = "Nome do cluster EKS"
  type        = string

}
