# Run Terraform AAC manually

## Goal

Get familiar with Terraform AAC and be able to run it manually against an ACI Simulator

## Pre-requisites

- Use an IDE of your choice. This tutorial will assume Visual Studio Code
- Git installed
- Access to GitLab server
- Access to ACI Simulator

## Time Estimate

1h

## Lab Overview and Credentials

Each Lab pod will operate as a self contained unit consisting of the following components:

- 1x Control VM hosting the required software components (Git, Ansible, Robot, CI/CD Platform, etc.) that the ACI as Code solution are build upon
- 1x ACI Simulator

You will be able to access the instances on the following addresses:

- GitLab: <https://CONTROLLER_IP>
- ACI simulator: <https://APIC_IP>

The control VM and ACI simulator can be accessed using the following credentials.

| VM         | Username | Password |
| ---------- | -------- | -------- |
| Control VM | lab      | cisco123 |
| ACI Sim    | admin    | cisco123 (before bootstrap), C1sco123 (after bootstrap) |

## Clone terraform-aac locally

Go to the terraform-aac repo (<https://CONTROLLER_IP/aci-iac/terraform-aac>) and click on the `Clone` dropdown. Take note of the `Clone with HTTPS` value.

Clone the repository locally in a directory of your choice.

```sh
local-laptop:~$ git -c http.sslVerify=false clone https://CONTROLLER_IP/aci-iac/terraform-aac
Cloning into 'terraform-aaac'...
warning: redirecting to https://CONTROLLER_IP/aci-iac/terraform-aac.git/
remote: Enumerating objects: 208, done.
remote: Total 208 (delta 0), reused 0 (delta 0), pack-reused 208
Receiving objects: 100% (208/208), 43.66 KiB | 698.00 KiB/s, done.
Resolving deltas: 100% (92/92), done.
```

This will make the `terraform-aac` repository available locally. Open up the folder in your favorite IDE (e.g. Visual Studio, PyCharm...). All changes described in the next section will be made on the local copy of this repository

**Please note** that as the GitLab instance is using a self-signed certificate is it required to disable certificate validation when executing
the git command. This can be done using either a command line argument as in the example above or by disabling this in the global git
configuration with the following command. It is however not advised disabling SSL verification globally as this **will introduce a security risk**
and should only be used temporarily.

## Customize Terraform backend

The `terraform-aac` repository we are using is pre-configured to use Terraform Cloud to store the statefile. As we will be using a local statefile in this lab, the `main.tf` file must be edited and have the following section removed.

```hcl
  cloud {
    organization = "AAC"

    workspaces {
      name = "terraform-aac"
    }
  }
```

Once this section is removed, then commit and push the file to Git.

```sh
local-laptop:~/terraform-aac$ git add .
local-laptop:~/terraform-aac$ git commit -m "Remove TF Cloud config"
local-laptop:~/terraform-aac$ git -c http.sslVerify=false push origin master

## Start Terraform AAC container on Control VM

**Note** You may choose to run Terraform on your local laptop instead of using a container as described in this and the subsequent steps.

To miminze the dependencies on your local machine can you choose to use a container on the control VM like we used to execute Ansible manually. We will start the container by using the following `kubectl` command.

```sh
control-vm:~$ kubectl run terraform-aac --image=danischm/aac:0.5.1 sleep infinity
pod/terraform-aac created
````

Once the container pod has been started can access the prompt inside the container using the following command.

```sh
control-vm:~$ kubectl exec -it terraform-aac -- bash
root@terraform-aac:/#
````

## Clone terraform-aac repository

Once the Terraform AAC container has been started is it time to clone the terraform-aac repository inside the container.

```sh
root@terraform-aac:/# git -c http.sslVerify=false clone https://CONTROLLER_IP/aci-iac/terraform-aac.git
Cloning into 'terraform-aac'...
remote: Enumerating objects: 943, done.
remote: Counting objects: 100% (4/4), done.
remote: Compressing objects: 100% (4/4), done.
remote: Total 943 (delta 0), reused 0 (delta 0), pack-reused 939
Receiving objects: 100% (943/943), 334.30 KiB | 10.45 MiB/s, done.
Resolving deltas: 100% (563/563), done.
```

## Install required software packages

Before Terraform AAC can be executed is it required to install a few Python packages. The container comes with Terraform pre-installed.

```sh
root@terraform-aac:/# cd terraform-aac/
root@terraform-aac:/terraform-aac# pip install --upgrade pip
root@terraform-aac:/terraform-aac# pip install --upgrade iac-validate iac-test jmespath
Requirement already satisfied: iac-validate in /usr/local/lib/python3.8/dist-packages (0.1.4)
Requirement already satisfied: iac-test in /usr/local/lib/python3.8/dist-packages (0.1.2)
Requirement already satisfied: click<9.0.0,>=8.0.4 in /usr/local/lib/python3.8/dist-packages (from iac-validate) (8.1.3)
Requirement already satisfied: yamale<5.0.0,>=4.0.3 in /usr/local/lib/python3.8/dist-packages (from iac-validate) (4.0.4)
Collecting ruamel.yaml<0.17.0,>=0.16.10
  Downloading ruamel.yaml-0.16.13-py2.py3-none-any.whl (111 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 111.9/111.9 kB 3.7 MB/s eta 0:00:00
Requirement already satisfied: errorhandler<3.0.0,>=2.0.1 in /usr/local/lib/python3.8/dist-packages (from iac-validate) (2.0.1)
Requirement already satisfied: robotframework-requests<0.10.0,>=0.9.3 in /usr/local/lib/python3.8/dist-packages (from iac-test) (0.9.3)
Requirement already satisfied: robotframework-jsonlibrary<0.6,>=0.5 in /usr/local/lib/python3.8/dist-packages (from iac-test) (0.5)
Requirement already satisfied: RESTinstance<2.0.0,>=1.3.0 in /usr/local/lib/python3.8/dist-packages (from iac-test) (1.3.0)
Collecting jmespath<0.11.0,>=0.10.0
  Downloading jmespath-0.10.0-py2.py3-none-any.whl (24 kB)
Requirement already satisfied: robotframework-pabot<3.0.0,>=2.5.3 in /usr/local/lib/python3.8/dist-packages (from iac-test) (2.7.0)
Requirement already satisfied: robotframework<6.0.0,>=5.0.1 in /usr/local/lib/python3.8/dist-packages (from iac-test) (5.0.1)
Requirement already satisfied: Jinja2<4.0.0,>=3.0.3 in /usr/local/lib/python3.8/dist-packages (from iac-test) (3.1.2)
Requirement already satisfied: MarkupSafe>=2.0 in /usr/local/lib/python3.8/dist-packages (from Jinja2<4.0.0,>=3.0.3->iac-test) (2.1.1)
Requirement already satisfied: tzlocal in /usr/local/lib/python3.8/dist-packages (from RESTinstance<2.0.0,>=1.3.0->iac-test) (4.2)
Requirement already satisfied: pytz in /usr/local/lib/python3.8/dist-packages (from RESTinstance<2.0.0,>=1.3.0->iac-test) (2022.2.1)
Requirement already satisfied: GenSON in /usr/local/lib/python3.8/dist-packages (from RESTinstance<2.0.0,>=1.3.0->iac-test) (1.2.2)
Requirement already satisfied: pygments in /usr/local/lib/python3.8/dist-packages (from RESTinstance<2.0.0,>=1.3.0->iac-test) (2.13.0)
Requirement already satisfied: flex in /usr/local/lib/python3.8/dist-packages (from RESTinstance<2.0.0,>=1.3.0->iac-test) (6.14.1)
Requirement already satisfied: requests in /usr/local/lib/python3.8/dist-packages (from RESTinstance<2.0.0,>=1.3.0->iac-test) (2.28.1)
Requirement already satisfied: jsonpath-ng in /usr/local/lib/python3.8/dist-packages (from RESTinstance<2.0.0,>=1.3.0->iac-test) (1.5.3)
Requirement already satisfied: docutils in /usr/local/lib/python3.8/dist-packages (from RESTinstance<2.0.0,>=1.3.0->iac-test) (0.19)
Requirement already satisfied: jsonschema in /usr/local/lib/python3.8/dist-packages (from RESTinstance<2.0.0,>=1.3.0->iac-test) (4.16.0)
Requirement already satisfied: robotframework-stacktrace>=0.4.1 in /usr/local/lib/python3.8/dist-packages (from robotframework-pabot<3.0.0,>=2.5.3->iac-test) (0.4.1)
Requirement already satisfied: ruamel.yaml.clib>=0.1.2 in /usr/local/lib/python3.8/dist-packages (from ruamel.yaml<0.17.0,>=0.16.10->iac-validate) (0.2.6)
Requirement already satisfied: pyyaml in /usr/local/lib/python3.8/dist-packages (from yamale<5.0.0,>=4.0.3->iac-validate) (6.0)
Requirement already satisfied: decorator in /usr/local/lib/python3.8/dist-packages (from jsonpath-ng->RESTinstance<2.0.0,>=1.3.0->iac-test) (5.1.1)
Requirement already satisfied: ply in /usr/local/lib/python3.8/dist-packages (from jsonpath-ng->RESTinstance<2.0.0,>=1.3.0->iac-test) (3.11)
Requirement already satisfied: six in /usr/local/lib/python3.8/dist-packages (from jsonpath-ng->RESTinstance<2.0.0,>=1.3.0->iac-test) (1.16.0)
Requirement already satisfied: importlib-resources>=1.4.0 in /usr/local/lib/python3.8/dist-packages (from jsonschema->RESTinstance<2.0.0,>=1.3.0->iac-test) (5.9.0)
Requirement already satisfied: pkgutil-resolve-name>=1.3.10 in /usr/local/lib/python3.8/dist-packages (from jsonschema->RESTinstance<2.0.0,>=1.3.0->iac-test) (1.3.10)
Requirement already satisfied: pyrsistent!=0.17.0,!=0.17.1,!=0.17.2,>=0.14.0 in /usr/local/lib/python3.8/dist-packages (from jsonschema->RESTinstance<2.0.0,>=1.3.0->iac-test) (0.18.1)
Requirement already satisfied: attrs>=17.4.0 in /usr/local/lib/python3.8/dist-packages (from jsonschema->RESTinstance<2.0.0,>=1.3.0->iac-test) (22.1.0)
Requirement already satisfied: jsonpointer>=1.7 in /usr/local/lib/python3.8/dist-packages (from flex->RESTinstance<2.0.0,>=1.3.0->iac-test) (2.3)
Requirement already satisfied: rfc3987>=1.3.4 in /usr/local/lib/python3.8/dist-packages (from flex->RESTinstance<2.0.0,>=1.3.0->iac-test) (1.3.8)
Requirement already satisfied: strict-rfc3339>=0.7 in /usr/local/lib/python3.8/dist-packages (from flex->RESTinstance<2.0.0,>=1.3.0->iac-test) (0.7)
Requirement already satisfied: validate-email>=1.2 in /usr/local/lib/python3.8/dist-packages (from flex->RESTinstance<2.0.0,>=1.3.0->iac-test) (1.3)
Requirement already satisfied: charset-normalizer<3,>=2 in /usr/local/lib/python3.8/dist-packages (from requests->RESTinstance<2.0.0,>=1.3.0->iac-test) (2.1.1)
Requirement already satisfied: urllib3<1.27,>=1.21.1 in /usr/local/lib/python3.8/dist-packages (from requests->RESTinstance<2.0.0,>=1.3.0->iac-test) (1.26.12)
Requirement already satisfied: idna<4,>=2.5 in /usr/local/lib/python3.8/dist-packages (from requests->RESTinstance<2.0.0,>=1.3.0->iac-test) (3.4)
Requirement already satisfied: certifi>=2017.4.17 in /usr/local/lib/python3.8/dist-packages (from requests->RESTinstance<2.0.0,>=1.3.0->iac-test) (2022.9.24)
Requirement already satisfied: pytz-deprecation-shim in /usr/local/lib/python3.8/dist-packages (from tzlocal->RESTinstance<2.0.0,>=1.3.0->iac-test) (0.1.0.post0)
Requirement already satisfied: backports.zoneinfo in /usr/local/lib/python3.8/dist-packages (from tzlocal->RESTinstance<2.0.0,>=1.3.0->iac-test) (0.2.1)
Requirement already satisfied: zipp>=3.1.0 in /usr/local/lib/python3.8/dist-packages (from importlib-resources>=1.4.0->jsonschema->RESTinstance<2.0.0,>=1.3.0->iac-test) (3.8.1)
Requirement already satisfied: tzdata in /usr/local/lib/python3.8/dist-packages (from pytz-deprecation-shim->tzlocal->RESTinstance<2.0.0,>=1.3.0->iac-test) (2022.4)
Installing collected packages: ruamel.yaml, jmespath
  Attempting uninstall: ruamel.yaml
    Found existing installation: ruamel.yaml 0.17.21
    Uninstalling ruamel.yaml-0.17.21:
      Successfully uninstalled ruamel.yaml-0.17.21
  Attempting uninstall: jmespath
    Found existing installation: jmespath 1.0.1
    Uninstalling jmespath-1.0.1:
      Successfully uninstalled jmespath-1.0.1
Successfully installed jmespath-0.10.0 ruamel.yaml-0.16.13
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
```

The python packages we just installed will be used to run the pre- and post-deployment validations in the next steps.

## Terraform Initialization

In addition to installing the Python packages in the previous step, we also need to initialize the Terraform working directory, which includes installing the required Terraform modules and providers. This is done using the `terraform init` command.

```sh
root@terraform-aac:/terraform-aac# terraform init
Initializing modules...
Initializing modules...
Downloading registry.terraform.io/netascode/nac-access-policies/aci 0.3.2 for access_policies...
- access_policies in .terraform/modules/access_policies
Downloading registry.terraform.io/netascode/aaep/aci 0.2.0 for access_policies.aci_aaep...
- access_policies.aci_aaep in .terraform/modules/access_policies.aci_aaep
Downloading registry.terraform.io/netascode/access-fex-interface-profile/aci 0.1.0 for access_policies.aci_access_fex_interface_profile_manual...
- access_policies.aci_access_fex_interface_profile_manual in .terraform/modules/access_policies.aci_access_fex_interface_profile_manual
Downloading registry.terraform.io/netascode/access-fex-interface-selector/aci 0.2.0 for access_policies.aci_access_fex_interface_selector_manual...
- access_policies.aci_access_fex_interface_selector_manual in .terraform/modules/access_policies.aci_access_fex_interface_selector_manual
Downloading registry.terraform.io/netascode/access-leaf-interface-policy-group/aci 0.1.4 for access_policies.aci_access_leaf_interface_policy_group...
- access_policies.aci_access_leaf_interface_policy_group in .terraform/modules/access_policies.aci_access_leaf_interface_policy_group
Downloading registry.terraform.io/netascode/access-leaf-interface-profile/aci 0.1.0 for access_policies.aci_access_leaf_interface_profile_auto...
- access_policies.aci_access_leaf_interface_profile_auto in .terraform/modules/access_policies.aci_access_leaf_interface_profile_auto
<snip>
- tenant.aci_redirect_policy in .terraform/modules/tenant.aci_redirect_policy
Downloading registry.terraform.io/netascode/route-control-route-map/aci 0.1.0 for tenant.aci_route_control_route_map...
- tenant.aci_route_control_route_map in .terraform/modules/tenant.aci_route_control_route_map
Downloading registry.terraform.io/netascode/service-graph-template/aci 0.1.0 for tenant.aci_service_graph_template...
- tenant.aci_service_graph_template in .terraform/modules/tenant.aci_service_graph_template
Downloading registry.terraform.io/netascode/set-rule/aci 0.2.2 for tenant.aci_set_rule...
- tenant.aci_set_rule in .terraform/modules/tenant.aci_set_rule
Downloading registry.terraform.io/netascode/tenant/aci 0.1.0 for tenant.aci_tenant...
- tenant.aci_tenant in .terraform/modules/tenant.aci_tenant
Downloading registry.terraform.io/netascode/vrf/aci 0.1.6 for tenant.aci_vrf...
- tenant.aci_vrf in .terraform/modules/tenant.aci_vrf

Initializing the backend...

Initializing provider plugins...
- Finding ciscodevnet/aci versions matching ">= 2.0.0, >= 2.5.2"...
- Finding netascode/utils versions matching ">= 0.2.2"...
- Installing ciscodevnet/aci v2.5.2...
- Installed ciscodevnet/aci v2.5.2 (signed by a HashiCorp partner, key ID 433649E2C56309DE)
- Installing netascode/utils v0.2.2...
- Installed netascode/utils v0.2.2 (self-signed, key ID 48630DA58CAFD6C0)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

## ACI as Code Validation Stage

With Terraform initialized it is time to start using ACI as Code. The first task we will perform is the pre-deployment validation, which runs a set of syntax and semantic checks against our desired configuration. This is done using a two different tools/commands:

- terraform fmt
- iac-validate

Terraform fmt verifies the format and syntax of the Terraform scripts and can be used to either re-format the scripts on the fly or simply highlight any deviation from best practice. We will be using the latter in this lab.

```sh
root@terraform-aac:/terraform-aac# terraform fmt -check -recursive -diff
root@terraform-aac:/terraform-aac#
```

If the command returns an empty output as above does it mean that no deviation from best practice was found.

The `iac-validate` tool runs the ACI as Code syntax and semantics checks as this can not be done using Terraform. `iac-validate` is a publicly available tool written by Cisco CX, but it can not be used for anything without the corresponding schema and validation rules. In this lab we are storing the schema and validation rules within the `terraform-aac` repository.

```sh
root@terraform-aac:/terraform-aac# iac-validate ./data/
root@terraform-aac:/terraform-aac#
```

Again, if no output is provided by the tool it means that no syntax or semantic issues where found.

## ACI as Code Plan Stage

With the desired configuration validated in the previous step we are ready to execute a `terraform plan`, which indicates the objects that will be added/removed from the ACI fabric in order for its configuration to match the desired configuration.

But before doing this is it required to define a number of environment variables that defines the IP address of the APIC, credentials to use, etc.

```sh
root@terraform-aac:/terraform-aac# export ACI_URL=https://<IP of ACI Simulator>
root@terraform-aac:/terraform-aac# export ACI_USERNAME=<Username on ACI Simulator>
root@terraform-aac:/terraform-aac# export ACI_PASSWORD=<Password on ACI Simulator>
````

At this stage no configuration changes will be made to the ACI fabric, but the APIC will be queried to refresh the state entries in the Terraform statefile (if any).

```sh
root@terraform-aac:/terraform-aac# terraform plan -out=plan.tfplan -input=false
data.utils_yaml_merge.model: Reading...
data.utils_yaml_merge.model: Read complete after 0s [id=7748519c4c49165c29be4de5254b7284b9c6ce6a]

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.access_policies.module.aci_aaep["AAEP1"].aci_rest_managed.infraAttEntityP will be created
  + resource "aci_rest_managed" "infraAttEntityP" {
      + class_name = "infraAttEntityP"
      + content    = {
          + "name" = "AAEP1"
        }
      + dn         = "uni/infra/attentp-AAEP1"
      + id         = (known after apply)
    }

  # module.access_policies.module.aci_aaep["AAEP1"].aci_rest_managed.infraRsDomP["uni/l3dom-ROUTED1"] will be created
  + resource "aci_rest_managed" "infraRsDomP" {
      + class_name = "infraRsDomP"
      + content    = {
          + "tDn" = "uni/l3dom-ROUTED1"
        }
      + dn         = "uni/infra/attentp-AAEP1/rsdomP-[uni/l3dom-ROUTED1]"
      + id         = (known after apply)
    }

  # module.access_policies.module.aci_aaep["AAEP1"].aci_rest_managed.infraRsDomP["uni/phys-PHYSICAL1"] will be created
  + resource "aci_rest_managed" "infraRsDomP" {
      + class_name = "infraRsDomP"
      + content    = {
          + "tDn" = "uni/phys-PHYSICAL1"
        }
      + dn         = "uni/infra/attentp-AAEP1/rsdomP-[uni/phys-PHYSICAL1]"
      + id         = (known after apply)
    }

    <snip>

  # module.tenant["mgmt"].module.aci_oob_external_management_instance["EXT1"].aci_rest_managed.mgmtRsOoBCons["OOB-CON1"] will be created
  + resource "aci_rest_managed" "mgmtRsOoBCons" {
      + class_name = "mgmtRsOoBCons"
      + content    = {
          + "tnVzOOBBrCPName" = "OOB-CON1"
        }
      + dn         = "uni/tn-mgmt/extmgmt-default/instp-EXT1/rsooBCons-OOB-CON1"
      + id         = (known after apply)
    }

  # module.tenant["mgmt"].module.aci_oob_external_management_instance["EXT1"].aci_rest_managed.mgmtSubnet["0.0.0.0/0"] will be created
  + resource "aci_rest_managed" "mgmtSubnet" {
      + class_name = "mgmtSubnet"
      + content    = {
          + "ip" = "0.0.0.0/0"
        }
      + dn         = "uni/tn-mgmt/extmgmt-default/instp-EXT1/subnet-[0.0.0.0/0]"
      + id         = (known after apply)
    }

  # module.tenant["mgmt"].module.aci_tenant[0].aci_rest_managed.fvTenant will be created
  + resource "aci_rest_managed" "fvTenant" {
      + class_name = "fvTenant"
      + content    = {
          + "descr"     = ""
          + "name"      = "mgmt"
          + "nameAlias" = ""
        }
      + dn         = "uni/tn-mgmt"
      + id         = (known after apply)
    }

Plan: 295 to add, 0 to change, 0 to destroy.

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: plan.tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "plan.tfplan"
```

Your output will likely differ from the sample output above, but at the end of the output you will see a summary with the number of objects that will be added, changed, or deleted.

As we ran the terraform command with the `-out=plan.tfplan` flag, the derived plan will be written to the `plan.tfplan` file. In the next section we will use this file as an input when executing `terraform apply`.

## ACI as Code Apply Stage

We are now ready to apply the planned configuration changes to the ACI fabric. This will be done using the `terraform apply` command.

```sh
root@terraform-aac:/terraform-aac# terraform apply -input=false -auto-approve plan.tfplan
<snip>
module.tenant["PROD"].module.aci_endpoint_group["PROD/EPG_VLAN102"].aci_rest_managed.fvRsBd: Creation complete after 0s [id=uni/tn-PROD/ap-PROD/epg-EPG_VLAN102/rsbd]
module.tenant["PROD"].module.aci_endpoint_group["PROD/EPG_VLAN102"].aci_rest_managed.fvRsDomAtt["PHYSICAL1"]: Creation complete after 0s [id=uni/tn-PROD/ap-PROD/epg-EPG_VLAN102/rsdomAtt-[uni/phys-PHYSICAL1]]
module.tenant["infra"].module.aci_l3out_interface_profile_auto["IPN"].aci_rest_managed.l3extLIfP: Creation complete after 0s [id=uni/tn-infra/out-IPN/lnodep-IPN/lifp-IPN]
module.tenant["mgmt"].module.aci_inband_endpoint_group["INB1"].aci_rest_managed.fvRsProv["STD-CON1"]: Creation complete after 0s [id=uni/tn-mgmt/mgmtp-default/inb-INB1/rsprov-STD-CON1]
module.tenant["mgmt"].module.aci_inband_endpoint_group["INB1"].aci_rest_managed.mgmtRsMgmtBD: Creation complete after 0s [id=uni/tn-mgmt/mgmtp-default/inb-INB1/rsmgmtBD]
module.tenant["PROD"].module.aci_endpoint_group["PROD/EPG_VLAN100"].aci_rest_managed.fvRsBd: Creation complete after 0s [id=uni/tn-PROD/ap-PROD/epg-EPG_VLAN100/rsbd]
module.tenant["PROD"].module.aci_endpoint_group["PROD/EPG_VLAN100"].aci_rest_managed.fvRsDomAtt["PHYSICAL1"]: Creation complete after 0s [id=uni/tn-PROD/ap-PROD/epg-EPG_VLAN100/rsdomAtt-[uni/phys-PHYSICAL1]]
module.tenant["PROD"].module.aci_endpoint_group["PROD/EPG_VLAN101"].aci_rest_managed.fvRsBd: Creation complete after 0s [id=uni/tn-PROD/ap-PROD/epg-EPG_VLAN101/rsbd]
module.tenant["PROD"].module.aci_endpoint_group["PROD/EPG_VLAN100"].aci_rest_managed.fvRsPathAtt_port["101-1-vl-100"]: Creation complete after 0s [id=uni/tn-PROD/ap-PROD/epg-EPG_VLAN100/rspathAtt-[topology/pod-1/paths-101/pathep-[eth1/1]]]
module.tenant["PROD"].module.aci_endpoint_group["PROD/EPG_VLAN101"].aci_rest_managed.fvRsDomAtt["PHYSICAL1"]: Creation complete after 0s [id=uni/tn-PROD/ap-PROD/epg-EPG_VLAN101/rsdomAtt-[uni/phys-PHYSICAL1]]
module.tenant["infra"].module.aci_l3out_interface_profile_auto["IPN"].aci_rest_managed.ospfIfP[0]: Creating...
module.tenant["infra"].module.aci_l3out_interface_profile_auto["IPN"].aci_rest_managed.l3extRsPathL3OutAtt["topology/pod-1/paths-1001/pathep-[eth1/60]"]: Creating...
module.tenant["infra"].module.aci_l3out_interface_profile_auto["IPN"].aci_rest_managed.ospfIfP[0]: Creation complete after 1s [id=uni/tn-infra/out-IPN/lnodep-IPN/lifp-IPN/ospfIfP]
module.tenant["infra"].module.aci_l3out_interface_profile_auto["IPN"].aci_rest_managed.l3extRsPathL3OutAtt["topology/pod-1/paths-1001/pathep-[eth1/60]"]: Creation complete after 0s [id=uni/tn-infra/out-IPN/lnodep-IPN/lifp-IPN/rspathL3OutAtt-[topology/pod-1/paths-1001/pathep-[eth1/60]]]
module.tenant["infra"].module.aci_l3out_interface_profile_auto["IPN"].aci_rest_managed.ospfRsIfPol[0]: Creating...
module.tenant["infra"].module.aci_l3out_interface_profile_auto["IPN"].aci_rest_managed.ospfRsIfPol[0]: Creation complete after 0s [id=uni/tn-infra/out-IPN/lnodep-IPN/lifp-IPN/ospfIfP/rsIfPol]

Apply complete! Resources: 295 added, 0 changed, 0 destroyed.
```

Once the configuration changes have been applied to the ACI fabric, this can then be verified using the APIC GUI.

With Terrafrom only the configuration elements are described in the desired configuration and/or present in the Terraform statefile added, changed, or removed when executing `terraform apply`.

As in this lab we are using the local filesystem for the Terraform state file `terraform.tfstate` this file will just be created/modified.

```sh
root@terraform-aac:/terraform-aac# ls -la terraform.tfstate
-rw-r--r-- 1 root root 1396254 Jan  6 03:17 terraform.tfstate
```

## ACI as Code Testing Stage

Using manual verification of configuration changes is naturally not a scalable solution, which is why automated testing is available in ACI as code.

In the Terraform flavor of AAC we will use the `iac-test` tool to render the test templates against the desired configuration and then execute the tests.

```sh
root@terraform-aac:/terraform-aac# iac-test --data ./data --data ./defaults --templates ./tests/templates --filters ./tests/filters --output ./tests/results/aci |& tee test_output.txt
Storing .pabotsuitenames file
2022-11-11 14:01:35.028534 [PID:35] [0] [ID:2] EXECUTING Aci.Config.Access Policies.Ap Leaf Interface Profile
2022-11-11 14:01:35.031217 [PID:36] [2] [ID:1] EXECUTING Aci.Config.Access Policies.Ap Leaf Interface Policy Group
2022-11-11 14:01:35.031521 [PID:37] [3] [ID:3] EXECUTING Aci.Config.Access Policies.Ap Leaf Switch Policy Group
2022-11-11 14:01:35.031658 [PID:38] [1] [ID:0] EXECUTING Aci.Config.Access Policies.Aaep
2022-11-11 14:01:36.345744 [PID:37] [3] [ID:3] PASSED Aci.Config.Access Policies.Ap Leaf Switch Policy Group in 1.3 seconds
2022-11-11 14:01:36.346684 [PID:43] [3] [ID:4] EXECUTING Aci.Config.Access Policies.Ap Leaf Switch Profile
2022-11-11 14:01:36.441557 [PID:35] [0] [ID:2] PASSED Aci.Config.Access Policies.Ap Leaf Interface Profile in 1.4 seconds
2022-11-11 14:01:36.443886 [PID:44] [0] [ID:5] EXECUTING Aci.Config.Access Policies.Ap Spine Interface Policy Group
2022-11-11 14:01:36.452379 [PID:36] [2] [ID:1] PASSED Aci.Config.Access Policies.Ap Leaf Interface Policy Group in 1.4 seconds
2022-11-11 14:01:36.453676 [PID:45] [2] [ID:6] EXECUTING Aci.Config.Access Policies.Ap Spine Interface Profile
2022-11-11 14:01:36.554444 [PID:38] [1] [ID:0] PASSED Aci.Config.Access Policies.Aaep in 1.5 seconds
2022-11-11 14:01:36.555802 [PID:46] [1] [ID:7] EXECUTING Aci.Config.Access Policies.Ap Spine Switch Profile
2022-11-11 14:01:37.269265 [PID:45] [2] [ID:6] PASSED Aci.Config.Access Policies.Ap Spine Interface Profile in 0.8 seconds
<snip>
2022-11-11 14:02:12.206344 [PID:274] [0] [ID:120] EXECUTING Aci.Health.Tenants.PROD.Vrf
2022-11-11 14:02:12.269348 [PID:266] [3] [ID:116] PASSED Aci.Health.Tenants.Mgmt.Oob Ext Mgmt Instance in 1.2 seconds
2022-11-11 14:02:12.270076 [PID:275] [3] [ID:121] EXECUTING Aci.Health.Tenants.Tenant
2022-11-11 14:02:12.809733 [PID:268] [2] [ID:118] PASSED Aci.Health.Tenants.PROD.Bridge Domain in 1.7 seconds
2022-11-11 14:02:12.810388 [PID:279] [2] [ID:122] EXECUTING Aci.Operational.Fabric Policies.Bgp Policy
2022-11-11 14:02:13.215403 [PID:274] [0] [ID:120] PASSED Aci.Health.Tenants.PROD.Vrf in 1.0 seconds
2022-11-11 14:02:13.216049 [PID:280] [0] [ID:123] EXECUTING Aci.Operational.Fabric Policies.Config Export
2022-11-11 14:02:13.510194 [PID:273] [1] [ID:119] PASSED Aci.Health.Tenants.PROD.Endpoint Group in 1.3 seconds
2022-11-11 14:02:13.685168 [PID:275] [3] [ID:121] PASSED Aci.Health.Tenants.Tenant in 1.4 seconds
2022-11-11 14:02:13.922932 [PID:279] [2] [ID:122] PASSED Aci.Operational.Fabric Policies.Bgp Policy in 1.1 seconds
2022-11-11 14:02:14.123258 [PID:280] [0] [ID:123] PASSED Aci.Operational.Fabric Policies.Config Export in 0.9 seconds
282 tests, 261 passed, 0 failed, 21 skipped.
===================================================
Output:  /builds/aci-iac/terraform-aac/tests/results/aci/output.xml
Log:     /builds/aci-iac/terraform-aac/tests/results/aci/log.html
Report:  /builds/aci-iac/terraform-aac/tests/results/aci/report.html
Stopping PabotLib process
Robot Framework remote server at 127.0.0.1:8270 started.
Robot Framework remote server at 127.0.0.1:8270 stopped.
PabotLib process stopped
Total testing: 2 minutes 32.70 seconds
Elapsed time:  41.77 seconds
```

Like the tool we used for validation the `iac-test` is a publicly available tool written by Cisco CX, but it can not be used for anything without the test templates. In this lab these templates are stored within the `terraform-aac` repository.

## Lab Summary

If you have followed the steps outlined in this lab guide, you have successfully used Terraform AAC to modify the configurations of your ACI simulator.

In the next lab we will integrate these steps into a CI/CD pipeline in order to eliminate manual tasks.
