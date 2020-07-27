variable "name_prefix" {
  default     = "rjelinski"
  description = "name prefix for all resources"
}

variable "tags" {
  default     = {}
  description = "tags included to resources. name tag always present"
}

variable "public_subnets" {
  default     = {}
  description = "public subnets"
  type = map(object({
    az_name    = string
    cidr_block = string
  }))
}

variable "private_subnets" {
  default     = {}
  description = "private subnets"
  type = map(object({
    az_name    = string
    cidr_block = string
  }))
}

variable "main_cidr_block" {
  default     = "10.0.0.0/16"
  description = "cidr block for entire vpc network"
}