# NDO Support Matrix

This table provides an overview of which object is supported in combination with which tool.

* **CLI** refers to the ability to render the JSON configuration using [aac-tool](../cli/overview.md)
* **Ansible** refers to the ability to deploy the object using Ansible
* **Terraform** refers to the ability to deploy the object using Terraform
* **Reverse** refers to the ability to generate YAML files from JSON configurations (e.g., NDO JSON dumps) using [aac-tool](../cli/overview.md)

### Bootstrap

<span style="display: inline-block; width:250px">Description</span> | CLI | Ansible | Terraform | Reverse
---|---|---|---|---
[Bootstrap](./ndo/bootstrap/bootstrap.md) | | :material-check: | |

### System

<span style="display: inline-block; width:250px">Description</span> | CLI | Ansible | Terraform | Reverse
---|---|---|---|---
[System Config](./ndo/ndo/system_config.md) | | :material-check: | |
[TACACS Provider](./ndo/ndo/tacacs_provider.md) | | :material-check: | |
[Login Domain](./ndo/ndo/login_domain.md) | | :material-check: | |
[Remote Location](./ndo/ndo/remote_location.md) | | :material-check: | |
[Local User](./ndo/ndo/user.md) | | :material-check: | |
[CA Certificate](./ndo/ndo/ca_certificate.md) | | :material-check: | |
[Site](./ndo/ndo/site.md) | | :material-check: | |
[Site Fabric Connectivity](./ndo/ndo/fabric_connectivity.md) | | :material-check: | |
[Tenant](./ndo/ndo/tenant.md) | | :material-check: | |
[DHCP Relay Policy](./ndo/ndo/dhcp_relay.md) | | :material-check: | |
[DHCP Option Policy](./ndo/ndo/dhcp_option.md) | | :material-check: | |

### Schema

<span style="display: inline-block; width:250px">Description</span> | CLI | Ansible | Terraform | Reverse
---|---|---|---|---
[Schema](./ndo/schema/schema.md) | | :material-check: | |
Deploy Schema | | :material-check: | |
