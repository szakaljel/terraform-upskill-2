module "net" {
  source = "../../reusable/net"

  name_prefix = var.name_prefix
  public_subnets = {
    "eu-west-3a" = {
      az_name    = "eu-west-3a"
      cidr_block = "10.0.1.0/24"
    }
    "eu-west-3b" = {
      az_name    = "eu-west-3b"
      cidr_block = "10.0.2.0/24"
    }
  }
  private_subnets = {
    "eu-west-3a" = {
      az_name    = "eu-west-3a"
      cidr_block = "10.0.3.0/24"
    }
    "eu-west-3b" = {
      az_name    = "eu-west-3b"
      cidr_block = "10.0.4.0/24"
    }
  }
  tags = var.tags
}

module "postgres" {
  source = "../../reusable/postgres"

  name_prefix = var.name_prefix
  subnet_ids  = [for key, subnet in module.net.private_subnets : subnet.id]
  db = {
    name     = var.db.name
    username = var.db.username
    password = var.db.password
  }

  vpc = {
    id         = module.net.vpc.id,
    cidr_block = module.net.vpc.cidr_block
  }

  tags = var.tags
}

module "lb" {
  source = "../../reusable/lb"

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
  subnet_ids = [for key, subnet in module.net.public_subnets : subnet.id]
  vpc_id     = module.net.vpc.id
}

module "app" {
  source = "../../reusable/autoscaling_app"

  name_prefix   = var.name_prefix
  tags          = var.tags
  subnet_ids    = [for key, subnet in module.net.public_subnets : subnet.id]
  target_groups = { for key, tg in module.lb.target_groups : tg.id => { arn = tg.arn, name = tg.name, id = tg.id } }
  lb            = { name = module.lb.lb.name, id = module.lb.lb.id }
  ami_id        = var.ami_id
  app = {
    port             = 5555
    sg_protocol      = "tcp"
    user_data_base64 = base64encode(data.template_file.user_data.rendered)
  }
  autoscaling = {
    requests_count = 10
    min_size       = 1
    max_size       = 2
  }

  vpc = {
    id         = module.net.vpc.id
    cidr_block = module.net.vpc.cidr_block
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/templates/user_data.tpl")
  vars = {
    db_username = var.db.username
    db_password = var.db.password
    db_name     = var.db.name
    db_url      = module.postgres.postgres.address
  }
}


