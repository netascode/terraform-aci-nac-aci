module "aci_fabric_l2_mtu" {
  source  = "netascode/fabric-l2-mtu/aci"
  version = ">= 0.8.0"

  l2_port_mtu = 9216
}
