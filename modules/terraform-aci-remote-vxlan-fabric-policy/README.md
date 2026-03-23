<!-- BEGIN_TF_DOCS -->
# Terraform ACI Remote VXLAN Fabric Policy Module

Description

Location in GUI:
`Tenants` » `infra` » `Policies` » `VXLAN Gateway` » `Remote VXLAN Fabrics`

## Examples

```hcl
module "terraform-aci-remote-vxlan-fabric-policy" {
  source  = "netascode/nac-aci/aci/modules/terraform-aci-remote-vxlan-fabric-policy"
  version = ">= 0.9.1"

  name               = "REMOTE_VXLAN_POLICY"
  border_gateway_set = "BGW1"
  remote_evpn_peers = [
    {
      ip                    = "10.1.1.1"
      description           = "Remote EVPN Peer 1"
      remote_as             = "65001"
      admin_state           = true
      allow_self_as         = false
      disable_peer_as_check = false
      password              = "secret123"
      ttl                   = 10
      peer_prefix_policy    = "PREFIX_POLICY1"
      as_propagate          = "none"
      local_as              = 65000
    }
  ]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.17.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.17.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Remote Vxlan Fabric name. | `string` | n/a | yes |
| <a name="input_remote_evpn_peers"></a> [remote\_evpn\_peers](#input\_remote\_evpn\_peers) | List of Remote EVPN peers. | <pre>list(object({<br/>    ip                    = string<br/>    description           = optional(string)<br/>    remote_as             = string<br/>    admin_state           = optional(bool, true)<br/>    allow_self_as         = optional(bool, false)<br/>    disable_peer_as_check = optional(bool, false)<br/>    password              = optional(string)<br/>    ttl                   = optional(number)<br/>    peer_prefix_policy    = optional(string)<br/>    as_propagate          = optional(string)<br/>    local_as              = optional(number)<br/>  }))</pre> | `[]` | no |
| <a name="input_border_gateway_set"></a> [border\_gateway\_set](#input\_border\_gateway\_set) | Border Gateway Set policy name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `vxlanRemoteFabric` object. |
| <a name="output_name"></a> [name](#output\_name) | vxlanRemoteFabric name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.bgpAsP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpInfraPeerP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpLocalAsnP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpRsPeerPfxPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vxlanRemoteFabric](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vxlanRsRemoteFabricToBgwSet](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->