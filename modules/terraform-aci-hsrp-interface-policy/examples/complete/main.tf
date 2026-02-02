module "aci_hsrp_interface_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-hsrp-interface-policy"
  version = ">= 0.8.0"

  tenant       = "ABC"
  name         = "HSRP_IF1"
  description  = "My Description"
  bfd_enable   = true
  use_bia      = false
  delay        = 5
  reload_delay = 10
}
