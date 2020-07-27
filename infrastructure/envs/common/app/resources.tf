module "app" {
  source = "../../../modules/autoscaling_app"

  name_prefix   = var.name_prefix
  tags          = var.tags
  subnet_ids    = [for key, subnet in data.terraform_remote_state.main.outputs.network.private_subnets : subnet.id]
  target_groups = { for key, tg in data.terraform_remote_state.main.outputs.lb.target_groups : tg.id => { arn = tg.arn, name = tg.name, id = tg.id } }
  lb            = { name = data.terraform_remote_state.main.outputs.lb.lb.name, id = data.terraform_remote_state.main.outputs.lb.lb.id }
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
    id         = data.terraform_remote_state.main.outputs.vpc.id
    cidr_block = data.terraform_remote_state.main.outputs.vpc.cidr_block
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/templates/user_data.tpl")
  vars = {
    db_username = data.terraform_remote_state.main.outputs.postgres.db.username
    db_password = data.terraform_remote_state.main.outputs.postgres.db.password
    db_name     = data.terraform_remote_state.main.outputs.postgres.db.name
    db_url      = data.terraform_remote_state.main.outputs.postgres.address
  }
}


