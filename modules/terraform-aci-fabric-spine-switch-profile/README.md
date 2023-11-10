<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-fabric-spine-switch-profile/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-fabric-spine-switch-profile/actions/workflows/test.yml)

# Terraform ACI Fabric Spine Switch Profile Module

Manages ACI Fabric Spine Switch Profile

Location in GUI:
`Fabric` » `Fabric Policies` » `Switches` » `Spine Switches` » `Profiles`

## Examples

```hcl
module "aci_fabric_spine_switch_profile" {
  source  = "netascode/fabric-spine-switch-profile/aci"
  version = ">= 0.2.0"

  name               = "SPINE1001"
  interface_profiles = ["PROF1"]
  selectors = [{
    name         = "SEL1"
    policy_group = "POL1"
    node_blocks = [{
      name = "BLOCK1"
      from = 1001
      to   = 1001
    }]
  }]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Spine switch profile name. | `string` | n/a | yes |
| <a name="input_interface_profiles"></a> [interface\_profiles](#input\_interface\_profiles) | List of interface profile names. | `list(string)` | `[]` | no |
| <a name="input_selectors"></a> [selectors](#input\_selectors) | List of selectors. Allowed values `from`: 1-4000. Allowed values `to`: 1-4000. | <pre>list(object({<br>    name         = string<br>    policy_group = optional(string)<br>    node_blocks = list(object({<br>      name = string<br>      from = number<br>      to   = optional(number)<br>    }))<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `fabricSpineP` object. |
| <a name="output_name"></a> [name](#output\_name) | Spine switch profile name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.fabricNodeBlk](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fabricRsSpNodePGrp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fabricRsSpPortP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fabricSpineP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fabricSpineS](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->