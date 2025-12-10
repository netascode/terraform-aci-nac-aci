<!-- BEGIN_TF_DOCS -->
# Terraform ACI HSRP Group Policy Module

Manages ACI HSRP Group Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `HSRP` » `HSRP Group Policies`

## Examples

```hcl
module "aci_hsrp_group_policy" {
  source = "../.."

  tenant               = "OSPF_TEST"
  name                 = "hsrp_group_policy_prod"
  alias                = "hsrp_grp_pol"
  description          = "Production HSRP Group Policy with preemption"
  annotation           = "orchestrator:terraform"
  preempt              = true
  hello_interval       = 3000
  hold_interval        = 10000
  priority             = 110
  hsrp_type            = "md5"
  key                  = "SecureHSRPKey2024"
  preempt_delay_min    = 5
  preempt_delay_reload = 60
  preempt_delay_sync   = 10
  timeout              = 300
  owner_key            = "network_team"
  owner_tag            = "production"
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
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Tenant name. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | HSRP group policy name. | `string` | n/a | yes |
| <a name="input_alias"></a> [alias](#input\_alias) | Alias for object. | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_annotation"></a> [annotation](#input\_annotation) | Annotation. User annotation for object. Suggested format: orchestrator:value | `string` | `""` | no |
| <a name="input_preempt"></a> [preempt](#input\_preempt) | Enable preemption. Allows a higher-priority HSRP router to become the active router. | `bool` | `false` | no |
| <a name="input_hello_interval"></a> [hello\_interval](#input\_hello\_interval) | Hello interval in milliseconds. Time between hello packets sent by HSRP. | `number` | `3000` | no |
| <a name="input_hold_interval"></a> [hold\_interval](#input\_hold\_interval) | Hold interval in milliseconds. Time before declaring active router down. | `number` | `10000` | no |
| <a name="input_key"></a> [key](#input\_key) | Authentication key for HSRP packets. Used for MD5 authentication. | `string` | `""` | no |
| <a name="input_preempt_delay_min"></a> [preempt\_delay\_min](#input\_preempt\_delay\_min) | Preempt minimum delay in seconds. Minimum time to wait before preempting. | `number` | `0` | no |
| <a name="input_preempt_delay_reload"></a> [preempt\_delay\_reload](#input\_preempt\_delay\_reload) | Preempt reload delay in seconds. Delay after reload before preempting. | `number` | `0` | no |
| <a name="input_preempt_delay_sync"></a> [preempt\_delay\_sync](#input\_preempt\_delay\_sync) | Preempt synchronization delay in seconds. Delay for IP redundancy clients to be ready. | `number` | `0` | no |
| <a name="input_priority"></a> [priority](#input\_priority) | HSRP priority. Higher value is preferred for active router selection. | `number` | `100` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Timeout in seconds for HSRP session. | `number` | `0` | no |
| <a name="input_hsrp_type"></a> [hsrp\_type](#input\_hsrp\_type) | HSRP version type. Options: simple (HSRPv1) or md5 (HSRPv2 with MD5 authentication). | `string` | `"simple"` | no |
| <a name="input_owner_key"></a> [owner\_key](#input\_owner\_key) | Owner key for enabling clients to own their data for entity correlation. | `string` | `""` | no |
| <a name="input_owner_tag"></a> [owner\_tag](#input\_owner\_tag) | Owner tag for enabling clients to add their own data. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of the HSRP group policy object. |
| <a name="output_name"></a> [name](#output\_name) | HSRP group policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.hsrpGroupPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->