<!-- BEGIN_TF_DOCS -->
# Terraform ACI Netflow Record Module

Manages ACI Netflow Records

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface Policies` » `NetFlow` » `Netflow Records`

## Examples

```hcl
module "aci_netflow_record" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-netflow-record"
  version = ">= 0.9.0"

  name             = "RECORD1"
  description      = "Netflow record 1"
  match_parameters = ["dst-ip", "src-ip"]
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
| <a name="input_name"></a> [name](#input\_name) | Netflow Record name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Netflow Record description. | `string` | `""` | no |
| <a name="input_match_parameters"></a> [match\_parameters](#input\_match\_parameters) | Netflow Record match parameters. Allowed values: `dst-ip`, `dst-ipv4`, `dst-ipv6`, `dst-mac`, `dst-port`, `ethertype`, `proto`, `src-ip`, `src-ipv4`, `src-ipv6`, `src-mac`, `src-port`, `tos`, `vlan`, `unspecified`. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `netflowRecordPol` object. |
| <a name="output_name"></a> [name](#output\_name) | Netflow Record name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.netflowRecordPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->