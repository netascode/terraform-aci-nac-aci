<!-- BEGIN_TF_DOCS -->
# Terraform ACI QoS Module

Manages ACI QoS

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Global` » `QOS Class`

## Examples

```hcl
module "aci_qos" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-qos"
  version = ">= 0.8.0"

  preserve_cos = true
  qos_classes = [{
    level                = 1
    admin_state          = false
    mtu                  = 9000
    bandwidth_percent    = 30
    scheduling           = "strict-priority"
    congestion_algorithm = "wred"
    minimum_buffer       = 1
    pfc_state            = true
    no_drop_cos          = "cos1"
    pfc_scope            = "fabric"
    ecn                  = true
    forward_non_ecn      = true
    wred_max_threshold   = 90
    wred_min_threshold   = 10
    wred_probability     = 5
    weight               = 1
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
| <a name="input_preserve_cos"></a> [preserve\_cos](#input\_preserve\_cos) | Preserve CoS. | `bool` | `false` | no |
| <a name="input_qos_classes"></a> [qos\_classes](#input\_qos\_classes) | List of QoS classes. Allowed values `level`: 1-6. Default value `admin_state`: true. Allowed values `mtu`: 1-9216. Default value `mtu`: 9000. Allowed values `bandwidth_percent`: 0-100. Default value `bandwidth_percent`: 20. Choices `scheduling`: `wrr`, `strict-priority`. Default value `scheduling`: `wrr`. Choices `congestion_algorithm`: `tail-drop`, `wred`. Default value `congestion_algorithm`: `tail-drop`. Allowed values `minimum_buffer`: 0-3. Default value `minimum_buffer`: 0. Default value `pfc_state`: false. Choices `no_drop_cos`: `unspecified`, `cos0`, `cos1`, `cos2`, `cos3`, `cos4`, `cos5`, `cos6`, `cos7`, `. Default value `no\_drop\_cos`: `. Choices `pfc_scope`: `tor`, `fabric`. Default value `pfc_scope`: `tor`. Default value `ecn`: false. Default value `forward_non_ecn`: false. Allowed values `wred_max_threshold`: 0-100. Default value `wred_max_threshold`: 100. Allowed values `wred_min_threshold`: 0-100. Default value `wred_min_threshold`: 0. Allowed values `wred_probability`: 0-100. Default value `wred_probability`: 0. Allowed values `weight`: 0-7. Default value `weight`: 0. | <pre>list(object({<br/>    level                = number<br/>    admin_state          = optional(bool, true)<br/>    mtu                  = optional(number, 9000)<br/>    scheduling           = optional(string, "wrr")<br/>    bandwidth_percent    = optional(number, 20)<br/>    congestion_algorithm = optional(string, "tail-drop")<br/>    minimum_buffer       = optional(number, 0)<br/>    pfc_state            = optional(bool, false)<br/>    no_drop_cos          = optional(string, "")<br/>    pfc_scope            = optional(string, "tor")<br/>    ecn                  = optional(bool, false)<br/>    forward_non_ecn      = optional(bool, false)<br/>    wred_max_threshold   = optional(number, 100)<br/>    wred_min_threshold   = optional(number, 0)<br/>    wred_probability     = optional(number, 0)<br/>    weight               = optional(number, 0)<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `qosInstPol` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.qosBuffer](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.qosClass](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.qosCong](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.qosInstPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.qosPfcPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.qosQueue](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.qosSched](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->