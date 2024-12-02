# Terraform ACI SR MPLS Global Configuration

Location in GUI:
`Tenants` » `infra` » `Policies` » `Protocol` » `MPLS Global Configuration` » `default`


{{ doc_gen }}

### Examples

```yaml
apic:
  fabric_policies:
    sr_mpls_global_configuration:
      sr_global_block_minimum: 16000
      sr_global_block_maximum: 275999
```
