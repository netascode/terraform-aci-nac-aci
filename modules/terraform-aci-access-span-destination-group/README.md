<!-- BEGIN_TF_DOCS -->
# Terraform ACI Access SPAN Destination Group Module

Manages ACI Access SPAN Destination Group

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Troubleshooting` » `SPAN` » `SPAN Destination Groups`

## Examples

```hcl
module "aci_access_span_destination_group-destination_epg" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-span-destination-group"
  version = ">= 0.8.0"

  name                = "ABC"
  ip                  = "1.1.1.1"
  source_prefix       = "2.2.2.2"
  dscp                = "CS0"
  mtu                 = 9000
  ttl                 = 16
  span_version        = 2
  enforce_version     = true
  tenant              = "TEN1"
  application_profile = "APP1"
  endpoint_group      = "EPG1"
}

module "aci_access_span_destination_group-destination_port" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-span-destination-group"
  version = ">= 0.8.0"

  name    = "ABC"
  mtu     = 9000
  pod_id  = 2
  node_id = 101
  module  = 2
  port    = 10
}

module "aci_access_span_destination_group-destination_subport" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-span-destination-group"
  version = ">= 0.8.0"

  name     = "ABC"
  mtu      = 9000
  pod_id   = 2
  node_id  = 101
  module   = 2
  port     = 10
  sub_port = 5
}


module "aci_access_span_destination_group-destination_channel" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-span-destination-group"
  version = ">= 0.8.0"

  name    = "ABC"
  mtu     = 9000
  node_id = 101
  channel = "PC1"
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
| <a name="input_name"></a> [name](#input\_name) | Access SPAN Destination Group name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Access SPAN Destination Group description. | `string` | `""` | no |
| <a name="input_pod_id"></a> [pod\_id](#input\_pod\_id) | Access SPAN Destination Group Pod ID. Minimum value: `1`. Maximum value: `255`. | `number` | `1` | no |
| <a name="input_node_id"></a> [node\_id](#input\_node\_id) | Access SPAN Destination Group Node ID. Minimum value: `1`. Maximum value: `4000`. | `number` | `0` | no |
| <a name="input_module"></a> [module](#input\_module) | Access SPAN Destination Group Module. Minimum value: `1`. Maximum value: `9`. | `number` | `1` | no |
| <a name="input_port"></a> [port](#input\_port) | Access SPAN Destination Group port. Minimum value: `1`. Maximum value: `127`. | `number` | `0` | no |
| <a name="input_sub_port"></a> [sub\_port](#input\_sub\_port) | Access SPAN Destination Group Sub-port. Minimum value: `1`. Maximum value: `16`. | `number` | `0` | no |
| <a name="input_channel"></a> [channel](#input\_channel) | Access SPAN Destination Group Channel Name. | `string` | `""` | no |
| <a name="input_ip"></a> [ip](#input\_ip) | Access SPAN Destination Group IP. | `string` | `""` | no |
| <a name="input_source_prefix"></a> [source\_prefix](#input\_source\_prefix) | Access SPAN Destination Group source prefix. | `string` | `""` | no |
| <a name="input_dscp"></a> [dscp](#input\_dscp) | Access SPAN Destination Group DSCP. Allowed values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63. | `string` | `"unspecified"` | no |
| <a name="input_flow_id"></a> [flow\_id](#input\_flow\_id) | Access SPAN Destination Group flow id. Allowed values: 1-1023. | `number` | `1` | no |
| <a name="input_mtu"></a> [mtu](#input\_mtu) | Access SPAN Destination Group MTU. Allowed values: 64-9216. | `number` | `1518` | no |
| <a name="input_ttl"></a> [ttl](#input\_ttl) | Access SPAN Destination Group TTL. Allowed values: 1-255. | `number` | `64` | no |
| <a name="input_span_version"></a> [span\_version](#input\_span\_version) | Access SPAN Destination Group SPAN version. Allowed values: 1-2. | `number` | `1` | no |
| <a name="input_enforce_version"></a> [enforce\_version](#input\_enforce\_version) | Access SPAN Destination Group enforced version flag. | `bool` | `false` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Access SPAN Destination Group Tenant name. | `string` | `""` | no |
| <a name="input_application_profile"></a> [application\_profile](#input\_application\_profile) | Access SPAN Destination Group Application Profile name. | `string` | `""` | no |
| <a name="input_endpoint_group"></a> [endpoint\_group](#input\_endpoint\_group) | Access SPAN Destination Group Endpoint Group name. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `spanDestGrp` object. |
| <a name="output_name"></a> [name](#output\_name) | Access SPAN Destination Group name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.spanDest](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanDestGrp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanRsDestEpg](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanRsDestPathEp_channel](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanRsDestPathEp_port](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanRsDestPathEp_subport](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->