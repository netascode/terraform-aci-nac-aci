# L2 MTU

Location in GUI:
`Fabric` » `Fabric Policies` » `Global` » `Fabric L2 MTU` » `default`

{{ doc_gen }}

### Examples

```yaml
apic:
  fabric_policies:
    l2_port_mtu: 9216
```

```yaml
apic:
  fabric_policies:
    l2_mtu_policies:
      - name: L2_8950
        port_mtu_size: 8950
```