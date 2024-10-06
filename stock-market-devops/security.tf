# ECS Tasks Security Group: Allow access to S3 and the internet

# Security Group for ECS tasks
resource "aws_security_group" "ecs_tasks" {
    name        = "cb-ecs-tasks-security-group"
    description = "Allow ECS tasks to communicate with S3 and the internet"
    vpc_id      = aws_vpc.main.id

    # Ingress Rule: No inbound traffic is required for ECS tasks, as they initiate requests to S3
    ingress {
        protocol    = "-1"   # No inbound traffic is allowed from external sources
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Egress Rule: Allow ECS tasks to communicate with S3 buckets (via HTTPS)
    egress {
        protocol    = "tcp"
        from_port   = 443    # HTTPS port for communication with S3
        to_port     = 443
        cidr_blocks = ["0.0.0.0/0"]  # Open to internet (S3 endpoints are on public IPs)
    }

    # Egress Rule: Allow ECS tasks to access the internet for updates, etc.
    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]  # Full outbound access to the internet
    }

    tags = {
        Name = "ECS Tasks Security Group"
    }
}
