data "aws_availability_zones" "region_zones" {
  state = "available"
  filter {
    name   = "group-name"
    values = [var.region]
  }
}

module "network" {
  source = "../../../modules/network"

  name_prefix = var.name_prefix
  public_subnets = {
    "eu-west-3a" = {
      az_name    = data.aws_availability_zones.region_zones.names[0]
      cidr_block = cidrsubnet(var.main_cidr_block, 8, 1)
    }
    "eu-west-3b" = {
      az_name    = data.aws_availability_zones.region_zones.names[1]
      cidr_block = cidrsubnet(var.main_cidr_block, 8, 2)
    }
  }
  private_subnets = {
    "eu-west-3a" = {
      az_name    = data.aws_availability_zones.region_zones.names[0]
      cidr_block = cidrsubnet(var.main_cidr_block, 8, 3)
    }
    "eu-west-3b" = {
      az_name    = data.aws_availability_zones.region_zones.names[1]
      cidr_block = cidrsubnet(var.main_cidr_block, 8, 4)
    }
  }
  tags = var.tags
}

module "postgres" {
  source = "../../../modules/postgres"

  name_prefix = var.name_prefix
  subnet_ids  = [for key, subnet in module.network.private_subnets : subnet.id]
  db = {
    name     = var.db.name
    username = var.db.username
    password = var.db.password
  }

  vpc = {
    id         = module.network.vpc.id,
    cidr_block = module.network.vpc.cidr_block
  }

  tags = var.tags
}

module "lb" {
  source = "../../../modules/lb"

  name_prefix = var.name_prefix
  tags        = var.tags
  listeners = {
    "http" : {
      protocol    = "HTTP"
      sg_protocol = "tcp"
      port        = 80
      target = {
        protocol = "HTTP"
        port     = 5555
        health_check = {
          interval = 30
          path     = "/health"
        }
      }
    }
  }
  subnet_ids = [for key, subnet in module.network.public_subnets : subnet.id]
  vpc_id     = module.network.vpc.id
}

