first_region    = "us-east-1"
second_region   = "us-east-2"
assume_role_arn = "arn:aws:iam::281061728100:role/Bi-Project"

first_vpc_cidr_block     = "20.0.0.0/16"
first_subnet_cidr_block  = "20.0.0.0/28"
second_vpc_cidr_block    = "21.0.0.0/16"
second_subnet_cidr_block = "21.0.0.0/28"

first_transit_gateway_name  = "first-tgw"
first_vpc_attachment_name   = "tgw-first-attachment"
second_transit_gateway_name = "second-tgw"
second_vpc_attachment_name  = "tgw-second-attachment"
peering_attachment_name     = "second-first-peering"

