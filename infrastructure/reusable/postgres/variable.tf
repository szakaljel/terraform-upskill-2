variable "name_prefix" {
  default     = "rjelinski"
  description = "name prefix for all resources"
}

variable "tags" {
  default     = {}
  description = "tags included to resources. name tag always present"
}

variable "vpc" {
  description = "vpc related values"
  type = object({
    id         = string
    cidr_block = string
  })
}

variable "subnet_ids" {
  description = "subnets in which rds will reside"
  type        = list(string)
}

variable "db" {
  description = "database user info and db name"
  type = object({
    name     = string
    username = string
    password = string
  })
}

variable "db_instance" {
  default = {
    instance_type     = "db.t2.micro"
    engine_version    = "10.13"
    allocated_storage = 10
    storage_type      = "standard"
  }
  description = "specification of db instance and engine"
  type = object({
    instance_type     = string
    engine_version    = string
    allocated_storage = number
    storage_type      = string
  })
}