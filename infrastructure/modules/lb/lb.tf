resource "aws_security_group" "lb_sg" {
  name        = "${var.name_prefix}-lb-sg"
  description = "lb sg"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.listeners
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.sg_protocol
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = "${var.name_prefix}-lb-sg" }, var.tags)
}

resource "aws_lb" "lb" {
  name               = "${var.name_prefix}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.subnet_ids

  tags = merge({ Name = "${var.name_prefix}-lb" }, var.tags)
}

resource "aws_lb_target_group" "main" {
  for_each = var.listeners

  name     = "${var.name_prefix}-lb-tg-${each.key}"
  port     = each.value.target.port
  protocol = each.value.target.protocol
  vpc_id   = var.vpc_id

  tags = merge({ Name = "${var.name_prefix}-lb-tg-${each.key}" }, var.tags)

  health_check {
    enabled  = true
    interval = each.value.target.health_check.interval
    path     = each.value.target.health_check.path
    port     = each.value.target.port
    protocol = each.value.target.protocol
  }
}

resource "aws_lb_listener" "main" {
  for_each = var.listeners

  load_balancer_arn = aws_lb.lb.arn
  port              = each.value.port
  protocol          = each.value.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main[each.key].arn
  }
}