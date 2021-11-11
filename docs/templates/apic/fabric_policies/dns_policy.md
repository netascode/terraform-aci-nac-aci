# DNS Profile Policy

Description

{{ aac_doc }}
### Examples

```yaml
apic:
  fabric_policies:
    dns_policies:
      - name: DNS-1
        mgmt_epg: oob
        providers:
          - ip: 1.1.1.1
            preferred: 'yes'
        domains:
          - name: cisco.com
            default: 'yes'
```
