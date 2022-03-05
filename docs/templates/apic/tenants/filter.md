# Filter

Location in GUI:
`Tenants` » `XXX` » `Contracts` » `Filters`

### Terraform modules

* [Filter](https://registry.terraform.io/modules/netascode/filter/aci/latest)

{{ aac_doc }}

### Examples

Simple example:

```yaml
apic:
  tenants:
    - name: ABC
      filters:
        - name: FILTER1
          entries:
            - name: HTTP
              ethertype: ip
              protocol: tcp
              destination_from_port: 80
              stateful: true
```

Full example:

```yaml
apic:
  tenants:
    - name: ABC
      filters:
        - name: FILTER1
          alias: ABC-FILTER1
          description: My Desc
          entries:
            - name: ENTRY1
              alias: ENTRY1-ALIAS
              ethertype: ip
              protocol: tcp
              source_from_port: 80
              source_to_port: 80
              destination_from_port: 80
              destination_to_port: 80
              stateful: true
```
