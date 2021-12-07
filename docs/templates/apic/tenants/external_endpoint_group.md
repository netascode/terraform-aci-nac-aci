# External Endpoint Group

Location in GUI:
`Tenants` » `XXX` » `Networking` » `L3outs` » `XXX` » `External EPGs`

### Terraform modules

* [External Endpoint Group](https://registry.terraform.io/modules/netascode/external-endpoint-group/aci/latest)

{{ aac_doc }}
### Examples

Simple example:

```yaml
apic:
  tenants:
    - name: ABC
      l3outs:
        - name: L3OUT1
          external_endpoint_groups:
            - name: EXT-EPG1
              subnets:
                - prefix: 0.0.0.0/0
              contracts:
                consumers:
                  - CON1
```

Full example:

```yaml
apic:
  tenants:
    - name: ABC
      l3outs:
        - name: L3OUT1
          external_endpoint_groups:
            - name: EXT-EPG1
              alias: ABC-EXT-EPG1
              description: My Desc
              preferred_group: exclude
              qos_class: level4
              target_dscp: CS5
              subnets:
                - name: ALL
                  prefix: 0.0.0.0/0
                  import_route_control: 'no'
                  export_route_control: 'no'
                  shared_route_control: 'no'
                  import_security: 'yes'
                  shared_security: 'no'
              contracts:
                consumers:
                  - CON1
                providers:
                  - CON1
                imported_consumers:
                  - IMPORT-CON1
```
