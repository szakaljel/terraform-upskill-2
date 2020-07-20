variable "name_prefix" {
  default     = "rjelinski"
  description = "name prefix for all resources"
}

variable "tags" {
  default     = {}
  description = "tags included to resources. name tag always present"
}

variable "region" {
  default     = "eu-west-3"
  description = "aws region"
}

variable "ami_id" {
  description = "ami used in ec2 instances"
  type        = string
}

variable "db" {
  description = "database user info and db name"
  type = object({
    name     = string
    username = string
    password = string
  })
}