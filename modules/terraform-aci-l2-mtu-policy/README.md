<!-- BEGIN_TF_DOCS -->
# Terraform ACI L2 MTU Policy Module

Description

Location in GUI:
`Fabric` » `Fabric Policies` » `Policies` » `Global` » `Fabric L2 MTU`

## Examples

```hcl
module "aci_l2_mtu_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-l2-mtu-policy"
  version = ">= 0.8.0"

  name          = "L2_8950"
  port_mtu_size = 8950
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
| <a name="input_name"></a> [name](#input\_name) | Fabric L2 MTU custom policy name | `string` | n/a | yes |
| <a name="input_port_mtu_size"></a> [port\_mtu\_size](#input\_port\_mtu\_size) | L2 MTU. Minimum value: `576`. Maximum value: `9216`. | `number` | `9000` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `l2InstPol` object. |
| <a name="output_name"></a> [name](#output\_name) | MTU policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.l2InstPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->