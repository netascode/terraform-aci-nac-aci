resource "aci_rest_managed" "snmpSrc" {
  for_each   = { for s in var.snmp_trap_policies : s.name => s }
  dn         = "uni/fabric/moncommon/snmpsrc-${each.value.name}"
  class_name = "snmpSrc"
  content = {
    name = each.value.name
  }
}

resource "aci_rest_managed" "snmpRsDestGroup" {
  for_each   = { for s in var.snmp_trap_policies : s.name => s }
  dn         = "${aci_rest_managed.snmpSrc[each.value.name].dn}/rsdestGroup"
  class_name = "snmpRsDestGroup"
  content = {
    tDn = try("uni/fabric/snmpgroup-${each.value.destination_group}", null)
  }
}

resource "aci_rest_managed" "syslogSrc" {
  for_each   = { for s in var.syslog_policies : s.name => s }
  dn         = "uni/fabric/moncommon/slsrc-${each.value.name}"
  class_name = "syslogSrc"
  content = {
    name   = each.value.name
    incl   = join(",", concat(each.value.audit == true && each.value.events == true && each.value.faults == true && each.value.session == true ? ["all"] : [], each.value.audit == true ? ["audit"] : [], each.value.events == true ? ["events"] : [], each.value.faults == true ? ["faults"] : [], each.value.session == true ? ["session"] : []))
    minSev = each.value.minimum_severity
  }
}

resource "aci_rest_managed" "syslogRsDestGroup" {
  for_each   = { for s in var.syslog_policies : s.name => s }
  dn         = "${aci_rest_managed.syslogSrc[each.value.name].dn}/rsdestGroup"
  class_name = "syslogRsDestGroup"
  content = {
    tDn = try("uni/fabric/slgroup-${each.value.destination_group}", null)
  }
}
