module "stock-market-devops" {
  source      = "./stock-market-devops"
  aws_region  = "eu-central-1"
  vpc_cidr    = "10.10.0.0/16"
  app_image   = "ghcr.io/afifsoussi/stock-exchange"
  bDeployBlue = true # Set to true for blue deployment, false for green deployment
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


# Import the health check ID for the blue S3 bucket 
output "blue_bucket_health_check_id" {
  value       = module.stock-market-devops.blue_bucket_health_check_id
  description = "The Route53 health check ID for the blue S3 bucket"
}

# Import the health check ID for the green S3 bucke
output "green_bucket_health_check_id" {
  value       = module.stock-market-devops.green_bucket_health_check_id
  description = "The Route53 health check ID for the green S3 bucket"
}