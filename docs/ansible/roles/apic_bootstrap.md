# apic_bootstrap

This role is typically run after the initial setup of APICs has been completed. It ensures certain configurations which are needed to run other apic_dayX roles are in place. The following objects are created:

- Creates a user, to be used by 'apic_deploy' role to apply configuration changes. This user has admin privileges and a public certificate configured, to allow signature-based authentications.
- Creates a user (read-only privileges) for testing
- Creates a user (admin privileges) to be used my MSO
- Configures an encryption passphrase to ensure that secrets are exported in backups
- Resets the 'admin' password

## Sample Playbook

```yaml
---
- name: Deploy APIC Bootstrap
  hosts: apic
  gather_facts: no
 
  tasks:
    - name: APIC Bootstrap
      ansible.builtin.include_role:
        name: cisco.aac.apic_bootstrap
```

## Classes

Class | Type | Example
-------|------|--------
Bootstrap | bootstrap | [link](../../data_model/apic/bootstrap/bootstrap.md)
