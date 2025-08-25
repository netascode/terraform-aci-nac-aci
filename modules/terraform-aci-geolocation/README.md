<!-- BEGIN_TF_DOCS -->
# Terraform ACI Geolocation Module

ACI Geolocation

Location in GUI:
`Fabric` » `Fabric Policies` » `Policies` » `Geolocation`

## Examples

```hcl
module "aci_geolocation" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-geolocation"
  version = ">= 0.8.0"

  name        = "SITE1"
  description = "Site Description"
  buildings = [{
    name        = "BUILDING1"
    description = "Building Description"
    floors = [{
      name        = "FLOOR1"
      description = "Floor Description"
      rooms = [{
        name        = "ROOM1"
        description = "Room Description"
        rows = [{
          name        = "ROW1"
          description = "Row Description"
          racks = [{
            name        = "RACK1"
            description = "Rack Description"
            nodes = [{
              node_id = 201
              pod_id  = 2
            }]
          }]
        }]
      }]
    }]
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
| <a name="input_name"></a> [name](#input\_name) | Site name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Site description. | `string` | `""` | no |
| <a name="input_buildings"></a> [buildings](#input\_buildings) | List of buildings. Allowed values `node_id`: 1-4000. Allowed values `pod_id`: 1-255. Default value `pod_id`: 1. | <pre>list(object({<br/>    name        = string<br/>    description = optional(string, "")<br/>    floors = optional(list(object({<br/>      name        = string<br/>      description = optional(string, "")<br/>      rooms = optional(list(object({<br/>        name        = string<br/>        description = optional(string, "")<br/>        rows = optional(list(object({<br/>          name        = string<br/>          description = optional(string, "")<br/>          racks = optional(list(object({<br/>            name        = string<br/>            description = optional(string, "")<br/>            nodes = optional(list(object({<br/>              node_id = number<br/>              pod_id  = optional(number, 1)<br/>            })), [])<br/>          })), [])<br/>        })), [])<br/>      })), [])<br/>    })), [])<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `geoSite` object. |
| <a name="output_name"></a> [name](#output\_name) | Site name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.geoBuilding](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.geoFloor](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.geoRack](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.geoRoom](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.geoRow](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.geoRsNodeLocation](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.geoSite](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->