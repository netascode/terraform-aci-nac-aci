<!-- BEGIN_TF_DOCS -->
# Endpoint IP Tag Module

Manages Endpoint IP Tags

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Endpoint Tags` » `Endpoint IP`

## Examples

```hcl
module "aci_endpoint_ip_tag_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-endpoint-ip-tag-policy"
  version = "> 0.9.3"

  ip     = "1.1.1.1"
  tenant = "TEN1"
  vrf    = "TEN1-VRF"
  tags = [{
    key   = "Environment"
    value = "PROD"
  }]
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
| <a name="input_ip"></a> [ip](#input\_ip) | IP address. | `string` | n/a | yes |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Tenant Name. | `string` | n/a | yes |
| <a name="input_vrf"></a> [vrf](#input\_vrf) | VRF Name. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Policy Tags | <pre>list(object({<br/>    key   = string<br/>    value = string<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguised name of `fvEpIpTag` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.fvEpIpTag](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.tagTag](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->