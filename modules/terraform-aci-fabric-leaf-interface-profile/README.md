<!-- BEGIN_TF_DOCS -->
# Terraform ACI Fabric Leaf Interface Profile Module

Manages ACI Fabric Leaf Interface Profile

Location in GUI:
`Fabric` » `Fabric Policies` » `Interfaces` » `Leaf Interfaces` » `Profiles`

## Examples

```hcl
module "aci_fabric_leaf_interface_profile" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-abric-leaf-interface-profile"
  version = ">= 0.8.0"

  name = "LEAF101"
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
| <a name="input_name"></a> [name](#input\_name) | Leaf interface profile name. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `fabricLePortP` object. |
| <a name="output_name"></a> [name](#output\_name) | Leaf interface profile name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.fabricLePortP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->