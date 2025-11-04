module "aci_ospf_route_summarization_policy" {
  source = "netascode/nac-aci/aci//modules/terraform-aci-ospf-route-summarization-policy"

  tenant             = "ABC"
  name               = "OSPF_SUM1"
  description        = "My OSPF Route Summarization Policy"
  cost               = "100"
  inter_area_enabled = true
  tag                = 12345
  name_alias         = "OSPF_SUM_ALIAS"
}