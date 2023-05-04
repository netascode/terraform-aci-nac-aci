module "vlan_pool" {
  source  = "netascode/nac-aci/aci"
  version = ">= 0.7.0"

  yaml_files = ["vlan_pool.yaml"]

  manage_access_policies = true
}
