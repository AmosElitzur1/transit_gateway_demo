first_region    = "us-east-1"
second_region   = "us-east-2"
assume_role_arn = "arn:aws:iam::<your second account id>:role/<role name>" #replace it with your role arn.

first_vpc_cidr_block      = "20.0.0.0/16"
first_subnet_cidr_block   = "20.0.0.0/28"
second_vpc_cidr_block     = "21.0.0.0/16"
second_subnet_cidr_blocks = ["21.0.0.0/28", "21.0.1.0/28"]

first_transit_gateway_name  = "first-tgw"
first_vpc_attachment_name   = "tgw-first-attachment"
second_transit_gateway_name = "second-tgw"
second_vpc_attachment_name  = "tgw-second-attachment"
peering_attachment_name     = "second-first-peering"

db_name = "develeap_we_can_take_you_there_demo_db"
