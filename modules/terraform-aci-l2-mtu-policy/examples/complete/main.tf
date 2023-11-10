module "aci_l2_mtu_policy" {
  source  = "netascode/l2-mtu-policy/aci"
  version = ">= 0.1.0"

  name          = "L2_8950"
  port_mtu_size = 8950
}
