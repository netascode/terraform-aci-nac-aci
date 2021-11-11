# BGP Best Path Policy

Description

{{ aac_doc }}
### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        bgp_best_path_policies:
          - name: BGP-BEST-PATH1
            control_type: multi-path-relax
```
