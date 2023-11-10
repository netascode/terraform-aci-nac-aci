
locals {
  subj_filter_list = flatten([
    for subj in var.subjects : [
      for flt in lookup(subj, "filters", []) : {
        id     = "${subj.name}-${flt.filter}"
        subj   = subj.name
        filter = flt.filter
      }
    ]
  ])
}

resource "aci_rest_managed" "vzOOBBrCP" {
  dn         = "uni/tn-mgmt/oobbrc-${var.name}"
  class_name = "vzOOBBrCP"
  content = {
    name      = var.name
    nameAlias = var.alias
    descr     = var.description
    scope     = var.scope
  }
}

resource "aci_rest_managed" "vzSubj" {
  for_each   = { for subj in var.subjects : subj.name => subj }
  dn         = "${aci_rest_managed.vzOOBBrCP.dn}/subj-${each.value.name}"
  class_name = "vzSubj"
  content = {
    name      = each.value.name
    nameAlias = each.value.alias
    descr     = each.value.description
  }
}

resource "aci_rest_managed" "vzRsSubjFiltAtt" {
  for_each   = { for filter in local.subj_filter_list : filter.id => filter }
  dn         = "${aci_rest_managed.vzSubj[each.value.subj].dn}/rssubjFiltAtt-${each.value.filter}"
  class_name = "vzRsSubjFiltAtt"
  content = {
    action         = "permit"
    tnVzFilterName = each.value.filter
  }
}
