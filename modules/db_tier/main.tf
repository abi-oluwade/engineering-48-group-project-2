# create a subnet
resource "aws_subnet" "db_subnet"{
  vpc_id = var.vpc_id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    name = var.name
  }
}

# create a security group
resource "aws_security_group" "app_security_dm" {
  name        = "db_security_dm"
  description = "Allow inbound traffic from app"
  vpc_id      = var.vpc_id

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    security_groups = [var.app_security_group_id]
  }

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    security_groups = [var.app_security_group_id]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    name = var.name
  }
}

# launch an instance
resource "aws_instance" "db_instance"{
  ami = var.db-ami
  subnet_id = aws_subnet.db_subnet.id
  vpc_security_group_ids = [var.app_security_group_id]
  instance_type = "t2.micro"
  key_name = "Eng-48-common-key"
  associate_public_ip_address = true
  tags = {
    name = "${var.name}-db instance"
  }
}
