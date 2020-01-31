# Creating a private subnet
resource  "aws_subnet" "db_subnet" {
  vpc_id = var.vpc_id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "${var.tag} - DB Subnet"
  }
}

resource "aws_security_group" "db_security_group" {
  name        = "${var.tag}_db"
  description = "Allow traffic from app"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    security_groups = ["${var.app_security_group_id}"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = ["${var.app_security_group_id}"]
  }
  tags = {
    Name = "${var.tag}_db"
  }
}


# Launch an instance
resource "aws_instance" "db_instance" {
ami = var.ami_id_db
vpc_security_group_ids = ["${aws_security_group.db_security_group.id}"]
subnet_id = aws_subnet.db_subnet.id
instance_type = "t2.micro"
associate_public_ip_address = true
key_name = "thomas-eng-48-first-key"
tags = {
    Name = "${var.tag}_db"
  }
}
