# External Endpoint Group

The following table maps the subnet flags to the corresponding GUI terminology:

|Subnet Flag|GUI Terminology|
|---|---|
|`import_security`|`External Subnets for External EPG`|
|`shared_security`|`Shared Security Import Subnet`|
|`import_route_control`|`Import Route Control Subnet`|
|`export_route_control`|`Export Route Control Subnet`|
|`shared_route_control`|`Shared Route Control Subnet`|
|`aggregate_import_route_control`|`Aggregate Export`|
|`aggregate_export_route_control`|`Aggregate Import`|
|`aggregate_shared_route_control`|`Aggregate Shared Routes`|

Location in GUI:

- `Tenants` » `XXX` » `Networking` » `L3outs` » `XXX` » `External EPGs`
- `Tenants` » `XXX` » `Networking` » `SR MPLS L3outs` » `XXX` » `External EPGs`

### Terraform modules

- [External Endpoint Group](https://registry.terraform.io/modules/netascode/external-endpoint-group/aci/latest)

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
              preferred_group: false
              qos_class: level4
              target_dscp: CS5
              subnets:
                - name: ALL
                  prefix: 0.0.0.0/0
                  import_route_control: false
                  export_route_control: false
                  shared_route_control: false
                  import_security: true
                  shared_security: false
              contracts:
                consumers:
                  - CON1
                providers:
                  - CON1
                imported_consumers:
                  - IMPORT-CON1
```

SR MPLS example:

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
