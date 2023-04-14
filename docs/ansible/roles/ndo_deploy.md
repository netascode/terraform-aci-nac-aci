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
TACACS Provider | [link](../../data_model/ndo/ndo/tacacs_provider.md)
Login Domain | [link](../../data_model/ndo/ndo/login_domain.md)
Remote Location | [link](../../data_model/ndo/ndo/remote_location.md)
User | [link](../../data_model/ndo/ndo/user.md)
CA Certificate | [link](../../data_model/ndo/ndo/ca_certificate.md)
Site | [link](../../data_model/ndo/ndo/site.md)
Site Fabric Connectivity | [link](../../data_model/ndo/ndo/fabric_connectivity.md)
Tenant | [link](../../data_model/ndo/ndo/tenant.md)
Schema | [link](../../data_model/ndo/schema/schema.md)
DHCP Relay Policy | [link](../../data_model/ndo/ndo/dhcp_relay.md)
DHCP Option Policy | [link](../../data_model/ndo/ndo/dhcp_option.md)
