variable "vpc_id" {
  description = "the vpc id of which the app is launched"
}

variable "tag" {
  description = "tag interpolated from original main and variable tf files"
}

variable "gateway_id" {
  description = "gateway id from original main.tf"
}

variable "ami_id" {
  description = "AMI id from original main and variables"
}

variable "db_instance-ip" {
  description = "the ip of the db instance"
}
