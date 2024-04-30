# MCP Global Instance

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Global` » `MCP Instance Policy default`


{{ doc_gen }}

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
      action: false
      admin_state: true
      key: cisco
      frequency_sec: 5
      initial_delay: 300
      loop_detection: 5
      per_vlan: false
```
