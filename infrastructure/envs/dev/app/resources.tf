module "app" {
  source = "../../common/app"

  name_prefix = var.name_prefix
  region      = var.region
  ami_id      = var.ami_id
  remote = {
    bucket   = var.remote_bucket
    key      = var.remote_key
    profile  = var.remote_profile
    region   = var.remote_region
    role_arn = var.remote_role_arn
  }
  tags = { Owner = var.owner }
}
