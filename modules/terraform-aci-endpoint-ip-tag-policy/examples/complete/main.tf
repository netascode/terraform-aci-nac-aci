module "aci_endpoint_ip_tag_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-endpoint-ip-tag-policy"
  version = "> 0.9.3"

  ip     = "1.1.1.1"
  tenant = "TEN1"
  vrf    = "TEN1-VRF"
  tags = [{
    key   = "Environment"
    value = "PROD"
  }]
}