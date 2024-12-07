# Access Leaf Interface Policy Group

Location in GUI:
`Fabric` » `Access Policies` » `Interfaces` » `Leaf Interfaces` » `Policy Groups`


{{ doc_gen }}

### Examples

Simple example:

```yaml
apic:
  access_policies:
    leaf_interface_policy_groups:
      - name: SERVER1
        type: access
        link_level_policy: 10G
        cdp_policy: CDP-ENABLED
        lldp_policy: LLDP-ENABLED
        aaep: AAEP1
```

Full example:

```yaml
apic:
  access_policies:
    leaf_interface_policy_groups:
      - name: SERVER1
        description: "Server1"
        type: access
        link_level_policy: 10G
        cdp_policy: CDP-ENABLED
        lldp_policy: LLDP-ENABLED
        spanning_tree_policy: BPDU-FILTER
        mcp_policy: MCP-ENABLED
        l2_policy: PORT-LOCAL
        storm_control_policy: 10P
        port_channel_policy: LACP-ACTIVE
        port_channel_member_policy: FAST
        aaep: AAEP1
        netflow_monitor_policies:
          - name: MONITOR1
            ip_filter_type: ipv6
        macsec_interface_policy: MACSEC_INT1
```
