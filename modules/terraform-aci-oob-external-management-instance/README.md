<!-- BEGIN_TF_DOCS -->
# Terraform ACI OOB External Management Instance Module

Manages ACI OOB External Management Instance

Location in GUI:
`Tenants` » `mgmt` » `External Management Network Instance Profiles`

## Examples

```hcl
module "aci_oob_external_management_instance" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-oob-external-management-instance"
  version = ">= 0.8.0"

  name                   = "INST1"
  subnets                = ["0.0.0.0/0"]
  oob_contract_consumers = ["CON1"]
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
| <a name="input_name"></a> [name](#input\_name) | OOB external management instance name. | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnets | `list(string)` | `[]` | no |
| <a name="input_oob_contract_consumers"></a> [oob\_contract\_consumers](#input\_oob\_contract\_consumers) | List of OOB contract consumers. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `mgmtInstP` object. |
| <a name="output_name"></a> [name](#output\_name) | OOB external management instance name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.mgmtInstP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.mgmtRsOoBCons](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.mgmtSubnet](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->