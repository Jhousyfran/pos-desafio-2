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

variable "cache_config" {
  description = "Lista de caches a serem criados"
  type = list(object({
    name                 = string
    engine               = string
    engine_version       = string
    node_type            = string
    num_cache_nodes      = number
    parameter_group_name = string
    port                 = number
  }))

}

variable "subnet_ids" {
  description = "IDs das subnets privadas para o RDS"
  type        = list(string)

}

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR da VPC para liberar acesso ao Redis"
  type        = string
}
