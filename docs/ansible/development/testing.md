# Integration Testing

[Molecule](https://molecule.readthedocs.io/en/latest/) is used for testing Ansible roles. A total of two ACI Simulators and one MSO instance is used for testing, whereas the second ACI Simulator is used together with the MSO instance for site level configurations. VM snapshots are used to revert the ACI simulators to a certain state before testing and backups are used to revert the MSO state. For each scenario, typically four playbooks are involved:

- ```create.yaml```: prepares the test environment and ensures a certain state
- ```playbook.yaml```: runs the corresponding role
- ```verify.yaml```: runs the corresponding test role
- ```destroy.yaml```: empty playbook, that is needed to ensure that instances are marked as destroyed after testing

Each role has one or more scenarios defined, whereas each scenario has its own set of data input files. Each scenario typically has the following test sequence:

```yaml
test_sequence:
- syntax
- create
- converge
- idempotence
- verify
- destroy
```

The following common files are shared across multiple scenarios:

- ```common/test/bin/vault-env```: this script is needed to use an environment variable as Ansible vault password
- ```common/test/data/lab/hosts.yaml```: This is the common hosts file which references one APIC simulator and one MSO instance
- ```common/test/data/lab/group_vars/aci.yaml```: This file defines the common group_vars used for all scenarios
- ```common/test/tasks/revert_acisim1.yaml```: This playbook reverts the first ACI simulator to a certain VM snapshot ('snapshot' variable specifies the snapshot name)
- ```common/test/tasks/revert_acisim2.yaml```: This playbook reverts the second ACI simulator to a certain VM snapshot ('snapshot' variable specifies the snapshot name)
- ```common/test/tasks/revert_mso1.yaml```: This playbook initiates a rollback to a previously generated backup of the MSO instance

Two playbooks are used to summarize the test results of all scenarios:

- ```playbooks/create_apic_test_report.yaml```
- ```playbooks/create_mso_test_report.yaml```