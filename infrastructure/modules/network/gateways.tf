resource "aws_internet_gateway" "igw" {
  count = local.is_any_public ? 1 : 0

  vpc_id = aws_vpc.main.id
  tags   = merge({ Name = "${var.name_prefix}-igw" }, var.tags)
}