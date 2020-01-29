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

# Create subnet for app
resource "aws_subnet" "app_subnet" {
  vpc_id = aws_vpc.app_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "${var.tag} - Subnet"
  }
}

# Internet gateway
resource "aws_internet_gateway" "app_gw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "${var.tag} - Internet gateway"
  }
}

# Route table
resource "aws_route_table" "app_route" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_gw.id
  }
  tags = {
    Name = "${var.tag} - Route Table"
  }
}

# Route table associations
resource "aws_route_table_association" "app_assoc" {
  subnet_id = aws_subnet.app_subnet.id
  route_table_id = aws_route_table.app_route.id
}


# Launch an instance
resource "aws_instance" "app_instance" {
  ami           = var.ami_id
  vpc_security_group_ids = ["${aws_security_group.app_security_group.id}"]
  subnet_id = aws_subnet.app_subnet.id # Do this once you got your subnet
  instance_type = "t2.micro"
  associate_public_ip_address = true
  user_data = data.template_file.app_init.rendered
  tags = {
    Name = var.tag
  }
}


# Security
resource "aws_security_group" "app_security_group" {
  name        = "Eng48-Thomas-N-security-group"
  description = "Set inbound and outbound traffic"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.tag} - Security"
  }
}

data "template_file" "app_init" {
  template = "${file("./scripts/init_script.sh.tpl")}"
}
