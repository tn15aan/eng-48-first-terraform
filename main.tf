# Set a provider

provider "aws" {
  region = "eu-west-1"
}

# Create VPC
resource "aws_vpc" "app_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.tag} - VPC"
  }
}


# Internet gateway
resource "aws_internet_gateway" "app_gw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "${var.tag} - Internet gateway"
  }
}


# Call module to create app Tier
module "app" {
  source = "./modules/app_tier"
  vpc_id = aws_vpc.app_vpc.id
  tag = var.tag
  gateway_id = aws_internet_gateway.app_gw.id
  ami_id = var.ami_id
}


# Call module for DB
resource "aws_security_group" "app_security_group" {
  name        = var.tag
  description = "Allow traffic from app"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    security_groups = [module.app.app_security_group_id]
  }


  tags = {
    Name = "${var.tag} - Security"
  }
}
