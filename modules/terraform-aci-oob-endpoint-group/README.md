<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-oob-endpoint-group/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-oob-endpoint-group/actions/workflows/test.yml)

# Terraform ACI OOB Endpoint Group Module

Manages ACI OOB Endpoint Group

Location in GUI:
`Tenants` » `mgmt` » `Node Manangement EPGs`

## Examples

```hcl
module "aci_oob_endpoint_group" {
  source  = "netascode/oob-endpoint-group/aci"
  version = ">= 0.1.0"

  name                   = "OOB1"
  oob_contract_providers = ["OOB-CON1"]
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
| <a name="input_name"></a> [name](#input\_name) | OOB endpoint group name. | `string` | n/a | yes |
| <a name="input_oob_contract_providers"></a> [oob\_contract\_providers](#input\_oob\_contract\_providers) | List of OOB contract providers. | `list(string)` | `[]` | no |
| <a name="input_static_routes"></a> [static\_routes](#input\_static\_routes) | List of OOB Static routes | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `mgmtOoB` object. |
| <a name="output_name"></a> [name](#output\_name) | OOB endpoint group name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.mgmtOoB](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.mgmtRsOoBProv](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.mgmtStaticRoute](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->