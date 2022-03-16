# test_mso_deploy

This role will run all tests related to 'mso_deploy' role.

## Sample Playbook

```yaml
---
- name: MSO Deploy Tests
  hosts: mso
  gather_facts: no
 
  tasks:
    - name: MSO Deploy Tests
      ansible.builtin.include_role:
        name: cisco.aac.test_mso_deploy
```
