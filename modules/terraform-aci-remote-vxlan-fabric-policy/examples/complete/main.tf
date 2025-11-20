module "terraform-aci-remote-vxlan-fabric-policy" {
  source  = "netascode/nac-aci/aci/modules/terraform-aci-remote-vxlan-fabric-policy"
  version = ">= 0.9.1"

  tenant      = "infra"
  name        = "REMOTE_VXLAN_POLICY"
  bgw_pol_set = "BGW1"
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
