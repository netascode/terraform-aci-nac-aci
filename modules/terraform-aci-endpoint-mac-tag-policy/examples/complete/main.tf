module "aci_endpoint_mac_tag_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-endpoint-mac-tag-policy"
  version = "> 0.9.3"

  tenant        = "TEN1"
  mac           = "AB:CD:EF:DC:BA"
  bridge_domain = "all"
  vrf           = "TEN1-VRF"
  tags = [{
    key   = "Environment"
    value = "PROD"
  }]
}