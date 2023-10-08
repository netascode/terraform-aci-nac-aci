# Fabric SPAN Destination Group

Location in GUI:
`Fabric` » `Fabric Policies` » `Policies` » `Troubleshooting` » `SPAN` » `SPAN Destination Groups`

{{ doc_gen }}

### Examples

```yaml
apic:
  fabric_policies:
    span:
      destination_groups:
        - name: DST_GRP1
          description: My Fabric SPAN
          tenant: ABC
          application_profile: AP1
          endpoint_group: EPG1
          ip: 1.1.1.1
          source_prefix: 1.2.3.4/32
          dscp: CS4
          flow_id: 1
          ttl: 10
          version: 2
          enforce_version: true
```
