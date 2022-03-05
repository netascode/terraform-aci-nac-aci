# VSPAN Destination Group

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Troubleshooting` » `VSPAN` » `VSPAN Destination Groups`

{{ aac_doc }}

### Examples

```yaml
apic:
  access_policies:
    vspan:
      destination_groups:
        - name: DST_GRP1
          destinations:
            - name: DST1
              tenant: ABC
              application_profile: AP1
              endpoint_group: EPG1
              endpoint: 00:50:56:96:6B:4F
```
