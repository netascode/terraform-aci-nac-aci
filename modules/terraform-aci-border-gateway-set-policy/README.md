<!-- BEGIN_TF_DOCS -->
# Terraform ACI Border Gateway Policy Module

Manages ACI Border Gateway Policy

Location in GUI:
`Tenant` » `Infra` » `Policies` » `VXLAN Gateways`

## Examples

```hcl
module "aci_border_gateway_set_policy" {
  source = "./modules/terraform-aci-border-gateway-set-policy"

  name  = "BGW1"
  site_id = 100
  external_data_plane_ips = [
    {
      pod_id = 1
      ip     = "192.168.1.10"
    },
    {
      pod_id = 2
      ip     = "192.168.2.10"
    }
  ]
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

## Custom Variables

This module defines the following variables with validation:
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Alphanumeric string, up to 64 characters. | `string` | n/a | yes |
| <a name="input_site_id"></a> [site\_id](#input\_site\_id) | Integer between 0 and 65535. | `number` | n/a | yes |
| <a name="input_external_data_plane_ips"></a> [external\_data\_plane\_ips](#input\_external\_data\_plane\_ips) | List of objects, each with pod_id (Integer from 1 to 254) and ip (IPv4 address, no netmask). | <pre>list(object({<br>  pod_id = number<br>  ip     = string<br>}))</pre> | n/a | yes |



## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `vxlanBgwSet` object. |
| <a name="output_name"></a> [name](#output\_name) | vxlanBgwSet  policy name. |
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `vxlanSite` object. |
| <a name="output_name"></a> [name](#output\_name) | vxlanSite ID. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.vxlanBgwSet](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->