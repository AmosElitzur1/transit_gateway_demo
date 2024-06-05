resource "random_password" "mysql" {
  length  = 15
  special = true
}

resource "aws_db_subnet_group" "default" {
  provider   = aws.second
  name       = "main"
  subnet_ids = [aws_subnet.second.id]
}

resource "aws_db_instance" "mysql" {
  provider             = aws.second
  allocated_storage    = 10
  db_name              = "mydb"
  db_subnet_group_name = aws_db_subnet_group.default.name
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "db_user"
  password             = random_password.mysql.result
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.second.id]
}
