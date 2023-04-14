# test_ndo_bootstrap

This role will run all tests related to 'ndo_bootstrap' role.

## Sample Playbook

```yaml
---
- name: NDO Bootstrap Tests
  hosts: ndo
  gather_facts: no
 
  tasks:
    - name: NDO Bootstrap Tests
      ansible.builtin.include_role:
        name: cisco.aac.test_ndo_bootstrap
```
