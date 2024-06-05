## first transit gateway:

resource "aws_ec2_transit_gateway" "first" {
  provider = aws.first
  tags = {
    Name = "${var.first_transit_gateway_name}"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "first" {
  provider           = aws.first
  subnet_ids         = [aws_subnet.first.id]
  transit_gateway_id = aws_ec2_transit_gateway.first.id
  vpc_id             = aws_vpc.first.id
  tags = {
    Name = "${var.first_vpc_attachment_name}"
  }
}

## second transit gateway:

resource "aws_ec2_transit_gateway" "second" {
  provider = aws.second
  tags = {
    Name = "${var.second_transit_gateway_name}"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "second" {
  provider           = aws.second
  subnet_ids         = aws_subnet.second[*].id
  transit_gateway_id = aws_ec2_transit_gateway.second.id
  vpc_id             = aws_vpc.second.id
  tags = {
    Name = "${var.second_vpc_attachment_name}"
  }
}

## peering:
 
data "aws_caller_identity" "first" {
  provider = aws.first
}

resource "aws_ec2_transit_gateway_peering_attachment" "peer" {
  provider                = aws.second
  peer_account_id         = data.aws_caller_identity.first.account_id
  peer_region             = var.first_region
  peer_transit_gateway_id = aws_ec2_transit_gateway.first.id
  transit_gateway_id      = aws_ec2_transit_gateway.second.id
  tags = {
    Name = "${var.peering_attachment_name}",
    Side = "Creator"
  }
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "peer" {
  provider                      = aws.first
  depends_on                    = [aws_ec2_transit_gateway_peering_attachment.peer]
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.peer.id
  tags = {
    Name = "${var.peering_attachment_name}",
    Side = "Acceptor"
  }
}

#### allow traffic between the accounts by modify route tables and security group:

## first:

resource "aws_route" "first" {
  provider               = aws.first
  destination_cidr_block = aws_vpc.second.cidr_block
  route_table_id         = aws_route_table.first.id
  transit_gateway_id     = aws_ec2_transit_gateway.first.id
}

resource "aws_ec2_transit_gateway_route" "first" {
  provider                       = aws.first
  depends_on                     = [aws_ec2_transit_gateway_peering_attachment_accepter.peer]
  destination_cidr_block         = aws_vpc.second.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.peer.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.first.association_default_route_table_id
}

##second:

resource "aws_route" "second" {
  provider               = aws.second
  destination_cidr_block = aws_vpc.first.cidr_block
  route_table_id         = aws_route_table.second.id
  transit_gateway_id     = aws_ec2_transit_gateway.second.id
}

resource "aws_ec2_transit_gateway_route" "second" {
  provider                       = aws.second
  depends_on                     = [aws_ec2_transit_gateway_peering_attachment_accepter.peer]
  destination_cidr_block         = aws_vpc.first.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.peer.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.second.association_default_route_table_id
}


