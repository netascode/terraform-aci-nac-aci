<!-- BEGIN_TF_DOCS -->
# Terraform ACI MACsec Interfaces Policy Module

Manages ACI MACsec Interfaces Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `MACsec` » `Interfaces`

## Examples

```hcl
module "aci_macsec_interfaces_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-macsec-interfaces-policy"
  version = ">= 0.8.0"

  name                     = "macsec-int-pol"
  admin_state              = true
  macsec_parameters_policy = "macsec-parameter-policy"
  macsec_keychain_policy   = "macsec-keychain-policy"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.0.0 |

## Providers

No providers.

## Inputs

No inputs.

## Outputs

No outputs.

## Resources

No resources.
<!-- END_TF_DOCS -->