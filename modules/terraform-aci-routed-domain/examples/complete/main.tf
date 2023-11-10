module "aci_routed_domain" {
  source  = "netascode/routed-domain/aci"
  version = ">= 0.1.1"

  name                 = "RD1"
  vlan_pool            = "VP1"
  vlan_pool_allocation = "dynamic"
  security_domains     = ["SEC1"]
}
