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
  validation {
    condition     = length(var.public_subnet) == 2
    error_message = "Please give 2 public valid subnet CIDR"
  }
}

variable "database_subnet" {
  type = list(string)
  validation {
    condition     = length(var.database_subnet) == 2
    error_message = "Please give 2 database valid subnet CIDR"
  }
}

variable "private_subnet" {
  type = list(string)
  validation {
    condition     = length(var.private_subnet) == 2
    error_message = "Please give 2 private valid subnet CIDR"
  }
}

variable "acceptor_vpc_id" {
  type    = string
  default = ""
}
