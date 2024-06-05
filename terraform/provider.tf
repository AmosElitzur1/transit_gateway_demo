provider "aws" {
	alias  = "first"
	region = var.first_region
}

provider "aws" {
	alias  = "second"
	region = var.second_region
	assume_role {
		role_arn = var.assume_role_arn
	}
}