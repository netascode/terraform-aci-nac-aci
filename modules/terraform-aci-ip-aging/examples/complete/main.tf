module "aci_ip_aging" {
  source  = "netascode/ip-aging/aci"
  version = ">= 0.8.0"

  admin_state = true
}
