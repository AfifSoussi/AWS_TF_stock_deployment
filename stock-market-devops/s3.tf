# S3 bucket creation (with website configuration)
resource "aws_s3_bucket" "html_bucket" {
  bucket = "my-exchange-rate-html-bucket"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name        = "Exchange Rate HTML Bucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_website_configuration" "hosting" {
  bucket = aws_s3_bucket.html_bucket.id

  index_document {
    suffix = "index.html"
  }
}

# Public access block (allow public access)
resource "aws_s3_bucket_public_access_block" "html_bucket_access" {
  bucket = aws_s3_bucket.html_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Public access policy for the S3 bucket
resource "aws_s3_bucket_policy" "html_bucket_policy" {
  bucket = aws_s3_bucket.html_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.html_bucket.arn}/*"
      }
    ]
  })
}

# VPC Endpoint for S3 access 
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_vpc.main.main_route_table_id]
}

# Output the S3 bucket website URL
output "s3_website_url" {
  value       = aws_s3_bucket.html_bucket.website_endpoint
  description = "The S3 bucket website URL"
}

# Output the AWS region
output "aws_region" {
  value       = var.aws_region
  description = "The AWS region where the S3 bucket is located"
}
