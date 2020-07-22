resource "aws_security_group" "private" {
  name   = "${var.name_prefix}-postgres-sg"
  vpc_id = var.vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = "${var.name_prefix}-postgres-sg" }, var.tags)
}

resource "aws_db_subnet_group" "subnets" {
  name       = "${var.name_prefix}-postgres-subnets"
  subnet_ids = var.subnet_ids

  tags = merge({ Name = "${var.name_prefix}-postgres-subnets" }, var.tags)
}

resource "aws_db_instance" "default" {
  allocated_storage      = var.db_instance.allocated_storage
  storage_type           = var.db_instance.storage_type
  engine                 = "postgres"
  engine_version         = var.db_instance.engine_version
  instance_class         = var.db_instance.instance_type
  name                   = var.db.name
  username               = var.db.username
  password               = var.db.password
  db_subnet_group_name   = aws_db_subnet_group.subnets.name
  vpc_security_group_ids = [aws_security_group.private.id]
  skip_final_snapshot    = true
  identifier             = "${var.name_prefix}-postgres"
  multi_az               = true

  tags = merge({ Name = "${var.name_prefix}-postgres" }, var.tags)
}
