<!-- BEGIN_TF_DOCS -->
# Terraform ACI Access FEX Interface Profile Module

Manages ACI Access FEX Interface Profile

Location in GUI:
`Fabric` » `Access Policies` » `Interfaces` » `Leaf Interfaces` » `Profiles`

## Examples

```hcl
module "aci_access_fex_interface_profile" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-fex-interface-profile"
  version = ">= 0.8.0"

  name = "FEX1"
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
| <a name="input_name"></a> [name](#input\_name) | FEX interface profile name. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `infraFexP` object. |
| <a name="output_name"></a> [name](#output\_name) | FEX interface profile name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.infraFexBndlGrp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.infraFexP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->