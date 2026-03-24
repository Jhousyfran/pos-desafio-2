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

variable "public_subnet_1a_id" {
  description = "ID da sub-rede pública na zona de disponibilidade 1a"
  type        = string

}

variable "public_subnet_1b_id" {
  description = "ID da sub-rede pública na zona de disponibilidade 1b"
  type        = string

}


