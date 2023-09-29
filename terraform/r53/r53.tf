resource "aws_route53_zone" "main" {
  name = var.domain_name
}

output "name_server_ips" {
  value = aws_route53_zone.main.name_servers
}

resource "aws_route53_record" "website_record" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = aws_route53_zone.main.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_website_record" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = aws_route53_zone.main.zone_id
    evaluate_target_health = false
  }
}