module "aci_fabric_span_source_group" {
  source      = "netascode/fabric-span-source-group/aci"
  version     = ">= 0.1.0"
  name        = "SPAN1"
  description = "My Test Fabric Span Source Group"
  admin_state = false
  sources = [
    {
      name        = "SRC1"
      description = "Source1"
      direction   = "both"
      span_drop   = "no"
      tenant      = "TEN1"
      vrf         = "VRF1"
      fabric_paths = [
        {
          node_id = 1001
          port    = 1
        }
      ]
    },
    {
      name          = "SRC2"
      description   = "Source2"
      direction     = "in"
      span_drop     = "no"
      tenant        = "TEN1"
      bridge_domain = "BD1"
      fabric_paths = [
        {
          node_id = 101
          port    = 49
        },
      ]
    }
  ]
  destination_name        = "DESTINATION1"
  destination_description = "My Destination"
}
