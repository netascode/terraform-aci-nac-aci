<!-- BEGIN_TF_DOCS -->
# Terraform ACI Inband Endpoint Group Module

Manages ACI Inband Endpoint Group

Location in GUI:
`Tenants` » `mgmt` » `Node Management EPGs`

## Examples

```hcl
module "aci_inband_endpoint_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-inband-endpoint-group"
  version = ">= 0.8.0"

  name                        = "INB1"
  vlan                        = 10
  bridge_domain               = "INB1"
  contract_consumers          = ["CON1"]
  contract_providers          = ["CON1"]
  contract_imported_consumers = ["I_CON1"]
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
| <a name="input_name"></a> [name](#input\_name) | Inband endpoint group name. | `string` | n/a | yes |
| <a name="input_vlan"></a> [vlan](#input\_vlan) | Vlan ID. Minimum value: 1. Maximum value: 4096. | `number` | n/a | yes |
| <a name="input_bridge_domain"></a> [bridge\_domain](#input\_bridge\_domain) | Bridge domain name. | `string` | n/a | yes |
| <a name="input_contract_consumers"></a> [contract\_consumers](#input\_contract\_consumers) | List of contract consumers. | `list(string)` | `[]` | no |
| <a name="input_contract_providers"></a> [contract\_providers](#input\_contract\_providers) | List of contract providers. | `list(string)` | `[]` | no |
| <a name="input_contract_imported_consumers"></a> [contract\_imported\_consumers](#input\_contract\_imported\_consumers) | List of imported contract consumers. | `list(string)` | `[]` | no |
| <a name="input_static_routes"></a> [static\_routes](#input\_static\_routes) | List of inband Static routes | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `mgmtInB` object. |
| <a name="output_name"></a> [name](#output\_name) | Inband endpoint group name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.fvRsCons](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsConsIf](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsProv](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.mgmtInB](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.mgmtRsMgmtBD](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.mgmtStaticRoute](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->