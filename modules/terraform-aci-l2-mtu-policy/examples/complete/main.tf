module "aci_l2_mtu_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-l2-mtu-policy"
  version = ">= 0.8.0"

  name          = "L2_8950"
  port_mtu_size = 8950
}
