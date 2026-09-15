<!-- BEGIN_TF_DOCS -->
# Terraform ACI IP Address Pool Module

Manages ACI IP Address Pool

Location in GUI:
`Tenants` » `mgmt` » `IP Address Pools`

## Examples

```hcl
module "aci_ip_address_pool" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-ip-address-pool"
  version = "> 2.0.0"

  name                    = "POOL_1"
  description             = "My Description"
  gateway_address         = "10.0.1.1/24"
  skip_gateway_validation = true
  address_ranges = [{
    from = "10.1.2.10"
    to   = "10.1.2.20"
  }]
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
| <a name="input_name"></a> [name](#input\_name) | IP address pool name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_gateway_address"></a> [gateway\_address](#input\_gateway\_address) | Gateway IP address in CIDR notation. | `string` | n/a | yes |
| <a name="input_skip_gateway_validation"></a> [skip\_gateway\_validation](#input\_skip\_gateway\_validation) | Skip gateway validation. | `bool` | `false` | no |
| <a name="input_address_ranges"></a> [address\_ranges](#input\_address\_ranges) | List of address ranges. | <pre>list(object({<br/>    from = string<br/>    to   = string<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `fvnsAddrInst` object. |
| <a name="output_name"></a> [name](#output\_name) | IP address pool name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.fvnsAddrInst](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvnsUcastAddrBlk](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->