# Bootstrap

Bootstrap is only used with Ansible and uses the initial admin credentials to provision a set of local users. Optionally a list of objects to be deleted can be provided.

{{ aac_doc }}

### Examples

```yaml
apic:
  bootstrap:
    admin_username: admin
    admin_password: cisco
```
