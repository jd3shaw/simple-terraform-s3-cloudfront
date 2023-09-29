variable "domain_name" {
  type    = string
  default = "example.com"
}

variable "cloudflare_email" {
  type    = string
}

variable "cloudflare_api_key" {
  type    = string
}

variable "cloudflare_account_id" {
  type    = string
}

variable "tunnel_secret_key" {
  type    = string
}
variable "cloudfront_domain_name" {
  type = string
}