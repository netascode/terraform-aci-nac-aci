# Service Graph Template

Location in GUI:
`Tenants` » `XXX` » `Services` » `L4-L7` » `Service Graph Templates`


{{ doc_gen }}

### Examples

Simple example:

```yaml
apic:
  tenants:
    - name: ABC
      services:
        service_graph_templates:
          - name: TEMPLATE1
            redirect: true
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
            redirect: true
            share_encapsulation: false
            device:
              tenant: ABC
              name: DEV1
            consumer:
              direct_connect: false
            provider:
              direct_connect: true
```
