<!-- BEGIN_TF_DOCS -->
# Terraform ACI Border Gateway Set PolicyModule

Manages ACI Border Gateway Set Policy

Location in GUI:
`Tenants` » `infra` » `Policies` » `VXLAN Gateway` » `Border Gateway Sets`

## Examples

```hcl
module "aci_border_gateway_set_policy" {
  source  = "netascode/nac-aci/aci/modules/terraform-aci-border-gateway-set-policy"
  version = "> 1.2.0"

  name    = "BGW1"
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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.17.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.17.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | An alphanumeric string up to 64 characters long. | `string` | n/a | yes |
| <a name="input_vxlan_site_id"></a> [vxlan\_site\_id](#input\_vxlan\_site\_id) | A site ID integer up to 65535. | `number` | n/a | yes |
| <a name="input_external_data_plane_ips"></a> [external\_data\_plane\_ips](#input\_external\_data\_plane\_ips) | A list of external data plane IPs, each with a pod\_id (1-254) and an IPv4 address. | <pre>list(object({<br/>    pod_id = number<br/>    ip     = string<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of vxlanBgwSet object. |
| <a name="output_name"></a> [name](#output\_name) | Name of vxlanBgwSet object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.vxlanBgwSet](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vxlanExtAnycastIP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vxlanSite](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->