# Geolocation Policy

Location in GUI:
`Fabric` » `Fabric Policies` » `Policies` » `Geolocation`

### Terraform modules

* [Geolocation](https://registry.terraform.io/modules/netascode/geolocation/aci/latest)

{{ doc_gen }}

### Examples

```yaml
apic:
  fabric_policies:
    geolocation:
      sites:
        - name: site1
          buildings:
            - name: building1
              floors:
                - name: floor1
                  rooms:
                    - name: room1
                      rows:
                        - name: row1
                          racks:
                            - name: rack1
                              nodes:
                                - 101
                                - 102
```
