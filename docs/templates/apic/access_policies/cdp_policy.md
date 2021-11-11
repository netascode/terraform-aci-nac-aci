# CDP Interface Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `CDP Interface`

Terraform modules:

* [CDP Policy](https://github.com/netascode/terraform-aci-cdp-policy)

{{ aac_doc }}
### Examples

```yaml
apic:
  access_policies:
    interface_policies:
      cdp_policies:
        - name: CDP-ENABLED
          admin_state: enabled
```
