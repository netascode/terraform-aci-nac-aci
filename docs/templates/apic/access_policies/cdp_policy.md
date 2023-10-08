# CDP Interface Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `CDP Interface`

### Terraform modules

* [CDP Policy](https://registry.terraform.io/modules/netascode/cdp-policy/aci/latest)

{{ doc_gen }}

### Examples

```yaml
apic:
  access_policies:
    interface_policies:
      cdp_policies:
        - name: CDP-ENABLED
          admin_state: true
```
