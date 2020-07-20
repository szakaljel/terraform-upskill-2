resource "aws_security_group" "public" {
  name   = "${var.name_prefix}-sg-public"
  vpc_id = var.vpc.id

  ingress {
    from_port   = var.app.port
    to_port     = var.app.port
    protocol    = var.app.sg_protocol
    cidr_blocks = [var.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = "${var.name_prefix}-sg-public" }, var.tags)
}

resource "aws_launch_template" "app" {
  name = "${var.name_prefix}-ec2-app-launch-template"

  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.public.id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge({ Name = "${var.name_prefix}-ec2-app" }, var.tags)
  }
  user_data = var.app.user_data_base64
}

resource "aws_autoscaling_group" "web_autoscaling" {
  max_size = var.autoscaling.max_size
  min_size = var.autoscaling.min_size

  vpc_zone_identifier = var.subnet_ids
  target_group_arns   = [for tg in var.target_groups : tg.arn]
  health_check_type   = "ELB"

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "main" {
  for_each = var.target_groups

  name                   = "${var.name_prefix}-ag-target-tracking-policy-${each.value.name}"
  autoscaling_group_name = aws_autoscaling_group.web_autoscaling.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "app/${var.lb.name}/${local.lb_clean_id}/targetgroup/${each.value.name}/${local.target_group_clean_id_lookup[each.key]}"
    }
    target_value = var.autoscaling.requests_count
  }
}
