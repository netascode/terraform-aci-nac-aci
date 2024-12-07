<!-- BEGIN_TF_DOCS -->
# Terraform ACI PTP Profile Module

Manages ACI PTP Profile

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Global` » `PTP User Profile`

## Examples

```hcl
module "aci_ptp_profile" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-aaep"
  version = ">= 0.8.0"

  name              = "PTP1"
  announce_interval = -3
  announce_timeout  = 2
  delay_interval    = -4
  sync_interval     = -4
  forwardable       = false
  template          = "telecom"
  mismatch_handling = "configured"
  priority          = 201
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
| <a name="input_name"></a> [name](#input\_name) | PTP Profile name. | `string` | n/a | yes |
| <a name="input_announce_interval"></a> [announce\_interval](#input\_announce\_interval) | Announcement Interval. Minimum value: -3. Maximum value: 4. | `number` | `1` | no |
| <a name="input_announce_timeout"></a> [announce\_timeout](#input\_announce\_timeout) | Announcement Timeout. Minimum value: 2. Maximum value: 10. | `number` | `3` | no |
| <a name="input_delay_interval"></a> [delay\_interval](#input\_delay\_interval) | Delay Interval. Minimum value: -4. Maximum value: 5 | `number` | `-3` | no |
| <a name="input_forwardable"></a> [forwardable](#input\_forwardable) | Destination MAC of PTP Messages | `bool` | `true` | no |
| <a name="input_priority"></a> [priority](#input\_priority) | Teracom G.8275.1 Profile Priority. Minimum value: 1. Maximum value: 255. | `number` | `128` | no |
| <a name="input_sync_interval"></a> [sync\_interval](#input\_sync\_interval) | Sync Interval. Minimum value: -4. Maximum value: 1. | `number` | `1` | no |
| <a name="input_template"></a> [template](#input\_template) | Profile Template. | `string` | `"aes67"` | no |
| <a name="input_mismatch_handling"></a> [mismatch\_handling](#input\_mismatch\_handling) | Mismatched Destination MAC Handling. | `string` | `"configured"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `ptpProfile` object. |
| <a name="output_name"></a> [name](#output\_name) | PTP Profile Name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.ptpProfile](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->