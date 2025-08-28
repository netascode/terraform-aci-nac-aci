<!-- BEGIN_TF_DOCS -->
# Terraform ACI Control Plane MTU Module

Manages ACI Control Plane MTU

Location in GUI:
`System` » `System Settings` » `Control Plane  MTU`

## Examples

```hcl
module "aci_control_plane_mtu" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-control-plane-mtu"
  version = "> 1.1.0"

  CPMtu        = 9000
  APICMtuApply = true
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.15.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.15.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_mtu"></a> [mtu](#input\_mtu) | CP MTU policy. | `number` | `9000` | no |
| <a name="input_apic_mtu_apply"></a> [apic\_mtu\_apply](#input\_apic\_mtu\_apply) | APIC MTU apply policy | `bool` | `"false"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `infraCPMtuPol` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.infraCPMtuPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->