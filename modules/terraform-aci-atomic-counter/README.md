<!-- BEGIN_TF_DOCS -->
# Terraform ACI Atomic Counter Module

Manages Atomic Counter

Location in GUI:
`Operations` » `Visualization` » `Atomic Counter`

## Examples

```hcl
module "aci_atomic_counter" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-atomic-counter"
  version = ">= 0.9.4"

  admin_state = true
  mode        = "trail"
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
| <a name="input_admin_state"></a> [admin\_state](#input\_admin\_state) | Atomic Counter Administrative state. | `bool` | n/a | yes |
| <a name="input_mode"></a> [mode](#input\_mode) | Atomic Counter Mode. Valid values are `trail` or `path` | `string` | `"trail"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `dbgOngoingAcMode` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.dbgOngoingAcMode](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->