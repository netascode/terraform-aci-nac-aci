# Redirect Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `L4-L7 Policy-Based Redirect`

### Terraform modules

* [Redirect Policy](https://registry.terraform.io/modules/netascode/redirect-policy/aci/latest)

{{ aac_doc }}

### Examples

Simple example:

```yaml
apic:
  tenants:
    - name: ABC
      services:
        redirect_policies:
          - name: PBR1
            l3_destinations:
              - ip: 1.1.1.1
                mac: 00:00:00:11:22:33
```

Full example:

```yaml
apic:
  tenants:
    - name: ABC
      services:
        redirect_policies:
          - name: PBR1
            alias: PBR1
            description: My Desc
            type: L3
            anycast: disabled
            hashing: sip-dip-prototype
            threshold: disabled
            max_threshold: 0
            min_threshold: 0
            threshold_down_action: permit
            resilient_hashing: disabled
            redirect_backup_policy: L4L7_REDIRECT_BACKUP1
            l3_destinations:
              - description: My Desc
                ip: 1.1.1.1
                ip_2:
                mac: 00:00:00:11:22:33
                pod: 1
                redirect_health_group: HEALTH_GROUP_1
```
