<!-- BEGIN_TF_DOCS -->
# Terraform CoPP Interface Policy Module

Manages CoPP Interface Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `CoPP Interface`

## Examples

```hcl
module "aci_copp_interface_policy" {
  source = "./modules/terraform-aci-copp-interface-policy"

  name        = "COPP1"
  description = "COPP1 Description"
  protocol_policies = [{
    name            = "COPP-PROTO1"
    rate            = "123"
    burst           = "1234"
    match_protocols = ["bgp", "ospf"]
  }]
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
| <a name="input_name"></a> [name](#input\_name) | CoPP Interface policy name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | CoPP Interface policy description. | `string` | `""` | no |
| <a name="input_protocol_policies"></a> [protocol\_policies](#input\_protocol\_policies) | CoPP protocol policies. | <pre>list(object({<br>    name            = string<br>    rate            = optional(string, 10)<br>    burst           = optional(string, 10)<br>    match_protocols = optional(list(string), null)<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `coppIfPol` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.coppIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.coppProtoClassP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->