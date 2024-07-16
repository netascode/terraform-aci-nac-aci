<!-- BEGIN_TF_DOCS -->
# Terraform ACI MACsec Parameters Policy Module

Manages ACI MACsec Parameters Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `MACsec` » `Parameters`

## Examples

```hcl
module "aci_macsec_parameters_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-macsec-parameters-policy"
  version = ">= 0.8.0"

  name          = "macsecparam1"
  descr         = "macsecparam1 description"
  admin_state   = true
  confOffset    = "offset-30"
  keySvrPrio    = 128
  cipherSuite   = "gcm-aes-128"
  replayWindow  = 1024
  sakExpiryTime = 120
  secPolicy     = "must-secure"
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