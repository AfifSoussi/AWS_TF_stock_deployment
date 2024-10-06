# Health Check for the Blue S3 Bucket using its default S3 website endpoint
resource "aws_route53_health_check" "blue_bucket_health_check" {
  fqdn              = aws_s3_bucket.blue_bucket.website_endpoint
  type              = "HTTP"
  resource_path     = "/index.html"  # Ensure this file exists in your S3 bucket
  failure_threshold = 3
  request_interval  = 30
}

# Health Check for the Green S3 Bucket using its default S3 website endpoint
resource "aws_route53_health_check" "green_bucket_health_check" {
  fqdn              = aws_s3_bucket.green_bucket.website_endpoint
  type              = "HTTP"
  resource_path     = "/index.html"
  failure_threshold = 3
  request_interval  = 30
}

