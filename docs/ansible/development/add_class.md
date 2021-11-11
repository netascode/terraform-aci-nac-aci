# Adding support for a new class

A typical workflow to add support for a new class:

1. Update Yamale schema in ```apic_validate``` role
2. Add jinja2 template to respective role and folder, eg. ```apic_deploy``` role, ```templates/access_policies/``` folder
3. Add default values to ```apic_defaults.yaml``` file in ```apic_common``` role
4. Add a reference to the newly created template to ```apic_objects.yaml``` file in respective role, eg. ```apic_deploy```
5. Add jinja2 templates for test cases to respective role and folder, eg. ```test_apic_deploy``` role, ```templates/config/access_policies/``` folder
6. Add a reference to the newly created template to ```apic_objects.yaml``` file in respective role, eg. ```apic_deploy```
7. Add a reference to the newly created test template to ```apic_objects.yaml``` file in respective role, eg. ```test_apic_deploy```
8. Update molecule test scenarios in respective role to cover newly added functionality, eg. ```apic_deploy```
