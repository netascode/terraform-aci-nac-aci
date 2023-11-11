module "aci_physical_domain" {
  source  = "netascode/physical-domain/aci"
  version = ">= 0.8.0"

  name                 = "PHY1"
  vlan_pool            = "VP1"
  vlan_pool_allocation = "dynamic"
  security_domains     = ["SEC1"]
}
