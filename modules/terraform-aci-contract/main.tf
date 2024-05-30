locals {
  subj_filter_list = flatten([
    for subj in var.subjects : [
      for flt in coalesce(subj.filters, []) : {
        id                    = "${subj.name}-${flt.filter}"
        subj                  = subj.name
        filter                = flt.filter
        action                = flt.action
        directives            = join(",", concat(flt.log == true ? ["log"] : [], flt.no_stats == true ? ["no_stats"] : []))
        priority              = flt.priority
        apply_both_directions = subj.apply_both_directions
        directions            = flt.directions
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
  for_each   = { for subj in var.subjects : subj.name => subj if subj.apply_both_directions == true }
  dn         = "${aci_rest_managed.vzBrCP.dn}/subj-${each.value.name}"
  class_name = "vzSubj"
  content = {
    name        = each.value.name
    nameAlias   = each.value.alias
    descr       = each.value.description
    revFltPorts = each.value.reverse_filter_ports ? "yes" : "no"
    prio        = each.value.qos_class
    targetDscp  = each.value.target_dscp
  }
}

resource "aci_rest_managed" "vzRsSubjFiltAtt" {
  for_each   = { for filter in local.subj_filter_list : filter.id => filter if filter.apply_both_directions == true }
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
  for_each   = { for subj in var.subjects : subj.name => subj if subj.service_graph != null }
  dn         = "${aci_rest_managed.vzSubj[each.key].dn}/rsSubjGraphAtt"
  class_name = "vzRsSubjGraphAtt"
  content = {
    tnVnsAbsGraphName = each.value.service_graph
  }
}

resource "aci_rest_managed" "vzSubj_unidir" {
  depends_on = [aci_rest_managed.vzSubj]
  for_each   = { for subj in var.subjects : subj.name => subj if subj.apply_both_directions == false }
  dn         = "${aci_rest_managed.vzBrCP.dn}/subj-${each.value.name}"
  class_name = "vzSubj"
  content = {
    name        = each.value.name
    nameAlias   = each.value.alias
    descr       = each.value.description
    revFltPorts = "no"
    prio        = each.value.qos_class
    targetDscp  = each.value.target_dscp
  }
}

resource "aci_rest_managed" "vzInTerm" {
  depends_on = [aci_rest_managed.vzSubj_unidir, aci_rest_managed.vzSubj]
  for_each   = { for subj in var.subjects : subj.name => subj if subj.apply_both_directions == false }
  dn         = "${aci_rest_managed.vzBrCP.dn}/subj-${each.value.name}/intmnl"
  class_name = "vzInTerm"
}

resource "aci_rest_managed" "vzOutTerm" {
  depends_on = [aci_rest_managed.vzSubj_unidir, aci_rest_managed.vzSubj]
  for_each   = { for subj in var.subjects : subj.name => subj if subj.apply_both_directions == false }
  dn         = "${aci_rest_managed.vzBrCP.dn}/subj-${each.value.name}/outtmnl"
  class_name = "vzOutTerm"
}

resource "aci_rest_managed" "vzRsFiltAtt_consprov" {
  for_each   = { for filter in local.subj_filter_list : filter.id => filter if filter.apply_both_directions == false && contains(filter.directions, "consumer_to_provider") }
  dn         = "${aci_rest_managed.vzSubj_unidir[each.value.subj].dn}/intmnl/rsfiltAtt-${each.value.filter}"
  class_name = "vzRsFiltAtt"
  content = {
    action           = each.value.action
    tnVzFilterName   = each.value.filter
    directives       = each.value.directives
    priorityOverride = each.value.priority
  }
}

resource "aci_rest_managed" "vzRsFiltAtt_provcons" {
  for_each   = { for filter in local.subj_filter_list : filter.id => filter if filter.apply_both_directions == false && contains(filter.directions, "provider_to_consumer") }
  dn         = "${aci_rest_managed.vzSubj_unidir[each.value.subj].dn}/outtmnl/rsfiltAtt-${each.value.filter}"
  class_name = "vzRsFiltAtt"
  content = {
    action           = each.value.action
    tnVzFilterName   = each.value.filter
    directives       = each.value.directives
    priorityOverride = each.value.priority
  }
}

resource "aci_rest_managed" "vzRsInTermGraphAtt" {
  for_each   = { for subj in var.subjects : subj.name => subj if subj.service_graph_consumer_to_provider != null && subj.apply_both_directions == false }
  dn         = "${aci_rest_managed.vzSubj_unidir[each.key].dn}/intmnl/rsInTermGraphAtt"
  class_name = "vzRsInTermGraphAtt"
  content = {
    tnVnsAbsGraphName = each.value.service_graph_consumer_to_provider
  }
}

resource "aci_rest_managed" "vzRsOutTermGraphAtt" {
  for_each   = { for subj in var.subjects : subj.name => subj if subj.service_graph_provider_to_consumer != null && subj.apply_both_directions == false }
  dn         = "${aci_rest_managed.vzSubj_unidir[each.key].dn}/outtmnl/rsOutTermGraphAtt"
  class_name = "vzRsOutTermGraphAtt"
  content = {
    tnVnsAbsGraphName = each.value.service_graph_provider_to_consumer
  }
}
