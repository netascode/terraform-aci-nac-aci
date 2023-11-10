module "aci_access_spine_interface_selector" {
  source  = "netascode/access-spine-interface-selector/aci"
  version = ">= 0.2.0"

  interface_profile = "SPINE1001"
  name              = "1-2"
  policy_group      = "ACC1"
  port_blocks = [{
    name        = "PB1"
    description = "My Description"
    from_port   = 1
    to_port     = 2
  }]
}
