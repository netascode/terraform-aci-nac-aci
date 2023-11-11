module "aci_node_control_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-node-control-policy"
  version = ">= 0.8.0"

  name      = "NC1"
  dom       = true
  telemetry = "netflow"
}
