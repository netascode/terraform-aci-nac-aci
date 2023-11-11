<!-- BEGIN_TF_DOCS -->
# Terraform ACI Spanning Tree Policy Module

Manages ACI Spanning Tree Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `Spanning Tree Interface`

## Examples

```hcl
module "aci_spanning_tree_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-spanning-tree-policy"
  version = ">= 0.8.0"

  name        = "STP1"
  bpdu_filter = true
  bpdu_guard  = true
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
| <a name="input_name"></a> [name](#input\_name) | Spanning tree policy name. | `string` | n/a | yes |
| <a name="input_bpdu_filter"></a> [bpdu\_filter](#input\_bpdu\_filter) | BPDU filter. | `bool` | `false` | no |
| <a name="input_bpdu_guard"></a> [bpdu\_guard](#input\_bpdu\_guard) | BPDU guard. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `stpIfPol` object. |
| <a name="output_name"></a> [name](#output\_name) | Spanning tree policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.stpIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->