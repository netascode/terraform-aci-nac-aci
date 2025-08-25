<!-- BEGIN_TF_DOCS -->
# Terraform ACI External Connectivity Policy Module

Manages ACI External Connectivity Policy

Location in GUI:
`Tenants` » `infra` » `Policies` » `Protocol` » `Fabric Ext Connection Policies`

## Examples

```hcl
module "aci_external_connectivity_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-external-connectivity-policy"
  version = ">= 0.8.0"

  name         = "EXT-POL1"
  route_target = "extended:as2-nn4:5:17"
  fabric_id    = 2
  site_id      = 2
  peering_type = "route_reflector"
  bgp_password = "SECRETPW"
  routing_profiles = [{
    name        = "PROF1"
    description = "My Description"
    subnets     = ["10.0.0.0/24"]
  }]
  data_plane_teps = [{
    pod_id = 2
    ip     = "11.1.1.11"
  }]
  unicast_teps = [{
    pod_id = 2
    ip     = "1.2.3.4"
  }]
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
| <a name="input_name"></a> [name](#input\_name) | External connectivity policy name. | `string` | n/a | yes |
| <a name="input_route_target"></a> [route\_target](#input\_route\_target) | Route target. | `string` | `"extended:as2-nn4:5:16"` | no |
| <a name="input_fabric_id"></a> [fabric\_id](#input\_fabric\_id) | Fabric ID. Minimum value: 1. Maximum value: 65535. | `number` | `1` | no |
| <a name="input_site_id"></a> [site\_id](#input\_site\_id) | Site ID. Minimum value: 0. Maximum value: 1000. | `number` | `0` | no |
| <a name="input_peering_type"></a> [peering\_type](#input\_peering\_type) | Peering type. Choices: `full_mesh`, `route_reflector`. | `string` | `"full_mesh"` | no |
| <a name="input_bgp_password"></a> [bgp\_password](#input\_bgp\_password) | BGP password. | `string` | `null` | no |
| <a name="input_routing_profiles"></a> [routing\_profiles](#input\_routing\_profiles) | External routing profiles. | <pre>list(object({<br/>    name        = string<br/>    description = optional(string, "")<br/>    subnets     = optional(list(string), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_data_plane_teps"></a> [data\_plane\_teps](#input\_data\_plane\_teps) | Data plane TEPs. Allowed values `pod_id`: 1-255. | <pre>list(object({<br/>    pod_id = number<br/>    ip     = string<br/>  }))</pre> | `[]` | no |
| <a name="input_unicast_teps"></a> [unicast\_teps](#input\_unicast\_teps) | Unicast TEPs. Allowed values `pod_id`: 1-255. | <pre>list(object({<br/>    pod_id = number<br/>    ip     = string<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `fvFabricExtConnP` object. |
| <a name="output_name"></a> [name](#output\_name) | External connectivity policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.fvExtRoutableUcastConnP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvFabricExtConnP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvIp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvPeeringP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvPodConnP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extFabricExtRoutingP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extSubnet](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->