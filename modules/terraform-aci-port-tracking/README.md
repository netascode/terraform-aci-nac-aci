<!-- BEGIN_TF_DOCS -->
# Terraform ACI Port Tracking Module

Manages ACI Port Tracking

Location in GUI:
`System` » `System Settings` » `Port Tracking`

## Examples

```hcl
module "aci_port_tracking" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-port-tracking"
  version = ">= 0.8.0"

  admin_state = true
  delay       = 5
  min_links   = 2
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
| <a name="input_admin_state"></a> [admin\_state](#input\_admin\_state) | Admin state. | `bool` | `false` | no |
| <a name="input_delay"></a> [delay](#input\_delay) | Delay. Minimum value: 1. Maximum value: 300. | `number` | `120` | no |
| <a name="input_min_links"></a> [min\_links](#input\_min\_links) | Minimum links. Minimum value: 0. Maximum value: 48. | `number` | `0` | no |
| <a name="input_include_apic"></a> [include\_apic](#input\_include\_apic) | Include APIC ports. | `bool` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `infraPortTrackPol` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.infraPortTrackPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->