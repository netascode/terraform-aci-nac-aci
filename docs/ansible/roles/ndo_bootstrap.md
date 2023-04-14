# ndo_bootstrap

This role is typically run after the initial setup of NDO instances has been completed. It ensures certain configurations which are needed to run other 'ndo_dayX' roles are in place. The following objects are created:

- Creates a user, to be used by 'ndo_deploy' rolw to apply configuration changes. This user has admin privileges.
- Creates a user (read-only privileges) for testing
- Configures a keyring

## Sample Playbook

```yaml
---
- name: Deploy NDO Bootstrap
  hosts: ndo
  gather_facts: no
 
  tasks:
    - name: NDO Bootstrap
      ansible.builtin.include_role:
        name: cisco.aac.ndo_bootstrap
```

## Classes

Class | Type | Example
-------|------|--------
Bootstrap | bootstrap | [link](../../data_model/ndo/bootstrap/bootstrap.md)
