# Pod Policy Group

Location in GUI:
`Fabric` » `Fabric Policies` » `Pods` » `Policy Groups`

### Terraform modules

* [Fabric Pod Policy Group](https://registry.terraform.io/modules/netascode/fabric-pod-policy-group/aci/latest)

{{ aac_doc }}

### Examples

```yaml
apic:
  fabric_policies:
    pod_policy_groups:
      - name: POD1
        snmp_policy: SNMP1
        date_time_policy: NTP1
```
