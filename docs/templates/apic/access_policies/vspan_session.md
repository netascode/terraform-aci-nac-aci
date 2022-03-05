# VSPAN Session

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Troubleshooting` » `VSPAN` » `VSPAN Sessions`

{{ aac_doc }}

### Examples

```yaml
apic:
  access_policies:
    vspan:
      sessions:
        - name: SESSION1
          destination:
            name: DST_GRP1
          sources:
            - name: SRC1
              direction: both
              tenant: ABC
              application_profile: AP1
              endpoint_group: EPG1
              endpoint: 00:50:56:96:6B:4F
              access_paths:
                - node_id: 101
                  port: 1
```
