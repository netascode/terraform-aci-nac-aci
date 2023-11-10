<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-trust-control-policy/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-trust-control-policy/actions/workflows/test.yml)

# Terraform ACI Trust Control Policy Module

Manages ACI Trust Control Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `First Hop Security` » `Trust Control Policies`

## Examples

```hcl
module "aci_trust_control_policy" {
  source  = "netascode/trust-control-policy/aci"
  version = ">= 0.1.0"

  tenant         = "ABC"
  name           = "TCP1"
  description    = "My Description"
  dhcp_v4_server = true
  dhcp_v6_server = true
  ipv6_router    = true
  arp            = true
  nd             = true
  ra             = true
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
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Tenant name. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Trust control policy name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Trust control policy description. | `string` | `""` | no |
| <a name="input_dhcp_v4_server"></a> [dhcp\_v4\_server](#input\_dhcp\_v4\_server) | DHCP IPv4 server flag. | `bool` | `false` | no |
| <a name="input_dhcp_v6_server"></a> [dhcp\_v6\_server](#input\_dhcp\_v6\_server) | DHCP IPv6 server flag. | `bool` | `false` | no |
| <a name="input_ipv6_router"></a> [ipv6\_router](#input\_ipv6\_router) | IPv6 router flag. | `bool` | `false` | no |
| <a name="input_arp"></a> [arp](#input\_arp) | ARP flag. | `bool` | `false` | no |
| <a name="input_nd"></a> [nd](#input\_nd) | IPv6 neighbor discovery flag. | `bool` | `false` | no |
| <a name="input_ra"></a> [ra](#input\_ra) | IPv6 router advertisment flag. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `fhsTrustCtrlPol` object. |
| <a name="output_name"></a> [name](#output\_name) | Trust control policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.fhsTrustCtrlPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->