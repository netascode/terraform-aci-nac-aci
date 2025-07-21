module "aci_port_tracking" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-port-tracking"
  version = ">= 0.8.0"

  CPMtu        = 9000
  APICMtuApply = true
}
