# EP Loop Protection

Location in GUI:
`System` » `System Settings` » `Endpoint Controls`

### Terraform modules

* [Endpoint Loop Protection](https://registry.terraform.io/modules/netascode/endpoint-loop-protection/aci/latest)

{{ doc_gen }}

### Examples

```yaml
apic:
  fabric_policies:
    ep_loop_protection:
      admin_state: true
      detection_interval: 180
      detection_multiplier: 10
      action: port-disable
```
