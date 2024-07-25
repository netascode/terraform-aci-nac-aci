resource "aci_rest_managed" "qosMplsCustomPol" {
  dn         = "uni/tn-infra/qosmplscustom-${var.name}"
  class_name = "qosMplsCustomPol"
  content = {
    name      = var.name
    nameAlias = var.alias
    descr     = var.description
  }
}

resource "aci_rest_managed" "qosMplsIngressRule" {
  for_each   = { for ing in var.ingress_rules : "${ing.exp_from}-${ing.exp_to != null ? ing.exp_to : ing.exp_from}" => ing }
  dn         = "${aci_rest_managed.qosMplsCustomPol.dn}/exp-${each.value.exp_from}-${each.value.exp_to != null ? each.value.exp_to : each.value.exp_from}"
  class_name = "qosMplsIngressRule"
  content = {
    prio      = each.value.priority
    from      = each.value.exp_from
    to        = each.value.exp_to != null ? each.value.exp_to : each.value.exp_from
    target    = each.value.dscp_target
    targetCos = each.value.cos_target
  }
}

resource "aci_rest_managed" "qosMplsEgressRule" {
  for_each   = { for eg in var.egress_rules : "${eg.dscp_from}-${eg.dscp_to != null ? eg.dscp_to : eg.dscp_from}" => eg }
  dn         = "${aci_rest_managed.qosMplsCustomPol.dn}/dscpToExp-${each.value.dscp_from}-${each.value.dscp_to != null ? each.value.dscp_to : each.value.dscp_from}"
  class_name = "qosMplsEgressRule"
  content = {
    from      = each.value.dscp_from
    to        = each.value.dscp_to != null ? each.value.dscp_to : each.value.dscp_from
    targetExp = each.value.exp_target
    targetCos = each.value.cos_target
  }
}
