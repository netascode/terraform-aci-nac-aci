module "aci_mcp_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-mcp-policy"
  version = ">= 0.8.0"

  name                   = "MCP-STRICT"
  admin_state            = true
  per_vlan_mcp           = true
  strict_mode            = true
  max_vlans              = 256
  grace_period           = 5
  grace_period_msec      = 500
  strict_init_delay_time = 180
  strict_tx_freq         = 2
  strict_tx_freq_msec    = 0
}
