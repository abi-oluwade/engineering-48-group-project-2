# Set a provider
# Configure the AWS provider
provider "aws" {
  region = "eu-west-1"
}

# Create private subnets
resource "aws_subnet" "mongo_subnet1" {
  # link vpc_id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "${var.db_name} - mongo subnet 1"
  }
}

resource "aws_subnet" "mongo_subnet2" {
  # link vpc_id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-1b"
  tags = {
    Name = "${var.db_name} - mongo subnet 2"
  }
}

resource "aws_subnet" "mongo_subnet3" {
  # link vpc_id
  cidr_block = "10.0.3.0/24"
  availability_zone = "eu-west-1c"
  tags = {
    Name = "${var.db_name} - mongo subnet 3"
  }
}

# Send template to sh file
data "template_file" "primary_mongo_init" {
  template = "${file(".scripts/init_script.sh.tpl")}"
}

# Launching instances
resource "aws_instance" "mongo_instance1" {
  ami = var.mongo_ami_id
  subnet_id = aws_subnet.mongo_subnet1.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  user_data = data.template_file.primary_mongo_init.rendered
  tags = {
    Name = "${var.db_name} - mongo first instance"
  }
}

resource "aws_instance" "mongo_instance2" {
  ami = var.mongo_ami_id
  subnet_id = aws_subnet.mongo_subnet2.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  tags = {
    Name = "${var.db_name} - mongo second instance"
  }
}

resource "aws_instance" "mongo_instance3" {
  ami = var.mongo_ami_id
  subnet_id = aws_subnet.mongo_subnet3.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  tags = {
    Name = "${var.db_name} - mongo third instance"
  }
}

# Route table associations
resource "aws_route_table_association" "db_assoc" {
  subnet_id = aws_subnet.mongo_subnet1.id
  route_table_id = aws_route_table.db_route.id
}


# Security Groups
resource "aws_security_group" "db_security_group" {
  ## LINK VPC vpc_id      = var.vpc_id
  description = "Allow traffic from app"
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
  egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.db_name} - Security group"
  }
}
