<!-- BEGIN_TF_DOCS -->
# Terraform ACI External Endpoint Group Module

Manages ACI External Endpoint Group

Location in GUI:
`Tenants` » `XXX` » `Networking` » `L3outs` » `XXX` » `External EPGs`

## Examples

```hcl
module "aci_external_endpoint_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-external-endpoint-group"
  version = ">= 0.8.0"

  tenant          = "ABC"
  l3out           = "L3OUT1"
  name            = "EXTEPG1"
  alias           = "EXTEPG1-ALIAS"
  description     = "My Description"
  preferred_group = true
  qos_class       = "level2"
  target_dscp     = "CS2"
  subnets = [{
    name                           = "SUBNET1"
    prefix                         = "10.0.0.0/8"
    description                    = "My Subnet Description"
    import_route_control           = true
    export_route_control           = true
    shared_route_control           = true
    import_security                = true
    shared_security                = true
    aggregate_import_route_control = true
    aggregate_export_route_control = true
    aggregate_shared_route_control = true
    bgp_route_summarization        = true
    bgp_route_summarization_policy = "BGP_RS_Policy1"
  }]
  contract_consumers          = ["CON1"]
  contract_providers          = ["CON1"]
  contract_imported_consumers = ["ICON1"]
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
| <a name="input_l3out"></a> [l3out](#input\_l3out) | L3out name. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name. | `string` | n/a | yes |
| <a name="input_annotation"></a> [annotation](#input\_annotation) | Annotation value. | `string` | `null` | no |
| <a name="input_alias"></a> [alias](#input\_alias) | Alias. | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_preferred_group"></a> [preferred\_group](#input\_preferred\_group) | Preferred group membership. | `bool` | `false` | no |
| <a name="input_qos_class"></a> [qos\_class](#input\_qos\_class) | QoS class. Choices: `level1`, `level2`, `level3`, `level4`, `level5`, `level6`, `unspecified`. | `string` | `"unspecified"` | no |
| <a name="input_target_dscp"></a> [target\_dscp](#input\_target\_dscp) | Target DSCP. Choices: `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7`, `unspecified` or a number between `0` and `63`. | `string` | `"unspecified"` | no |
| <a name="input_route_control_profiles"></a> [route\_control\_profiles](#input\_route\_control\_profiles) | List of route control profiles. Choices `direction`: `import`, `export`. | <pre>list(object({<br/>    name      = string<br/>    direction = optional(string, "import")<br/>  }))</pre> | `[]` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnets. Default value `import_route_control`: false. Default value `export_route_control`: false. Default value `shared_route_control`: false. Default value `import_security`: true. Default value `shared_security`: false. Default value `aggregate_import_route_control`: false. Default value `aggregate_export_route_control`: false. Default value `aggregate_shared_route_control`: false. Default value `bgp_route_summarization`: false. Default value `ospf_route_summarization`: false. Default value `eigrp_route_summarization`: false. | <pre>list(object({<br/>    name                           = optional(string, "")<br/>    annotation                     = optional(string, null)<br/>    prefix                         = string<br/>    description                    = optional(string, "")<br/>    import_route_control           = optional(bool, false)<br/>    export_route_control           = optional(bool, false)<br/>    shared_route_control           = optional(bool, false)<br/>    import_security                = optional(bool, true)<br/>    shared_security                = optional(bool, false)<br/>    aggregate_import_route_control = optional(bool, false)<br/>    aggregate_export_route_control = optional(bool, false)<br/>    aggregate_shared_route_control = optional(bool, false)<br/>    bgp_route_summarization        = optional(bool, false)<br/>    bgp_route_summarization_policy = optional(string, "")<br/>    ospf_route_summarization       = optional(bool, false)<br/>    eigrp_route_summarization      = optional(bool, false)<br/>    route_control_profiles = optional(list(object({<br/>      name      = string<br/>      direction = optional(string, "import")<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_contract_consumers"></a> [contract\_consumers](#input\_contract\_consumers) | List of contract consumers. | `list(string)` | `[]` | no |
| <a name="input_contract_providers"></a> [contract\_providers](#input\_contract\_providers) | List of contract providers. | `list(string)` | `[]` | no |
| <a name="input_contract_imported_consumers"></a> [contract\_imported\_consumers](#input\_contract\_imported\_consumers) | List of imported contract consumers. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `l3extInstP` object. |
| <a name="output_name"></a> [name](#output\_name) | External endpoint group name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.fvRsCons](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsConsIf](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsProv](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extInstP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extRsInstPToProfile](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extRsSubnetToProfile](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extRsSubnetToRtSumm](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extSubnet](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->