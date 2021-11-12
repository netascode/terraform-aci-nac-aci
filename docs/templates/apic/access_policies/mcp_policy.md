# MCP Interface Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `MCP Interface`

### Terraform modules

* [MCP Policy](https://registry.terraform.io/modules/netascode/mcp-policy/aci/latest)

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
