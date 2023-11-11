module "aci_fabric_spine_interface_profile" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-spine-interface-profile"
  version = ">= 0.8.0"

  name = "SPINE1001"
}
