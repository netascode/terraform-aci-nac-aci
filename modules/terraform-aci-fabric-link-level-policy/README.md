<!-- BEGIN_TF_DOCS -->
# Terraform ACI Fabric Link Level Policy

Description

Location in GUI:
`Fabric` » `Fabric Policies` » `Policies` » `Interface` » `Link Level`

## Examples

```hcl
module "aci_fabric_link_level_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-link-level-policy"
  version = ">= 0.0.1"

  name         = "name"
  descr        = "My Description"
  linkDebounce = 1000
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
| <a name="input_name"></a> [name](#input\_name) | Fabric link level policy name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Fabric link level policy description. | `string` | `""` | no |
| <a name="input_link_debounce_interval"></a> [link\_debounce\_interval](#input\_link\_debounce\_interval) | Link debounce interval. Minimum value: 0. Maximum value: 5000. | `number` | `0` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `fabricFIfPol` object. |
| <a name="output_name"></a> [name](#output\_name) | Fabric link level policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.fabricFIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->