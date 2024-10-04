# Autoscaling for Blue (Production) ECS Service
resource "aws_appautoscaling_target" "blue_target" {
  max_capacity       = 2
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.blue_stock_exchange_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Scaling Policy for Blue ECS Service - Scale Up
resource "aws_appautoscaling_policy" "blue_scale_up" {
  name               = "blue-scale-up"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.blue_target.resource_id
  scalable_dimension = aws_appautoscaling_target.blue_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.blue_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown               = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}

# Scaling Policy for Blue ECS Service - Scale Down
resource "aws_appautoscaling_policy" "blue_scale_down" {
  name               = "blue-scale-down"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.blue_target.resource_id
  scalable_dimension = aws_appautoscaling_target.blue_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.blue_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown               = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = -1
    }
  }
}

# Autoscaling for Green (Testing) ECS Service
resource "aws_appautoscaling_target" "green_target" {
  max_capacity       = 2
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.green_stock_exchange_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Scaling Policy for Green ECS Service - Scale Up
resource "aws_appautoscaling_policy" "green_scale_up" {
  name               = "green-scale-up"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.green_target.resource_id
  scalable_dimension = aws_appautoscaling_target.green_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.green_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown               = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}

# Scaling Policy for Green ECS Service - Scale Down
resource "aws_appautoscaling_policy" "green_scale_down" {
  name               = "green-scale-down"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.green_target.resource_id
  scalable_dimension = aws_appautoscaling_target.green_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.green_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown               = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = -1
    }
  }
}
