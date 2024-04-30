# Spanning Tree Interface Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `Spanning Tree Interface`


{{ doc_gen }}

### Examples

```yaml
apic:
  access_policies:
    interface_policies:
      spanning_tree_policies:
        - name: BPDU-FILTER
          bpdu_filter: true
```
