resource "aci_rest_managed" "rtctrlAttrP" {
  dn         = "uni/tn-${var.tenant}/attr-${var.name}"
  class_name = "rtctrlAttrP"
  content = {
    name  = var.name
    descr = var.description
  }
}

resource "aci_rest_managed" "rtctrlSetComm" {
  count      = var.community != "" ? 1 : 0
  dn         = "${aci_rest_managed.rtctrlAttrP.dn}/scomm"
  class_name = "rtctrlSetComm"
  content = {
    "community"   = var.community
    "setCriteria" = var.community_mode
    "type"        = "community"
  }
}

resource "aci_rest_managed" "rtctrlSetTag" {
  count      = var.tag != null ? 1 : 0
  dn         = "${aci_rest_managed.rtctrlAttrP.dn}/srttag"
  class_name = "rtctrlSetTag"
  content = {
    "tag"  = var.tag
    "type" = "rt-tag"
  }
}

resource "aci_rest_managed" "rtctrlSetDamp" {
  count      = var.dampening != false ? 1 : 0
  dn         = "${aci_rest_managed.rtctrlAttrP.dn}/sdamp"
  class_name = "rtctrlSetDamp"
  content = {
    "halfLife"        = var.dampening_half_life
    "maxSuppressTime" = var.dampening_max_suppress_time
    "reuse"           = var.dampening_reuse_limit
    "suppress"        = var.dampening_suppress_limit
    "type"            = "dampening-pol"
  }
}

resource "aci_rest_managed" "rtctrlSetWeight" {
  count      = var.weight != null ? 1 : 0
  dn         = "${aci_rest_managed.rtctrlAttrP.dn}/sweight"
  class_name = "rtctrlSetWeight"
  content = {
    "weight" = var.weight
    "type"   = "rt-weight"
  }
}

resource "aci_rest_managed" "rtctrlSetNh" {
  count      = var.next_hop != "" ? 1 : 0
  dn         = "${aci_rest_managed.rtctrlAttrP.dn}/nh"
  class_name = "rtctrlSetNh"
  content = {
    "addr" = var.next_hop
    "type" = "ip-nh"
  }
}

resource "aci_rest_managed" "rtctrlSetPref" {
  count      = var.preference != null ? 1 : 0
  dn         = "${aci_rest_managed.rtctrlAttrP.dn}/spref"
  class_name = "rtctrlSetPref"
  content = {
    "localPref" = var.preference
    "type"      = "local-pref"
  }
}

resource "aci_rest_managed" "rtctrlSetRtMetric" {
  count      = var.metric != null ? 1 : 0
  dn         = "${aci_rest_managed.rtctrlAttrP.dn}/smetric"
  class_name = "rtctrlSetRtMetric"
  content = {
    "metric" = var.metric
    "type"   = "metric"
  }
}

resource "aci_rest_managed" "rtctrlSetRtMetricType" {
  count      = var.metric_type != "" ? 1 : 0
  dn         = "${aci_rest_managed.rtctrlAttrP.dn}/smetrict"
  class_name = "rtctrlSetRtMetricType"
  content = {
    "metricType" = var.metric_type
    "type"       = "metric"
  }
}

resource "aci_rest_managed" "rtctrlSetAddComm" {
  for_each   = { for comm in var.additional_communities : comm.community => comm }
  dn         = "${aci_rest_managed.rtctrlAttrP.dn}/saddcomm-${each.value.community}"
  class_name = "rtctrlSetAddComm"
  content = {
    "community"   = each.value.community
    "descr"       = each.value.description
    "setCriteria" = "append"
    "type"        = "community"
  }
}

resource "aci_rest_managed" "rtctrlSetASPath" {
  count      = var.set_as_path != false ? 1 : 0
  dn         = "${aci_rest_managed.rtctrlAttrP.dn}/saspath-${var.set_as_path_criteria}"
  class_name = "rtctrlSetASPath"
  content = {
    "criteria" = var.set_as_path_criteria
    "lastnum"  = var.set_as_path_count
    "type"     = "as-path"
  }
}

resource "aci_rest_managed" "rtctrlSetASPathASN" {
  count      = var.set_as_path != false && var.set_as_path_criteria == "prepend" && var.set_as_path_asn != null ? 1 : 0
  dn         = "${aci_rest_managed.rtctrlSetASPath[0].dn}/asn-${var.set_as_path_order}"
  class_name = "rtctrlSetASPathASN"
  content = {
    "asn"   = var.set_as_path_asn
    "order" = var.set_as_path_order
  }
}

resource "aci_rest_managed" "rtctrlSetNhUnchanged" {
  count      = var.next_hop_propagation == true || var.multipath == true ? 1 : 0
  dn         = "${aci_rest_managed.rtctrlAttrP.dn}/nhunchanged"
  class_name = "rtctrlSetNhUnchanged"
  content = {
    "type" = "nh-unchanged"
  }
}

resource "aci_rest_managed" "rtctrlSetRedistMultipath" {
  count      = var.multipath == true ? 1 : 0
  dn         = "${aci_rest_managed.rtctrlAttrP.dn}/redistmpath"
  class_name = "rtctrlSetRedistMultipath"
  content = {
    "type" = "redist-multipath"
  }
  depends_on = [
    aci_rest_managed.rtctrlSetNhUnchanged
  ]
}

resource "aci_rest_managed" "rtctrlSetPolicyTag" {
  count      = var.external_endpoint_group != "" && var.external_endpoint_group_l3out != "" ? 1 : 0
  dn         = "${aci_rest_managed.rtctrlAttrP.dn}/sptag"
  class_name = "rtctrlSetPolicyTag"
  content = {
    "type" = "policy-tag"
  }
}

resource "aci_rest_managed" "rtctrlRsSetPolicyTagToInstP" {
  count      = var.external_endpoint_group != "" && var.external_endpoint_group_l3out != "" ? 1 : 0
  dn         = "${aci_rest_managed.rtctrlSetPolicyTag[0].dn}/rssetPolicyTagToInstP"
  class_name = "rtctrlRsSetPolicyTagToInstP"
  content = {
    "tDn" = "uni/tn-${try(var.external_endpoint_group_tenant, var.tenant)}/out-${var.external_endpoint_group_l3out}/instP-${var.external_endpoint_group}"
  }
}
