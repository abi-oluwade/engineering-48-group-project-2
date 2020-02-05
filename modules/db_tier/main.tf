# create private subnets for the databases
resource "aws_subnet" "db_subnet1"{
  vpc_id = var.vpc_id
  cidr_block = "10.0.4.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    name = "${var.name} - DB Subnet1"
  }
}

resource "aws_subnet" "db_subnet2"{
  vpc_id = var.vpc_id
  cidr_block = "10.0.5.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    name = "${var.name} - DB Subnet2"
  }
}

resource "aws_subnet" "db_subnet3"{
  vpc_id = var.vpc_id
  cidr_block = "10.0.6.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    name = "${var.name} - DB Subnet3"
  }
}

# create a security group
resource "aws_security_group" "db_security_group" {
  name        = "${var.name}_db"
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
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    security_groups = [var.app_security_group_id]
  }
  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    security_groups = [var.app_security_group_id]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    name = "${var.name}_db"
  }
}
resource "aws_eip_association" "eip_assoc" {
  instance_id = aws_instance.db_instance1.id
  allocation_id = aws_eip.eip_db.id
  public_ip = "52.17.39.45"

}
#resource "aws_eip" "eip_db" {
#  vpc = var.vpc_id
#  public_ip = "52.17.39.45"
#}
# launch an instance
resource "aws_instance" "db_instance1"{
  ami = var.db-ami
  subnet_id = aws_subnet.db_subnet1.id
  vpc_security_group_ids = ["${aws_security_group.db_security_group.id}"]
  instance_type = "t2.micro"
  key_name = "Eng-48-common-key"
  associate_public_ip_address = true
  tags = {
    name = "${var.name}-db1"
  }
}

resource "aws_instance" "db_instance2"{
  ami = var.db-ami
  subnet_id = aws_subnet.db_subnet2.id
  vpc_security_group_ids = ["${aws_security_group.db_security_group.id}"]
  instance_type = "t2.micro"
  key_name = "Eng-48-common-key"
  associate_public_ip_address = true
  tags = {
    name = "${var.name}-db2"
  }
}

resource "aws_instance" "db_instance3"{
  ami = var.db-ami
  subnet_id = aws_subnet.db_subnet3.id
  vpc_security_group_ids = ["${aws_security_group.db_security_group.id}"]
  instance_type = "t2.micro"
  key_name = "Eng-48-common-key"
  associate_public_ip_address = true
  tags = {
    name = "${var.name}-db3"
  }
}
