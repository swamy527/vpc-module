variable "cidr_block" {
  default = "172.30.0.0/16"
}

variable "project" {

}

variable "environment" {

}

variable "public_cidr" {
  type = list(string)
  validation {
    condition     = length(var.public_cidr) == 2
    error_message = "please give two public valid cidr"
  }
}

variable "private_cidr" {
  type = list(string)
  validation {
    condition     = length(var.private_cidr) == 2
    error_message = "please give two private valid cidr"
  }
}

variable "database_cidr" {
  type = list(string)
  validation {
    condition     = length(var.database_cidr) == 2
    error_message = "please give two databse valid cidr"
  }
}

variable "peering_required" {
  type    = bool
  default = false
}

variable "vpc_acceptor_id" {
  default = ""
}
