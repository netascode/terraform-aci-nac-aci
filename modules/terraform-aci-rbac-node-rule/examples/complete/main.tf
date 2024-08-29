module "aci_rbac_node_rule" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-rbac-node-rule"
  version = ">= 0.9.1"

  node_id = 101
  port_rules = [{
    name   = "SEC1"
    domain = "SEC1"
  }]
}
