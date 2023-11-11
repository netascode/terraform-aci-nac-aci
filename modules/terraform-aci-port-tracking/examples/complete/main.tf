module "aci_port_tracking" {
  source  = "netascode/port-tracking/aci"
  version = ">= 0.8.0"

  admin_state = true
  delay       = 5
  min_links   = 2
}
