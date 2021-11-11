# apic_snapshot

This role creates an APIC snapshot. It is a wrapper for the existing ACI Ansible [module](https://docs.Ansible.com/Ansible/latest/collections/cisco/aci/aci_config_snapshot_module.html).

## Sample Playbook

```yaml
---
- name: APIC Snapshot
  hosts: apic
  gather_facts: no
 
  tasks:
    - name: APIC Snapshot
      include_role:
        name: cisco.aac.apic_snapshot
```
