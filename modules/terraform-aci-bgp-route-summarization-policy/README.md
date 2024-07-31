<!-- BEGIN_TF_DOCS -->
# Terraform ACI BGP Route Summarization Policy Module

Manages ACI BGP Route Summarization Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `BGP` » `BGP Route Summarization`

## Examples

```hcl
module "aci_bgp_route_summarization_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-bgp-route-summarization-policy"
  version = ">= 0.8.0"

  name         = "ABC"
  tenant       = "TEN1"
  description  = "My Description"
  as_set       = true
  summary_only = false
  af_mcast     = false
  af_ucast     = true
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
| <a name="input_name"></a> [name](#input\_name) | BGP Route Summarization Policy name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | BGP Route Summarization Policy description. | `string` | `""` | no |
| <a name="input_as_set"></a> [as\_set](#input\_as\_set) | Flag to as Generate AS-SET information. | `bool` | `false` | no |
| <a name="input_summary_only"></a> [summary\_only](#input\_summary\_only) | Flag to as Do not advertise more specifics. | `bool` | `false` | no |
| <a name="input_af_mcast"></a> [af\_mcast](#input\_af\_mcast) | Flag to as AF Mcast. | `bool` | `false` | no |
| <a name="input_af_ucast"></a> [af\_ucast](#input\_af\_ucast) | Flag to as AF Ucast. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `bgpRtSummPol` object. |
| <a name="output_name"></a> [name](#output\_name) | BGP Route Summarization Policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.bgpRtSummPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->