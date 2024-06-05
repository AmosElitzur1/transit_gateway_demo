variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}

variable "ami_name" {
  type    = string
  default = "mysql-ubuntu"
}

packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

data "amazon-ami" "ubuntu" {
  filters = {
    virtualization-type = "hvm"
    name                = "ubuntu/images/*ubuntu-noble-*"
    root-device-type    = "ebs"
    architecture        = "x86_64"
  }
  owners      = ["amazon"]
  most_recent = true
  region      = var.aws_region
}

source "amazon-ebs" "example" {
  region          = var.aws_region
  source_ami      = data.amazon-ami.ubuntu.id
  instance_type   = var.instance_type
  ssh_username    = var.ssh_username
  ami_name        = var.ami_name
  ami_description = "AMI with MySQL installed"
}

build {
  sources = ["source.amazon-ebs.example"]

  provisioner "shell" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y mysql-server",
      "sudo service mysql start"
    ]
  }
}
