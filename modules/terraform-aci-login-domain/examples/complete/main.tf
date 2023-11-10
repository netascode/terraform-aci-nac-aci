module "aci_login_domain" {
  source  = "netascode/login-domain/aci"
  version = ">= 0.2.0"

  name        = "TACACS1"
  description = "My Description"
  realm       = "tacacs"
  tacacs_providers = [{
    hostname_ip = "10.1.1.10"
    priority    = 10
  }]
}
