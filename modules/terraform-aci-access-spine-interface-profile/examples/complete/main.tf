module "aci_access_spine_interface_profile" {
  source  = "netascode/access-spine-interface-profile/aci"
  version = ">= 0.8.0"

  name = "SPINE1001"
}
