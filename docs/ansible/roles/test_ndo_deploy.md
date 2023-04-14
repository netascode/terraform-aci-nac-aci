# test_ndo_deploy

This role will run all tests related to 'ndo_deploy' role.

## Sample Playbook

```yaml
---
- name: NDO Deploy Tests
  hosts: ndo
  gather_facts: no
 
  tasks:
    - name: NDO Deploy Tests
      ansible.builtin.include_role:
        name: cisco.aac.test_ndo_deploy
```
