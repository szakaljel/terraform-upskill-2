output "public_subnets" {
  value = { for key, subnet in aws_subnet.public : key => { id = subnet.id, arn = subnet.arn } }
}

output "private_subnets" {
  value = { for key, subnet in aws_subnet.private : key => { id = subnet.id, arn = subnet.arn } }
}

output "vpc" {
  value = { id = aws_vpc.main.id, arn = aws_vpc.main.arn, cidr_block = aws_vpc.main.cidr_block }
}