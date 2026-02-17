<!-- BEGIN_TF_DOCS -->
# Terraform ACI Remote VxLAN Fabric Policy Module

Manages ACI Remote VxLAN Fabric Policy

Location in GUI:
`Tenant` » `Infra` » `Policies` » `VXLAN Gateways` » `Remote VXLAN Fabrics`

## Examples

```hcl
module "aci_remote_vxlan_fabric_policy" {
  source = "./modules/terraform-aci-remote-vxlan-fabric-policy"

  tenant      = "infra"
  name        = "REMOTE_VXLAN_POLICY"
  border_gateway_set = "BGW1"
  remote_evpn_peers = [
    {
      ip                        = "10.1.1.1"
      description               = "Remote EVPN Peer 1"
      remote_as                 = "65001"
      admin_state               = true
      allow_self_as             = false
      disable_peer_as_check     = false
      password                  = "secret123"
      ttl                       = 10
      peer_prefix_policy        = "PREFIX_POLICY1"
      as_propagate              = "none"
      local_as                  = 65000
    }
  ]
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
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Tenant name. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Node profile name. | `string` | n/a | yes |
| <a name="input_border_gateway_set"></a> [bgw\_pol\_set](#input\_bgw\_pol\_set) | Border Gateway Set. | `string` | n/a | yes |
| <a name="input_remote_evpn_peers"></a> [remote\_evpn\_peers](#input\_remote\_evpn\_peers) | List of Remote EVPN peers with `ip`, `description`, `remote_as` (0-4294967295), `admin_state`, `allow_self_as`, `disable_peer_as_check`, `password`, `ttl` (1-255), `peer_prefix_policy`, `as_propagate` (none/no-prepend/replace-as/dual-as), `local_as` (0-4294967295). | <pre>list(object({
  ip                        = string
  description               = optional(string)
  remote_as                 = string
  admin_state               = optional(bool, true)
  allow_self_as             = optional(bool, false)
  disable_peer_as_check     = optional(bool, false)
  password                  = optional(string)
  ttl                       = optional(number)
  peer_prefix_policy        = optional(string)
  as_propagate              = optional(string)
  local_as                  = optional(number)
}))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `l3extRsEctx` object. |
| <a name="output_name"></a> [name](#output\_name) | Remote VxLAN fabric policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.l3extRsEctx](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpPeerP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->
