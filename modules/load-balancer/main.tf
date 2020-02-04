# application load balancer
resource "aws_lb" "app_lb" {
  name               = "app-lb-eng48"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${var.app_security_group_id}"]
  subnets            = [var.app_subnet_one, var.app_subnet_two, var.app_subnet_three]
  #subnets            = [var.subnet_groups]

  enable_deletion_protection = false
  tags = {
    Name = var.name
  }
}

# Load balancer listener
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_lb_target_group" "app_tg" {
  name     = "Eng48-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "app_tg_attach" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = "var.app_instance"
  port             = 80
}
