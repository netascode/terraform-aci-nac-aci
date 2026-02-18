module "aci_bridge_domain" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-bridge-domain"
  version = ">= 0.8.0"

  tenant                     = "ABC"
  name                       = "BD1"
  alias                      = "BD1-ALIAS"
  description                = "My Description"
  arp_flooding               = true
  advertise_host_routes      = true
  ip_dataplane_learning      = false
  limit_ip_learn_to_subnets  = false
  mac                        = "11:11:11:11:11:11"
  ep_move_detection          = true
  virtual_mac                = "22:22:22:22:22:22"
  l3_multicast               = true
  multicast_arp_drop         = true
  multi_destination_flooding = "drop"
  unicast_routing            = false
  unknown_unicast            = "flood"
  unknown_ipv4_multicast     = "opt-flood"
  unknown_ipv6_multicast     = "opt-flood"
  vrf                        = "VRF1"
  nd_interface_policy        = "ND_INTF_POL1"
  endpoint_retention_policy  = "ERP1"
  legacy_mode_vlan           = 135
  subnets = [{
    description        = "Subnet Description"
    ip                 = "1.1.1.1/24"
    primary_ip         = true
    public             = true
    shared             = true
    igmp_querier       = true
    nd_ra_prefix       = false
    no_default_gateway = false
    tags = [
      {
        key   = "tag_key"
        value = "tag_value"
      }
    ]
  }]
  l3outs = ["L3OUT1"]
  dhcp_labels = [{
    dhcp_relay_policy  = "DHCP_RELAY_1"
    dhcp_option_policy = "DHCP_OPTION_1"
  }]
  netflow_monitor_policies = [{
    name           = "NETFLOW_MONITOR_1"
    ip_filter_type = "ipv4"
  }]
}
