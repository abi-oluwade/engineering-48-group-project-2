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

# Launching instances
resource "aws_instance" "mongo_instance1" {
  ami = var.mongo_ami_id
  subnet_id = aws_subnet.mongo_subnet1.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
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
