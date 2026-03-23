resource "aci_rest_managed" "qosVxlanCustomPol" {
  dn         = "uni/tn-infra/qosvxlancustom-${var.name}"
  class_name = "qosVxlanCustomPol"
  content = {
    name  = var.name
    descr = var.description
  }
}

resource "aci_rest_managed" "qosVxlanIngressRule" {
  for_each   = { for ing in var.ingress_rules : "${ing.dscp_from}-${ing.dscp_to}" => ing }
  dn         = "${aci_rest_managed.qosVxlanCustomPol.dn}/idscp-${each.value.dscp_from}-${each.value.dscp_to}"
  class_name = "qosVxlanIngressRule"
  content = {
    prio      = each.value.priority
    from      = each.value.dscp_from
    to        = each.value.dscp_to
    target    = each.value.dscp_target
    targetCos = each.value.cos_target
  }
}

resource "aci_rest_managed" "qosVxlanEgressRule" {
  for_each   = { for eg in var.egress_rules : "${eg.dscp_from}-${eg.dscp_to}" => eg }
  dn         = "${aci_rest_managed.qosVxlanCustomPol.dn}/edscp-${each.value.dscp_from}-${each.value.dscp_to}"
  class_name = "qosVxlanEgressRule"
  content = {
    from      = each.value.dscp_from
    to        = each.value.dscp_to
    target    = each.value.dscp_target
    targetCos = each.value.cos_target
  }
}
