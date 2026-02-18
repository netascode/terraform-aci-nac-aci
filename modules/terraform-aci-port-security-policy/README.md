<!-- BEGIN_TF_DOCS -->
# Terraform ACI Port Security Policy Module

Manages ACI Port Security Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `Port Security`

## Examples

```hcl
module "aci_port_security_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-port-security-policy"
  version = "> 1.2.0"

  name              = "PORT_SEC_10"
  description       = "Port security with max 10 endpoints"
  maximum_endpoints = 10
  timeout           = 300
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.17.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.17.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Port security policy name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_maximum_endpoints"></a> [maximum\_endpoints](#input\_maximum\_endpoints) | Maximum number of endpoints. A value of 0 means unlimited. | `number` | `0` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Port security timeout in seconds. | `number` | `60` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `l2PortSecurityPol` object. |
| <a name="output_name"></a> [name](#output\_name) | Port security policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.l2PortSecurityPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->