#Application Load Balancer , Target Group for the ALB , Listener for the target group



#Application Load Balancer

resource "aws_lb" "my_alb" {
  name               = "load-balancer-1"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.my_public_subnet_1.id,aws_subnet.my_public_subnet_2.id]

  enable_deletion_protection = true

  tags = {
    name = "Application Load Balancer"
  }
}


#Target Groups for the ALB 

resource "aws_lb_target_group" "target_group-alb_80" {
  name        = "TG-ALB-HTTP"
  target_type = "instance"  #alb
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.my_vpc.id
}

# resource "aws_lb_target_group" "target_group-alb_443" {
#   name          = "TG-ALB-HTTPS"
#   target_type   = "alb"
#   port          = 443
#   protocol      = "tcp"
#   vpc_id        = aws_vpc.my_vpc.id

# }
                                                                                      #port 443 needs a domain (certificate arn)
#Listeners for the Target Groups

# resource "aws_lb_listener" "listener-443" {
#   load_balancer_arn = aws_lb.front_end.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn =  !needs a domain , λογω πορτας 443(encryption)

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.front_end.arn
#   }
# }

resource "aws_lb_listener" "listener-80" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"
  #certificate_arn   !not needed (port 80)

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group-alb_80.arn
  }

  tags = {
    name = "Listener for http protocol"
  }
}


