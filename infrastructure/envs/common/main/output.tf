output "network" {
  value = {
    private_subnets = { for key, subnet in module.network.private_subnets : key => { id = subnet.id, arn = subnet.arn } }
    public_subnets  = { for key, subnet in module.network.public_subnets : key => { id = subnet.id, arn = subnet.arn } }
  }
}

output "lb" {
  value = {
    target_groups = { for key, tg in module.lb.target_groups : tg.id => { arn = tg.arn, name = tg.name, id = tg.id } }
    lb            = { name = module.lb.lb.name, id = module.lb.lb.id }
  }
}

output "vpc" {
  value = {
    id         = module.network.vpc.id
    cidr_block = module.network.vpc.cidr_block
  }
}

output "postgres" {
  value = {
    address = module.postgres.postgres.address
    db = {
      name     = var.db.name
      username = var.db.username
      password = var.db.password
    }
  }
  sensitive = true
}