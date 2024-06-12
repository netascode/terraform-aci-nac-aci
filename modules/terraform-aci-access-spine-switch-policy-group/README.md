<!-- BEGIN_TF_DOCS -->
# Terraform ACI Access Spine Switch Policy Group Module

Description

Location in GUI:
`Fabric` » `Access Policies` » `Switches` » `Spine Switches` » `Policy Groups`

## Examples

```hcl
module "aci_access_spine_switch_policy_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-spine-switch-policy-group"
  version = ">= 0.8.0"

  name            = "SW-PG1"
  lldp_policy     = "LLDP-ON"
  bfd_ipv4_policy = "BFD-IPV4-POLICY"
  bfd_ipv6_policy = "BFD-IPV6-POLICY"
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
| <a name="input_name"></a> [name](#input\_name) | Spine switch policy group name. | `string` | n/a | yes |
| <a name="input_lldp_policy"></a> [lldp\_policy](#input\_lldp\_policy) | LLDP policy name. | `string` | `""` | no |
| <a name="input_bfd_ipv4_policy"></a> [bfd\_ipv4\_policy](#input\_bfd\_ipv4\_policy) | BFD IPv4 policy name. | `string` | `""` | no |
| <a name="input_bfd_ipv6_policy"></a> [bfd\_ipv6\_policy](#input\_bfd\_ipv6\_policy) | BFD IPv6 policy name. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `infraSpineAccNodePGrp` object. |
| <a name="output_name"></a> [name](#output\_name) | Spine switch policy group name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.infraRsBfdIpv4InstPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.infraRsBfdIpv6InstPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.infraRsSpinePGrpToLldpIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.infraSpineAccNodePGrp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->