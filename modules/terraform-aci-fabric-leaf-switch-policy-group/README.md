<!-- BEGIN_TF_DOCS -->
# Terraform ACI Fabric Leaf Switch Policy Group Module

Manages ACI Fabric Leaf Switch Policy Group

Location in GUI:
`Fabric` » `Fabric Policies` » `Switches` » `Leaf Switches` » `Policy Groups`

## Examples

```hcl
module "aci_fabric_leaf_switch_policy_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-leaf-switch-policy-group"
  version = ">= 0.8.0"

  name                = "LEAFS"
  psu_policy          = "PSU1"
  node_control_policy = "NC1"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Leaf switch policy group name. | `string` | n/a | yes |
| <a name="input_psu_policy"></a> [psu\_policy](#input\_psu\_policy) | PSU policy name. | `string` | `""` | no |
| <a name="input_node_control_policy"></a> [node\_control\_policy](#input\_node\_control\_policy) | Node control policy name. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `fabricLeNodePGrp` object. |
| <a name="output_name"></a> [name](#output\_name) | Leaf switch policy group name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.fabricLeNodePGrp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fabricRsNodeCtrl](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fabricRsPsuInstPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->