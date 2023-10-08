# Pod Setup

Location in GUI:
`Fabric` » `Inventory` » `Pod Fabric Setup Policy`

### Terraform modules

* [Pod Setup](https://registry.terraform.io/modules/netascode/pod-setup/aci/latest)

{{ doc_gen }}

### Examples

```yaml
apic:
  pod_policies:
    pods:
      - id: 1
      - id: 2
        tep_pool: 10.1.0.0/16
        external_tep_pools:
          - prefix: 172.16.1.0/24
            reserved_address_count: 2
        remote_pools:
          - id: 1
            remote_pool: 10.2.0.0/24
```
