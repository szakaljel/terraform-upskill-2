module "net" {
  source = "../../reusable/net"

  name_prefix = "rjelinski-tu-ami"
  public_subnets = {
    "eu-west-3a" = {
      az_name    = "eu-west-3a"
      cidr_block = "10.0.1.0/24"
    }
  }
}