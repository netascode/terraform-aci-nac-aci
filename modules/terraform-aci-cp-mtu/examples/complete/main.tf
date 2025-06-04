module "aci-cp-mtu" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-cp-mtu"
  version = ">= 0.8.0"

  l2_port_mtu = 9216
}