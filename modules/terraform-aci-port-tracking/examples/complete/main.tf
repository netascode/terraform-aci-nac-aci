module "aci_port_tracking" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-port-tracking"
  version = ">= 0.8.0"

  admin_state = true
  delay       = 5
  min_links   = 2
}
