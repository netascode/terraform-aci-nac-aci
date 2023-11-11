module "aci_vlan_pool" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-vlan-pool"
  version = ">= 0.8.0"

  name        = "VP1"
  description = "Vlan Pool 1"
  allocation  = "dynamic"
  ranges = [{
    description = "Range 1"
    from        = 2
    to          = 3
    allocation  = "static"
    role        = "internal"
  }]
}
