module "aci_fabric_spine_interface_profile" {
  source  = "netascode/fabric-spine-interface-profile/aci"
  version = ">= 0.1.0"

  name = "SPINE1001"
}
