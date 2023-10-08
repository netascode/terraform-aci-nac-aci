# MST Switch Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Switch` » `Spanning Tree`

### Terraform modules

* [MST Policy](https://registry.terraform.io/modules/netascode/mst-policy/aci/latest)

{{ doc_gen }}

### Examples

```yaml
apic:
  access_policies:
    switch_policies:
      mst_policies:
        - name: REGION1
          region: region1
          revision: 1
          instances:
            - name: INST-1
              id: 1
              vlan_ranges:
                - from: 5
                  to: 6
```
