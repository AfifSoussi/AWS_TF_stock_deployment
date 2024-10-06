module "stock-market-devops" {
  source                = "./stock-market-devops"
  aws_region            = "eu-central-1"
  vpc_cidr              = "10.10.0.0/16"
  app_image             = "ghcr.io/afifsoussi/stock-exchange"
  blue_green_deployment = true # Enable Blue-Green deployment support
}

# Output the blue S3 website URL
output "blue_s3_website_url" {
  value       = module.stock-market-devops.blue_website_url
  description = "The URL of the blueS3 website bucket"
}

# Output the green S3 website URL
output "green_s3_website_url" {
  value       = module.stock-market-devops.green_website_url
  description = "The URL of the green S3 website bucket"
}


# Output the AWS region where the resources are deployed
output "aws_region" {
  value       = module.stock-market-devops.aws_region
  description = "The AWS region where the infrastructure is deployed"
}
