<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-vpc-policy/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-vpc-policy/actions/workflows/test.yml)

# Terraform ACI vPC Policy Module

Manages ACI vPC Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Switch` » `VPC Domain`

## Examples

```hcl
module "aci_vpc_policy" {
  source  = "netascode/vpc-policy/aci"
  version = ">= 0.1.0"

  name               = "VPC1"
  peer_dead_interval = 300
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
| <a name="input_name"></a> [name](#input\_name) | VPC policy name. | `string` | n/a | yes |
| <a name="input_peer_dead_interval"></a> [peer\_dead\_interval](#input\_peer\_dead\_interval) | Peer dead interval. Minimum value: 5. Maximum value: 600. | `number` | `200` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `vpcInstPol` object. |
| <a name="output_name"></a> [name](#output\_name) | VPC policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.vpcInstPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->