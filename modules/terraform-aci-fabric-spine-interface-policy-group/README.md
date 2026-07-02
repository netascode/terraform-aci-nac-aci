<!-- BEGIN_TF_DOCS -->
# Terraform ACI Fabric Spine Interface Policy Group Module

Manages ACI Fabric Spine Interface Policy Group

Location in GUI:
`Fabric` » `Fabric Policies` » `Interfaces` » `Spine Interfaces` » `Policy Groups` » `Spine Fabric Port`

## Examples

```hcl
module "aci_fabric_spine_interface_policy_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-spine-interface-policy-group"
  version = "> 2.0.0"

  name              = "SPINES"
  description       = "All Spines"
  link_level_policy = "default"
  macsec_policy     = "default"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.15.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.15.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Spine interface policy group name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_link_level_policy"></a> [link\_level\_policy](#input\_link\_level\_policy) | Link level policy name. | `string` | `""` | no |
| <a name="input_macsec_policy"></a> [macsec\_policy](#input\_macsec\_policy) | MACsec fabric interface policy name. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `fabricSpPortPGrp` object. |
| <a name="output_name"></a> [name](#output\_name) | Spine interface policy group name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.fabricRsFIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fabricRsMacsecFabIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fabricSpPortPGrp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->