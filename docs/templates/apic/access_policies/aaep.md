# AAEP

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Global` » `Attachable Access Entity Profiles`

### Terraform modules

* [AAEP](https://registry.terraform.io/modules/netascode/aaep/aci/latest)

{{ aac_doc }}
### Examples

```yaml
apic:
  access_policies:
    aaeps:
      - name: AAEP1
        infra_vlan: enabled
        physical_domains:
          - PHY1
        routed_domains:
          - ROUTED1
        vmware_vmm_domains:
          - VMM1
        endpoint_groups:
          - tenant: ABC
            application_profile: AP1
            endpoint_group: EPG1
            vlan: 1234
            mode: untagged
            deployment_immediacy: immediate
```
