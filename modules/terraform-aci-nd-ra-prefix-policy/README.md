<!-- BEGIN_TF_DOCS -->
# Terraform ACI ND RA Prefix Policy Module

Manages ACI ND RA Prefix Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `ND RA Prefix`

## Examples

```hcl
module "aci_nd_ra_prefix_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-nd-ra-prefix-policy"
  version = ">= 0.8.0"

  tenant             = "ABC"
  name               = "NDRA1"
  description        = "My Description"
  valid_lifetime     = 1000
  preferred_lifetime = 10000
  auto_configuration = false
  on_link            = false
  router_address     = false
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
| <a name="input_name"></a> [name](#input\_name) | ND RA prefix policy name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_valid_lifetime"></a> [valid\_lifetime](#input\_valid\_lifetime) | Valid lifetime. Minimum value: 0. Maximum value: 4294967295. | `number` | `2592000` | no |
| <a name="input_preferred_lifetime"></a> [preferred\_lifetime](#input\_preferred\_lifetime) | Preferred lifetime. Minimum value: 0. Maximum value: 4294967295. | `number` | `604800` | no |
| <a name="input_auto_configuration"></a> [auto\_configuration](#input\_auto\_configuration) | Auto configuration. | `bool` | `true` | no |
| <a name="input_on_link"></a> [on\_link](#input\_on\_link) | On link. | `bool` | `true` | no |
| <a name="input_router_address"></a> [router\_address](#input\_router\_address) | Router address. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `ndPfxPol` object. |
| <a name="output_name"></a> [name](#output\_name) | ND RA prefix policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.ndPfxPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->