module "aci_l4l7_device" {
  source  = "netascode/l4l7-device/aci"
  version = ">= 0.2.0"

  tenant          = "ABC"
  name            = "DEV1"
  alias           = "DEV1-ALIAS"
  context_aware   = "multi-Context"
  type            = "PHYSICAL"
  function        = "GoTo"
  copy_device     = false
  managed         = false
  service_type    = "FW"
  trunking        = false
  physical_domain = "PD1"
  concrete_devices = [{
    name  = "CDEV1"
    alias = "CDEV1-ALIAS"
    interfaces = [{
      name     = "CINT1"
      alias    = "CINT1-ALIAS"
      pod_id   = 2
      node_id  = 101
      node2_id = 102
      channel  = "VPC1"
    }]
  }]
  logical_interfaces = [{
    name  = "INT1"
    alias = "INT1-ALIAS"
    vlan  = 10
    concrete_interfaces = [{
      device    = "CDEV1"
      interface = "CINT1"
    }]
  }]
}
