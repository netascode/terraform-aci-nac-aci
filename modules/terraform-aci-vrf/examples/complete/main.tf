module "aci_vrf" {
  source  = "netascode/vrf/aci"
  version = ">= 0.2.4"

  tenant                                 = "ABC"
  name                                   = "VRF1"
  alias                                  = "VRF1-ALIAS"
  description                            = "My Description"
  enforcement_direction                  = "egress"
  enforcement_preference                 = "unenforced"
  data_plane_learning                    = false
  preferred_group                        = true
  transit_route_tag_policy               = "TRP1"
  bgp_timer_policy                       = "BGP1"
  bgp_ipv4_address_family_context_policy = "BGP_AF_IPV4"
  bgp_ipv6_address_family_context_policy = "BGP_AF_IPV6"
  bgp_ipv4_import_route_target           = "route-target:as2-nn2:10:10"
  bgp_ipv4_export_route_target           = "route-target:as2-nn2:10:10"
  bgp_ipv6_import_route_target           = "route-target:as2-nn2:10:10"
  bgp_ipv6_export_route_target           = "route-target:as2-nn2:10:10"
  dns_labels                             = ["DNS1"]
  contract_consumers                     = ["CON1"]
  contract_providers                     = ["CON1"]
  contract_imported_consumers            = ["I_CON1"]
  pim_enabled                            = true
  pim_mtu                                = 9200
  pim_fast_convergence                   = true
  pim_strict_rfc                         = true
  pim_max_multicast_entries              = 1000
  pim_reserved_multicast_entries         = "undefined"
  pim_static_rps = [
    {
      ip                  = "1.1.1.1"
      multicast_route_map = "TEST_RM"
    },
    {
      ip = "1.1.1.2"
    },
  ]
  pim_fabric_rps = [
    {
      ip                  = "2.2.2.1"
      multicast_route_map = "TEST_RM"
    },
    {
      ip = "2.2.2.2"
    }
  ]
  pim_bsr_listen_updates                   = true
  pim_bsr_forward_updates                  = true
  pim_bsr_filter_multicast_route_map       = "MCAST_RM1"
  pim_auto_rp_listen_updates               = true
  pim_auto_rp_forward_updates              = true
  pim_auto_rp_filter_multicast_route_map   = "MCAST_RM2"
  pim_asm_shared_range_multicast_route_map = "MCAST_RM3"
  pim_asm_sg_expiry                        = 1800
  pim_asm_sg_expiry_multicast_route_map    = "MCAST_RM4"
  pim_asm_traffic_registry_max_rate        = 10
  pim_asm_traffic_registry_source_ip       = "1.1.1.1"
  pim_ssm_group_range_multicast_route_map  = "MCAST_RM5"
  pim_inter_vrf_policies = [
    {
      tenant              = "TEN2"
      vrf                 = "VRF1"
      multicast_route_map = "MCAST_RM6"
    }
  ]
  pim_igmp_ssm_translate_policies = [
    {
      group_prefix   = "228.0.0.0/8"
      source_address = "3.3.3.3"
    },
    {
      group_prefix   = "229.0.0.0/8"
      source_address = "4.4.4.4"
    }
  ]
  leaked_internal_prefixes = [{
    prefix = "1.1.1.0/24"
    public = true
    destinations = [{
      description = "Leak to VRF2"
      tenant      = "ABC"
      vrf         = "VRF2"
      public      = false
    }]
  }]
  leaked_external_prefixes = [{
    prefix             = "2.2.0.0/16"
    from_prefix_length = 24
    to_prefix_length   = 32
    destinations = [{
      description = "Leak to VRF2"
      tenant      = "ABC"
      vrf         = "VRF2"
    }]
  }]
}
