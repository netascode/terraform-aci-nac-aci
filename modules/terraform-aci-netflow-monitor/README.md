<!-- BEGIN_TF_DOCS -->
# Terraform ACI Netflow Monitor Module

Manages ACI Netflow Monitors

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface Policies` » `NetFlow` » `Netflow Records`

## Examples

```hcl
module "aci_netflow_monitor" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-netflow-monitor"
  version = ">= 0.9.0"

  name           = "MONITOR1"
  description    = "Netflow monitor 1"
  flow_record    = "RECORD1"
  flow_exporters = ["EXPORTER1", "EXPORTER2"]
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
| <a name="input_name"></a> [name](#input\_name) | Netflow Monitor name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Netflow Monitor description. | `string` | `""` | no |
| <a name="input_flow_record"></a> [flow\_record](#input\_flow\_record) | Netflow Monitor flow record. | `string` | `""` | no |
| <a name="input_flow_exporters"></a> [flow\_exporters](#input\_flow\_exporters) | Netflow Monitor flow exporters. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `netflowMonitorPol` object. |
| <a name="output_name"></a> [name](#output\_name) | Netflow Monitor name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.netflowMonitorPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.netflowRsMonitorToExporter](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.netflowRsMonitorToRecord](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->