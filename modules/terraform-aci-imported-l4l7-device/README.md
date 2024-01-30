<!-- BEGIN_TF_DOCS -->
# Terraform ACI Imported L4L7 Device Module

ACI Imported L4L7 Device

Location in GUI:
`Tenants` » `XXX` » `Services` » `L4-L7` » `Imported Devices`

## Examples

```hcl
module "aci_imported_l4l7_device" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-imported-l4l7-device"
  version = ">= 0.8.1"

  tenant        = "ABC"
  source_tenant = "DEF"
  source_device = "DEV1"
  description   = "My imported device"
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
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Tenant name. | `string` | n/a | yes |
| <a name="input_source_tenant"></a> [source\_tenant](#input\_source\_tenant) | Source device tenant name. | `string` | n/a | yes |
| <a name="input_source_device"></a> [source\_device](#input\_source\_device) | L4L7 device name to be imported. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Imported device description. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `vnsLDevIf` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.vnsLDevIf](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->