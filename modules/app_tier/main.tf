# Main for App Tier
# Place all that concerns the app tier in here

# Create subnet for app
resource "aws_subnet" "app_subnet" {
  vpc_id = var.vpc_id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "${var.tag} - Subnet"
  }
}

# Route table
resource "aws_route_table" "app_route" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.gateway_id
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
  key_name = "thomas-eng-48-first-key"
  user_data = data.template_file.app_init.rendered
  tags = {
    Name = "${var.tag}_app"
  }
}


# Security
resource "aws_security_group" "app_security_group" {
  vpc_id      = var.vpc_id

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.tag} - Security"
  }
}

data "template_file" "app_init" {
  template = "${file("./scripts/init_script.sh.tpl")}"
  vars = {
	db-ip=var.db_instance-ip
  }

}
