<!-- BEGIN_TF_DOCS -->
# Terraform ACI Proxy Policy Module

Manages ACI HTTP/HTTPS Proxy Policy

Location in GUI:
`System` » `System Settings` » `Proxy Policy`

## Examples

```hcl
module "aci_proxy_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-proxy-policy"
  version = ">= 2.1.0"

  http_url       = "http://172.16.8.1:8080"
  http_username  = "user_http"
  http_password  = "Cisco!234"
  https_url      = "https://172.16.8.1:8443"
  https_username = "user_https"
  https_password = "Cisco!234"
  ignore_hosts = [
    "192.168.8.1",
    "hostname-1"
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

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_http_url"></a> [http\_url](#input\_http\_url) | HTTP proxy URL, e.g. `http://proxy.example.com:8080`. | `string` | `""` | no |
| <a name="input_http_username"></a> [http\_username](#input\_http\_username) | Username for the HTTP proxy. Embedded into the HTTP URL when set. | `string` | `""` | no |
| <a name="input_http_password"></a> [http\_password](#input\_http\_password) | Password for the HTTP proxy. Embedded into the HTTP URL when set. | `string` | `""` | no |
| <a name="input_https_url"></a> [https\_url](#input\_https\_url) | HTTPS proxy URL, e.g. `https://proxy.example.com:8443`. | `string` | `""` | no |
| <a name="input_https_username"></a> [https\_username](#input\_https\_username) | Username for the HTTPS proxy. Embedded into the HTTPS URL when set. | `string` | `""` | no |
| <a name="input_https_password"></a> [https\_password](#input\_https\_password) | Password for the HTTPS proxy. Embedded into the HTTPS URL when set. | `string` | `""` | no |
| <a name="input_ignore_hosts"></a> [ignore\_hosts](#input\_ignore\_hosts) | List of hostnames or IP addresses that should bypass the proxy. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `proxyServer` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.proxyIgnoreHost](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.proxyServer](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->