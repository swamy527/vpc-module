variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "dns_host" {
  type    = bool
  default = true
}

variable "common_tags" {
  default = {}
}

variable "vpc_tags" {
  default = {}
}


variable "project_name" {

}

variable "environment" {

}

variable "gateway" {
  default = {}
}

variable "public_subnet" {
  type = list(string)
}

variable "database_subnet" {
  type = list(string)
}

variable "private_subnet" {
  type = list(string)
}
