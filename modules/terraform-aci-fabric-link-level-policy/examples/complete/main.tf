module "aci_fabric_link_level_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-link-level-policy"
  version = ">= 0.0.1"

  name         = "name"
  descr        = "My Description"
  linkDebounce = 1000
}
