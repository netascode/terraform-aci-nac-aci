# Service Graph Template

Location in GUI:
`Tenants` » `XXX` » `Services` » `L4-L7` » `Service Graph Templates`

### Terraform modules

* [Service Graph Template](https://registry.terraform.io/modules/netascode/service-graph-template/aci/latest)

{{ aac_doc }}
### Examples

Simple example:

```yaml
apic:
  tenants:
    - name: ABC
      services:
        service_graph_templates:
          - name: TEMPLATE1
            redirect: enabled
            device:
              name: DEV1
```

Full example:

```yaml
apic:
  tenants:
    - name: ABC
      services:
        service_graph_templates:
          - name: TEMPLATE1
            alias: TEMPLATE1-ALIAS
            description: My Desc
            template_type: FW_ROUTED
            redirect: enabled
            share_encapsulation: disabled
            device:
              tenant: ABC
              name: DEV1
```
