# SPAN Destination Groups

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Troubleshooting` » `SPAN` » `SPAN Source Groups`

### Terraform modules

* [MST](https://registry.terraform.io/modules/netascode/mst/aci/latest)

{{ aac_doc }}
### Examples

```yaml
apic:
  access_policies:
    span:
      source_groups:
        - name: INT1
          destination:
            name: TAP1
          sources:
            - name: SRC1
              direction: both
              access_paths:
                - node_id: 101
                  port: 1
```
