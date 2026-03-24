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

variable "eks_cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
}

variable "private_subnet_1a_id" {
  description = "ID da sub-rede privada na zona de disponibilidade 1a"
  type        = string

}

variable "private_subnet_1b_id" {
  description = "ID da sub-rede privada na zona de disponibilidade 1b"
  type        = string

}
