<!-- BEGIN_TF_DOCS -->
# Terraform ACI OSPF Route Summarization Policy Module

Manages ACI OSPF Route Summarization Policy

Location in GUI:
`Tenants` » `<TENANT>` » `Networking` » `Protocol Policies` » `OSPF` » `OSPF Route Summarization`

## Examples

```hcl
module "aci_ospf_route_summarization_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-ospf-route-summarization-policy"
  version = ">= 0.8.0"

  tenant              = "ABC"
  name                = "OSPF_SUM1"
  description         = "My OSPF Route Summarization Policy"
  cost                = "100"
  inter_area_enabled  = true
  tag                 = 12345
  name_alias          = "OSPF_SUM_ALIAS"
}
```

## Requirements

| Name                                                                      | Version  |
| ------------------------------------------------------------------------- | -------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci)                   | >= 2.0.0 |

## Providers

| Name                                              | Version  |
| ------------------------------------------------- | -------- |
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.0.0 |

## Inputs

| Name                                                                                         | Description                                                                      | Type     | Default         | Required |
| -------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------- | -------- | --------------- | :------: |
| <a name="input_tenant"></a> [tenant](#input\_tenant)                                         | Tenant name.                                                                     | `string` | n/a             |   yes    |
| <a name="input_name"></a> [name](#input\_name)                                               | OSPF route summarization policy name.                                            | `string` | n/a             |   yes    |
| <a name="input_description"></a> [description](#input\_description)                          | Description.                                                                     | `string` | `""`            |    no    |
| <a name="input_cost"></a> [cost](#input\_cost)                                               | Route cost. Allowed values are `unspecified` or a number between 0 and 16777215. | `string` | `"unspecified"` |    no    |
| <a name="input_inter_area_enabled"></a> [inter\_area\_enabled](#input\_inter\_area\_enabled) | Inter-area enabled.                                                              | `bool`   | `false`         |    no    |
| <a name="input_tag"></a> [tag](#input\_tag)                                                  | Route tag. Minimum value: 0. Maximum value: 4294967295.                          | `number` | `0`             |    no    |
| <a name="input_name_alias"></a> [name\_alias](#input\_name\_alias)                           | Name alias.                                                                      | `string` | `""`            |    no    |

## Outputs

| Name                                             | Description                                   |
| ------------------------------------------------ | --------------------------------------------- |
| <a name="output_dn"></a> [dn](#output\_dn)       | Distinguished name of `ospfRtSummPol` object. |
| <a name="output_name"></a> [name](#output\_name) | OSPF route summarization policy name.         |

## Resources

| Name                                                                                                                         | Type     |
| ---------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aci_rest_managed.ospfRtSummPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->