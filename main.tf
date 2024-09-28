module "stock-market-devops" {
  source = "./stock-market-devops"
  aws_region = "eu-central-1"
  vpc_cidr = "10.10.0.0/16"
  app_image = "strm/helloworld-http"
}



output "alb_hostname" {
  value = module.stock-market-devops.App-Load-Balancer-Hostname
}

# Output the S3 bucket name from the module
output "s3_website_url" {
  value       = module.stock-market-devops.s3_website_url
  description = "The name of the S3 bucket"
}

# Output the AWS region from the module
output "aws_region" {
  value       = module.stock-market-devops.aws_region
  description = "The AWS region where the S3 bucket is located"
}
