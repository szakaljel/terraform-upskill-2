locals {
  is_any_public  = length(var.public_subnets) > 0 ? true : false
  is_any_private = length(var.private_subnets) > 0 ? true : false
}