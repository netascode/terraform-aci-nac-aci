# External Connectivity Policy

Location in GUI:
`Tenants` » `infra` » `Policies` » `Protocol` » `Fabric Ext Connection Policies`

### Terraform modules

* [External Connectivity Policy](https://registry.terraform.io/modules/netascode/external-connectivity-policy/aci/latest)

{{ aac_doc }}

### Examples

```yaml
apic:
  fabric_policies:
    external_connectivity_policy:
      name: IPN
      site_id: 1
      bgp_password: cisco
      routing_profiles:
        - name: IPN1
          subnets:
            - 11.1.0.0/16
  pod_policies:
    pods:
      - id: 1
        data_plane_tep: 1.2.3.4
```
