# test_apic_deploy

This role will run all tests related to 'apic_deploy' role.

## Sample Playbook

```yaml
---
- name: APIC Deploy Tests
  hosts: apic
  gather_facts: no
 
  tasks:
    - name: APIC Deploy Tests
      ansible.builtin.include_role:
        name: cisco.aac.test_apic_deploy
```
