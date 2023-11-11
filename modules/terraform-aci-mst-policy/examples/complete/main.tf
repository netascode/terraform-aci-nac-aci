module "aci_mst_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-mst-policy"
  version = ">= 0.8.0"

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
