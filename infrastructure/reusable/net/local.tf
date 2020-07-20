locals {
  is_any_public = length(var.public_subnets) > 0 ? true : false
}