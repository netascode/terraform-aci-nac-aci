module "aci_end_point_retention_policy" {
  source                         = "netascode/nac-aci/aci//modules/terraform-aci-endpoint-retention-policy"
  version                        = ">= 0.9.4"
  name                           = "ERP1"
  descr                          = "Terraform"
  hold_interval                  = 6
  bounce_entry_aging_interval    = 630
  local_endpoint_aging_interval  = 900
  remote_endpoint_aging_interval = 300
  move_frequency                 = 256
}
