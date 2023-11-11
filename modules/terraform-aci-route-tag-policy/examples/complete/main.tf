module "aci_route_tag_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-route-tag-policy"
  version = ">= 0.8.0"

  tenant      = "TEN1"
  name        = "TAG1"
  description = "My Tag"
  tag         = 12345
}
