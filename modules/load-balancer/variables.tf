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
variable "app_security_group_id" {
  description = "this is the security group for app"
}
#variable "subnet_groups" {
#  description = "the group of app subnets"
#}
variable "app_subnet_one" {
  description = "this is the first app subnet"
}
variable "app_subnet_two" {
  description = "this is the second app subnet"
}
variable "app_subnet_three" {
  description = "this is the third app subnet"
}

variable "app_instance" {
  description = "this is the app instance from the app module"
}
