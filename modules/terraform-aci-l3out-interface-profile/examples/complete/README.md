<!-- BEGIN_TF_DOCS -->
# L3out Interface Profile Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_l3out_interface_profile" {
  source  = "netascode/l3out-interface-profile/aci"
  version = ">= 0.2.11"

  tenant                      = "ABC"
  l3out                       = "L3OUT1"
  node_profile                = "NP1"
  name                        = "IP1"
  multipod                    = false
  remote_leaf                 = false
  bfd_policy                  = "BFD1"
  ospf_interface_profile_name = "OSPFP1"
  ospf_authentication_key     = "12345678"
  ospf_authentication_key_id  = 2
  ospf_authentication_type    = "md5"
  ospf_interface_policy       = "OSPF1"
  igmp_interface_policy       = "IIP"
  qos_class                   = "level2"
  custom_qos_policy           = "CQP"
  interfaces = [{
    description = "Interface 1"
    type        = "vpc"
    svi         = true
    vlan        = 5
    mac         = "12:34:56:78:90:AB"
    mtu         = "1500"
    mode        = "native"
    node_id     = 201
    node2_id    = 202
    pod_id      = 2
    channel     = "VPC1"
    ip_a        = "1.1.1.2/24"
    ip_b        = "1.1.1.3/24"
    ip_shared   = "1.1.1.1/24"
    bgp_peers = [{
      ip                               = "4.4.4.4"
      remote_as                        = 12345
      description                      = "BGP Peer Description"
      allow_self_as                    = true
      as_override                      = true
      disable_peer_as_check            = true
      next_hop_self                    = false
      send_community                   = true
      send_ext_community               = true
      password                         = "BgpPassword"
      allowed_self_as_count            = 5
      bfd                              = true
      disable_connected_check          = true
      ttl                              = 2
      weight                           = 200
      remove_all_private_as            = true
      remove_private_as                = true
      replace_private_as_with_local_as = true
      unicast_address_family           = false
      multicast_address_family         = false
      admin_state                      = false
      local_as                         = 12346
      as_propagate                     = "no-prepend"
      peer_prefix_policy               = "PPP"
      export_route_control             = "ERC"
      import_route_control             = "IRC"
    }]
  }]
}
```
<!-- END_TF_DOCS -->