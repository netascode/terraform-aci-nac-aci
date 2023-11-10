module "aci_port_channel_policy" {
  source  = "netascode/port-channel-policy/aci"
  version = ">= 0.1.0"

  name                 = "LACP-ACTIVE"
  mode                 = "active"
  min_links            = 2
  max_links            = 10
  suspend_individual   = false
  graceful_convergence = false
  fast_select_standby  = false
  load_defer           = true
  symmetric_hash       = true
  hash_key             = "src-ip"
}
