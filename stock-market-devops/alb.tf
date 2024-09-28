# ALB definition
resource "aws_alb" "main" {
    name        = "cb-load-balancer"
    subnets         = aws_subnet.public.*.id
    security_groups = [aws_security_group.lb.id]
}

# ALB Target Group for ECS task
resource "aws_alb_target_group" "app" {
    name        = "cb-target-group"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = aws_vpc.main.id
    target_type = "ip"

    health_check {
        healthy_threshold   = "3"
        interval            = "30"
        protocol            = "HTTP"
        matcher             = "200"
        timeout             = "3"
        path                = var.health_check_path
        unhealthy_threshold = "2"
    }
}

# # ALB Listener
# resource "aws_alb_listener" "front_end" {
#   load_balancer_arn = aws_alb.main.id
#   port              = var.app_port
#   protocol          = "HTTP"

#   default_action {
#     target_group_arn = aws_alb_target_group.app.id
#     type             = "forward"
#   }
# }

# ALB Listener (Updated to redirect to S3 static website URL)
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.main.id
  port              = var.app_port
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      protocol    = "HTTP"
      host        = "${aws_s3_bucket.html_bucket.bucket}.s3-website.${var.aws_region}.amazonaws.com"
      path        = "/"
      port        = "80"
      status_code = "HTTP_301"
    }
  }
}


output "App-Load-Balancer-Hostname" {
  value = aws_alb.main.dns_name
}
