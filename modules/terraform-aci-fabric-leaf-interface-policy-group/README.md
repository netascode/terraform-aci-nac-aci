<!-- BEGIN_TF_DOCS -->
# Terraform ACI Fabric Leaf Interface Policy Group Module

Manages ACI Fabric Leaf Interface Policy Group

Location in GUI:
`Fabric` » `Fabric Policies` » `Interfaces` » `Leaf Interfaces` » `Policy Groups` » `Leaf Fabric Port`

## Examples

```hcl
module "aci_fabric_leaf_interface_policy_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-leaf-interface-policy-group"
  version = ">= 1.0.2"

  name              = "LEAFS"
  description       = "All Leafs"
  link_level_policy = "default"
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
| <a name="input_name"></a> [name](#input\_name) | Leaf interface policy group name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_link_level_policy"></a> [link\_level\_policy](#input\_link\_level\_policy) | Link Level policy name. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `fabricLePortPGrp` object. |
| <a name="output_name"></a> [name](#output\_name) | Leaf interface policy group name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.fabricLePortPGrp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fabricRsFIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->