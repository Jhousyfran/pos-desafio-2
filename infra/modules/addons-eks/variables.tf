
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
