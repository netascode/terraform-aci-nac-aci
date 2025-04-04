module "aci_l3out_node_profile" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-l3out-node-profile"
  version = ">= 0.9.1"

  tenant             = "ABC"
  l3out              = "L3OUT1"
  name               = "NP1"
  bgp_timer_policy   = "BGP_TIMER-1"
  bgp_as_path_policy = "BGP_AS_PATH-1"
  multipod           = true
  remote_leaf        = false
  nodes = [{
    node_id               = 201
    pod_id                = 2
    router_id             = "2.2.2.2"
    router_id_as_loopback = false
    loopbacks             = ["12.12.12.12", "2001:db8:42f8:2c07:85a3:0000:0000:abcd"]
    static_routes = [{
      prefix      = "0.0.0.0/0"
      description = "Default Route"
      preference  = 10
      bfd         = true
      next_hops = [{
        ip          = "3.3.3.3"
        description = "Next Hop Description"
        preference  = 10
        type        = "prefix"
      }]
    }]
  }]
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
}
