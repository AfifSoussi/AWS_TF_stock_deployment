resource "aws_ecs_task_definition" "stock_exchange_app" {
  family                   = "stock-exchange-task"           # Name of your ECS task family
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"                          # Set the desired CPU
  memory                   = "512"                          # Set the desired memory

  container_definitions = jsonencode([
    {
      name      = "stock-exchange-app"                      # Name of the container
      image     = "ghcr.io/afifsoussi/stock-exchange:latest" # GitHub Container Registry image
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80                                # Expose port (adjust as needed)
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "S3_BUCKET"
          value = "my-exchange-rate-html-bucket"
        }
      ]
    }
  ])
}
