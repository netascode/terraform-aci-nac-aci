# MCP Global Instance

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Global` » `MCP Instance Policy default`

### Terraform modules

* [MCP](https://registry.terraform.io/modules/netascode/mcp/aci/latest)

{{ aac_doc }}
### Examples

Simple example:

```yaml
apic:
  access_policies:
    mcp:
      key: cisco
```

Full example:

```yaml
apic:
  access_policies:
    mcp:
      action: disabled
      admin_state: enabled
      key: cisco
      frequency_sec: 5
      initial_delay: 300
      loop_detection: 5
      per_vlan: disabled
```
