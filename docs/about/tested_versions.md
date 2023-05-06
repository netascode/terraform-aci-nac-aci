# Tested Versions

This list provides an overview of which version of components have been tested together for a specific release.

## Release 0.7.0

### ACI

Component | Version
---|---
ACI | 4.2.x, 5.2.x, 6.0.x
NDO | 3.7.x, 4.1.x (Ansible only)

### Terraform

Component | Version
---|---
[Terraform](https://developer.hashicorp.com/terraform/downloads) | 1.4.6
[ACI Provider](https://registry.terraform.io/providers/CiscoDevNet/aci/2.5.2) | 2.7.0
[MSO Provider](https://registry.terraform.io/providers/CiscoDevNet/mso/0.9.0) | 0.9.0
[Utils Provider](https://registry.terraform.io/providers/netascode/utils/0.2.2) | 0.2.5

### Terraform Modules

Component | Version
---|---
[NaC ACI Module](https://registry.terraform.io/modules/netascode/nac-aci/aci/latest) | 0.7.0
[NaC NDO Module](https://registry.terraform.io/modules/netascode/nac-ndo/mso/latest) | 0.7.0

### Python Tools

Component | Version
---|---
[iac-validate](https://github.com/netascode/iac-validate) | 0.2.3
[iac-test](https://github.com/netascode/iac-test) | 0.2.4
[nexus-pcv](https://github.com/netascode/nexus-pcv) | 0.1.5

### Container Image for internal use

Component | Version
---|---
[danischm/aac](https://hub.docker.com/r/danischm/aac/tags) | 0.5.10

### Ansible

Component | Version
---|---
[ansible-core](https://github.com/ansible/ansible) | 2.14.5
[Robot Framework](https://robotframework.org/) | 6.0.2
[Pabot](https://pabot.org/) | 2.15.0

## Release 0.6.0

### ACI

Component | Version
---|---
ACI | 4.2.x, 5.2.x
MSO/NDO | 2.2.x, 3.7.x

### Terraform

Component | Version
---|---
[Terraform](https://developer.hashicorp.com/terraform/downloads) | 1.3.7
[ACI Provider](https://registry.terraform.io/providers/CiscoDevNet/aci/2.5.2) | 2.6.0
[Utils Provider](https://registry.terraform.io/providers/netascode/utils/0.2.2) | 0.2.4

### Terraform Modules

Component | Version
---|---
[NaC Merge Module](https://registry.terraform.io/modules/netascode/nac-merge/utils/latest) | 0.1.2
[NaC Tenant Module](https://registry.terraform.io/modules/netascode/nac-tenant/aci/latest) | 0.4.1
[NaC Access Policies Module](https://registry.terraform.io/modules/netascode/nac-access-policies/aci/latest) | 0.4.0
[NaC Fabric Policies Module](https://registry.terraform.io/modules/netascode/nac-fabric-policies/aci/latest) | 0.4.1
[NaC Pod Policies Module](https://registry.terraform.io/modules/netascode/nac-pod-policies/aci/latest) | 0.4.0
[NaC Node Policies Module](https://registry.terraform.io/modules/netascode/nac-node-policies/aci/latest) | 0.4.0
[NaC Interface Policies Module](https://registry.terraform.io/modules/netascode/nac-interface-policies/aci/latest) | 0.4.0

### Python Tools

Component | Version
---|---
[iac-validate](https://github.com/netascode/iac-validate) | 0.2.2
[iac-test](https://github.com/netascode/iac-test) | 0.2.2
[nexus-pcv](https://github.com/netascode/nexus-pcv) | 0.1.3

### Container Image for internal use

Component | Version
---|---
[danischm/aac](https://hub.docker.com/r/danischm/aac/tags) | 0.5.3

### Ansible

Component | Version
---|---
[ansible-core](https://github.com/ansible/ansible) | 2.13.7
[Robot Framework](https://robotframework.org/) | 6.0.2
[Pabot](https://pabot.org/) | 2.11.0

## Release 0.5.0

### ACI

Component | Version
---|---
ACI | 4.2.x, 5.2.x

### Terraform

Component | Version
---|---
[Terraform](https://developer.hashicorp.com/terraform/downloads) | 1.3.6
[ACI Provider](https://registry.terraform.io/providers/CiscoDevNet/aci/2.5.2) | 2.5.2
[Utils Provider](https://registry.terraform.io/providers/netascode/utils/0.2.2) | 0.2.2

### Terraform Modules

Component | Version
---|---
[NaC Tenant Module](https://registry.terraform.io/modules/netascode/nac-tenant/aci/latest) | 0.3.3
[NaC Access Policies Module](https://registry.terraform.io/modules/netascode/nac-access-policies/aci/latest) | 0.3.2
[NaC Fabric Policies Module](https://registry.terraform.io/modules/netascode/nac-fabric-policies/aci/latest) | 0.3.4
[NaC Pod Policies Module](https://registry.terraform.io/modules/netascode/nac-pod-policies/aci/latest) | 0.3.0
[NaC Node Policies Module](https://registry.terraform.io/modules/netascode/nac-node-policies/aci/latest) | 0.3.2
[NaC Interface Policies Module](https://registry.terraform.io/modules/netascode/nac-interface-policies/aci/latest) | 0.3.2

### Python Tools

Component | Version
---|---
[iac-validate](https://github.com/netascode/iac-validate) | 0.2.1
[iac-test](https://github.com/netascode/iac-test) | 0.2.2
[nexus-pcv](https://github.com/netascode/nexus-pcv) | 0.1.3

### Container Image for internal use

Component | Version
---|---
[danischm/aac](https://hub.docker.com/r/danischm/aac/tags) | 0.5.0

### Ansible

Component | Version
---|---
[ansible-core](https://github.com/ansible/ansible) | 2.13.7
[Robot Framework](https://robotframework.org/) | 6.0.1
[Pabot](https://pabot.org/) | 2.8.0
