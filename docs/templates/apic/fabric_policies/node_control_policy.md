# Node Control Switch Policy

Location in GUI:
`Fabric` » `Fabric Policies` » `Policies` » `Monitoring` » `Fabric Node Controls`

### Terraform modules

* [Node Control Policy](https://registry.terraform.io/modules/netascode/node-control-policy/aci/latest)

{{ doc_gen }}

### Examples

```yaml
apic:
  fabric_policies:
    switch_policies:
      node_control_policies:
        - name: DOM_NETFLOW
          dom: true
```
