variable "vpc_id" {
  description = "the vpc id of which the app is launches"
}

variable "gateway_id" {
  description = "the gateway id of which the app is launches"
}

variable "name" {
  description = "the name tags of which the app is launches"
}

variable "db-ami" {
  description = "the ami id of which the db is launches"
}

variable "app_security_group_id" {
  description = ""
}
