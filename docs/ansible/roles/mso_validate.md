# mso_validate

This role validates all provided MSO data input files (typically in host_vars directory) against a [Yamale](https://github.com/23andMe/Yamale) schema. Strict validation is enforced, so no extra (not defined in schema) variables are allowed. The schema definition file is named 'mso_schema.yaml' and is placed in the 'files' directory within the role.

## Sample Playbook

```yaml
---
- name: Validate MSO Data
  hosts: mso
  gather_facts: no
  vars:
    path: "{{ inventory_dir }}/host_vars/{{ inventory_hostname }}"
 
  tasks:
    - name: Validate MSO Data
      ansible.builtin.include_role:
        name: cisco.aac.mso_validate
```
