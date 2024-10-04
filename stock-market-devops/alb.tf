# This ALB will manage traffic between the Blue (production) and Green (testing) environments.
resource "aws_alb" "main" {
  name            = "cb-load-balancer"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb.id]

  tags = {
    Name        = "CB Load Balancer"
    Environment = "Production"
  }
}

# This target group is attached to the ECS Blue (Production) service. The ALB will forward traffic to this group by default.
resource "aws_alb_target_group" "blue_app" {
  name        = "cb-target-group-blue"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  # Health check configuration to ensure that the ECS tasks in the Blue environment are healthy before receiving traffic.
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "Blue Target Group"
    Environment = "Production"
  }
}

# This target group is attached to the ECS Green (Testing) service. Traffic will be routed here for validation before promotion to production.
resource "aws_alb_target_group" "green_app" {
  name        = "cb-target-group-green"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  # Health check configuration to validate the health of the Green environment before promoting it to Blue.
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "Green Target Group"
    Environment = "Testing"
  }
}

# ALB Listener for Blue-Green Switching
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.main.id
  port              = var.app_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.blue_app.arn  # Initially pointing to Blue target group
  }
}

# ALB Listener Rule to forward traffic to Green during testing
resource "aws_alb_listener_rule" "green_rule" {
  listener_arn = aws_alb_listener.front_end.arn
  priority     = 100
  
  condition {
    path_pattern {
      values = ["/green"]  # Route traffic to Green for testing
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.green_app.arn
  }
}

# ALB Listener Rule to forward traffic to Blue
resource "aws_alb_listener_rule" "blue_rule" {
  listener_arn = aws_alb_listener.front_end.arn
  priority     = 200
  
  condition {
    path_pattern {
      values = ["/"]  # Route traffic to Blue by default
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.blue_app.arn
  }
}

# Output the ALB DNS name
output "App-Load-Balancer-Hostname" {
  value       = aws_alb.main.dns_name
  description = "DNS name of the Application Load Balancer"
}

# Outputs for ALB Target Groups
output "Blue-Target-Group-ARN" {
  value       = aws_alb_target_group.blue_app.arn
  description = "ARN of the Blue Target Group"
}

output "Green-Target-Group-ARN" {
  value       = aws_alb_target_group.green_app.arn
  description = "ARN of the Green Target Group"
}

output "ALB-Listener-ARN" {
  value       = aws_alb_listener.front_end.arn
  description = "ARN of the ALB Listener"
}
