variable "vpc_id" {
  description = "the vpc id of which the app is launches"
}

variable "gateway_id" {
  description = "the gateway id of which the app is launches"
}

variable "name" {
  description = "the name tags of which the app is launches"
}

variable "app-ami" {
  description = "the ami id of which the app is launches"
}

variable "db_instance-ip" {
  description = "ip of the db instance"
}
variable "public_subnet" {
description = "A list of public subnets"
type = list
default = []
}
variable "availability_zone" {
description = "a list of availability_zones"
type = "list"
default = []
}

variable "aws_lb_target_group-id" {
  description = ""
}
