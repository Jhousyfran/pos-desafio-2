variable "prefix" {
  description = "Prefix para nomear os recursos"
  type        = string
}

variable "project" {
  description = "Nome do projeto"
  type        = string
}

variable "cidr_block" {
  description = "Bloco CIDR para a VPC"
  type        = string
}

variable "tags" {
  description = "Tags para aplicar aos recursos"
  type        = map(string)
  default     = {}
}


