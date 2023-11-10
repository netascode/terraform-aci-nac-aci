<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-fabric-isis-bfd/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-fabric-isis-bfd/actions/workflows/test.yml)

# Terraform ACI Fabric ISIS BFD Module

Manages ACI Fabric ISIS BFD

Location in GUI:
`Fabric` » `Fabric Policies` » `Policies` » `Interface` » `L3 Interface` » `default`

## Examples

```hcl
module "aci_fabric_isis_bfd" {
  source  = "netascode/fabric-isis-bfd/aci"
  version = ">= 0.1.0"

  admin_state = true
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
| <a name="input_admin_state"></a> [admin\_state](#input\_admin\_state) | Admin state. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `l3IfPol` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.l3IfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->