variable "Name" {
  type    = string
  default = "Eng48-app"
}

variable "db_name" {
  type = string
  default = "Eng48-mongo"
}

variable "app-ami-id" {
  type = string
  default = "ami-0435fbee126540ee8"
}

variable "db-ami-id" {
  type = string
  default = "ami-0c4de3ea38a26aa97"
}
