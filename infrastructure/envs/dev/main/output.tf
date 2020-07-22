output "network" {
  value = module.main.network
}

output "lb" {
  value = module.main.lb
}

output "vpc" {
  value = module.main.vpc
}

output "postgres" {
  value     = module.main.postgres
  sensitive = true
}