# SR MPLS External Endpoint Group

Location in GUI:
`Tenants` » `XXX` » `Networking` » `SR MPLS L3outs` » `XXX` » `External EPGs`

{{ aac_doc }}

### Examples


```yaml
apic:
  tenants:
    - name: ABC
      sr_mpls_l3outs:
        - name: ABC_SR_MPLS_L3OUT 
          external_endpoint_groups:
            - name: ext-epg
              subnets:
                - name: ALL
                  prefix: 0.0.0.0/0
                  route_leaking: true
                  security: true
                  aggregate_shared_route_control: true
              contracts:
                consumers:
                  - CON1
                providers:
                  - CON1
                imported_consumers:
                  - IMPORT-CON1
```
