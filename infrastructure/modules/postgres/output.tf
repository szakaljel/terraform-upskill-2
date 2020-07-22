output "postgres" {
  value = {
    address = aws_db_instance.default.address
  }
}