<!-- BEGIN_TF_DOCS -->
# Terraform ACI Smart Licensing Module

Manages ACI Smart Licensing

Location in GUI:
`System` » `Smart Licensing`

## Examples

```hcl
module "aci_smart_licensing" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-smart-licensing"
  version = ">= 0.8.0"

  mode               = "proxy"
  registration_token = "ABCDEFG"
  proxy_hostname_ip  = "a.proxy.com"
  proxy_port         = "80"
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
| <a name="input_proxy_hostname_ip"></a> [proxy\_hostname\_ip](#input\_proxy\_hostname\_ip) | Proxy Hostname or IP Address | `string` | `""` | no |
| <a name="input_proxy_port"></a> [proxy\_port](#input\_proxy\_port) | Proxy port | `string` | `"443"` | no |
| <a name="input_mode"></a> [mode](#input\_mode) | Mode | `string` | `"smart-licensing"` | no |
| <a name="input_registration_token"></a> [registration\_token](#input\_registration\_token) | Registration token ID | `string` | n/a | yes |
| <a name="input_url"></a> [url](#input\_url) | URL | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `licenseLicPolicy` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.licenseLicPolicy](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->