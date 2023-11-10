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

  tenant                                  = "TF"
  name                                    = "L3OUT1"
  multipod                                = false
  alias                                   = "L3OUT1-ALIAS"
  description                             = "My Description"
  routed_domain                           = "RD1"
  vrf                                     = "VRF1"
  bgp                                     = true
  ospf                                    = true
  ospf_area                               = "0.0.0.10"
  ospf_area_cost                          = 10
  ospf_area_type                          = "stub"
  l3_multicast_ipv4                       = true
  target_dscp                             = "CS0"
  import_route_control_enforcement        = true
  export_route_control_enforcement        = true
  interleak_route_map                     = "ILRM"
  dampening_ipv4_route_map                = "D4RM"
  dampening_ipv6_route_map                = "D6RM"
  default_route_leak_policy               = true
  default_route_leak_policy_always        = true
  default_route_leak_policy_criteria      = "in-addition"
  default_route_leak_policy_context_scope = false
  default_route_leak_policy_outside_scope = false
  redistribution_route_maps = [{
    source    = "direct"
    route_map = "RRM"
  }]
  import_route_map_description = "IRM Description"
  import_route_map_type        = "global"
  import_route_map_contexts = [{
    name        = "ICON1"
    description = "ICON1 Description"
    action      = "deny"
    order       = 5
    set_rule    = "ISET1"
    match_rule  = "IMATCH1"
  }]
  export_route_map_description = "ERM Description"
  export_route_map_type        = "global"
  export_route_map_contexts = [{
    name        = "ECON1"
    description = "ECON1 Description"
    action      = "deny"
    order       = 6
    set_rule    = "ESET1"
    match_rule  = "EMATCH1"
  }]
}

data "aci_rest_managed" "l3extOut" {
  dn = module.main.dn

  depends_on = [module.main]
}

resource "test_assertions" "l3extOut" {
  component = "l3extOut"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.l3extOut.content.name
    want        = module.main.name
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.l3extOut.content.descr
    want        = "My Description"
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest_managed.l3extOut.content.nameAlias
    want        = "L3OUT1-ALIAS"
  }

  equal "targetDscp" {
    description = "targetDscp"
    got         = data.aci_rest_managed.l3extOut.content.targetDscp
    want        = "CS0"
  }

  equal "enforceRtctrl" {
    description = "enforceRtctrl"
    got         = data.aci_rest_managed.l3extOut.content.enforceRtctrl
    want        = "export,import"
  }
}

data "aci_rest_managed" "ospfExtP" {
  dn = "${data.aci_rest_managed.l3extOut.id}/ospfExtP"

  depends_on = [module.main]
}

resource "test_assertions" "ospfExtP" {
  component = "ospfExtP"

  equal "areaCost" {
    description = "areaCost"
    got         = data.aci_rest_managed.ospfExtP.content.areaCost
    want        = "10"
  }

  equal "areaCtrl" {
    description = "areaCtrl"
    got         = data.aci_rest_managed.ospfExtP.content.areaCtrl
    want        = "redistribute,summary"
  }

  equal "areaId" {
    description = "areaId"
    got         = data.aci_rest_managed.ospfExtP.content.areaId
    want        = "0.0.0.10"
  }

  equal "areaType" {
    description = "areaType"
    got         = data.aci_rest_managed.ospfExtP.content.areaType
    want        = "stub"
  }
}

data "aci_rest_managed" "bgpExtP" {
  dn = "${data.aci_rest_managed.l3extOut.id}/bgpExtP"

  depends_on = [module.main]
}

resource "test_assertions" "bgpExtP" {
  component = "bgpExtP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.bgpExtP.content.name
    want        = "bgp"
  }
}

data "aci_rest_managed" "l3extRsL3DomAtt" {
  dn = "${data.aci_rest_managed.l3extOut.id}/rsl3DomAtt"

  depends_on = [module.main]
}

resource "test_assertions" "l3extRsL3DomAtt" {
  component = "l3extRsL3DomAtt"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.l3extRsL3DomAtt.content.tDn
    want        = "uni/l3dom-RD1"
  }
}

data "aci_rest_managed" "l3extRsEctx" {
  dn = "${data.aci_rest_managed.l3extOut.id}/rsectx"

  depends_on = [module.main]
}

resource "test_assertions" "l3extRsEctx" {
  component = "l3extRsEctx"

  equal "tnFvCtxName" {
    description = "tnFvCtxName"
    got         = data.aci_rest_managed.l3extRsEctx.content.tnFvCtxName
    want        = "VRF1"
  }
}

data "aci_rest_managed" "rtctrlProfile_import" {
  dn = "${data.aci_rest_managed.l3extOut.id}/prof-default-import"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlProfile_import" {
  component = "rtctrlProfile_import"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.rtctrlProfile_import.content.name
    want        = "default-import"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.rtctrlProfile_import.content.descr
    want        = "IRM Description"
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.rtctrlProfile_import.content.type
    want        = "global"
  }
}

data "aci_rest_managed" "rtctrlCtxP_import" {
  dn = "${data.aci_rest_managed.rtctrlProfile_import.id}/ctx-ICON1"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlCtxP_import" {
  component = "rtctrlCtxP_import"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.rtctrlCtxP_import.content.name
    want        = "ICON1"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.rtctrlCtxP_import.content.descr
    want        = "ICON1 Description"
  }

  equal "action" {
    description = "action"
    got         = data.aci_rest_managed.rtctrlCtxP_import.content.action
    want        = "deny"
  }

  equal "order" {
    description = "order"
    got         = data.aci_rest_managed.rtctrlCtxP_import.content.order
    want        = "5"
  }
}

data "aci_rest_managed" "rtctrlRsScopeToAttrP_import" {
  dn = "${data.aci_rest_managed.rtctrlCtxP_import.id}/scp/rsScopeToAttrP"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlRsScopeToAttrP_import" {
  component = "rtctrlRsScopeToAttrP_import"

  equal "tnRtctrlAttrPName" {
    description = "tnRtctrlAttrPName"
    got         = data.aci_rest_managed.rtctrlRsScopeToAttrP_import.content.tnRtctrlAttrPName
    want        = "ISET1"
  }
}

data "aci_rest_managed" "rtctrlRsCtxPToSubjP_import" {
  dn = "${data.aci_rest_managed.rtctrlCtxP_import.id}/rsctxPToSubjP-IMATCH1"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlRsCtxPToSubjP_import" {
  component = "rtctrlRsCtxPToSubjP_import"

  equal "tnRtctrlSubjPName" {
    description = "tnRtctrlSubjPName"
    got         = data.aci_rest_managed.rtctrlRsCtxPToSubjP_import.content.tnRtctrlSubjPName
    want        = "IMATCH1"
  }
}

data "aci_rest_managed" "rtctrlProfile_export" {
  dn = "${data.aci_rest_managed.l3extOut.id}/prof-default-export"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlProfile_export" {
  component = "rtctrlProfile_export"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.rtctrlProfile_export.content.name
    want        = "default-export"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.rtctrlProfile_export.content.descr
    want        = "ERM Description"
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.rtctrlProfile_export.content.type
    want        = "global"
  }
}

data "aci_rest_managed" "rtctrlCtxP_export" {
  dn = "${data.aci_rest_managed.rtctrlProfile_export.id}/ctx-ECON1"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlCtxP_export" {
  component = "rtctrlCtxP_export"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.rtctrlCtxP_export.content.name
    want        = "ECON1"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.rtctrlCtxP_export.content.descr
    want        = "ECON1 Description"
  }

  equal "action" {
    description = "action"
    got         = data.aci_rest_managed.rtctrlCtxP_export.content.action
    want        = "deny"
  }

  equal "order" {
    description = "order"
    got         = data.aci_rest_managed.rtctrlCtxP_export.content.order
    want        = "6"
  }
}

data "aci_rest_managed" "rtctrlRsScopeToAttrP_export" {
  dn = "${data.aci_rest_managed.rtctrlCtxP_export.id}/scp/rsScopeToAttrP"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlRsScopeToAttrP_export" {
  component = "rtctrlRsScopeToAttrP_export"

  equal "tnRtctrlAttrPName" {
    description = "tnRtctrlAttrPName"
    got         = data.aci_rest_managed.rtctrlRsScopeToAttrP_export.content.tnRtctrlAttrPName
    want        = "ESET1"
  }
}

data "aci_rest_managed" "rtctrlRsCtxPToSubjP_export" {
  dn = "${data.aci_rest_managed.rtctrlCtxP_export.id}/rsctxPToSubjP-EMATCH1"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlRsCtxPToSubjP_export" {
  component = "rtctrlRsCtxPToSubjP_export"

  equal "tnRtctrlSubjPName" {
    description = "tnRtctrlSubjPName"
    got         = data.aci_rest_managed.rtctrlRsCtxPToSubjP_export.content.tnRtctrlSubjPName
    want        = "EMATCH1"
  }
}

data "aci_rest_managed" "pimExtP" {
  dn = "${data.aci_rest_managed.l3extOut.id}/pimextp"

  depends_on = [module.main]
}

resource "test_assertions" "pimExtP" {
  component = "pimExtP"

  equal "enabledAf" {
    description = "enabledAf"
    got         = data.aci_rest_managed.pimExtP.content.enabledAf
    want        = "ipv4-mcast"
  }

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.pimExtP.content.name
    want        = "pim"
  }
}

data "aci_rest_managed" "l3extRsInterleakPol" {
  dn = "${data.aci_rest_managed.l3extOut.id}/rsinterleakPol"

  depends_on = [module.main]
}

resource "test_assertions" "l3extRsInterleakPol" {
  component = "l3extRsInterleakPol"

  equal "tnRtctrlProfileName" {
    description = "tnRtctrlProfileName"
    got         = data.aci_rest_managed.l3extRsInterleakPol.content.tnRtctrlProfileName
    want        = "ILRM"
  }
}

data "aci_rest_managed" "l3extDefaultRouteLeakP" {
  dn = "${data.aci_rest_managed.l3extOut.id}/defrtleak"

  depends_on = [module.main]
}

resource "test_assertions" "l3extDefaultRouteLeakP" {
  component = "l3extDefaultRouteLeakP"

  equal "always" {
    description = "always"
    got         = data.aci_rest_managed.l3extDefaultRouteLeakP.content.always
    want        = "yes"
  }

  equal "criteria" {
    description = "criteria"
    got         = data.aci_rest_managed.l3extDefaultRouteLeakP.content.criteria
    want        = "in-addition"
  }

  equal "scope" {
    description = "scope"
    got         = data.aci_rest_managed.l3extDefaultRouteLeakP.content.scope
    want        = ""
  }
}

data "aci_rest_managed" "l3extRsDampeningPol_ipv4" {
  dn = "${data.aci_rest_managed.l3extOut.id}/rsdampeningPol-[D4RM]-ipv4-ucast"

  depends_on = [module.main]
}

resource "test_assertions" "l3extRsDampeningPol_ipv4" {
  component = "l3extRsDampeningPol_ipv4"

  equal "af" {
    description = "af"
    got         = data.aci_rest_managed.l3extRsDampeningPol_ipv4.content.af
    want        = "ipv4-ucast"
  }

  equal "tnRtctrlProfileName" {
    description = "tnRtctrlProfileName"
    got         = data.aci_rest_managed.l3extRsDampeningPol_ipv4.content.tnRtctrlProfileName
    want        = "D4RM"
  }
}

data "aci_rest_managed" "l3extRsDampeningPol_ipv6" {
  dn = "${data.aci_rest_managed.l3extOut.id}/rsdampeningPol-[D6RM]-ipv6-ucast"

  depends_on = [module.main]
}

resource "test_assertions" "l3extRsDampeningPol_ipv6" {
  component = "l3extRsDampeningPol_ipv6"

  equal "af" {
    description = "af"
    got         = data.aci_rest_managed.l3extRsDampeningPol_ipv6.content.af
    want        = "ipv6-ucast"
  }

  equal "tnRtctrlProfileName" {
    description = "tnRtctrlProfileName"
    got         = data.aci_rest_managed.l3extRsDampeningPol_ipv6.content.tnRtctrlProfileName
    want        = "D6RM"
  }
}

data "aci_rest_managed" "l3extRsRedistributePol" {
  dn = "${data.aci_rest_managed.l3extOut.id}/rsredistributePol-[RRM]-direct"

  depends_on = [module.main]
}

resource "test_assertions" "l3extRsRedistributePol" {
  component = "l3extRsRedistributePol"

  equal "src" {
    description = "src"
    got         = data.aci_rest_managed.l3extRsRedistributePol.content.src
    want        = "direct"
  }

  equal "tnRtctrlProfileName" {
    description = "tnRtctrlProfileName"
    got         = data.aci_rest_managed.l3extRsRedistributePol.content.tnRtctrlProfileName
    want        = "RRM"
  }
}
