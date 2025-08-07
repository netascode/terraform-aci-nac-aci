locals {
  faults = flatten([
    for policy in var.fault_severity_policies : [
      for fault in policy.faults : {
        class            = policy.class
        fault_id         = fault.fault_id
        initial_severity = fault.initial_severity
        target_severity  = fault.target_severity
        description      = fault.description
      }
    ]
  ])
}

resource "aci_rest_managed" "monFabricPol" {
  dn         = "uni/fabric/monfab-${var.name}"
  class_name = "monFabricPol"
  content = {
    name  = var.name
    descr = var.description
  }
}

resource "aci_rest_managed" "snmpSrc" {
  for_each   = { for s in var.snmp_trap_policies : s.name => s }
  dn         = "${aci_rest_managed.monFabricPol.dn}/snmpsrc-${each.value.name}"
  class_name = "snmpSrc"
  content = {
    name = each.value.name
  }
}

resource "aci_rest_managed" "snmpRsDestGroup" {
  for_each   = { for s in var.snmp_trap_policies : s.name => s if s.destination_group != null }
  dn         = "${aci_rest_managed.snmpSrc[each.value.name].dn}/rsdestGroup"
  class_name = "snmpRsDestGroup"
  content = {
    tDn = "uni/fabric/snmpgroup-${each.value.destination_group}"
  }
}

resource "aci_rest_managed" "syslogSrc" {
  for_each   = { for s in var.syslog_policies : s.name => s }
  dn         = "${aci_rest_managed.monFabricPol.dn}/slsrc-${each.value.name}"
  class_name = "syslogSrc"
  content = {
    name   = each.value.name
    incl   = join(",", concat(each.value.audit == true && each.value.events == true && each.value.faults == true && each.value.session == true ? ["all"] : [], each.value.audit == true ? ["audit"] : [], each.value.events == true ? ["events"] : [], each.value.faults == true ? ["faults"] : [], each.value.session == true ? ["session"] : []))
    minSev = each.value.minimum_severity
  }
}

resource "aci_rest_managed" "syslogRsDestGroup" {
  for_each   = { for s in var.syslog_policies : s.name => s if s.destination_group != null }
  dn         = "${aci_rest_managed.syslogSrc[each.value.name].dn}/rsdestGroup"
  class_name = "syslogRsDestGroup"
  content = {
    tDn = "uni/fabric/slgroup-${each.value.destination_group}"
  }
}

resource "aci_rest_managed" "monFabricTarget" {
  for_each   = { for s in var.fault_severity_policies : s.class => s }
  dn         = "${aci_rest_managed.monFabricPol.dn}/tarfab-${each.value.class}"
  class_name = "monFabricTarget"
  content = {
    scope = each.value.class
  }
}

resource "aci_rest_managed" "faultSevAsnP" {
  for_each   = { for f in local.faults : f.fault_id => f }
  dn         = "${aci_rest_managed.monFabricTarget[each.value.class].dn}/fsevp-${each.value.fault_id}"
  class_name = "faultSevAsnP"
  content = {
    code    = each.value.fault_id
    initial = each.value.initial_severity
    target  = each.value.target_severity
    descr   = each.value.description
  }
}
