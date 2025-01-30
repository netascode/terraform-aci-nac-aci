<!-- BEGIN_TF_DOCS -->
# Terraform ACI Multicast Route Map Module

Manages ACI Multicast Route Map

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocols` » `Route Maps for Multicast`

## Examples

```hcl
module "aci_multicast_route_map" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-multicast-route-map"
  version = ">= 0.8.0"

  tenant      = "ABC"
  name        = "MRM1"
  description = "My Description"
  entries = [
    {
      order     = 1
      action    = "deny"
      source_ip = "1.2.3.4/32"
      group_ip  = "224.0.0.0/8"
      rp_ip     = "3.4.5.6"
    },
    {
      order = 2
    }
  ]
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
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Multicast route map's tenant name. | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Multicast route map name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_entries"></a> [entries](#input\_entries) | Multicast route map entries. `order` allowed range: `0-9999`. `action` allowed values: `permit` or `deny`. Default value `action`: `permit`. | <pre>list(object({<br/>    action    = optional(string, "permit")<br/>    group_ip  = optional(string, "0.0.0.0")<br/>    order     = number<br/>    rp_ip     = optional(string, "0.0.0.0")<br/>    source_ip = optional(string, "0.0.0.0")<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `pimRouteMapPol` object. |
| <a name="output_name"></a> [name](#output\_name) | Multicast route map name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.pimRouteMapEntry](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimRouteMapPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->