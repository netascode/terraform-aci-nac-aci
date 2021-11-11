# mso_common

This role has several tasks/templates/variables that are used by more than one MSO role (eg. 'mso_deploy' and 'test_mso_deploy').

## Templates

### mso_common.robot

This template has common parts that are shared across all MSO test cases. It also includes the definition of the 'Login MSO' keyword, which handles username/password based authentication.

## Variables

### mso_defaults.yaml

This variable file has all the default values that can be customized for MSO. All other MSO roles include this variable file and refer to its values. It also includes the definition of object name suffixes which will be consistently appended to ACI names as specified in data input files.

## Tasks

The following common tasks are defined, which are then used by the 'mso_deploy' role:

- **mso_render_stage.yaml**: This is the first stage that renders the configurations for each object using the corresponding template and the provided data input files. This stage is always run for all objects.
- **mso_config_stage.yaml**: This stage uses the previously rendered configurations and pushes them using the 'mso_rest' module.
- **mso_delete_stage.yaml**: This stage uses the 'mso_delete' module and deletes objects from MSO if they are not included in the data input files.

The following common tasks are defined, which are then used by 'test_mso_bootstrap' and 'test_mso_deploy' roles:

- **test_mso_render_common.yaml**: This task renders the 'mso_common.robot' template
- **test_mso_render_stage.yaml**: This stage renders the test suites for each object using the corresponding robot template and the provided data input files. The 'mso_resolve' module is used to resolve ID placeholders in a second step.

These tasks are expected to be called from loops (see 'tasks/main.yaml' in 'mso_deploy' or 'test_mso_deploy' role for an example).
