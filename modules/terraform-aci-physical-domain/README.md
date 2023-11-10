<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-physical-domain/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-physical-domain/actions/workflows/test.yml)

# Terraform ACI Physical Domain Module

Manages ACI Physical Domain

Location in GUI:
`Fabric` » `Access Policies` » `Physical and External Domains` » `Physical Domains`

## Examples

```hcl
module "aci_physical_domain" {
  source  = "netascode/physical-domain/aci"
  version = ">= 0.1.1"

  name                 = "PHY1"
  vlan_pool            = "VP1"
  vlan_pool_allocation = "dynamic"
  security_domains     = ["SEC1"]
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
| <a name="input_name"></a> [name](#input\_name) | Physical domain name. | `string` | n/a | yes |
| <a name="input_vlan_pool"></a> [vlan\_pool](#input\_vlan\_pool) | Vlan pool name. | `string` | n/a | yes |
| <a name="input_vlan_pool_allocation"></a> [vlan\_pool\_allocation](#input\_vlan\_pool\_allocation) | Vlan pool allocation mode. Choices: `static`, `dynamic`. | `string` | `"static"` | no |
| <a name="input_security_domains"></a> [security\_domains](#input\_security\_domains) | Security domains associated to physical domain | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `physDomP` object. |
| <a name="output_name"></a> [name](#output\_name) | Physical domain name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.aaaDomainRef](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.infraRsVlanNs](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.physDomP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->