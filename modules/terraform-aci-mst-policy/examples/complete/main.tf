module "aci_mst_policy" {
  source  = "netascode/mst-policy/aci"
  version = ">= 0.2.0"

  name     = "MST1"
  region   = "REG1"
  revision = 1
  instances = [{
    name = "INST1"
    id   = 1
    vlan_ranges = [{
      from = 10
      to   = 20
    }]
  }]
}
