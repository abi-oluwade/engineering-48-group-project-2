# Main for app tier
# place all the concerns for the app tier

# launch configuration for auto scaling
resource "aws_launch_configuration" "app_conf" {
  name = "app_conf"
  instance_type = "t2.micro"
  image_id = var.app-ami
  security_groups = [aws_security_group.app_security_dm.id]
}

resource "aws_autoscaling_group" "app_autoscaling" {
  name = "Eng-48-autoscaling"
  max_size = 6
  min_size = 3
  launch_configuration = aws_launch_configuration.app_conf.name
  vpc_zone_identifier = [aws_subnet.public_one.id,aws_subnet.public_two.id,aws_subnet.public_three.id]
  target_group_arns = [var.aws_lb_target_group-id]

  # tags = {
  #  name = var.name
  # }
}

# create a subnet
#resource "aws_subnet" "public" {
#  count                   = "${length(var.public_subnet)}"
#  vpc_id                  = "${var.vpc_id}"
#  cidr_block              = "${var.public_subnet[count.index]}"
#  availability_zone       = "${var.availability_zone[count.index]}"
#  tags = {
#    name = "${var.name}-app-subnet-${count.index + 1}"
#    }
#}
resource "aws_subnet" "public_one"{
  vpc_id = var.vpc_id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    name = var.name
  }
}
resource "aws_subnet" "public_two"{
  vpc_id = var.vpc_id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-1b"
  tags = {
    name = var.name
  }
}
resource "aws_subnet" "public_three"{
  vpc_id = var.vpc_id
  cidr_block = "10.0.3.0/24"
  availability_zone = "eu-west-1c"
  tags = {
    name = var.name
  }
}
resource "aws_db_subnet_group" "subnets" {
  name = "subnet_groups"
  count = "${length(var.public_subnet)}"
  subnet_ids = ["${aws_subnet.public_one}","${aws_subnet.public_two}","${aws_subnet.public_three}"]
#  subnet_ids = ["${aws_subnet.public[count.index]}"]
}
# route table
resource "aws_route_table" "app_route_table" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.gateway_id
  }
  tags = {
   name = var.name
  }
}

# route table association
resource "aws_route_table_association" "app_association_one"{
  #count = "${length(var.public_subnet)}"
  subnet_id = aws_subnet.public_one.id
  #subnet_id = ["${aws_subnet.public_one}","${aws_subnet.public_two}","${aws_subnet.public_three}"]
  route_table_id = aws_route_table.app_route_table.id
}
resource "aws_route_table_association" "app_association_two"{
  #count = "${length(var.public_subnet)}"
  subnet_id = aws_subnet.public_two.id
  route_table_id = aws_route_table.app_route_table.id
}
resource "aws_route_table_association" "app_association_three"{
  #count = "${length(var.public_subnet)}"
  subnet_id = aws_subnet.public_three.id
  route_table_id = aws_route_table.app_route_table.id
}

# create a security group
resource "aws_security_group" "app_security_dm" {
  name        = "app_security_dm"
  description = "Allow 80 TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
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

# send template sh file
data  "template_file" "app_init" {
  template = "${file("./scripts/init_scripts.sh.tpl")}"
  vars = {
    db-ip=var.db_instance-ip
  }
}

# launch an instance
#resource "aws_instance" "app_instance"{
#  count = "${length(var.public_subnet)}"
#  ami = var.app-ami
#  subnet_id = aws_subnet.public[count.index].id
#  vpc_security_group_ids = [aws_security_group.app_security_dm.id]
#  instance_type = "t2.micro"
#  associate_public_ip_address = true
#  key_name = "Eng-48-common-key"
#  user_data = data.template_file.app_init.rendered
#  tags = {
#    name = "${var.name}-app_instance-${count.index + 1}"
#  }
#}
