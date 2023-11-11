module "aci_dhcp_option_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-dhcp-option-policy"
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
