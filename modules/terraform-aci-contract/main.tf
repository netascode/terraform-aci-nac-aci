
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
    revFltPorts = "yes"
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
  for_each   = { for subj in var.subjects : subj.name => subj if subj.service_graph != null }
  dn         = "${aci_rest_managed.vzSubj[each.key].dn}/rsSubjGraphAtt"
  class_name = "vzRsSubjGraphAtt"
  content = {
    tnVnsAbsGraphName = each.value.service_graph
  }
}
