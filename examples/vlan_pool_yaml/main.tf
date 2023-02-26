module "vlan_pool" {
  source  = "netascode/aci/aci"
  version = "0.1.0"

  yaml_files = ["vlan_pool.yaml"]

  manage_access_policies = true
}
