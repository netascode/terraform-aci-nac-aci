# apic_validate

This role validates all provided APIC data input files (typically in host_vars directory) against a [Yamale](https://github.com/23andMe/Yamale) schema. Strict validation is enforced, so no extra (not defined in schema) variables are allowed. The schema definition file is named 'apic_schema.yaml' and is placed in the 'files' directory within the role. The module is just a wrapper for the [Yamale](https://github.com/23andMe/Yamale) tool which means any output provided comes directly from this tool. A small modification to the Yamale tool was necessary to support Ansible Vault encrypted values. The necessary changes are included in this [repository](https://github.com/damarco/Yamale).

## Sample Playbook

```yaml
---
- name: Validate APIC Data
  hosts: apic
  gather_facts: no
  vars:
    path: "{{ inventory_dir }}/host_vars/{{ inventory_hostname }}"
 
  tasks:
    - name: Validate APIC Data
      ansible.builtin.include_role:
        name: cisco.aac.apic_validate
```
