module "aci_l2_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-l2-policy"
  version = ">= 0.8.0"

  name             = "L2POL1"
  vlan_scope       = "portlocal"
  qinq             = "edgePort"
  reflective_relay = true
}
