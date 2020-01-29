resource "aws_security_group" "app_security_group" {
  name        = var.tag
  description = "Allow traffic from app"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    security_groups = [var.app_security_group_id]
  }


  tags = {
    Name = "${var.tag} - Security"
  }
}
