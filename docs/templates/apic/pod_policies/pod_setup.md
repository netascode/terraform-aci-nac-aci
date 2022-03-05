# Pod Setup

Location in GUI:
`Fabric` » `Inventory` » `Pod Fabric Setup Policy`

### Terraform modules

* [Pod Setup](https://registry.terraform.io/modules/netascode/pod-setup/aci/latest)

{{ aac_doc }}

### Examples

```yaml
apic:
  pod_policies:
    pods:
      - id: 1
      - id: 2
        tep_pool: 10.1.0.0/16
```
