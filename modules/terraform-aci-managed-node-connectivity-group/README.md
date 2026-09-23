<!-- BEGIN_TF_DOCS -->
# Terraform ACI Managed Node Connectivity Group Module

Manages ACI Managed Node Connectivity Group

Location in GUI:
`Tenant` » `mgmt` » `Managed Node Connectivity Groups`

## Examples

```hcl
module "aci_managed_node_connectivity_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-managed-node-connectivity-group"
  version = "> 2.0.0"

  name                = "MGMT-CONN-GRP1"
  oob_mgmt_epg        = "OOB1"
  oob_ip_address_pool = "POOL1"
  inb_mgmt_epg        = "INB1"
  inb_ip_address_pool = "POOL2"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Managed node connectivity group name. | `string` | n/a | yes |
| <a name="input_oob_mgmt_epg"></a> [oob\_mgmt\_epg](#input\_oob\_mgmt\_epg) | Out-of-band management EPG name, under the `mgmt` tenant. An empty string disables the out-of-band zone's EPG association. | `string` | `""` | no |
| <a name="input_oob_ip_address_pool"></a> [oob\_ip\_address\_pool](#input\_oob\_ip\_address\_pool) | Out-of-band IP address pool name, under the `mgmt` tenant. An empty string disables the out-of-band zone's address pool association. | `string` | `""` | no |
| <a name="input_inb_mgmt_epg"></a> [inb\_mgmt\_epg](#input\_inb\_mgmt\_epg) | In-band management EPG name, under the `mgmt` tenant. An empty string disables the in-band zone's EPG association. | `string` | `""` | no |
| <a name="input_inb_ip_address_pool"></a> [inb\_ip\_address\_pool](#input\_inb\_ip\_address\_pool) | In-band IP address pool name, under the `mgmt` tenant. An empty string disables the in-band zone's address pool association. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `mgmtGrp` object. |
| <a name="output_name"></a> [name](#output\_name) | Managed node connectivity group name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.mgmtGrp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.mgmtInBZone](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.mgmtOoBZone](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.mgmtRsAddrInst_inb](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.mgmtRsAddrInst_oob](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.mgmtRsInB](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.mgmtRsOoB](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->