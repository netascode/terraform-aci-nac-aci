<!-- BEGIN_TF_DOCS -->
# Terraform ACI Fabric Wide Settings Module

Manages ACI Fabric Wide Settings

Location in GUI:
`System` » `System Settings` » `Fabric-Wide Settings`

## Examples

```hcl
module "aci_fabric_wide_settings" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-wide-settings"
  version = ">= 0.8.0"

  domain_validation             = true
  enforce_subnet_check          = true
  opflex_authentication         = false
  disable_remote_endpoint_learn = true
  overlapping_vlan_validation   = true
  remote_leaf_direct            = true
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
| <a name="input_domain_validation"></a> [domain\_validation](#input\_domain\_validation) | Domain validation. | `bool` | `false` | no |
| <a name="input_enforce_subnet_check"></a> [enforce\_subnet\_check](#input\_enforce\_subnet\_check) | Enforce subnet check. | `bool` | `false` | no |
| <a name="input_opflex_authentication"></a> [opflex\_authentication](#input\_opflex\_authentication) | Opflex authentication. | `bool` | `true` | no |
| <a name="input_disable_remote_endpoint_learn"></a> [disable\_remote\_endpoint\_learn](#input\_disable\_remote\_endpoint\_learn) | Disable remote EP learn. | `bool` | `false` | no |
| <a name="input_overlapping_vlan_validation"></a> [overlapping\_vlan\_validation](#input\_overlapping\_vlan\_validation) | Overlapping VLAN validation. | `bool` | `false` | no |
| <a name="input_remote_leaf_direct"></a> [remote\_leaf\_direct](#input\_remote\_leaf\_direct) | Remote leaf direct. | `bool` | `false` | no |
| <a name="input_reallocate_gipo"></a> [reallocate\_gipo](#input\_reallocate\_gipo) | Reallocate GIPo | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `infraSetPol` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.infraSetPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->