module "aci" {
  source = "github.com/netascode/terraform-aci-nac-aci.git?ref=main"

  yaml_directories = ["../standard", "../standard_52", "../standard_60"]

  manage_access_policies    = true
  manage_fabric_policies    = true
  manage_pod_policies       = true
  manage_node_policies      = true
  manage_interface_policies = true
  manage_tenants            = true

  write_default_values_file = "defaults.yaml"
}
