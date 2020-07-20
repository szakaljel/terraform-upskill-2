resource "aws_vpc" "main" {
  cidr_block           = var.main_cidr_block
  enable_dns_hostnames = true
  tags                 = merge({ Name = "${var.name_prefix}-vpc" }, var.tags)
}

resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az_name
  tags              = merge({ Name = "${var.name_prefix}-public-subnet-${each.key}" }, var.tags)
}

resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az_name
  tags              = merge({ Name = "${var.name_prefix}-private-subnet-${each.key}" }, var.tags)
}
