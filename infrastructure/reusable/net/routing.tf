resource "aws_route_table" "public" {
  count = local.is_any_public ? 1 : 0

  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }
  tags = merge({ Name = "${var.name_prefix}-rt-public" }, var.tags)
}

resource "aws_route_table_association" "ec2_rt_association" {
  for_each = var.public_subnets

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[0].id
}