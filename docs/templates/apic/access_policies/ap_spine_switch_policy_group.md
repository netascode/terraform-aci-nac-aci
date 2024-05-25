# Access Spine Switch Policy Group

Location in GUI:
`Fabric` » `Access Policies` » `Switches` » `Spine Switches` » `Policy Groups`

{{ doc_gen }}

### Examples

```yaml
apic:
  access_policies:
    spine_switch_policy_groups:
      - name: ALL_SPINES
        lldp_policy: LLDP-ENABLED
        bfd_ipv4_policy: BFD-IPV4-POLICY
        bfd_ipv6_policy: BFD-IPV6-POLICY
```
