# LLDP Interface Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `LLDP Interface`

Terraform modules:

* [LLDP Policy](https://github.com/netascode/terraform-aci-lldp-policy)

{{ aac_doc }}
### Examples

```yaml
apic:
  access_policies:
    interface_policies:
      lldp_policies:
        - name: LLDP-ENABLED
          admin_rx_state: enabled
          admin_tx_state: enabled
```
