# set a provider
provider "aws" {
  region = "eu-west-1"
}

# create a vpc
resource "aws_vpc" "app_vpc"{
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = var.Name
  }
}

# internet gateway
resource "aws_internet_gateway" "app_internet_gateway"{
  vpc_id = aws_vpc.app_vpc.id
  tags = {
   Name = var.Name
   }
}

# call module to create app tier
module "app" {
  source = "./modules/app_tier"
  vpc_id = aws_vpc.app_vpc.id
  gateway_id = aws_internet_gateway.app_internet_gateway.id
  db_instance-ip = module.db.db_instance-ip
  name = var.Name
  app-ami = var.app-ami-id
}

# call module to create db tier
module "db" {
  source = "./modules/db_tier"
  vpc_id = aws_vpc.app_vpc.id
  gateway_id = aws_internet_gateway.app_internet_gateway.id
  name = var.Name
  app_security_group_id = module.app.app_security_group_id
  db-ami = var.db-ami-id
}
