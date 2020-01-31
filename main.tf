# Set a provider

provider "aws" {
  region = "eu-west-1"
}

# Create VPC
resource "aws_vpc" "app_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = var.tag
  }
}


# Internet gateway
resource "aws_internet_gateway" "app_gw" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    Name = var.tag
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
module "db" {
  source = "./modules/db_tier"
  vpc_id = aws_vpc.app_vpc.id
  tag = var.tag
  app_security_group_id = module.app.app_security_group_id
  ami_id_db = var.ami_id_db
}
