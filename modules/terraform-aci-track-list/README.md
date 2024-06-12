<!-- BEGIN_TF_DOCS -->
# Terraform ACI Track List Module

Manages ACI Track List

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `IP SLA` » `Track Lists`

## Examples

```hcl
module "aci_track_list" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-track-list"
  version = ">= 0.8.0"

  tenant          = "ABC"
  name            = "TRACK1"
  description     = "My Description"
  percentage_down = 10
  percentage_up   = 20
  type            = "percentage"
  track_members   = ["mem1", "mem2"]
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
| <a name="input_name"></a> [name](#input\_name) | Track List name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_type"></a> [type](#input\_type) | Type of Track List. Allowed values: `percentage`, `weight`. | `string` | `"percentage"` | no |
| <a name="input_percentage_down"></a> [percentage\_down](#input\_percentage\_down) | Down Threshold percentage. Minimum value: 0. Maximum value: 100. | `number` | `0` | no |
| <a name="input_percentage_up"></a> [percentage\_up](#input\_percentage\_up) | Up Threshold percentage. Minimum value: 0. Maximum value: 100. | `number` | `0` | no |
| <a name="input_weight_down"></a> [weight\_down](#input\_weight\_down) | Down Threshold weight. Minimum value: 0. Maximum value: 255. | `number` | `0` | no |
| <a name="input_weight_up"></a> [weight\_up](#input\_weight\_up) | Up Threshold weight. Minimum value: 0. Maximum value: 255. | `number` | `0` | no |
| <a name="input_track_members"></a> [track\_members](#input\_track\_members) | Track List members. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `fvTrackList` object. |
| <a name="output_name"></a> [name](#output\_name) | Track List name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.fvRsOtmListMember](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvTrackList](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->