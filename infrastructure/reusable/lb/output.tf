output "target_groups" {
  value = { for key, tg in aws_lb_target_group.main : key => { id = tg.id, arn = tg.arn, name = tg.name } }
}

output "lb" {
  value = {
    id   = aws_lb.lb.id
    name = aws_lb.lb.name
    arn  = aws_lb.lb.arn
  }
}