# LLDP Interface Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `LLDP Interface`

### Terraform modules

* [LLDP Policy](https://registry.terraform.io/modules/netascode/lldp-policy/aci/latest)

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
