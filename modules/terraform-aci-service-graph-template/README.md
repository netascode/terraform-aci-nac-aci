<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-service-graph-template/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-service-graph-template/actions/workflows/test.yml)

# Terraform ACI Service Graph Template Module

Manages ACI Service Graph Template

Location in GUI:
`Tenants` » `XXX` » `Services` » `L4-L7` » `Service Graph Templates`

## Examples

```hcl
module "aci_service_graph_template" {
  source  = "netascode/service-graph-template/aci"
  version = ">= 0.1.0"

  tenant              = "ABC"
  name                = "SGT1"
  alias               = "SGT1-ALIAS"
  description         = "My Description"
  template_type       = "FW_ROUTED"
  redirect            = true
  share_encapsulation = true
  device_name         = "DEV1"
  device_tenant       = "DEF"
  device_function     = "GoThrough"
  device_copy         = false
  device_managed      = false
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
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Tenant name. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Service graph template name. | `string` | n/a | yes |
| <a name="input_alias"></a> [alias](#input\_alias) | Alias. | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_template_type"></a> [template\_type](#input\_template\_type) | Template type. Choices: `FW_TRANS`, `FW_ROUTED`, `ADC_ONE_ARM`, `ADC_TWO_ARM`, `OTHER`, `CLOUD_NATIVE_LB`, `CLOUD_VENDOR_LB`, `CLOUD_NATIVE_FW`, `CLOUD_VENDOR_FW`. | `string` | `"OTHER"` | no |
| <a name="input_redirect"></a> [redirect](#input\_redirect) | Redirect. | `bool` | `false` | no |
| <a name="input_share_encapsulation"></a> [share\_encapsulation](#input\_share\_encapsulation) | Share encapsulation. | `bool` | `false` | no |
| <a name="input_device_name"></a> [device\_name](#input\_device\_name) | L4L7 device name. | `string` | n/a | yes |
| <a name="input_device_tenant"></a> [device\_tenant](#input\_device\_tenant) | L4L7 device tenant name. | `string` | `""` | no |
| <a name="input_device_function"></a> [device\_function](#input\_device\_function) | L4L7 device function. Choices: `None`, `GoTo`, `GoThrough`, `L2`, `L1`. | `string` | `"GoTo"` | no |
| <a name="input_device_copy"></a> [device\_copy](#input\_device\_copy) | L4L7 device copy function. | `bool` | `false` | no |
| <a name="input_device_managed"></a> [device\_managed](#input\_device\_managed) | L4L7 managed device. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `vnsAbsGraph` object. |
| <a name="output_name"></a> [name](#output\_name) | Service graph template name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.vnsAbsConnection_Consumer](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsAbsConnection_Provider](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsAbsFuncConn_Consumer](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsAbsFuncConn_Provider](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsAbsGraph](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsAbsNode](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsAbsTermConn_T1](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsAbsTermConn_T2](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsAbsTermNodeCon](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsAbsTermNodeProv](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsInTerm_T1](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsInTerm_T2](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsOutTerm_T1](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsOutTerm_T2](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsRsAbsConnectionConns_ConT1](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsRsAbsConnectionConns_ConT2](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsRsAbsConnectionConns_NodeN1Consumer](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsRsAbsConnectionConns_NodeN1Provider](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsRsNodeToLDev](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->