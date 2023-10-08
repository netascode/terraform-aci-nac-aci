# Tenant

Location in GUI:
`Application Management` » `Tenants`

{{ doc_gen }}

### Examples

On-premise Tenant:

```yaml
ndo:
  tenants:
    - name: MSO1
      description: Description
      sites:
        - APIC1
```

Azure Tenant:

```yaml
ndo:
  tenants:
    - name: AZURE1
      sites:
        - name: AZURE-SITE1
          azure_subscription_id: 11111111-1111-1111-1111-111111111111
          azure_shared_tenant: AZURE
```
