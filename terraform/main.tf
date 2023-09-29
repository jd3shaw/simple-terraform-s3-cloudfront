resource "aws_cloudfront_function" "viewer_request_function" {
  name        = "viewer-request-function"
  runtime = "cloudfront-js-1.0"
  comment = "Check whether the URI is missing"
  publish = true
  code = <<EOT
  function handler(event) {
    var request = event.request;
    var uri = request.uri;
    // Check whether the URI is missing a file name.
    if (uri.endsWith('/')) {
        request.uri += 'index.html';
    }
    // Check whether the URI is missing a file extension.
    else if (!uri.includes('.')) {
        request.uri += '/index.html';
    }
    return request;
  }
  EOT
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudfront_function" "viewer_response_function" {
  name        = "viewer-response-function"
  runtime = "cloudfront-js-1.0"
  comment = "Adds HTTP security headers"
  publish = true
  code = <<EOT
  function handler(event) {
    var response = event.response;
    var headers = response.headers;
    // Set HTTP security headers
    headers['strict-transport-security'] = { value: 'max-age=63072000; includeSubdomains; preload'}; 
    headers['content-security-policy'] = { value: "default-src 'none'; img-src 'self'; script-src 'self'; style-src 'self'; object-src 'none'; manifest-src 'self'; base-uri 'self'"};
    headers['x-content-type-options'] = { value: 'nosniff'}; 
    headers['x-frame-options'] = {value: 'DENY'}; 
    headers['x-xss-protection'] = {value: '1; mode=block'}; 
    headers['referrer-policy'] = {value: 'strict-origin-when-cross-origin'}; // Set Referrer-Policy header
    headers['permissions-policy'] = {value: `geolocation=(self "https://${var.domain_name}" "https://www.${var.domain_name}")`}; // Set Permissions
    // Return the response to viewers 
    return response;
  }
  EOT
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudfront_origin_request_policy" "website_policy" {
  name = "website-policy"

  cookies_config {
    cookie_behavior = "whitelist"

    cookies {
      items = ["AWSALB", "AWSALBCORS"]
    }
  }

  headers_config {
    header_behavior = "whitelist"

    headers {
      items = ["Access-Control-Request-Headers", "Access-Control-Request-Method", "Origin"]
    }
  }

  query_strings_config {
    query_string_behavior = "all"
  }
}

resource "aws_cloudfront_origin_access_identity" "website_access_identity" {
  comment = "CloudFront OAI"
}

resource "aws_cloudfront_distribution" "website_distribution" {
  origin {
    domain_name = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_id = "S3-${aws_s3_bucket.website_bucket.id}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.website_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  
  aliases = [
    "www.${var.domain_name}",
    "${var.domain_name}",
  ]

  default_cache_behavior {
    target_origin_id = "S3-${aws_s3_bucket.website_bucket.id}"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.viewer_request_function.arn
    }
    function_association {
      event_type   = "viewer-response"
      function_arn = aws_cloudfront_function.viewer_response_function.arn
    }

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "blacklist"

      locations = [ #just some general blacklists for countries not likely to need to see your content
        "CN",  # China
        "KP",  # North Korea
        "NG",  # Nigeria
        "RU",  # Russian Federation
      ]
    }
  }

  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 404
    response_code         = 404
    response_page_path    = "/error.html"
  }

  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 403
    response_code         = 403
    response_page_path    = "/error.html"
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.website_certificate.arn
    ssl_support_method   = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = local.common_tags

  depends_on = [
    aws_s3_bucket.website_bucket,
    aws_cloudfront_function.viewer_request_function,
    aws_cloudfront_function.viewer_response_function,
  ]

  provisioner "local-exec" {
    command = "aws cloudfront create-invalidation --distribution-id ${self.id} --paths /*"
  }
}