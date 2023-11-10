module "aci_l2_policy" {
  source  = "netascode/l2-policy/aci"
  version = ">= 0.1.0"

  name             = "L2POL1"
  vlan_scope       = "portlocal"
  qinq             = "edgePort"
  reflective_relay = true
}
