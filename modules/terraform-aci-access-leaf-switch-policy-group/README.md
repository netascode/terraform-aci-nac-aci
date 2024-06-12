<!-- BEGIN_TF_DOCS -->
# Terraform ACI Access Leaf Switch Policy Group Module

Manages ACI Access Leaf Switch Policy Group

Location in GUI:
`Fabric` » `Access Policies` » `Switches` » `Leaf Switches` » `Policy Groups`

## Examples

```hcl
module "aci_access_leaf_switch_policy_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-leaf-switch-policy-group"
  version = ">= 0.8.0"

  name                    = "SW-PG1"
  forwarding_scale_policy = "HIGH-DUAL-STACK"
  bfd_ipv4_policy         = "BFD-IPV4-POLICY"
  bfd_ipv6_policy         = "BFD-IPV6-POLICY"
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
| <a name="input_name"></a> [name](#input\_name) | Leaf switch policy group name. | `string` | n/a | yes |
| <a name="input_forwarding_scale_policy"></a> [forwarding\_scale\_policy](#input\_forwarding\_scale\_policy) | Forwarding scale policy name. | `string` | `""` | no |
| <a name="input_bfd_ipv4_policy"></a> [bfd\_ipv4\_policy](#input\_bfd\_ipv4\_policy) | BFD IPv4 policy name. | `string` | `""` | no |
| <a name="input_bfd_ipv6_policy"></a> [bfd\_ipv6\_policy](#input\_bfd\_ipv6\_policy) | BFD IPv6 policy name. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `infraAccNodePGrp` object. |
| <a name="output_name"></a> [name](#output\_name) | Leaf switch policy group name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.infraAccNodePGrp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.infraRsBfdIpv4InstPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.infraRsBfdIpv6InstPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.infraRsTopoctrlFwdScaleProfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->