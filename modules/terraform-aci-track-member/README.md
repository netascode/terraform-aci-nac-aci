<!-- BEGIN_TF_DOCS -->
# Terraform ACI Track Member Module

Manages ACI Track Member

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `IP SLA` » `Track Members`

## Examples

```hcl
module "aci_track_member" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-track-member"
  version = ">= 0.8.0"

  tenant         = "ABC"
  name           = "MEMBER1"
  description    = "My Description"
  destination_ip = "1.2.3.4"
  scope_type     = "l3out"
  scope          = "L3OUT1"
  ip_sla_policy  = "EXAMPLE"
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
| <a name="input_name"></a> [name](#input\_name) | Track Member name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_destination_ip"></a> [destination\_ip](#input\_destination\_ip) | Destination IP to be tracked | `string` | n/a | yes |
| <a name="input_scope_type"></a> [scope\_type](#input\_scope\_type) | Type of scope of track member. Allowed value: `l3out`, `bd`. | `string` | n/a | yes |
| <a name="input_scope"></a> [scope](#input\_scope) | Scope of track member. | `string` | n/a | yes |
| <a name="input_ip_sla_policy"></a> [ip\_sla\_policy](#input\_ip\_sla\_policy) | IP SLA Policy of a track member | `string` | n/a | yes |
| <a name="input_ip_sla_policy_tenant"></a> [ip\_sla\_policy\_tenant](#input\_ip\_sla\_policy\_tenant) | Tenant name used in reference for ip\_sla\_policy resolved automatically. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `fvTrackMember` object. |
| <a name="output_name"></a> [name](#output\_name) | Track Member name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.fvRsIpslaMonPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvTrackMember](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->