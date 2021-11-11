# Geolocation Policy

Description

{{ aac_doc }}
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
