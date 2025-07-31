module "aci_control_plane_mtu" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-control-plane-mtu"
  version = ">= 0.8.0"

  CPMtu        = 9000
  APICMtuApply = true
}
