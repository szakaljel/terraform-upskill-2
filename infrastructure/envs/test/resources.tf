module "app" {
  source = "../common"

  name_prefix = "rjelinski-tu-test"
  ami_id      = "ami-0c55170fdf0a2f4af"
  region      = "eu-west-3"
  db = {
    name     = "tu"
    username = "tuadmin"
    password = "tuadmin123"
  }
  tags = { Owner = "rjelinski" }
}
