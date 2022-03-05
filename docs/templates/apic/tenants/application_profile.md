# Application Profile

Location in GUI:
`Tenants` » `XXX` » `Application Profiles`

### Terraform modules

* [Application Profile](https://registry.terraform.io/modules/netascode/application-profile/aci/latest)

{{ aac_doc }}

### Examples

```yaml
apic:
  tenants:
    - name: ABC
      application_profiles:
        - name: AP1
          alias: AP1-ALIAS
          description: My AP Desc
```
