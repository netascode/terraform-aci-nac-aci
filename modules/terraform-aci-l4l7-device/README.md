<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-l4l7-device/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-l4l7-device/actions/workflows/test.yml)

# Terraform ACI L4L7 Device Module

Manages L4L7 Device

Location in GUI:
`Tenants` » `XXX` » `Services` » `L4-L7` » `Devices`

## Examples

```hcl
module "aci_l4l7_device" {
  source  = "netascode/l4l7-device/aci"
  version = ">= 0.2.0"

  tenant          = "ABC"
  name            = "DEV1"
  alias           = "DEV1-ALIAS"
  context_aware   = "multi-Context"
  type            = "PHYSICAL"
  function        = "GoTo"
  copy_device     = false
  managed         = false
  service_type    = "FW"
  trunking        = false
  physical_domain = "PD1"
  concrete_devices = [{
    name  = "CDEV1"
    alias = "CDEV1-ALIAS"
    interfaces = [{
      name     = "CINT1"
      alias    = "CINT1-ALIAS"
      pod_id   = 2
      node_id  = 101
      node2_id = 102
      channel  = "VPC1"
    }]
  }]
  logical_interfaces = [{
    name  = "INT1"
    alias = "INT1-ALIAS"
    vlan  = 10
    concrete_interfaces = [{
      device    = "CDEV1"
      interface = "CINT1"
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
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Tenant name. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name. | `string` | n/a | yes |
| <a name="input_alias"></a> [alias](#input\_alias) | Alias. | `string` | `""` | no |
| <a name="input_context_aware"></a> [context\_aware](#input\_context\_aware) | Context aware. Choices: `single-Context`, `multi-Context`. | `string` | `"single-Context"` | no |
| <a name="input_type"></a> [type](#input\_type) | Type. Choices: `PHYSICAL`, `VIRTUAL`, `CLOUD`. | `string` | `"PHYSICAL"` | no |
| <a name="input_function"></a> [function](#input\_function) | Function. Choices: `None`, `GoTo`, `GoThrough`, `L2`, `L1`. | `string` | `"GoTo"` | no |
| <a name="input_copy_device"></a> [copy\_device](#input\_copy\_device) | Copy device. | `bool` | `false` | no |
| <a name="input_managed"></a> [managed](#input\_managed) | Managed. | `bool` | `false` | no |
| <a name="input_promiscuous_mode"></a> [promiscuous\_mode](#input\_promiscuous\_mode) | Promiscuous mode. | `bool` | `false` | no |
| <a name="input_service_type"></a> [service\_type](#input\_service\_type) | Service type. Choices: `ADC`, `FW`, `OTHERS`, `COPY`, `NATIVELB`. | `string` | `"OTHERS"` | no |
| <a name="input_trunking"></a> [trunking](#input\_trunking) | Trunking. | `bool` | `false` | no |
| <a name="input_physical_domain"></a> [physical\_domain](#input\_physical\_domain) | Phyical domain name. | `string` | `""` | no |
| <a name="input_vmm_provider"></a> [vmm\_provider](#input\_vmm\_provider) | Type. Choices: `CloudFoundry`, `Kubernetes`, `Microsoft`, `OpenShift`, `OpenStack`, `Redhat`, `VMware`. | `string` | `"VMware"` | no |
| <a name="input_vmm_domain"></a> [vmm\_domain](#input\_vmm\_domain) | Virtual Machine Manager domain name. | `string` | `""` | no |
| <a name="input_concrete_devices"></a> [concrete\_devices](#input\_concrete\_devices) | List of concrete devices. Allowed values `pod_id`: 1-255. Default value `pod_id`: 1. Allowed values `node_id`, `node2_id`: 1-4000. Allowed values `fex_id`: 101-199. Allowed values `module`: 1-9. Default value `module`: 1. Allowed values `port`: 1-127. | <pre>list(object({<br>    name         = string<br>    alias        = optional(string, "")<br>    vcenter_name = optional(string, "")<br>    vm_name      = optional(string, "")<br>    interfaces = optional(list(object({<br>      name      = string<br>      alias     = optional(string, "")<br>      vnic_name = optional(string, "")<br>      pod_id    = optional(number, 1)<br>      node_id   = optional(number)<br>      node2_id  = optional(number)<br>      fex_id    = optional(number)<br>      module    = optional(number, 1)<br>      port      = optional(number)<br>      channel   = optional(string)<br>    })), [])<br>  }))</pre> | `[]` | no |
| <a name="input_logical_interfaces"></a> [logical\_interfaces](#input\_logical\_interfaces) | List of logical interfaces. Allowed values `vlan`: 1-4096. | <pre>list(object({<br>    name  = string<br>    alias = optional(string, "")<br>    vlan  = optional(number)<br>    concrete_interfaces = optional(list(object({<br>      device    = string<br>      interface = string<br>    })))<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `vnsLDevVip` object. |
| <a name="output_name"></a> [name](#output\_name) | L4L7 device name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.vnsCDev](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsCIf](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsLDevVip](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsLIf](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsRsALDevToDomP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsRsALDevToPhysDomP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsRsCIfAttN](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsRsCIfPathAtt_channel](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsRsCIfPathAtt_port](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->