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
  description              = "DESCRIPTION"
  snmp_policy              = "SNMP1"
  date_time_policy         = "DATE1"
  management_access_policy = "MAP1"
  route_reflector_policy   = "RR1"
  coop_group_policy        = "COOP1"
  isis_policy              = "ISIS1"
  macsec_policy            = "MACSEC1"

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
| <a name="input_description"></a> [description](#input\_description) | Pod policy description | `string` | `""` | no |
| <a name="input_snmp_policy"></a> [snmp\_policy](#input\_snmp\_policy) | SNMP policy name. | `string` | `""` | no |
| <a name="input_date_time_policy"></a> [date\_time\_policy](#input\_date\_time\_policy) | Date time policy name. | `string` | `""` | no |
| <a name="input_management_access_policy"></a> [management\_access\_policy](#input\_management\_access\_policy) | Management access policy name. | `string` | `""` | no |
| <a name="input_route_reflector_policy"></a> [route\_reflector\_policy](#input\_route\_reflector\_policy) | Pod Route Reflector Policy. | `string` | `""` | no |
| <a name="input_coop_group_policy"></a> [coop\_group\_policy](#input\_coop\_group\_policy) | Pod COOP Group Policy. | `string` | `""` | no |
| <a name="input_isis_policy"></a> [isis\_policy](#input\_isis\_policy) | Pod IS-IS Policy. | `string` | `""` | no |
| <a name="input_macsec_policy"></a> [macsec\_policy](#input\_macsec\_policy) | Pod MACsec Policy. | `string` | `""` | no |

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
| [aci_rest_managed.fabricRsMacsecPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fabricRsPodPGrpBGPRRP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fabricRsPodPGrpCoopP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fabricRsPodPGrpIsisDomP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fabricRsSnmpPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fabricRsTimePol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->