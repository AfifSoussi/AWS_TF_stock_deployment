
resource "aws_s3_bucket" "blue_bucket" {
  bucket = "my-exchange-rate-blue-bucket"
  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name        = "my-exchange-rate-blue"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_website_configuration" "blue_hosting" {
  bucket = aws_s3_bucket.blue_bucket.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "blue_html_bucket_access" {
  bucket = aws_s3_bucket.blue_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}



######### green bucket #####

resource "aws_s3_bucket" "green_bucket" {
  bucket = "my-exchange-rate-green-bucket"
  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name        = "my-exchange-rate-green"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_website_configuration" "green_hosting" {
  bucket = aws_s3_bucket.green_bucket.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "green_html_bucket_access" {
  bucket = aws_s3_bucket.green_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}



# Policy for Blue S3 Bucket to Allow Public Access
resource "aws_s3_bucket_policy" "blue_bucket_policy" {
  bucket = aws_s3_bucket.blue_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action   = "s3:GetObject",
        Resource = "${aws_s3_bucket.blue_bucket.arn}/*"
      }
    ]
  })
}

# Policy for Green S3 Bucket to Allow Public Access
resource "aws_s3_bucket_policy" "green_bucket_policy" {
  bucket = aws_s3_bucket.green_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action   = "s3:GetObject",
        Resource = "${aws_s3_bucket.green_bucket.arn}/*"
      }
    ]
  })
}


# Output the S3 bucket website URL
output "blue_website_url" {
  value       = aws_s3_bucket.blue_bucket.website_endpoint
  description = "The S3 blue bucket website URL"
}

# Output the S3 bucket website URL
output "green_website_url" {
  value       = aws_s3_bucket.green_bucket.website_endpoint
  description = "The S3 green bucket website URL"
}
# Output the AWS region
output "aws_region" {
  value       = var.aws_region
  description = "The AWS region where the S3 bucket is located"
}

