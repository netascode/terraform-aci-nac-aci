<!-- BEGIN_TF_DOCS -->
# Terraform ACI Fabric Pod Policy Group Module

Manages ACI Fabric Pod Policy Group

Location in GUI:
`Fabric` » `Fabric Policies` » `Pods` » `Policy Groups`

## Examples

```hcl
module "aci_fabric_pod_policy_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-pod-policy-group"
  version = ">= 0.8.0"

  name                     = "POD1"
  snmp_policy              = "SNMP1"
  date_time_policy         = "DATE1"
  management_access_policy = "MAP1"
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
| <a name="input_name"></a> [name](#input\_name) | Pod policy group name. | `string` | n/a | yes |
| <a name="input_snmp_policy"></a> [snmp\_policy](#input\_snmp\_policy) | SNMP policy name. | `string` | `""` | no |
| <a name="input_date_time_policy"></a> [date\_time\_policy](#input\_date\_time\_policy) | Date time policy name. | `string` | `""` | no |
| <a name="input_management_access_policy"></a> [management\_access\_policy](#input\_management\_access\_policy) | Management access policy name. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `fabricPodPGrp` object. |
| <a name="output_name"></a> [name](#output\_name) | Pod policy group name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.fabricPodPGrp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fabricRsCommPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fabricRsSnmpPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fabricRsTimePol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->