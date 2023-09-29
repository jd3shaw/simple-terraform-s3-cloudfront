module "r53_dns" {
  source = "./r53"

  domain_name = var.domain_name
  cloudfront_domain_name = aws_cloudfront_distribution.website_distribution.domain_name
}

# module "dns" {
#   source = "./cloudflare"

#   domain_name = var.domain_name
#   cloudflare_email = var.cloudflare_email
#   cloudflare_account_id = var.cloudflare_account_id
#   cloudflare_api_key = var.cloudflare_api_key
#   tunnel_secret_key = var.tunnel_secret_key
#   cloudfront_domain_name = aws_cloudfront_distribution.website_distribution.domain_name
# }