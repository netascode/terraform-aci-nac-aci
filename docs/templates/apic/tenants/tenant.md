# Tenant

The `managed` flag indicates if a tenant should be created/modified/deleted or is assumed to exist already and just acts a container for other objects. This flag is only relevant for Terraform.

Location in GUI:
`Tenants`


{{ doc_gen }}

### Examples

```yaml
apic:
  tenants:
    - name: ABC
      alias: ABC-ALIAS
      description: My Description
      security_domains:
        - SECURITY-DOMAIN1
```
