module "aci_route_tag_policy" {
  source  = "netascode/route-tag-policy/aci"
  version = ">= 0.1.0"

  tenant      = "TEN1"
  name        = "TAG1"
  description = "My Tag"
  tag         = 12345
}
