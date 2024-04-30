# DNS Profile Policy

Location in GUI:
`Fabric` » `Fabric Policies` » `Policies` » `Global` » `DNS Profiles`


{{ doc_gen }}

### Examples

```yaml
apic:
  fabric_policies:
    dns_policies:
      - name: DNS-1
        mgmt_epg: oob
        providers:
          - ip: 1.1.1.1
            preferred: true
        domains:
          - name: cisco.com
            default: true
```
