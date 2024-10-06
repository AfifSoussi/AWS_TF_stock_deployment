# Define the ECS Cluster
resource "aws_ecs_cluster" "main" {
    name = "cb-cluster"
}

# ECS Task Definition for the Stock Exchange Task (Blue - Production)
resource "aws_ecs_task_definition" "blue_stock_exchange_task" {
    family                   = "stock-exchange-task-blue"              # Updated task family for Blue
    execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
    task_role_arn            = aws_iam_role.ecs_task_role.arn
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = var.fargate_cpu
    memory                   = var.fargate_memory

    container_definitions = jsonencode([{
        name      = "stock-exchange-container"                     # Name of the container
        image     = "${var.app_image}:${var.image_tag}"            # Use the stock exchange container from GitHub Container Registry
        essential = true
        cpu       = 256
        memory    = 512
        portMappings = [{
            containerPort = 80                                    # Port mapping (adjust as needed)
            hostPort      = 80
            protocol      = "tcp"
        }]
        environment = [{
            name  = "S3_BUCKET"                                    # Override S3_BUCKET for Blue (Production)
            value = aws_s3_bucket.blue_bucket.bucket               # Use Blue S3 bucket
        }]
    }])
}

# ECS Task Definition for the Stock Exchange Task (Green - Testing)
resource "aws_ecs_task_definition" "green_stock_exchange_task" {
    family                   = "stock-exchange-task-green"              # Updated task family for Green
    execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
    task_role_arn            = aws_iam_role.ecs_task_role.arn
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = var.fargate_cpu
    memory                   = var.fargate_memory

    container_definitions = jsonencode([{
        name      = "stock-exchange-container"                     # Name of the container
        image     = "${var.app_image}:${var.image_tag}"            # Use the stock exchange container from GitHub Container Registry
        essential = true
        cpu       = 256
        memory    = 512
        portMappings = [{
            containerPort = 80                                    # Port mapping (adjust as needed)
            hostPort      = 80
            protocol      = "tcp"
        }]
        environment = [{
            name  = "S3_BUCKET"                                    # Override S3_BUCKET for Green (Testing)
            value = aws_s3_bucket.green_bucket.bucket              # Use Green S3 bucket
        }]
    }])
}

# ECS Service for Blue (Production)
resource "aws_ecs_service" "blue_stock_exchange_service" {
  name            = "stock-exchange-service-blue"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.blue_stock_exchange_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  # Load balancer removed. Now traffic is handled by the S3 bucket endpoint.
  # No need for ALB target group reference.

  network_configuration {
    subnets          = aws_subnet.private.*.id
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  depends_on = [aws_iam_role_policy_attachment.ecs-task-execution-role-policy-attachment]
}

# ECS Service for Green (Testing)
resource "aws_ecs_service" "green_stock_exchange_service" {
  name            = "stock-exchange-service-green"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.green_stock_exchange_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  # Load balancer removed. Now traffic is handled by the S3 bucket endpoint.
  # No need for ALB target group reference.

  network_configuration {
    subnets          = aws_subnet.private.*.id
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  depends_on = [aws_iam_role_policy_attachment.ecs-task-execution-role-policy-attachment]
}
