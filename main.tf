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
  aws_lb_target_group-id = module.load_balancer.aws_lb_target_group-id
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
module "load_balancer" {
  source = "./modules/load_balancer"
  vpc_id = aws_vpc.app_vpc.id
  gateway_id = aws_internet_gateway.app_internet_gateway.id
  name = var.Name
  app_security_group_id = module.app.app_security_group_id
  app-ami = var.app-ami-id
  app_subnet_one = module.app.app_subnet_one
  app_subnet_two = module.app.app_subnet_two
  app_subnet_three = module.app.app_subnet_three
  db_instance-ip = module.db.db_instance-ip
  app_instance = module.app.app_autoscaling
  #subnet_groups = module.app.subnet_groups
}
