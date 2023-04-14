# mso_bootstrap

This role is typically run after the initial setup of MSO instances has been completed. It ensures certain configurations which are needed to run other 'mso_dayX' roles are in place. The following objects are created:

- Creates a user, to be used by 'mso_deploy' rolw to apply configuration changes. This user has admin privileges.
- Creates a user (read-only privileges) for testing
- Configures a keyring

## Sample Playbook

```yaml
---
- name: Deploy MSO Bootstrap
  hosts: mso
  gather_facts: no
 
  tasks:
    - name: MSO Bootstrap
      ansible.builtin.include_role:
        name: cisco.aac.mso_bootstrap
```

## Classes

Class | Type | Example
-------|------|--------
Bootstrap | bootstrap | [link](../../data_model/ndo/bootstrap/bootstrap.md)
