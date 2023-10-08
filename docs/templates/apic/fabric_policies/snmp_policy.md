# SNMP Pod Policy

Location in GUI:
`Fabric Policies` » `Policies` » `Pod` » `SNMP`

### Terraform modules

* [SNMP Policy](https://registry.terraform.io/modules/netascode/snmp-policy/aci/latest)

{{ doc_gen }}

### Examples

Simple example:

```yaml
apic:
  fabric_policies:
    pod_policies:
      snmp_policies:
        - name: SNMP1
          communities:
            - abcABC123
          clients:
            - name: CLIENTS
              entries:
                - name: NMS1
                  ip: 1.1.1.1
```

Full example:

```yaml
apic:
  fabric_policies:
    pod_policies:
      snmp_policies:
        - name: SNMP1
          admin_state: true
          location: LOCATION
          contact: CONTACT
          users:
            - name: USER1
              privacy_type: aes-128
              privacy_key: Key123456
              authorization_type: hmac-sha1-96
              authorization_key: Key123456
          communities:
            - abcABC123
          clients:
            - name: CLIENTS
              mgmt_epg: inb
              entries:
                - name: NMS1
                  ip: 1.1.1.1
```
