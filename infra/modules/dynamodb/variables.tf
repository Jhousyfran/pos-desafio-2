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



variable "dynamodb_table" {
  description = "Configuração da tabela DynamoDB"
  type = object({
    name           = string
    billing_mode   = string
    read_capacity  = number
    write_capacity = number
    attribute_definitions = list(object({
      name = string
      type = string
    }))

  })
}

