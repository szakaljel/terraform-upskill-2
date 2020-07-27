module "main" {
  source = "../../common/main"

  name_prefix     = var.name_prefix
  region          = var.region
  main_cidr_block = var.main_cidr_block
  db = {
    name     = var.db_name
    username = var.db_username
    password = var.db_password
  }
  tags = { Owner = var.owner }
}
