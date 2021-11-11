# MCP Interface Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `MCP Interface`

Terraform modules:

* [MCP Policy](https://github.com/netascode/terraform-aci-mcp-policy)

{{ aac_doc }}
### Examples

```yaml
apic:
  access_policies:
    interface_policies:
      mcp_policies:
        - name: MCP-ENABLED
          admin_state: enabled
```
