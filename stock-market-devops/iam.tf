# ECS Task Execution Role 
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role-cb-cluster"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# ECS Task Role
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role-cb-app"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Attach S3 Bucket Policy for Access to the Blue Bucket
resource "aws_iam_role_policy" "ecs_task_role_s3_blue_access" {
  name = "ecs_task_role_s3_blue_access"
  role = aws_iam_role.ecs_task_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::my-exchange-rate-blue-bucket",
          "arn:aws:s3:::my-exchange-rate-blue-bucket/*"
        ]
      }
    ]
  })
}

# Attach S3 Bucket Policy for Access to the Green Bucket
resource "aws_iam_role_policy" "ecs_task_role_s3_green_access" {
  name = "ecs_task_role_s3_green_access"
  role = aws_iam_role.ecs_task_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::my-exchange-rate-green-bucket",
          "arn:aws:s3:::my-exchange-rate-green-bucket/*"
        ]
      }
    ]
  })
}

# Attach ECS Task Execution Policy
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
