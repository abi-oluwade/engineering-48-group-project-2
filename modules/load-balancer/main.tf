# application load balancer
resource "aws_lb" "app_lb" {
  name               = "app-lb-eng48"
  internal           = false
  load_balancer_type = "application"
  security_groups    = module.app.app_security_group_id
  subnets            = [module.app.app_subnet_one, module.app.app_subnet_two, module.app.app_subnet_three]
  enable_deletion_protection = false
  tags = {
    Name = var.Name
  }
}

# Load balancer listener
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.front_end.arn
  port              = "80"
  protocol          = "HTTPS"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end.arn
  }
}

resource "aws_lb_target_group" "app_tg" {
  name     = "Eng48-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.app_vpc.id
}

resource "aws_lb_target_group_attachment" "app_tg_attach" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = module.app.app_instance
  port             = 80
}
