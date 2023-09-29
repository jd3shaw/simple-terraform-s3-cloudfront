resource "aws_s3_bucket" "website_bucket" {
  bucket = var.domain_name

  tags = local.common_tags
}

locals {
  website_files = fileset("../websitecode", "**/*")
}

resource "aws_s3_object" "website_files" {
  for_each = local.website_files

  bucket = aws_s3_bucket.website_bucket.id
  key    = each.value
  source = "websitecode/${each.value}"
  tags   = local.common_tags

  etag = filemd5("../websitecode/${each.value}")

  content_type = lookup({
    ".html"        = "text/html",
    ".css"         = "text/css",
    ".js"          = "application/javascript",
    ".jpg"         = "image/jpeg",
    ".jpeg"        = "image/jpeg",
    ".png"         = "image/png",
    ".gif"         = "image/gif",
    ".xml"         = "application/xml",
    ".ico"         = "image/x-icon",
    ".webmanifest" = "application/manifest+json",
    # Add more extensions and corresponding content types as needed
  }, ".${split(".", each.value)[1]}", "application/octet-stream")
}

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "Grant CloudFront Origin Access Identity access to S3 bucket"
        Effect = "Allow"
        Principal = {
          AWS = "${aws_cloudfront_origin_access_identity.website_access_identity.iam_arn}"
        }
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.website_bucket.arn}/*"
      }
    ]
  })
}