variable "name_prefix" {
  default     = "rjelinski"
  description = "name prefix for all resources"
}

variable "tags" {
  default     = {}
  description = "tags included to resources. name tag always present"
}

variable "subnet_ids" {
  description = "subnets to which lb will forward traffic"
  type        = list(string)
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "listeners" {
  description = "configuration of listener and attached target group"
  type = map(object({
    protocol    = string
    port        = string
    sg_protocol = string
    target = object({
      protocol = string
      port     = string
      health_check = object({
        interval = number
        path     = string
      })
    })
  }))
}