# test_apic_bootstrap

This role will run all tests related to 'apic_bootstrap' role. It will verify that bootstrap configuration according to the data input files is in place (eg. necessary users created).

## Sample Playbook

```yaml
---
- name: Test APIC Bootstrap
  hosts: apic
  gather_facts: no
 
  tasks:
    - name: APIC Bootstrap Tests
      include_role:
        name: cisco.aac.test_apic_bootstrap
```
