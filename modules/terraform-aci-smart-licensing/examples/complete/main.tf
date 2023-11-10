module "aci_smart_licensing" {
  source  = "netascode/smart-licensing/aci"
  version = ">= 0.1.0"

  mode               = "proxy"
  registration_token = "ABCDEFG"
  proxy_hostname_ip  = "a.proxy.com"
  proxy_port         = "80"
}
