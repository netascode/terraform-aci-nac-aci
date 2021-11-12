# Forwarding Scale Switch Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Switch` » `Forwarding Scale Profiles`

### Terraform modules

* [Forwarding Scale Policy](https://registry.terraform.io/modules/netascode/forwarding-scale-policy/aci/latest)

{{ aac_doc }}
### Examples

```yaml
apic:
  access_policies:
    switch_policies:
      forwarding_scale_policies:
        - name: HIGH-DUAL-STACK
          profile: high-dual-stack
```
