# ndo_deploy

This role adds/modifies/deletes NDO objects.

## Sample Playbook

```yaml
---
- name: Deploy NDO
  hosts: ndo
  gather_facts: no
 
  tasks:
    - name: NDO Deploy
      ansible.builtin.include_role:
        name: cisco.aac.ndo_deploy
```

## Classes

Class | Example
---|---
System Config | [link](../../data_model/ndo/ndo/system_config.md)
Remote Location | [link](../../data_model/ndo/ndo/remote_location.md)
Site | [link](../../data_model/ndo/ndo/site.md)
Site Fabric Connectivity | [link](../../data_model/ndo/ndo/fabric_connectivity.md)
Tenant | [link](../../data_model/ndo/ndo/tenant.md)
Schema | [link](../../data_model/ndo/schema/schema.md)
DHCP Relay Policy | [link](../../data_model/ndo/ndo/dhcp_relay.md)
DHCP Option Policy | [link](../../data_model/ndo/ndo/dhcp_option.md)
