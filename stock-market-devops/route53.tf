# Health Check for the Blue S3 Bucket using its default S3 website endpoint
resource "aws_route53_health_check" "blue_bucket_health_check" {
  fqdn              = aws_s3_bucket.blue_bucket.website_endpoint
  port              = 80
  type              = "HTTP"
  resource_path     = "/index.html"  # Ensure this file exists in your S3 bucket
  failure_threshold = 3
  request_interval  = 30
}

# Health Check for the Green S3 Bucket using its default S3 website endpoint
resource "aws_route53_health_check" "green_bucket_health_check" {
  fqdn              = aws_s3_bucket.green_bucket.website_endpoint
  port              = 80
  type              = "HTTP"
  resource_path     = "/index.html"
  failure_threshold = 3
  request_interval  = 30
}


# Output the health check ID for the blue S3 bucket
output "blue_bucket_health_check_id" {
  value       = aws_route53_health_check.blue_bucket_health_check.id
  description = "The Route53 health check ID for the blue S3 bucket"
}

# Output the health check ID for the green S3 bucket
output "green_bucket_health_check_id" {
  value       = aws_route53_health_check.green_bucket_health_check.id
  description = "The Route53 health check ID for the green S3 bucket"
}
