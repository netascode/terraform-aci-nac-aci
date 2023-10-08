# Scheduler

Location in GUI:
`Admin` » `Schedulers` » `Fabric`

### Terraform modules

* [Fabric Scheduler](https://registry.terraform.io/modules/netascode/fabric-scheduler/aci/latest)

{{ doc_gen }}

### Examples

```yaml
apic:
  fabric_policies:
    schedulers:
      - name: scheduler1
        description: desc1
        recurring_windows:
          - name: window1
            day: Monday
            hour: 23
            minute: 1
```
