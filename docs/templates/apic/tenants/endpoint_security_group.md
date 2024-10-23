# Endpoint Security Group

Location in GUI:
`Tenants` » `XXX` » `Application Profiles` » `XXX` » `Endpoint Security Groups`


{{ doc_gen }}

### Examples

Simple example:

```yaml
apic:
  tenants:
    - name: ABC
      application_profiles:
        - name: AP1
          endpoint_security_groups:
            - name: ESG1
              vrf: VRF1
              contracts:
                consumers:
                  - CON1
                providers:
                  - CON2
              ip_subnet_selectors:
                - value: 10.1.1.0/24
                  description: IP Subnet Selector 1
```

Full example:

```yaml
apic:
  tenants:
    - name: ABC
      application_profiles:
        - name: AP1
          endpoint_security_groups:
            - name: ESG1
              description: ESG1 description
              vrf: VRF1
              shutdown: true
              intra_esg_isolation: true
              preferred_group: true
              contracts:
                consumers:
                  - CON3
                providers:
                  - CON3
                imported_consumers:
                  - IMPORTED-CON1
                intra_esgs:
                  - CON3
                masters:
                  - application_profile: AP1
                    endpoint_security_group: ESG2
              tag_selectors:
                - key: KEY1
                  operator: contains
                  value: VALUE1
                  description: TAG Selector 1
              epg_selectors:
                - application_profile: AP1
                  endpoint_group: EPG1
                  description: EPG Selector 1
              ip_subnet_selectors:
                - value: 10.1.1.0/24
                  description: IP Subnet Selector 1
```
