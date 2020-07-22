variable "name_prefix" {
  default     = "rjelinski"
  description = "name prefix for all resources"
}

variable "tags" {
  default     = {}
  description = "tags included to resources. name tag always present"
}

variable "subnet_ids" {
  description = "subnets in which instances will be placed"
  type        = list(string)
}


variable "lb" {
  description = "load balancer info"
  type = object({
    name = string
    id   = string
  })
}

variable "target_groups" {
  description = "target groups to which ec2 will be attached"
  type = map(object({
    arn  = string
    id   = string
    name = string
  }))
}

variable "instance_type" {
  default     = "t2.micro"
  description = "ec2 instance type"
}

variable "autoscaling" {
  description = "autoscaling configuration"
  type = object({
    requests_count = number
    max_size       = number
    min_size       = number
  })
}

variable "app" {
  description = "app configuration"
  type = object({
    port             = number
    sg_protocol      = string
    user_data_base64 = string
  })
}

variable "vpc" {
  description = "vpc info"
  type = object({
    id         = string
    cidr_block = string
  })
}

variable "ami_id" {
  description = "ami used in ec2 instances"
  type        = string
}