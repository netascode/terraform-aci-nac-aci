<!-- BEGIN_TF_DOCS -->
# Terraform ACI OOB Node Address Module

Manages ACI OOB Node Address

Location in GUI:
`Tenants` » `mgmt` » `Node Management Addresses` » `Static Node Management Addresses`

## Examples

```hcl
module "aci_oob_node_address" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-oob-node-address"
  version = ">= 0.8.0"

  node_id        = 111
  pod_id         = 2
  ip             = "100.1.1.111/24"
  gateway        = "100.1.1.254"
  v6_ip          = "2001::2/64"
  v6_gateway     = "2001::1"
  endpoint_group = "OOB1"
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
| <a name="input_ip"></a> [ip](#input\_ip) | OOB IP address. | `string` | `"0.0.0.0"` | no |
| <a name="input_gateway"></a> [gateway](#input\_gateway) | OOB gateway IP. | `string` | `"0.0.0.0"` | no |
| <a name="input_v6_ip"></a> [v6\_ip](#input\_v6\_ip) | OOB IPv6 address. | `string` | `"::"` | no |
| <a name="input_v6_gateway"></a> [v6\_gateway](#input\_v6\_gateway) | OOB IPv6 gateway IP. | `string` | `"::"` | no |
| <a name="input_endpoint_group"></a> [endpoint\_group](#input\_endpoint\_group) | OOB management endpoint group name. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `mgmtRsOoBStNode` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest.mgmtOoB](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest) | resource |
| [aci_rest_managed.mgmtRsOoBStNode](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->