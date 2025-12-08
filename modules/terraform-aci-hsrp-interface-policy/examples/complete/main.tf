module "aci_hsrp_interface_policy" {
  source = "../.."

  tenant       = "OSPF_TEST"
  name         = "hsrp_interface_policy"
  alias        = "hsrp_if_pol"
  description  = "HSRP Interface Policy with BFD enabled"
  annotation   = "orchestrator:terraform"
  bfd_enable   = true
  use_bia      = true
  delay        = 5
  reload_delay = 10
  owner_key    = "network_team"
  owner_tag    = "production"
}