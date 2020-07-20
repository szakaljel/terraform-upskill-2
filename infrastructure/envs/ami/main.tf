terraform {
  backend "s3" {
    bucket   = "rjelinski-terraform-state"
    key      = "state/ami.tfstate"
    region   = "eu-west-3"
    acl      = "private"
    encrypt  = true
    profile  = "sandbox"
    role_arn = "arn:aws:iam::890769921003:role/rjelinski-terraform-role"
  }
  required_version = ">= 0.12.0"
}

provider "aws" {
  region  = "eu-west-3"
  profile = "sandbox"
  assume_role {
    role_arn     = "arn:aws:iam::890769921003:role/rjelinski-terraform-provider-role"
    session_name = "terraform"
  }
}