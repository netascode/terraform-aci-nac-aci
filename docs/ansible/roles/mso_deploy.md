# mso_deploy

This role adds/modifies/deletes MSO objects.

## Sample Playbook

```yaml
---
- name: Deploy MSO
  hosts: mso
  gather_facts: no
 
  tasks:
    - name: MSO Deploy
      ansible.builtin.include_role:
        name: cisco.aac.mso_deploy
```

## Classes

Class | Example
---|---
System Config | [link](../../data_model/mso/mso/system_config.md)
TACACS Provider | [link](../../data_model/mso/mso/tacacs_provider.md)
Login Domain | [link](../../data_model/mso/mso/login_domain.md)
Remote Location | [link](../../data_model/mso/mso/remote_location.md)
User | [link](../../data_model/mso/mso/user.md)
CA Certificate | [link](../../data_model/mso/mso/ca_certificate.md)
Site | [link](../../data_model/mso/mso/site.md)
Site Fabric Connectivity | [link](../../data_model/mso/mso/fabric_connectivity.md)
Tenant | [link](../../data_model/mso/mso/tenant.md)
Schema | [link](../../data_model/mso/schema/schema.md)
DHCP Relay Policy | [link](../../data_model/mso/mso/dhcp_relay.md)
DHCP Option Policy | [link](../../data_model/mso/mso/dhcp_option.md)
