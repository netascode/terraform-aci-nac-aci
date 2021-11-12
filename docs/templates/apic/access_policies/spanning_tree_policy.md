# Spanning Tree Interface Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `Spanning Tree Interface`

### Terraform modules

* [Spanning Tree Policy](https://registry.terraform.io/modules/netascode/spanning-tree-policy/aci/latest)

{{ aac_doc }}
### Examples

```yaml
apic:
  access_policies:
    interface_policies:
      spanning_tree_policies:
        - name: BPDU-FILTER
          bpdu_filter: 'yes'
```
