<!-- BEGIN_TF_DOCS -->
# Terraform ACI Port Channel Policy Module

Manages ACI Port Channel Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `Port Channel`

## Examples

```hcl
module "aci_port_channel_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-port-channel-policy"
  version = ">= 0.8.0"

  name                 = "LACP-ACTIVE"
  mode                 = "active"
  min_links            = 2
  max_links            = 10
  suspend_individual   = false
  graceful_convergence = false
  fast_select_standby  = false
  load_defer           = true
  symmetric_hash       = true
  hash_key             = "src-ip"
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
| <a name="input_name"></a> [name](#input\_name) | Port channel policy name. | `string` | n/a | yes |
| <a name="input_mode"></a> [mode](#input\_mode) | Mode. Choices: `off`, `active`, `passive`, `mac-pin`, `mac-pin-nicload`. | `string` | n/a | yes |
| <a name="input_min_links"></a> [min\_links](#input\_min\_links) | Minimum links. Minimum value: 1. Maximum value: 16. | `number` | `1` | no |
| <a name="input_max_links"></a> [max\_links](#input\_max\_links) | Maximum links. Minimum value: 1. Maximum value: 16. | `number` | `16` | no |
| <a name="input_suspend_individual"></a> [suspend\_individual](#input\_suspend\_individual) | Suspend individual. | `bool` | `true` | no |
| <a name="input_graceful_convergence"></a> [graceful\_convergence](#input\_graceful\_convergence) | Graceful convergence. | `bool` | `true` | no |
| <a name="input_fast_select_standby"></a> [fast\_select\_standby](#input\_fast\_select\_standby) | Fast select standby. | `bool` | `true` | no |
| <a name="input_load_defer"></a> [load\_defer](#input\_load\_defer) | Load defer. | `bool` | `false` | no |
| <a name="input_symmetric_hash"></a> [symmetric\_hash](#input\_symmetric\_hash) | Symmetric hash. | `bool` | `false` | no |
| <a name="input_hash_key"></a> [hash\_key](#input\_hash\_key) | Hash key. Choices: `, `src-ip`, `dst-ip`, `l4-src-port`, `l4-dst-port`.` | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `lacpLagPol` object. |
| <a name="output_name"></a> [name](#output\_name) | Port channel policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.l2LoadBalancePol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.lacpLagPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->