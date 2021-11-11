# host_vars_merge

This vars plugin is based on the default [host_group_vars](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/host_group_vars_vars.html) plugin used by ansible, but differs in the way it deals with lists and dictionaries defined in multiple places. By default (without using this plugin), if a list/dictionary with the same name is defined again, it will replace the original list/dictionary. Using this plugin lists/dictionaries will be merged instead.

The plugin can be used by adding the following lines to the ```ansible.cfg```file.

```
[defaults]
vars_plugins_enabled = cisco.aac.host_vars_merge
```
