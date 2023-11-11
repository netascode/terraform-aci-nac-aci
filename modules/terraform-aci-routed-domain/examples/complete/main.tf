module "aci_routed_domain" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-routed-domain"
  version = ">= 0.8.0"

  name                 = "RD1"
  vlan_pool            = "VP1"
  vlan_pool_allocation = "dynamic"
  security_domains     = ["SEC1"]
}
