terraform {
  required_version = ">= 1.3.0"

  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "CiscoDevNet/aci"
      version = ">=2.0.0"
    }
  }
}

resource "aci_rest_managed" "fvTenant" {
  dn         = "uni/tn-TF"
  class_name = "fvTenant"
}

module "main" {
  source = "../.."

  tenant                                  = aci_rest_managed.fvTenant.content.name
  name                                    = "VRF1"
  alias                                   = "VRF1-ALIAS"
  description                             = "My Description"
  enforcement_direction                   = "egress"
  enforcement_preference                  = "unenforced"
  data_plane_learning                     = false
  preferred_group                         = true
  transit_route_tag_policy                = "TRP1"
  bgp_timer_policy                        = "BGP1"
  bgp_ipv4_address_family_context_policy  = "BGP_AF_IPV4"
  bgp_ipv6_address_family_context_policy  = "BGP_AF_IPV6"
  bgp_ipv4_import_route_target            = "route-target:as2-nn2:10:10"
  bgp_ipv4_export_route_target            = "route-target:as2-nn2:10:10"
  bgp_ipv6_import_route_target            = "route-target:as2-nn2:10:10"
  bgp_ipv6_export_route_target            = "route-target:as2-nn2:10:10"
  dns_labels                              = ["DNS1"]
  contract_consumers                      = ["CON1"]
  contract_providers                      = ["CON1"]
  contract_imported_consumers             = ["I_CON1"]
  pim_enabled                             = true
  pim_mtu                                 = 9200
  pim_fast_convergence                    = true
  pim_strict_rfc                          = true
  pim_max_multicast_entries               = 10
  pim_reserved_multicast_entries          = 10
  pim_resource_policy_multicast_route_map = "TEST_RM"
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
  pim_bsr_filter_multicast_route_map       = "TEST_RM"
  pim_auto_rp_listen_updates               = true
  pim_auto_rp_forward_updates              = true
  pim_auto_rp_filter_multicast_route_map   = "TEST_RM"
  pim_asm_shared_range_multicast_route_map = "TEST_RM"
  pim_asm_sg_expiry                        = 1800
  pim_asm_sg_expiry_multicast_route_map    = "TEST_RM"
  pim_asm_traffic_registry_max_rate        = 10
  pim_asm_traffic_registry_source_ip       = "1.1.1.1"
  pim_ssm_group_range_multicast_route_map  = "TEST_RM"
  pim_inter_vrf_policies = [
    {
      tenant              = "TEST_TEN"
      vrf                 = "TEST_VRF"
      multicast_route_map = "TEST_RM"
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
      tenant      = "TF"
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
      tenant      = "TF"
      vrf         = "VRF2"
    }]
  }]
}

data "aci_rest_managed" "fvCtx" {
  dn = "uni/tn-${aci_rest_managed.fvTenant.content.name}/ctx-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "fvCtx" {
  component = "fvCtx"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fvCtx.content.name
    want        = module.main.name
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest_managed.fvCtx.content.nameAlias
    want        = "VRF1-ALIAS"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.fvCtx.content.descr
    want        = "My Description"
  }

  equal "ipDataPlaneLearning" {
    description = "ipDataPlaneLearning"
    got         = data.aci_rest_managed.fvCtx.content.ipDataPlaneLearning
    want        = "disabled"
  }

  equal "pcEnfDir" {
    description = "pcEnfDir"
    got         = data.aci_rest_managed.fvCtx.content.pcEnfDir
    want        = "egress"
  }

  equal "pcEnfPref" {
    description = "pcEnfPref"
    got         = data.aci_rest_managed.fvCtx.content.pcEnfPref
    want        = "unenforced"
  }
}

data "aci_rest_managed" "vzAny" {
  dn = "${data.aci_rest_managed.fvCtx.id}/any"

  depends_on = [module.main]
}

resource "test_assertions" "vzAny" {
  component = "vzAny"

  equal "prefGrMemb" {
    description = "prefGrMemb"
    got         = data.aci_rest_managed.vzAny.content.prefGrMemb
    want        = "enabled"
  }
}

data "aci_rest_managed" "vzRsAnyToCons" {
  dn = "${data.aci_rest_managed.fvCtx.id}/any/rsanyToCons-CON1"

  depends_on = [module.main]
}

resource "test_assertions" "vzRsAnyToCons" {
  component = "vzRsAnyToCons"

  equal "tnVzBrCPName" {
    description = "tnVzBrCPName"
    got         = data.aci_rest_managed.vzRsAnyToCons.content.tnVzBrCPName
    want        = "CON1"
  }
}

data "aci_rest_managed" "vzRsAnyToProv" {
  dn = "${data.aci_rest_managed.fvCtx.id}/any/rsanyToProv-CON1"

  depends_on = [module.main]
}

resource "test_assertions" "vzRsAnyToProv" {
  component = "vzRsAnyToProv"

  equal "tnVzBrCPName" {
    description = "tnVzBrCPName"
    got         = data.aci_rest_managed.vzRsAnyToProv.content.tnVzBrCPName
    want        = "CON1"
  }
}

data "aci_rest_managed" "vzRsAnyToConsIf" {
  dn = "${data.aci_rest_managed.fvCtx.id}/any/rsanyToConsIf-I_CON1"

  depends_on = [module.main]
}

resource "test_assertions" "vzRsAnyToConsIf" {
  component = "vzRsAnyToConsIf"

  equal "tnVzCPIfName" {
    description = "tnVzCPIfName"
    got         = data.aci_rest_managed.vzRsAnyToConsIf.content.tnVzCPIfName
    want        = "I_CON1"
  }
}

data "aci_rest_managed" "fvRsCtxToExtRouteTagPol" {
  dn = "${data.aci_rest_managed.fvCtx.id}/rsctxToExtRouteTagPol"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsCtxToExtRouteTagPol" {
  component = "fvRsCtxToExtRouteTagPol"

  equal "tnL3extRouteTagPolName" {
    description = "tnL3extRouteTagPolName"
    got         = data.aci_rest_managed.fvRsCtxToExtRouteTagPol.content.tnL3extRouteTagPolName
    want        = "TRP1"
  }
}

data "aci_rest_managed" "fvRsBgpCtxPol" {
  dn = "${data.aci_rest_managed.fvCtx.id}/rsbgpCtxPol"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsBgpCtxPol" {
  component = "fvRsBgpCtxPol"

  equal "tnBgpCtxPolName" {
    description = "tnBgpCtxPolName"
    got         = data.aci_rest_managed.fvRsBgpCtxPol.content.tnBgpCtxPolName
    want        = "BGP1"
  }
}

data "aci_rest_managed" "fvRsCtxToBgpCtxAfPol_ipv4" {
  dn = "${data.aci_rest_managed.fvCtx.id}/rsctxToBgpCtxAfPol-BGP_AF_IPV4-ipv4-ucast"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsCtxToBgpCtxAfPol_ipv4" {
  component = "fvRsCtxToBgpCtxAfPol"

  equal "af" {
    description = "af"
    got         = data.aci_rest_managed.fvRsCtxToBgpCtxAfPol_ipv4.content.af
    want        = "ipv4-ucast"
  }

  equal "tnBgpCtxAfPolName" {
    description = "tnBgpCtxAfPolName"
    got         = data.aci_rest_managed.fvRsCtxToBgpCtxAfPol_ipv4.content.tnBgpCtxAfPolName
    want        = "BGP_AF_IPV4"
  }
}


data "aci_rest_managed" "fvRsCtxToBgpCtxAfPol_ipv6" {
  dn = "${data.aci_rest_managed.fvCtx.id}/rsctxToBgpCtxAfPol-BGP_AF_IPV6-ipv6-ucast"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsCtxToBgpCtxAfPol_ipv6" {
  component = "fvRsCtxToBgpCtxAfPol"

  equal "af" {
    description = "af"
    got         = data.aci_rest_managed.fvRsCtxToBgpCtxAfPol_ipv6.content.af
    want        = "ipv6-ucast"
  }

  equal "tnBgpCtxAfPolName" {
    description = "tnBgpCtxAfPolName"
    got         = data.aci_rest_managed.fvRsCtxToBgpCtxAfPol_ipv6.content.tnBgpCtxAfPolName
    want        = "BGP_AF_IPV6"
  }
}

data "aci_rest_managed" "bgpRtTargetP_ipv4" {
  dn = "${data.aci_rest_managed.fvCtx.id}/rtp-ipv4-ucast"

  depends_on = [module.main]
}

resource "test_assertions" "bgpRtTargetP_ipv4" {
  component = "bgpRtTargetP_ipv4"

  equal "af" {
    description = "af"
    got         = data.aci_rest_managed.bgpRtTargetP_ipv4.content.af
    want        = "ipv4-ucast"
  }
}

data "aci_rest_managed" "bgpRtTarget_ipv4_import" {
  dn = "${data.aci_rest_managed.bgpRtTargetP_ipv4.id}/rt-[route-target:as2-nn2:10:10]-import"

  depends_on = [module.main]
}

resource "test_assertions" "bgpRtTarget_ipv4_import" {
  component = "bgpRtTarget_ipv4_import"

  equal "rt" {
    description = "rt"
    got         = data.aci_rest_managed.bgpRtTarget_ipv4_import.content.rt
    want        = "route-target:as2-nn2:10:10"
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.bgpRtTarget_ipv4_import.content.type
    want        = "import"
  }
}

data "aci_rest_managed" "bgpRtTarget_ipv4_export" {
  dn = "${data.aci_rest_managed.bgpRtTargetP_ipv4.id}/rt-[route-target:as2-nn2:10:10]-export"

  depends_on = [module.main]
}

resource "test_assertions" "bgpRtTarget_ipv4_export" {
  component = "bgpRtTarget_ipv4_export"

  equal "rt" {
    description = "rt"
    got         = data.aci_rest_managed.bgpRtTarget_ipv4_export.content.rt
    want        = "route-target:as2-nn2:10:10"
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.bgpRtTarget_ipv4_export.content.type
    want        = "export"
  }
}

data "aci_rest_managed" "bgpRtTargetP_ipv6" {
  dn = "${data.aci_rest_managed.fvCtx.id}/rtp-ipv6-ucast"

  depends_on = [module.main]
}

resource "test_assertions" "bgpRtTargetP_ipv6" {
  component = "bgpRtTargetP_ipv6"

  equal "af" {
    description = "af"
    got         = data.aci_rest_managed.bgpRtTargetP_ipv6.content.af
    want        = "ipv6-ucast"
  }
}

data "aci_rest_managed" "bgpRtTarget_ipv6_import" {
  dn = "${data.aci_rest_managed.bgpRtTargetP_ipv6.id}/rt-[route-target:as2-nn2:10:10]-import"

  depends_on = [module.main]
}

resource "test_assertions" "bgpRtTarget_ipv6_import" {
  component = "bgpRtTarget_ipv6_import"

  equal "rt" {
    description = "rt"
    got         = data.aci_rest_managed.bgpRtTarget_ipv6_import.content.rt
    want        = "route-target:as2-nn2:10:10"
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.bgpRtTarget_ipv6_import.content.type
    want        = "import"
  }
}

data "aci_rest_managed" "bgpRtTarget_ipv6_export" {
  dn = "${data.aci_rest_managed.bgpRtTargetP_ipv6.id}/rt-[route-target:as2-nn2:10:10]-export"

  depends_on = [module.main]
}

resource "test_assertions" "bgpRtTarget_ipv6_export" {
  component = "bgpRtTarget_ipv6_export"

  equal "rt" {
    description = "rt"
    got         = data.aci_rest_managed.bgpRtTarget_ipv6_export.content.rt
    want        = "route-target:as2-nn2:10:10"
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.bgpRtTarget_ipv6_export.content.type
    want        = "export"
  }
}

data "aci_rest_managed" "dnsLbl" {
  dn = "${data.aci_rest_managed.fvCtx.id}/dnslbl-DNS1"

  depends_on = [module.main]
}

resource "test_assertions" "dnsLbl" {
  component = "dnsLbl"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.dnsLbl.content.name
    want        = "DNS1"
  }
}

data "aci_rest_managed" "pimCtxP" {
  dn = "${data.aci_rest_managed.fvCtx.id}/pimctxp"

  depends_on = [module.main]
}

resource "test_assertions" "pimCtxP" {
  component = "pimCtxP"

  equal "mtu" {
    description = "mtu"
    got         = data.aci_rest_managed.pimCtxP.content.mtu
    want        = "9200"
  }

  equal "ctrl" {
    description = "ctrl"
    got         = data.aci_rest_managed.pimCtxP.content.ctrl
    want        = "fast-conv,strict-rfc-compliant"
  }
}

data "aci_rest_managed" "pimResPol" {
  dn = "${data.aci_rest_managed.pimCtxP.id}/res"
}

resource "test_assertions" "pimResPol" {
  component = "pimResPol"

  equal "max" {
    description = "max"
    got         = data.aci_rest_managed.pimResPol.content.max
    want        = "10"
  }

  equal "rsvd" {
    description = "rsvd"
    got         = data.aci_rest_managed.pimResPol.content.rsvd
    want        = "10"
  }
}

data "aci_rest_managed" "rtdmcRsFilterToRtMapPol" {
  dn = "${data.aci_rest_managed.pimCtxP.id}/res/rsfilterToRtMapPol"
}

resource "test_assertions" "rtdmcRsFilterToRtMapPol" {
  component = "rtdmcRsFilterToRtMapPol"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.rtdmcRsFilterToRtMapPol.content.tDn
    want        = "uni/tn-TF/rtmap-TEST_RM}"
  }
}

data "aci_rest_managed" "pimStaticRPEntryPol_static_rp" {
  dn = "${data.aci_rest_managed.pimCtxP.dn}/staticrp/staticrpent-[1.1.1.1]"
}

resource "test_assertions" "pimStaticRPEntryPol_static_rp" {
  component = "pimStaticRPEntryPol"

  equal "rpIp" {
    description = "rpIp"
    got         = data.aci_rest_managed.pimStaticRPEntryPol_static_rp.content.rpIp
    want        = "1.1.1.1"
  }
}

data "aci_rest_managed" "rtdmcRsFilterToRtMapPol_static_rp" {
  dn = "${data.aci_rest_managed.pimStaticRPEntryPol_static_rp.dn}/rpgrprange/rsfilterToRtMapPol"
}

resource "test_assertions" "rtdmcRsFilterToRtMapPol_static_rp" {
  component = "rtdmcRsFilterToRtMapPol"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.rtdmcRsFilterToRtMapPol_static_rp.content.tDn
    want        = "uni/tn-TF/rtmap-TEST_RM"
  }
}

data "aci_rest_managed" "pimStaticRPEntryPol_fabric_rp" {
  dn = "${data.aci_rest_managed.pimCtxP.dn}/fabricrp/staticrpent-[2.2.2.1]"
}

resource "test_assertions" "pimStaticRPEntryPol_fabric_rp" {
  component = "pimStaticRPEntryPol"

  equal "rpIp" {
    description = "rpIp"
    got         = data.aci_rest_managed.pimStaticRPEntryPol_fabric_rp.content.rpIp
    want        = "2.2.2.1"
  }
}

data "aci_rest_managed" "rtdmcRsFilterToRtMapPol_fabric_rp" {
  dn = "${data.aci_rest_managed.pimStaticRPEntryPol_fabric_rp.dn}/rpgrprange/rsfilterToRtMapPol"
}

resource "test_assertions" "rtdmcRsFilterToRtMapPol_fabric_rp" {
  component = "rtdmcRsFilterToRtMapPol"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.rtdmcRsFilterToRtMapPol_fabric_rp.content.tDn
    want        = "uni/tn-TF/rtmap-TEST_RM"
  }
}

data "aci_rest_managed" "pimBSRPPol" {
  dn = "${data.aci_rest_managed.pimCtxP.dn}/bsrp"
}

resource "test_assertions" "pimBSRPPol" {
  component = "pimBSRPPol"

  equal "ctrl" {
    description = "ctrl"
    got         = data.aci_rest_managed.pimBSRPPol.content.ctrl
    want        = "forward,listen"
  }
}

data "aci_rest_managed" "rtdmcRsFilterToRtMapPol_bsr" {
  dn = "${data.aci_rest_managed.pimBSRPPol.dn}/bsfilter/rsfilterToRtMapPol"
}

resource "test_assertions" "rtdmcRsFilterToRtMapPol_bsr" {
  component = "rtdmcRsFilterToRtMapPol"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.rtdmcRsFilterToRtMapPol_bsr.content.tDn
    want        = "uni/tn-TF/rtmap-TEST_RM"
  }
}

data "aci_rest_managed" "pimAutoRPPol" {
  dn = "${data.aci_rest_managed.pimCtxP.dn}/autorp"
}

resource "test_assertions" "pimAutoRPPol" {
  component = "pimAutoRPPol"

  equal "ctrl" {
    description = "ctrl"
    got         = data.aci_rest_managed.pimAutoRPPol.content.ctrl
    want        = "forward,listen"
  }
}

data "aci_rest_managed" "rtdmcRsFilterToRtMapPol_auto_rp" {
  dn = "${data.aci_rest_managed.pimAutoRPPol.dn}/mafilter/rsfilterToRtMapPol"
}

resource "test_assertions" "rtdmcRsFilterToRtMapPol_auto_rp" {
  component = "rtdmcRsFilterToRtMapPol"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.rtdmcRsFilterToRtMapPol_auto_rp.content.tDn
    want        = "uni/tn-TF/rtmap-TEST_RM"
  }
}

data "aci_rest_managed" "pimASMPatPol" {
  dn = "${data.aci_rest_managed.pimCtxP.dn}/asmpat"
}

resource "test_assertions" "pimASMPatPol" {
  component = "pimASMPatPol"

  equal "ctrl" {
    description = "ctrl"
    got         = data.aci_rest_managed.pimASMPatPol.content.ctrl
    want        = ""
  }
}

data "aci_rest_managed" "rtdmcRsFilterToRtMapPol_asm_shared" {
  dn = "${data.aci_rest_managed.pimASMPatPol.dn}/sharedrange/rsfilterToRtMapPol"
}

resource "test_assertions" "rtdmcRsFilterToRtMapPol_asm_shared" {
  component = "rtdmcRsFilterToRtMapPol"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.rtdmcRsFilterToRtMapPol_asm_shared.content.tDn
    want        = "uni/tn-TF/rtmap-TEST_RM"
  }
}

data "aci_rest_managed" "pimSGRangeExpPol" {
  dn = "${data.aci_rest_managed.pimASMPatPol.dn}/sgrangeexp"
}

resource "test_assertions" "pimSGRangeExpPol" {
  component = "pimSGRangeExpPol"

  equal "sgExpItvl" {
    description = "sgExpItvl"
    got         = data.aci_rest_managed.pimSGRangeExpPol.content.sgExpItvl
    want        = "1800"
  }
}

data "aci_rest_managed" "rtdmcRsFilterToRtMapPol_asm_sg_expiry" {
  dn = "${data.aci_rest_managed.pimSGRangeExpPol.dn}/rsfilterToRtMapPol"
}

resource "test_assertions" "rtdmcRsFilterToRtMapPol_asm_sg_expiry" {
  component = "rtdmcRsFilterToRtMapPol"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.rtdmcRsFilterToRtMapPol_asm_sg_expiry.content.tDn
    want        = "uni/tn-TF/rtmap-TEST_RM"
  }
}

data "aci_rest_managed" "pimRegTrPol" {
  dn = "${data.aci_rest_managed.pimASMPatPol.dn}/regtr"
}

resource "test_assertions" "pimRegTrPol" {
  component = "pimRegTrPol"

  equal "maxRate" {
    description = "maxRate"
    got         = data.aci_rest_managed.pimRegTrPol.content.maxRate
    want        = "10"
  }

  equal "srcIp" {
    description = "srcIp"
    got         = data.aci_rest_managed.pimRegTrPol.content.srcIp
    want        = "1.1.1.1"
  }
}

data "aci_rest_managed" "rtdmcRsFilterToRtMapPol_ssm_range" {
  dn = "${data.aci_rest_managed.pimCtxP.dn}/ssmpat/ssmrange/rsfilterToRtMapPol"
}

resource "test_assertions" "rtdmcRsFilterToRtMapPol_ssm_range" {
  component = "rtdmcRsFilterToRtMapPol"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.rtdmcRsFilterToRtMapPol_ssm_range.content.tDn
    want        = "uni/tn-TF/rtmap-TEST_RM"
  }
}

data "aci_rest_managed" "pimInterVRFEntryPol" {
  dn = "${data.aci_rest_managed.pimCtxP.dn}/intervrf/intervrfent-[uni/tn-TEST_TEN/ctx-TEST_VRF]"
}

resource "test_assertions" "pimInterVRFEntryPol" {
  component = "rtdmcRsFilterToRtMapPol"

  equal "srcVrfDn" {
    description = "srcVrfDn"
    got         = data.aci_rest_managed.pimInterVRFEntryPol.content.srcVrfDn
    want        = "uni/tn-TEST_TEN/ctx-TEST_VRF"
  }
}

data "aci_rest_managed" "rtdmcRsFilterToRtMapPol_pim_inter_vrf" {
  dn = "${data.aci_rest_managed.pimInterVRFEntryPol.dn}/rsfilterToRtMapPol"
}

resource "test_assertions" "rtdmcRsFilterToRtMapPol_pim_inter_vrf" {
  component = "rtdmcRsFilterToRtMapPol"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.rtdmcRsFilterToRtMapPol_pim_inter_vrf.content.tDn
    want        = "uni/tn-TF/rtmap-TEST_RM"
  }
}

data "aci_rest_managed" "igmpSSMXlateP" {
  dn = "${data.aci_rest_managed.fvCtx.dn}/igmpctxp/ssmxlate-[228.0.0.0/8]-[3.3.3.3]"
}

resource "test_assertions" "igmpSSMXlateP" {
  component = "igmpSSMXlateP"

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.igmpSSMXlateP.content.descr
    want        = "228.0.0.0/8-3.3.3.3"
  }

  equal "grpPfx" {
    description = "grpPfx"
    got         = data.aci_rest_managed.igmpSSMXlateP.content.grpPfx
    want        = "228.0.0.0/8"
  }

  equal "srcAddr" {
    description = "srcAddr"
    got         = data.aci_rest_managed.igmpSSMXlateP.content.srcAddr
    want        = "3.3.3.3"
  }
}

data "aci_rest_managed" "leakInternalSubnet" {
  dn = "${data.aci_rest_managed.fvCtx.id}/leakroutes/leakintsubnet-[1.1.1.0/24]"

  depends_on = [module.main]
}

resource "test_assertions" "leakInternalSubnet" {
  component = "leakInternalSubnet"

  equal "ip" {
    description = "ip"
    got         = data.aci_rest_managed.leakInternalSubnet.content.ip
    want        = "1.1.1.0/24"
  }

  equal "scope" {
    description = "scope"
    got         = data.aci_rest_managed.leakInternalSubnet.content.scope
    want        = "public"
  }
}

data "aci_rest_managed" "leakTo_internal" {
  dn = "${data.aci_rest_managed.fvCtx.id}/leakroutes/leakintsubnet-[1.1.1.0/24]/to-[TF]-[VRF2]"

  depends_on = [module.main]
}

resource "test_assertions" "leakTo_internal" {
  component = "leakTo_internal"

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.leakTo_internal.content.descr
    want        = "Leak to VRF2"
  }

  equal "tenantName" {
    description = "tenantName"
    got         = data.aci_rest_managed.leakTo_internal.content.tenantName
    want        = "TF"
  }

  equal "ctxName" {
    description = "ctxName"
    got         = data.aci_rest_managed.leakTo_internal.content.ctxName
    want        = "VRF2"
  }

  equal "scope" {
    description = "scope"
    got         = data.aci_rest_managed.leakTo_internal.content.scope
    want        = "private"
  }
}

data "aci_rest_managed" "leakExternalPrefix" {
  dn = "${data.aci_rest_managed.fvCtx.id}/leakroutes/leakextsubnet-[2.2.0.0/16]"

  depends_on = [module.main]
}

resource "test_assertions" "leakExternalPrefix" {
  component = "leakExternalPrefix"

  equal "ip" {
    description = "ip"
    got         = data.aci_rest_managed.leakExternalPrefix.content.ip
    want        = "2.2.0.0/16"
  }

  equal "le" {
    description = "le"
    got         = data.aci_rest_managed.leakExternalPrefix.content.le
    want        = "32"
  }

  equal "ge" {
    description = "ge"
    got         = data.aci_rest_managed.leakExternalPrefix.content.ge
    want        = "24"
  }
}

data "aci_rest_managed" "leakTo_external" {
  dn = "${data.aci_rest_managed.fvCtx.id}/leakroutes/leakextsubnet-[2.2.0.0/16]/to-[TF]-[VRF2]"

  depends_on = [module.main]
}

resource "test_assertions" "leakTo_external" {
  component = "leakTo_external"

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.leakTo_external.content.descr
    want        = "Leak to VRF2"
  }

  equal "tenantName" {
    description = "tenantName"
    got         = data.aci_rest_managed.leakTo_external.content.tenantName
    want        = "TF"
  }

  equal "ctxName" {
    description = "ctxName"
    got         = data.aci_rest_managed.leakTo_external.content.ctxName
    want        = "VRF2"
  }
}
