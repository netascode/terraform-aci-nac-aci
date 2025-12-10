<!-- BEGIN_TF_DOCS -->
# Terraform ACI HSRP Interface Policy Module

Manages ACI HSRP Interface Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `HSRP` » `HSRP Interface Policies`

## Examples

```hcl
module "aci_hsrp_interface_policy" {
  source = "../.."

  tenant       = "OSPF_TEST"
  name         = "hsrp_interface_policy"
  alias        = "hsrp_if_pol"
  description  = "HSRP Interface Policy with BFD enabled"
  annotation   = "orchestrator:terraform"
  bfd_enable   = true
  use_bia      = true
  delay        = 5
  reload_delay = 10
  owner_key    = "network_team"
  owner_tag    = "production"
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
| <a name="input_tenant"></a> [tenant](#input\_tenant) | HSRP Interface Policy Tenant name. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | HSRP interface policy name. | `string` | n/a | yes |
| <a name="input_alias"></a> [alias](#input\_alias) | Alias for object. | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_annotation"></a> [annotation](#input\_annotation) | Annotation. User annotation for object. Suggested format: orchestrator:value | `string` | `""` | no |
| <a name="input_bfd_enable"></a> [bfd\_enable](#input\_bfd\_enable) | Enable BFD for HSRP interface. Controls BFD fast failure detection. | `bool` | `false` | no |
| <a name="input_use_bia"></a> [use\_bia](#input\_use\_bia) | Use Burned-In Address (BIA) for HSRP MAC address. When enabled, uses the interface's BIA as HSRP virtual MAC address. | `bool` | `false` | no |
| <a name="input_delay"></a> [delay](#input\_delay) | Minimum delay interval in seconds. Specifies the minimum time that must elapse before HSRP initializes. | `number` | `0` | no |
| <a name="input_reload_delay"></a> [reload\_delay](#input\_reload\_delay) | Reload delay interval in seconds. Delay after reload before HSRP activates. | `number` | `0` | no |
| <a name="input_owner_key"></a> [owner\_key](#input\_owner\_key) | Owner key for enabling clients to own their data for entity correlation. | `string` | `""` | no |
| <a name="input_owner_tag"></a> [owner\_tag](#input\_owner\_tag) | Owner tag for enabling clients to add their own data. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of the HSRP interface policy object. |
| <a name="output_name"></a> [name](#output\_name) | HSRP interface policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.hsrpIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->