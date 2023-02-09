# MSO Support Matrix

This table provides an overview of which object is supported in combination with which tool.

* **CLI** refers to the ability to render the JSON configuration using [aac-tool](../cli/overview.md)
* **Ansible** refers to the ability to deploy the object using Ansible
* **Terraform** refers to the ability to deploy the object using Terraform
* **Reverse** refers to the ability to generate YAML files from JSON configurations (e.g., MSO JSON dumps) using [aac-tool](../cli/overview.md)

### Bootstrap

Description | CLI | Ansible | Terraform | Reverse
---|---|---|---|---
[Bootstrap](./mso/bootstrap/bootstrap.md) | | :material-check: | |

### System

Description | CLI | Ansible | Terraform | Reverse
---|---|---|---|---
[System Config](./mso/mso/system_config.md) | | :material-check: | |
[TACACS Provider](./mso/mso/tacacs_provider.md) | | :material-check: | |
[Login Domain](./mso/mso/login_domain.md) | | :material-check: | |
[Remote Location](./mso/mso/remote_location.md) | | :material-check: | |
[Local User](./mso/mso/user.md) | | :material-check: | |
[CA Certificate](./mso/mso/ca_certificate.md) | | :material-check: | |
[Site](./mso/mso/site.md) | | :material-check: | |
[Site Fabric Connectivity](./mso/mso/fabric_connectivity.md) | | :material-check: | |
[Tenant](./mso/mso/tenant.md) | | :material-check: | |
[DHCP Relay Policy](./mso/mso/dhcp_relay.md) | | :material-check: | |
[DHCP Option Policy](./mso/mso/dhcp_option.md) | | :material-check: | |

### Schema

Description | CLI | Ansible | Terraform | Reverse
---|---|---|---|---
[Schema](./mso/schema/schema.md) | | :material-check: | |
Deploy Schema | | :material-check: | |
