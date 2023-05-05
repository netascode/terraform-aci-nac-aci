# Overview

All Terraform modules are open-sourced and freely available from the public Terraform registry. Various integrations for automated testing, NAE/NDI, etc. are part of a CX developed solution.

<figure markdown>
  ![Solution Overview](../assets/tf_solution_overview.png){ width="800" }
</figure>

## Structure

One of the key principles of *ACI as Code* is to provide complete separation of data (*variable definition*) from logic (*infrastructure declaration*). This is achieved by separating the *.yaml files which contain the desired ACI state from the Terraform modules which map the definition of the desired state to Terraform modules and resources.

```shell
$ tree -L 2
.
├── data
│   ├── apic.yaml
│   ├── access_policies.yaml
│   ├── fabric_policies.yaml
│   ├── node_policies.yaml
│   ├── pod_policies.yaml
│   ├── node_1001.yaml
│   ├── node_101.yaml
│   ├── node_102.yaml
│   ├── tenant_PROD.yaml
│   └── defaults.yaml
└── main.tf
```

## ACI Provider

The following Terraform provider is being used together with the *ACI as Code* solution: [link](https://registry.terraform.io/providers/CiscoDevNet/aci/latest)

The provider includes an `aci_rest_managed` resource which can be used to manage any ACI object. A simple example of how to use the resource can be found below:

```Terraform
resource "aci_rest_managed" "fvTenant" {
  dn         = "uni/tn-EXAMPLE_TENANT"
  class_name = "fvTenant"
  content = {
    name  = "EXAMPLE_TENANT"
    descr = "Example description"
  }
}
```

The `aci_rest_managed` resource is not only capable of pushing a configuration but also reading its state and reconcile configuration drift.

## ACI Modules

A Terraform module is a container for multiple resources that are used together. Modules can be used to create lightweight abstractions. While a Terraform resource represents a single API object (single MO in case of ACI), a Terraform Module consists of multiple resources (a branch of MOs in case of ACI).

The modules can be found here: [link](https://registry.terraform.io/search/modules?q=netascode)

A simple example of using one of the modules can be found below:

```Terraform
module "aci_contract" {
  source  = "netascode/contract/aci"
  version = ">= 0.0.1"

  tenant      = "ABC"
  name        = "CONTRACT1"
  subjects = [{
    name          = "SUBJECT1"
    filters = [{
      filter   = "HTTP"
    }]
  }]
}
```

## *Nexus-as-Code* Module

The *Nexus-as-Code* Terraform module is responsible for mapping the data to the corresponding ACI modules. The configuration is divided into six high level sections:

- `fabric_policies`: Configurations applied at the fabric level (e.g., fabric BGP route reflectors)
- `access_policies`: Configurations applied to external facing (downlink) interfaces (e.g., VLAN pools)
- `pod_policies`: Configurations applied at the pod level (e.g., TEP pool addresses)
- `node_policies`: Configurations applied at the node level (e.g., OOB node management address)
- `interface_policies`: Configurations applied at the interface level (e.g., assigning interface policy groups to physical ports)
- `tenants`: Configurations applied at the tenant level (e.g., VRFs and Bridge Domains)

Instead of hardcoding or spreading the definition of default values across different modules, a single file [defaults.yaml](https://wwwin-github.cisco.com/netascode/terraform-aac/blob/master/data/defaults.yaml) is used to define all default values in a central location.

This file is typically customized to reflect the specific customer requirements and reduces the overall size of input files as optional parameters with a default value can be ommited. As some customers prefer to append suffixes to object names, such suffixes can be defined once in `defaults.yaml` and then consistently appended to all objects of a specific type including its references.

## CI/CD Integration

The following templates for various CI/CD platforms are provided:

- [Jenkins](https://www.jenkins.io/): <https://wwwin-github.cisco.com/netascode/terraform-aac/blob/master/Jenkinsfile>
- [GitLab](https://gitlab.com/): <https://wwwin-github.cisco.com/netascode/terraform-aac/blob/master/.gitlab-ci.yml>
- [Drone](https://www.drone.io/): <https://wwwin-github.cisco.com/netascode/terraform-aac/blob/master/.drone.yml>

## Pre-Change Validation

Syntax validation ensures that the input data is syntactically correct, which is verified by [Yamale](https://github.com/23andMe/Yamale) and a corresponding schema. The [schema](https://wwwin-github.cisco.com/netascode/aac/blob/master/schemas/apic_schema.yaml) specifies the expected structure, input value types (String, Enum, IP, etc.) and additional constraints (eg. value ranges, regexes, etc.).

A sample schema can be found below:

```yaml
---
apic: include('apic', required=False)
---
apic:
  tenants: list(include('tenant'), required=False)

tenant:
  name: regex('^[a-zA-Z0-9_.:-]{1,64}$’)
  vrfs: list(include('ten_vrf'), required=False)

ten_vrf:
  name: regex('^[a-zA-Z0-9_.:-]{1,64}$’)
  alias: regex('^[a-zA-Z0-9_.:-]{1,64}$', required=False)
  data_plane_learning: enum('enabled', 'disabled', required=False)
  enforcement_direction: enum('ingress', 'egress', required=False)
```

Semantic validation is about verifying specific data model related constraints like referential integrity. It can be implemented using a rule based model like commonly done with linting tools. Examples are:

- Check uniqueness of key values (e.g., Node IDs)
- Check references/relationships between objects (e.g., Interface Policy Group referencing a CDP Policy)

To perform syntactic and semantic validation, [iac-validate](https://github.com/netascode/iac-validate) can be used.

```shell
iac-validate ./data/
```

## NDI Integration

Cisco NDI offers a feature called *Pre-Change Validation* which allows assessing the impact of a planned change before applying it to the infrastructure.

A Python [tool](https://github.com/netascode/nexus-pcv) renders the JSON configuration of a planned change from the `terraform plan` output and pushes it to NDI to trigger a Pre-Change Validation.

```shell
terraform plan -out=plan.tfplan
terraform show -json plan.tfplan > plan.json
nexus-pcv --hostname-ip 10.0.0.1 --username admin --password Cisco123 --group <yoursitegroup> --site <yourfabric> --name pcv123 --nac-tf-plan plan.json --output-summary output-summary.txt --output-url output-url.txt
```

## Automated Testing

To perform automated testing, [iac-test](https://github.com/netascode/iac-test) can be used to dynamically render the [Robot](https://robotframework.org/) test suites and subsequently execute them using [Pabot](https://pabot.org/).

Test suites can be categorized in three groups:

- *Configuration Tests*: verify if the desired configuration is in place
- *Health Tests*: leverage the in-built APIC/MSO fault correlation to retrieve faults and health scores and compare them against thresholds
- *Operation Tests*: verify operational state according to input data, eg. BGP peering state

Furthermore test suites are considered critical or non-critical:

- *Critical Tests*: test cases that solely depend on the ACI environment, e.g., Configuration Tests
- *Non-critical Tests*: test cases that potentially have dependencies outside of ACI, eg. BGP peering state

A failed non-critical test does not impact the overall test result in contrast to a critical test.

```shell
export ACI_URL="https://10.1.1.100"
export ACI_USERNAME=admin
export ACI_PASSWORD=password
iac-test --data ./data --data ./defaults.yaml --templates ./tests/templates --filters ./tests/filters --output ./tests/results/aci
```

After applying  changes with `terraform apply`, a subsequent `terraform plan` (using the same infrastructure code) is expected to return with no changes.
This test can be integrated into a CI/CD workflow by using the `-detailed-exitcode` flag when executing `terraform plan` which will return a non-zero exit code if changes are detected.

```shell
$ terraform plan -detailed-exitcode
No changes. Infrastructure is up-to-date.
```

## ChatOps

A sample integration with [Webex](https://www.webex.com/) can be found in the respective CI/CD pipeline templates.

## ACI to Code

[aac-tool](../../cli/overview/) can be used to directly create YAML inventory files from an existing APIC configuration snapshot.
