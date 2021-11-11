# template_local

This action plugin is a modification of the original [template](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/template_module.html) plugin optimized for local (ansible controller) operations. Instead of using the copy module to move files between the controller and the target system, the native ```shutil.copyfile()``` is used.

The plugin is used together with the [template_local](modules/template_local) module.
