module "aci_dhcp_option_policy" {
  source  = "netascode/dhcp-option-policy/aci"
  version = ">= 0.8.0"

  tenant      = "ABC"
  name        = "DHCP-OPTION1"
  description = "My Description"
  options = [{
    id   = 1
    data = "DATA1"
    name = "OPTION1"
  }]
}
