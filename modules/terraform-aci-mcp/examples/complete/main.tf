module "aci_mcp" {
  source  = "netascode/mcp/aci"
  version = ">= 0.1.0"

  admin_state         = true
  per_vlan            = true
  initial_delay       = 200
  key                 = "$ECRETKEY1"
  loop_detection      = 5
  disable_port_action = true
  frequency_sec       = 0
  frequency_msec      = 100
}
