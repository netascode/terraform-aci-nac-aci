<!-- BEGIN_TF_DOCS -->
# Terraform ACI Endpoint Retention Policy Module

Manages ACI Endpoint Retention Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `End Point Retention`

## Examples

```hcl
module "aci_end_point_retention_policy" {
  source                = "netascode/nac-aci/aci//modules/terraform-aci-endpoint-retention-policy"
  version               = ">= 0.9.4"
  name                  = "ERP1"
  descr                 = "Terraform"
  hold_interval         = 6
  bounce_entry_aging    = 630
  local_endpoint_aging  = 900
  remote_endpoint_aging = 300
  move_frequency        = 256
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
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Tenant name. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Endpoint Retention policy name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_hold_interval"></a> [hold\_interval](#input\_hold\_interval) | APIC Endpoint Retention hold interval. Minimum value: 5. Maximum value: 65535. | `number` | `300` | no |
| <a name="input_bounce_entry_aging"></a> [bounce\_entry\_aging](#input\_bounce\_entry\_aging) | APIC Endpoint Retention bounce entry aging. Minimum value: 150. Maximum value: 65535. | `number` | `630` | no |
| <a name="input_local_endpoint_aging"></a> [local\_endpoint\_aging](#input\_local\_endpoint\_aging) | APIC Endpoint Retention local endpoint aging. Minimum value: 120. Maximum value: 65535. | `number` | `900` | no |
| <a name="input_remote_endpoint_aging"></a> [remote\_endpoint\_aging](#input\_remote\_endpoint\_aging) | APIC Endpoint Retention remote endpoint aging. Minimum value: 120. Maximum value: 65535. | `number` | `300` | no |
| <a name="input_move_frequency"></a> [move\_frequency](#input\_move\_frequency) | APIC Endpoint Retention hold interval. Minimum value: 5. Maximum value: 65535. | `number` | `300` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `fvEpRetPol` object. |
| <a name="output_name"></a> [name](#output\_name) | Endpoint Retention policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.fvEpRetPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->