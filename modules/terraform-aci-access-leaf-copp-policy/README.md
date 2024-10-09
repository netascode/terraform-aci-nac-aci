<!-- BEGIN_TF_DOCS -->
# Terraform ACI Access Leaf CoPP Policy Module

Manages ACI Access Leaf CoPP Policy 

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Switch` » `CoPP Leaf`

## Examples

```hcl
module "aci_access_leaf_copp_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-leaf-copp-policy"
  version = ">= 0.8.0"

  name        = "POL1"
  description = "POL1"
  type        = "custom"
  custom_values = {
    arp_rate      = 1234
    arp_burst     = 300
    acl_log_rate  = 150
    acl_log_burst = 300
  }
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
| <a name="input_name"></a> [name](#input\_name) | Attachable access entity profile name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Attachable access entity profile description | `string` | `""` | no |
| <a name="input_type"></a> [type](#input\_type) | Profile type. Allowed values: `default`, `custom`, `strict`, `moderate`, `lenient`. | `string` | `"default"` | no |
| <a name="input_custom_values"></a> [custom\_values](#input\_custom\_values) | Custom CoPP values | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `coppLeafProfile` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.coppLeafProfile](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->