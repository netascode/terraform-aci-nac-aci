module "aci_access_spine_interface_profile" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-spine-interface-profile"
  version = ">= 0.8.0"

  name = "SPINE1001"
}
