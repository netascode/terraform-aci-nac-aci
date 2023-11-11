<!-- BEGIN_TF_DOCS -->
# Terraform ACI Forwarding Scale Policy Module

Manages ACI Forwarding Scale Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Switch` » `Forwarding Scale Profiles`

## Examples

```hcl
module "aci_forwarding_scale_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-forwarding-scale-policy"
  version = ">= 0.8.0"

  name    = "HIGH-DUAL-STACK"
  profile = "high-dual-stack"
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
| <a name="input_name"></a> [name](#input\_name) | Forwarding scale policy name. | `string` | n/a | yes |
| <a name="input_profile"></a> [profile](#input\_profile) | Profile. Choices: `dual-stack`, `ipv4`, `high-dual-stack`, `high-lpm`. | `string` | `"dual-stack"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `topoctrlFwdScaleProfilePol` object. |
| <a name="output_name"></a> [name](#output\_name) | Forwarding scale policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.topoctrlFwdScaleProfilePol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->