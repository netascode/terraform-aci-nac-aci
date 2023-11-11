module "aci_mcp_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-mcp-policy"
  version = ">= 0.8.0"

  name        = "MCP-OFF"
  admin_state = false
}
