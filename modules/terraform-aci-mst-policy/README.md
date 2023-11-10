<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-mst-policy/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-mst-policy/actions/workflows/test.yml)

# Terraform ACI MST Policy Module

Manages ACI MST Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Switch` » `Spanning Tree`

## Examples

```hcl
module "aci_mst_policy" {
  source  = "netascode/mst-policy/aci"
  version = ">= 0.2.0"

  name     = "MST1"
  region   = "REG1"
  revision = 1
  instances = [{
    name = "INST1"
    id   = 1
    vlan_ranges = [{
      from = 10
      to   = 20
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
| <a name="input_name"></a> [name](#input\_name) | MST policy name. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | MST region. | `string` | n/a | yes |
| <a name="input_revision"></a> [revision](#input\_revision) | MST revision. | `number` | n/a | yes |
| <a name="input_instances"></a> [instances](#input\_instances) | List of instances. Allowed values `id`: 1-4096. Allowed values `from`: 1-4096. Allowed values `to`: 1-4096. Default value `to`: value of `from`. | <pre>list(object({<br>    name = string<br>    id   = number<br>    vlan_ranges = optional(list(object({<br>      from = number<br>      to   = optional(number)<br>    })), [])<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `stpMstRegionPol` object. |
| <a name="output_name"></a> [name](#output\_name) | MST policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.fvnsEncapBlk](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.stpMstDomPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.stpMstRegionPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->