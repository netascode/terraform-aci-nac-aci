module "aci_fabric_l2_mtu" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-l2-mtu"
  version = ">= 0.8.0"

  l2_port_mtu = 9216
}
