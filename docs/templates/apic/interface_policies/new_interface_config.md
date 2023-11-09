# Interface Configuration

The new interface configuration model is available from ACI 6.0(x).

Location in GUI:
`Fabric` » `Access Policies` » `Interface Configuration`

### Terraform modules

* [Interface Configuration](https://registry.terraform.io/modules/netascode/interface-configuration/aci/latest)

{{ doc_gen }}

### Examples

Simple example:

```yaml
apic:
  new_interface_configuration: true
  interface_policies:
    nodes:
      - id: 101
        interfaces:
          - port: 1
            description: interface descr 1
            policy_group: ACC1
```

Breakout port example:

```yaml
apic:
  new_interface_configuration: true
  interface_policies:
    nodes:
      - id: 101
        interfaces:
          - port: 2
            description: interface breakout 2
            breakout: 10g-4x
            sub_ports:
              - port: 1
                policy_group: ACC1
              - port: 2
                policy_group: VPC2
```
