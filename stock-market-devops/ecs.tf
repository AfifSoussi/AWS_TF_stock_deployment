# Define the ECS Cluster
resource "aws_ecs_cluster" "main" {
    name = "cb-cluster"
}

# ECS Task Definition for the Stock Exchange Task
resource "aws_ecs_task_definition" "stock_exchange_task" {
    family                   = "stock-exchange-task"                # Updated task family name
    execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
    task_role_arn            = aws_iam_role.ecs_task_role.arn
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = var.fargate_cpu
    memory                   = var.fargate_memory

    container_definitions = jsonencode([
        {
            name      = "stock-exchange-container"                 # Name of the container
            image     = "ghcr.io/afifsoussi/stock-exchange:latest" # Use the stock exchange container from GitHub Container Registry
            essential = true
            cpu       = 256
            memory    = 512
            portMappings = [
                {
                    containerPort = 80                            # Port mapping (adjust as needed)
                    hostPort      = 80
                    protocol      = "tcp"
                }
            ]
        }
    ])
}

# ECS Service to run the Stock Exchange Task
resource "aws_ecs_service" "stock_exchange_service" {
    name            = "stock-exchange-service"                     # Updated service name
    cluster         = aws_ecs_cluster.main.id
    task_definition = aws_ecs_task_definition.stock_exchange_task.arn
    desired_count   = 1                                            # Number of tasks to run
    launch_type     = "FARGATE"

    network_configuration {
        security_groups  = [aws_security_group.ecs_tasks.id]
        subnets          = aws_subnet.private.*.id
        assign_public_ip = true
    }

    depends_on = [aws_iam_role_policy_attachment.ecs-task-execution-role-policy-attachment]
}
