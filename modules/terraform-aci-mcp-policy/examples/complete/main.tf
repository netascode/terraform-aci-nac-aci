module "aci_mcp_policy" {
  source  = "netascode/mcp-policy/aci"
  version = ">= 0.8.0"

  name        = "MCP-OFF"
  admin_state = false
}
