# Application Profile

The `managed` flag indicates if an application profile should be created/modified/deleted or is assumed to exist already and just acts a container for other objects. This flag is only relevant for Terraform.

Location in GUI:
`Tenants` » `XXX` » `Application Profiles`


{{ doc_gen }}

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
