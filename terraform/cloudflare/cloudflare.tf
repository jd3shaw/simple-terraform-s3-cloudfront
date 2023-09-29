resource "cloudflare_zone" "main" {
  zone = var.domain_name
  account_id = var.cloudflare_account_id
  plan = "free"
}

output "name_server_ips" {
  value = cloudflare_zone.main.name_servers
}

resource "cloudflare_record" "website_record" {
  zone_id = cloudflare_zone.main.id
  name    = var.domain_name
  type    = "CNAME"
  value   = var.cloudfront_domain_name
  proxied = false
}

resource "cloudflare_record" "www_website_record" {
  zone_id = cloudflare_zone.main.id
  name    = "www.${var.domain_name}"
  type    = "CNAME"
  value   = var.cloudfront_domain_name
  proxied = false
}