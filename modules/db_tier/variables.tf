variable "vpc_id" {
  description = "the vpc id of which the app is launched"
}

variable "app_security_group_id" {
  description = "security group from app"
}

variable "tag" {
  description = "tag interpolated from original main and variable tf files"
}
