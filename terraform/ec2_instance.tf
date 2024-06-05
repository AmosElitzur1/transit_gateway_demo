# ###  Testing instance

locals {
  rds_username = aws_db_instance.mysql.username
  rds_password = random_password.mysql.result
  rds_host     = aws_db_instance.mysql.address
  endpoints    = toset(["ssm", "ssmmessages", "ec2", "ec2messages"])
}

data "aws_ami" "mysql" {
  provider = aws.first
  owners   = ["self"]
  filter {
    name   = "name"
    values = ["mysql-ubuntu"]
  }
}

resource "aws_instance" "testing_instance" {
  provider                    = aws.first
  ami                         = data.aws_ami.mysql.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.first.id
  iam_instance_profile        = aws_iam_instance_profile.instance_profile.id
  vpc_security_group_ids      = [aws_security_group.first.id]
  associate_public_ip_address = false
  tags = {
    "Name" : "testing_instance"
  }
  user_data = <<-EOF
    #!/bin/bash
    mkdir -p /home/ssm-user
    echo "[mysql]" > /home/ssm-user/.my.cnf
    echo "user=${local.rds_username}" >> /home/ssm-user/.my.cnf
    echo "password=${local.rds_password}" >> /home/ssm-user/.my.cnf
    echo "host=${local.rds_host}" >> /home/ssm-user/.my.cnf
  EOF
}

resource "aws_iam_role" "instance_role" {
  provider = aws.first
  name     = "enable-ssm"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  provider   = aws.first
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.instance_role.name
}

resource "aws_iam_instance_profile" "instance_profile" {
  provider = aws.first
  name     = "test-instance-profile"
  role     = aws_iam_role.instance_role.name
}

resource "aws_vpc_endpoint" "ssm" {
  provider            = aws.first
  for_each            = local.endpoints
  vpc_id              = aws_vpc.first.id
  service_name        = "com.amazonaws.${var.first_region}.${each.value}"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.first.id]
  subnet_ids          = [aws_subnet.first.id]
  private_dns_enabled = true
  tags = {
    "Name" : "vpc_${each.value}_endpoint"
  }
}




