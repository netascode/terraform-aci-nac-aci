# test_mso_bootstrap

This role will run all tests related to 'mso_bootstrap' role.

## Sample Playbook

```yaml
---
- name: MSO Bootstrap Tests
  hosts: mso
  gather_facts: no
 
  tasks:
    - name: MSO Bootstrap Tests
      include_role:
        name: cisco.aac.test_mso_bootstrap
```
