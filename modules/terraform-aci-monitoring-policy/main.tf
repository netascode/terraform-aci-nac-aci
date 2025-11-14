resource "aci_rest_managed" "snmpSrc" {
  for_each   = toset(var.snmp_trap_policies)
  dn         = "uni/fabric/moncommon/snmpsrc-${each.value}"
  class_name = "snmpSrc"
  content = {
    name = each.value
  }
}

resource "aci_rest_managed" "snmpRsDestGroup" {
  for_each   = toset(var.snmp_trap_policies)
  dn         = "${aci_rest_managed.snmpSrc[each.value].dn}/rsdestGroup"
  class_name = "snmpRsDestGroup"
  content = {
    tDn = "uni/fabric/snmpgroup-${each.value}"
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
    tDn = "uni/fabric/slgroup-${each.value.name}"
  }
}
