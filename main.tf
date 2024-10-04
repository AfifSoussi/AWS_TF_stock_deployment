module "stock-market-devops" {
  source                = "./stock-market-devops"
  aws_region            = "eu-central-1"
  vpc_cidr              = "10.10.0.0/16"
  app_image             = "ghcr.io/afifsoussi/stock-exchange"
  blue_green_deployment = true # Enable Blue-Green deployment support
}

# Output for the Application Load Balancer hostname
output "alb_hostname" {
  value       = module.stock-market-devops.App-Load-Balancer-Hostname
  description = "DNS name of the Application Load Balancer"
}

# Output the ALB Listener ARN for use in CI/CD
output "alb_listener_arn" {
  value       = module.stock-market-devops.ALB-Listener-ARN
  description = "The ARN of the ALB Listener"
}

# Output the Blue Target Group ARN for Blue-Green deployment
output "blue_target_group_arn" {
  value       = module.stock-market-devops.Blue-Target-Group-ARN
  description = "The ARN of the Blue Target Group for production"
}

# Output the Green Target Group ARN for Blue-Green deployment
output "green_target_group_arn" {
  value       = module.stock-market-devops.Green-Target-Group-ARN
  description = "The ARN of the Green Target Group for testing"
}

# Output the AWS region where the resources are deployed
output "aws_region" {
  value       = module.stock-market-devops.aws_region
  description = "The AWS region where the infrastructure is deployed"
}
