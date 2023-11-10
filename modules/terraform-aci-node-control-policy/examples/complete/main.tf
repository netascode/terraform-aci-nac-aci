module "aci_node_control_policy" {
  source  = "netascode/node-control-policy/aci"
  version = ">= 0.1.0"

  name      = "NC1"
  dom       = true
  telemetry = "netflow"
}
