
locals {
  subj_filter_list = flatten([
    for subj in var.subjects : [
      for flt in coalesce(subj.filters, []) : {
        id         = "${subj.name}-${flt.filter}"
        subj       = subj.name
        filter     = flt.filter
        action     = flt.action
        directives = join(",", concat(flt.log == true ? ["log"] : [], flt.no_stats == true ? ["no_stats"] : []))
        priority   = flt.priority
      }
    ]
  ])
}

locals {
  subj_filter_list_ctp = flatten([
    for subj in var.subjects : [
      for flt in coalesce(subj.consumer_to_provider_filters, []) : {
        id         = "${subj.name}-${flt.filter}"
        subj       = subj.name
        filter     = flt.filter
        action     = flt.action
        directives = join(",", concat(flt.log == true ? ["log"] : [], flt.no_stats == true ? ["no_stats"] : []))
        priority   = flt.priority
      }
    ]
  ])
}

locals {
  subj_filter_list_ptc = flatten([
    for subj in var.subjects : [
      for flt in coalesce(subj.provider_to_consumer_filters, []) : {
        id         = "${subj.name}-${flt.filter}"
        subj       = subj.name
        filter     = flt.filter
        action     = flt.action
        directives = join(",", concat(flt.log == true ? ["log"] : [], flt.no_stats == true ? ["no_stats"] : []))
        priority   = flt.priority
      }
    ]
  ])
}

resource "aci_rest_managed" "vzBrCP" {
  dn         = "uni/tn-${var.tenant}/brc-${var.name}"
  class_name = "vzBrCP"
  content = {
    name       = var.name
    nameAlias  = var.alias
    descr      = var.description
    scope      = var.scope
    prio       = var.qos_class
    targetDscp = var.target_dscp
  }
}

resource "aci_rest_managed" "vzSubj" {
  for_each   = { for subj in var.subjects : subj.name => subj }
  dn         = "${aci_rest_managed.vzBrCP.dn}/subj-${each.value.name}"
  class_name = "vzSubj"
  content = {
    name        = each.value.name
    nameAlias   = each.value.alias
    descr       = each.value.description
    revFltPorts = length(each.value.filters) != 0 ? (each.value.reverse_filter_ports ? "yes" : "no") : "no"
    prio        = each.value.qos_class
    targetDscp  = each.value.target_dscp
  }
}

resource "aci_rest_managed" "vzRsSubjFiltAtt" {
  for_each   = { for filter in local.subj_filter_list : filter.id => filter }
  dn         = "${aci_rest_managed.vzSubj[each.value.subj].dn}/rssubjFiltAtt-${each.value.filter}"
  class_name = "vzRsSubjFiltAtt"
  content = {
    action           = each.value.action
    tnVzFilterName   = each.value.filter
    directives       = each.value.directives
    priorityOverride = each.value.priority
  }
}

resource "aci_rest_managed" "vzRsSubjGraphAtt" {
  for_each   = { for subj in var.subjects : subj.name => subj if subj.service_graph != null && length(subj.filters) != 0 }
  dn         = "${aci_rest_managed.vzSubj[each.key].dn}/rsSubjGraphAtt"
  class_name = "vzRsSubjGraphAtt"
  content = {
    tnVnsAbsGraphName = each.value.service_graph
  }
}

resource "aci_rest_managed" "vzInTerm" {
  for_each   = { for subj in var.subjects : subj.name => subj if length(subj.filters) == 0 && length(subj.provider_to_consumer_filters) + length(subj.consumer_to_provider_filters) != 0 }
  dn         = "${aci_rest_managed.vzSubj[each.key].dn}/intmnl"
  class_name = "vzInTerm"
  content = {
    prio       = each.value.consumer_to_provider_qos_class
    targetDscp = each.value.consumer_to_provider_target_dscp
  }
}

resource "aci_rest_managed" "vzOutTerm" {
  for_each   = { for subj in var.subjects : subj.name => subj if length(subj.filters) == 0 && length(subj.provider_to_consumer_filters) + length(subj.consumer_to_provider_filters) != 0 }
  dn         = "${aci_rest_managed.vzSubj[each.key].dn}/outtmnl"
  class_name = "vzOutTerm"
  content = {
    prio       = each.value.provider_to_consumer_qos_class
    targetDscp = each.value.provider_to_consumer_target_dscp
  }
}

resource "aci_rest_managed" "vzRsFiltAtt_ctp" {
  for_each   = { for filter in local.subj_filter_list_ctp : filter.id => filter }
  dn         = "${aci_rest_managed.vzInTerm[each.value.subj].dn}/rsfiltAtt-${each.value.filter}"
  class_name = "vzRsFiltAtt"
  content = {
    action           = each.value.action
    tnVzFilterName   = each.value.filter
    directives       = each.value.directives
    priorityOverride = each.value.priority
  }
}

resource "aci_rest_managed" "vzRsFiltAtt_ptc" {
  for_each   = { for filter in local.subj_filter_list_ptc : filter.id => filter }
  dn         = "${aci_rest_managed.vzOutTerm[each.value.subj].dn}/rsfiltAtt-${each.value.filter}"
  class_name = "vzRsFiltAtt"
  content = {
    action           = each.value.action
    tnVzFilterName   = each.value.filter
    directives       = each.value.directives
    priorityOverride = each.value.priority
  }
}

resource "aci_rest_managed" "vzRsInTermGraphAtt" {
  for_each   = { for subj in var.subjects : subj.name => subj if subj.consumer_to_provider_service_graph != null && length(subj.consumer_to_provider_filters) != 0 }
  dn         = "${aci_rest_managed.vzInTerm[each.key].dn}/rsInTermGraphAtt"
  class_name = "vzRsInTermGraphAtt"
  content = {
    tnVnsAbsGraphName = each.value.consumer_to_provider_service_graph
  }
}

resource "aci_rest_managed" "vzRsOutTermGraphAtt" {
  for_each   = { for subj in var.subjects : subj.name => subj if subj.provider_to_consumer_service_graph != null && length(subj.provider_to_consumer_filters) != 0 }
  dn         = "${aci_rest_managed.vzOutTerm[each.key].dn}/rsOutTermGraphAtt"
  class_name = "vzRsOutTermGraphAtt"
  content = {
    tnVnsAbsGraphName = each.value.provider_to_consumer_service_graph
  }
}