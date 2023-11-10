<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-scaffolding/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-scaffolding/actions/workflows/test.yml)

# Terraform ACI BGP Policy Module

Manages ACI BGP Policy

Location in GUI:
`System` » `System Settings` » `BGP Route Reflector`

## Examples

```hcl
module "aci_bgp_policy" {
  source  = "netascode/bgp-policy/aci"
  version = ">= 0.2.0"

  fabric_bgp_as = 65000
  fabric_bgp_rr = [{
    node_id = 2001
    pod_id  = 2
  }]
  fabric_bgp_external_rr = [{
    node_id = 2001
    pod_id  = 2
  }]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_fabric_bgp_as"></a> [fabric\_bgp\_as](#input\_fabric\_bgp\_as) | Fabric BGP AS. Minimum value: 1. Maximum value: 4294967295. | `number` | n/a | yes |
| <a name="input_fabric_bgp_rr"></a> [fabric\_bgp\_rr](#input\_fabric\_bgp\_rr) | List of fabric BGP route reflector nodes. Allowed values `node_id`: 1-4000. Allowed values `pod_id`: 1-255. Default value `pod_id`: 1. | <pre>list(object({<br>    node_id = number<br>    pod_id  = optional(number, 1)<br>  }))</pre> | `[]` | no |
| <a name="input_fabric_bgp_external_rr"></a> [fabric\_bgp\_external\_rr](#input\_fabric\_bgp\_external\_rr) | List of fabric BGP external route reflector nodes. Allowed values `node_id`: 1-4000. Allowed values `pod_id`: 1-255. Default value `pod_id`: 1. | <pre>list(object({<br>    node_id = number<br>    pod_id  = optional(number, 1)<br>  }))</pre> | `[]` | no |

## Outputs

No outputs.

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.bgpAsP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpRRNodePEp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpRRNodePEp-Ext](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->