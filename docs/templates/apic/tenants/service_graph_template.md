# Service Graph Template

Description

{{ aac_doc }}
### Examples

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
