data "aws_availability_zones" "region_zones" {
  state = "available"
  filter {
    name   = "group-name"
    values = [var.region]
  }
}

module "network" {
  source = "../../../modules/network"

  name_prefix     = var.name_prefix
  main_cidr_block = var.main_cidr_block
  public_subnets = {
    "eu-west-3a" = {
      az_name    = data.aws_availability_zones.region_zones.names[0]
      cidr_block = cidrsubnet(var.main_cidr_block, 8, 1)
    }
  }
}