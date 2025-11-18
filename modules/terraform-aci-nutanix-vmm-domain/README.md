<!-- BEGIN_TF_DOCS -->
# Terraform ACI Nutanix VMM Domain Module

Manages ACI Nutanix VMM Domain

Location in GUI:
`Virtual Networking` » `Nutanix`

## Examples

```hcl
module "aci_nutanix_vmm_domain" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-nutanix-vmm-domain"
  version = ">= 0.8.0"

  name                = "NTNX1"
  access_mode         = "read-write"
  vlan_pool           = "VLANPOOL1"
  allocation          = "dynamic"
  custom_vswitch_name = "NutanixVSwitch"
  security_domains    = ["SECURITY-DOMAIN1", "SECURITY-DOMAIN2"]
  credential_policies = [
    {
      name     = "CRED-POL1"
      username = "admin"
      password = "P@ssw0rd!"
    },
    {
      name     = "CRED-POL2"
      username = "nutanix"
      password = "Nutanix123!"
    }
  ]
  controller_profile = {
    name        = "ControllerProfile1"
    hostname_ip = "10.0.0.1"
    datacenter  = "DC1"
    aos_version = "6.6"
    credentials = "CRED-POL1"
    statistics  = true
  }
  cluster_controller = {
    name               = "CC1"
    hostname_ip        = "10.0.0.3"
    cluster_name       = "Cluster1"
    credentials        = "CRED-POL2"
    port               = 35001
    controller_profile = "ControllerProfile1"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.17.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.17.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Nutanix VMM domain name. | `string` | n/a | yes |
| <a name="input_access_mode"></a> [access\_mode](#input\_access\_mode) | Access mode. Choices: `read-only`, `read-write`. | `string` | `"read-write"` | no |
| <a name="input_vlan_pool"></a> [vlan\_pool](#input\_vlan\_pool) | Vlan pool name. | `string` | `null` | no |
| <a name="input_allocation"></a> [allocation](#input\_allocation) | Vlan pool allocation mode. Choices: `static`, `dynamic`. | `string` | `"dynamic"` | no |
| <a name="input_custom_vswitch_name"></a> [custom\_vswitch\_name](#input\_custom\_vswitch\_name) | Custom vSwitch name. | `string` | `""` | no |
| <a name="input_security_domains"></a> [security\_domains](#input\_security\_domains) | Security domains associated to Nutanix VMM domain | `list(string)` | `[]` | no |
| <a name="input_credential_policies"></a> [credential\_policies](#input\_credential\_policies) | List of Nutanix credentials. | <pre>list(object({<br/>    name     = string<br/>    username = string<br/>    password = string<br/>  }))</pre> | `[]` | no |
| <a name="input_controller_profile"></a> [controller\_profile](#input\_controller\_profile) | Controller Profile. Only one Controller Profile is allowed per Nutanix VMM domain. Default AOS version is `unknown`. Default statistics collection is `false`. | <pre>map(object({<br/>    name        = string<br/>    hostname_ip = string<br/>    datacenter  = string<br/>    aos_version = optional(string, "unknown")<br/>    credentials = string<br/>    statistics  = optional(bool, false)<br/>  }))</pre> | `{}` | no |
| <a name="input_cluster_controller"></a> [cluster\_controller](#input\_cluster\_controller) | Cluster Controller. Only one Cluster Controller is allowed per Controller Profile. Default port is `0`. | <pre>map(object({<br/>    name               = string<br/>    hostname_ip        = string<br/>    cluster_name       = string<br/>    credentials        = string<br/>    port               = optional(number, 0)<br/>    controller_profile = string<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `vmmDomP` object. |
| <a name="output_name"></a> [name](#output\_name) | Nutanix VMM domain name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.aaaDomainRef](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.infraRsVlanNs](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vmmClusterCtrlrP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vmmCtrlrP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vmmDomP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vmmRsAcc](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vmmRsClusterAcc](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vmmUsrAccP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->