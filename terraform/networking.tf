### first account:
data "aws_availability_zones" "first" {
  provider = aws.first
  state    = "available"
}

resource "aws_vpc" "first" {
  provider   = aws.first
  cidr_block = var.first_vpc_cidr_block
  tags = {
    "Name" = "first_vpc"
  }
}

resource "aws_subnet" "first" {
  provider          = aws.first
  vpc_id            = aws_vpc.first.id
  cidr_block        = var.first_subnet_cidr_block
  availability_zone = data.aws_availability_zones.first.names[0]
  tags = {
    "Name" = "first_private_subnet"
  }
}

resource "aws_route_table" "first" {
  provider = aws.first
  vpc_id   = aws_vpc.first.id
  tags = {
    "Name" = "first_private_rt"
  }
}

resource "aws_security_group" "first" {
  provider = aws.first
  name     = "first_vpc_sg"
  vpc_id   = aws_vpc.first.id
  tags = {
    Name = "first_vpc_sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "first" {
  provider          = aws.first
  security_group_id = aws_security_group.first.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

### second account:
data "aws_availability_zones" "second" {
  provider = aws.second
  state    = "available"
}

resource "aws_vpc" "second" {
  provider   = aws.second
  cidr_block = var.second_vpc_cidr_block
  tags = {
    "Name" = "second_vpc"
  }
}

resource "aws_subnet" "second" {
  provider          = aws.second
  vpc_id            = aws_vpc.second.id
  cidr_block        = var.second_subnet_cidr_block
  availability_zone = data.aws_availability_zones.second.names[0]
  tags = {
    "Name" = "second_private_subnet"
  }
}

resource "aws_route_table" "second" {
  provider = aws.second
  vpc_id   = aws_vpc.second.id
  tags = {
    "Name" = "second_private_rt"
  }
}

resource "aws_security_group" "second" {
  provider = aws.second
  name     = "second_vpc_sg"
  vpc_id   = aws_vpc.second.id
  tags = {
    Name = "second_vpc_sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "second" {
  provider          = aws.second
  security_group_id = aws_security_group.second.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


## Allow traffic from first vpc:
resource "aws_security_group_rule" "allow_traffic_from_first_vpc" {
  provider          = aws.second
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = [var.first_subnet_cidr_block]
  security_group_id = aws_security_group.second.id
  description       = "Allow traffic from first vpc"
}
