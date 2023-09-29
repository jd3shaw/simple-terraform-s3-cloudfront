resource "aws_acm_certificate" "website_certificate" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = [
    "www.${var.domain_name}"
  ]

  tags = {
    Name = "Website Certificate"
  }
}

resource "aws_acm_certificate_validation" "website_certificate_validation" {
  certificate_arn = aws_acm_certificate.website_certificate.arn

  timeouts {
    create = "30m"
  }
}