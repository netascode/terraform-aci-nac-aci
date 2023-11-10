resource "aci_rest_managed" "qosInstPol" {
  dn         = "uni/infra/qosinst-default"
  class_name = "qosInstPol"
  content = {
    ctrl = var.preserve_cos == true ? "dot1p-preserve" : ""
  }
}

resource "aci_rest_managed" "qosClass" {
  for_each   = { for class in var.qos_classes : class.level => class }
  dn         = "uni/infra/qosinst-default/class-level${each.value.level}"
  class_name = "qosClass"
  content = {
    prio  = "level${each.value.level}"
    admin = each.value.admin_state == true ? "enabled" : "disabled"
    mtu   = each.value.mtu
  }
}

resource "aci_rest_managed" "qosSched" {
  for_each   = { for class in var.qos_classes : class.level => class }
  dn         = "${aci_rest_managed.qosClass[each.value.level].dn}/sched"
  class_name = "qosSched"
  content = {
    bw   = each.value.bandwidth_percent
    meth = each.value.scheduling == "strict-priority" ? "sp" : "wrr"
  }
}

resource "aci_rest_managed" "qosQueue" {
  for_each   = { for class in var.qos_classes : class.level => class }
  dn         = "${aci_rest_managed.qosClass[each.value.level].dn}/queue"
  class_name = "qosQueue"
  content = {
    limit = "1522"
    meth  = "dynamic"
  }
}

resource "aci_rest_managed" "qosPfcPol" {
  for_each   = { for class in var.qos_classes : class.level => class }
  dn         = "${aci_rest_managed.qosClass[each.value.level].dn}/pfcpol-default"
  class_name = "qosPfcPol"
  content = {
    name        = "default"
    adminSt     = each.value.pfc_state == true ? "yes" : "no"
    noDropCos   = each.value.no_drop_cos
    enableScope = each.value.pfc_scope
  }
}

resource "aci_rest_managed" "qosCong" {
  for_each   = { for class in var.qos_classes : class.level => class }
  dn         = "${aci_rest_managed.qosClass[each.value.level].dn}/cong"
  class_name = "qosCong"
  content = {
    afdQueueLength   = "0"
    algo             = each.value.congestion_algorithm
    ecn              = each.value.ecn == true ? "enabled" : "disabled"
    forwardNonEcn    = each.value.forward_non_ecn == true ? "enabled" : "disabled"
    wredMaxThreshold = each.value.wred_max_threshold
    wredMinThreshold = each.value.wred_min_threshold
    wredProbability  = each.value.wred_probability
    wredWeight       = each.value.weight
  }
}

resource "aci_rest_managed" "qosBuffer" {
  for_each   = { for class in var.qos_classes : class.level => class }
  dn         = "${aci_rest_managed.qosClass[each.value.level].dn}/buffer"
  class_name = "qosBuffer"
  content = {
    min = each.value.minimum_buffer
  }
}
