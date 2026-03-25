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

variable "dbs_config" {
  description = "Lista de bancos de dados a serem criados"
  type = list(object({
    name           = string
    engine         = string
    version        = string
    storage        = number
    instance_class = string
    username       = string
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
  description = "CIDR da VPC para liberar acesso ao RDS"
  type        = string
}
