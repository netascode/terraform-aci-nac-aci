# ND RA Prefix Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `ND RA Prefix`

{{ aac_doc }}

### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        nd_ra prefix_policies:
          - name: ND-RA-PREFIX1
            auto_configuration: true
            on_link: true
```
