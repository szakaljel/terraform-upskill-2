data "terraform_remote_state" "main" {
  backend = "s3"
  config = {
    bucket   = var.remote.bucket
    key      = var.remote.key
    region   = var.remote.region
    profile  = var.remote.profile
    role_arn = var.remote.role_arn
  }
}