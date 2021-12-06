# Overview

The ```ansible-aac``` project provides an Ansible collection for managing and automating your Cisco ACI environment following Infrastructure as Code (IaC) principles. It consists of a set of plugins and roles to support ACI provisioning in a declarative fashion.

*Note: This collection is not compatible with versions of Ansible before v2.10.0.*

## Collection layout

    common/                 # Common files used for integration testing
    docker/                 # Dockerfile to build image with all requirements
    docs/                   # Documentation
    meta/                   # Ansible collection meta files
    playbooks/              # Playbooks to create test reports for integration tests
    plugins/                # Ansible plugins including modules
    roles/                  # Common role for modules/tasks shared across multiple roles
    requirements.txt        # Python requirements for ansible collection
    galaxy.yml              # Ansible Galaxy configuration file

## Structure

The configuration tasks (objects) are grouped according to its use. A bootstrap role is used as a way to setup prerequisites for other roles.

- **APIC Bootstrap**: This role is used to setup system users and other configurations necessary for 'apic_deploy' and 'test_apic_deploy' roles
- **APIC Deploy**: This is the main role for APIC deployment
- **MSO Bootstrap**: This role is used to setup system users and certificates necessary for 'mso_deploy' and 'test_mso_deploy' roles
- **MSO Deploy**: This is the main role for MSO deployment

Each role is then divided into three different stages.

<figure markdown>
```mermaid
%%{init: {'themeVariables': {'nodeBorder': '#009688', 'lineColor': '#009688', 'fontSize': '14px', 'fontFamily': 'Roboto'}}}%%
graph LR
    Render --> Configure
    Configure --> Delete
```
</figure>

The first stage is always the ```Render``` stage which takes the provided data input files and the configuration templates as an input and creates the rendered json configuration files. The second stage (```Configure```) will push the previously rendered configuration to APIC/MSO using the REST API. The third stage (```Delete```) will get a list of currently configured objects and compare that against the list of defined objects in the data input files. If there is an object currently configured but missing from the data input files, the object will be deleted. This is required as the second stage only handles additions and modifications.
