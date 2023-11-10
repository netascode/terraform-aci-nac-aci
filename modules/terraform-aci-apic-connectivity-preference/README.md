<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-apic-connectivity-preference/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-apic-connectivity-preference/actions/workflows/test.yml)

# Terraform ACI APIC Connectivity Preference Module

Manages ACI APIC Connectivity Preference

Location in GUI:
`System` » `System Settings` » `APIC Connectivity Preferences`

## Examples

```hcl
module "aci_apic_connectivity_preference" {
  source  = "netascode/apic-connectivity-preference/aci"
  version = ">= 0.1.0"

  interface_preference = "ooband"
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
| <a name="input_interface_preference"></a> [interface\_preference](#input\_interface\_preference) | Interface preference. Choices: `inband`, `ooband` | `string` | `"inband"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `mgmtConnectivityPrefs` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.mgmtConnectivityPrefs](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->