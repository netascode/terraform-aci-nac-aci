# Access Leaf Switch Policy Group

Location in GUI:
`Fabric` » `Access Policies` » `Switches` » `Leaf Switches` » `Policy Groups`


{{ doc_gen }}

### Examples

```yaml
apic:
  access_policies:
    leaf_switch_policy_groups:
      - name: ALL_LEAFS
        forwarding_scale_policy: HIGH-DUAL-STACK
        bfd_ipv4_policy: BFD-IPV4-POLICY
        bfd_ipv6_policy: BFD-IPV6-POLICY
```
