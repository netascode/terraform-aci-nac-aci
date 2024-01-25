<!-- BEGIN_TF_DOCS -->
# Terraform ACI Inband Node Address Module

Manages ACI Inband Node Address

Location in GUI:
`Tenants` » `mgmt` » `Node Management Addresses` » `Static Node Management Addresses`

## Examples

```hcl
module "aci_inband_node_address" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-inband-node-address"
  version = ">= 0.8.0"

  node_id             = 201
  pod_id              = 2
  ip                  = "10.1.1.100/24"
  gateway             = "10.1.1.254"
  v6_ip               = "2002::2/64"
  v6_gateway          = "2002::1"
  endpoint_group      = "INB1"
  endpoint_group_vlan = 4
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
| <a name="input_node_id"></a> [node\_id](#input\_node\_id) | Node ID. | `number` | n/a | yes |
| <a name="input_pod_id"></a> [pod\_id](#input\_pod\_id) | Pod ID. | `number` | `1` | no |
| <a name="input_ip"></a> [ip](#input\_ip) | Inband IP address. | `string` | `"0.0.0.0"` | no |
| <a name="input_gateway"></a> [gateway](#input\_gateway) | Inband gateway IP. | `string` | `"0.0.0.0"` | no |
| <a name="input_v6_ip"></a> [v6\_ip](#input\_v6\_ip) | Inband IPv6 address. | `string` | `"::"` | no |
| <a name="input_v6_gateway"></a> [v6\_gateway](#input\_v6\_gateway) | Inband IPv6 gateway IP. | `string` | `"::"` | no |
| <a name="input_endpoint_group"></a> [endpoint\_group](#input\_endpoint\_group) | Inband management endpoint group name. | `string` | n/a | yes |
| <a name="input_endpoint_group_vlan"></a> [endpoint\_group\_vlan](#input\_endpoint\_group\_vlan) | Inband management endpoint group vlan. | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `mgmtRsInBStNode` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest.mgmtInB](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest) | resource |
| [aci_rest_managed.mgmtRsInBStNode](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->