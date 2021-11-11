# selective_loop

This callback plugin can be used to streamline the standard output when executing playbooks. It is based on the [selective](https://docs.ansible.com/ansible/latest/collections/community/general/selective_callback.html) callback plugin included in ansible but adds support for loops. Otherwise it behaves exactly the same.

The plugin can be used by adding the following lines to the ```ansible.cfg```file.

```
[defaults]
stdout_callback = cisco.aac.selective_loop
```
