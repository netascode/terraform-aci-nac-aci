<!-- BEGIN_TF_DOCS -->
# Terraform ACI Banner Module

Manages ACI Banner

Location in GUI:
`System` » `System Settings` » `System Alias and Banners`

## Examples

```hcl
module "aci_banner" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-banner"
  version = ">= 0.8.0"

  apic_gui_banner_url      = "http://1.1.1.1"
  apic_gui_alias           = "PROD"
  apic_cli_banner          = "My CLI Banner"
  switch_cli_banner        = "My Switch Banner"
  apic_app_banner          = "My Application Banner"
  apic_app_banner_severity = "warning"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.15.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.15.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apic_gui_banner_message"></a> [apic\_gui\_banner\_message](#input\_apic\_gui\_banner\_message) | APIC GUI banner message. Either a GUI banner message or a GUI banner URL can be used, but not both. | `string` | `""` | no |
| <a name="input_apic_gui_banner_url"></a> [apic\_gui\_banner\_url](#input\_apic\_gui\_banner\_url) | APIC GUI banner URL. | `string` | `""` | no |
| <a name="input_apic_gui_alias"></a> [apic\_gui\_alias](#input\_apic\_gui\_alias) | APIC GUI alias. | `string` | `""` | no |
| <a name="input_apic_cli_banner"></a> [apic\_cli\_banner](#input\_apic\_cli\_banner) | APIC CLI banner. | `string` | `""` | no |
| <a name="input_switch_cli_banner"></a> [switch\_cli\_banner](#input\_switch\_cli\_banner) | Switch CLI banner. | `string` | `""` | no |
| <a name="input_apic_app_banner"></a> [apic\_app\_banner](#input\_apic\_app\_banner) | APIC Application banner. | `string` | `""` | no |
| <a name="input_apic_app_banner_severity"></a> [apic\_app\_banner\_severity](#input\_apic\_app\_banner\_severity) | Severity level for the APIC Application banner. Allowed values: info, critical, warning. | `string` | `"info"` | no |
| <a name="input_escape_html"></a> [escape\_html](#input\_escape\_html) | Enable escape HTML characters for banner. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `aaaPreLoginBanner` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.aaaPreLoginBanner](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->