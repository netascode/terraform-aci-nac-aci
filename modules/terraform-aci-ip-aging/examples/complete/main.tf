module "aci_ip_aging" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-ip-aging"
  version = ">= 0.8.0"

  admin_state = true
}
