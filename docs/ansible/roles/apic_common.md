# apic_common

This role has several tasks/templates/variables that are used by more than one APIC role (eg. 'apic_deploy' and 'test_apic_deploy').

## Templates

### apic_common.robot

This template has common parts that are shared across all APIC test cases. It also includes the definition of the 'Login APIC' keyword, which handles username/password based authentication.

## Variables

### apic_defaults.yaml

This variable file has all the default values that can be customized for APIC. All other APIC roles include this variable file and refer to its values.

## Tasks

The following common tasks are defined, which are then used by the 'apic_deploy' role:

- **apic_render_stage.yaml**: This is the first stage that renders the configurations for each object using the corresponding template and the provided data input files. This stage is always run for all objects.
- **apic_config_stage.yaml**: This stage uses the previously rendered configurations and pushes them using the REST API to APIC.
- **apic_delete_stage.yaml**: This stage uses the aci_delete module and deletes objects from APIC if they are not included in the data input files.

The following common tasks are defined, which are then used by 'test_apic_bootstrap' and 'test_apic_deploy' roles:

- **test_apic_render_common.yaml**: This task renders the apic_common.robot template
- **test_apic_render_stage.yaml**: This stage renders the test suites for each object using the corresponding robot template and the provided data input files.
