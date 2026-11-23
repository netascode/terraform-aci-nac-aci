locals {
  # Severity values pre-configured by the APIC on each default facility filter, restored on destroy instead of deleting the filter.
  syslog_facility_filter_defaults = {
    kern   = "errors"
    daemon = "errors"
  }
}

resource "aci_rest_managed" "snmpSrc" {
  for_each   = { for s in var.snmp_trap_policies : s.name => s }
  dn         = "uni/fabric/moncommon/snmpsrc-${each.value.name}"
  class_name = "snmpSrc"
  content = {
    name = each.value.name
  }
}

resource "aci_rest_managed" "snmpRsDestGroup" {
  for_each   = { for s in var.snmp_trap_policies : s.name => s if s.destination_group != "" }
  dn         = "${aci_rest_managed.snmpSrc[each.value.name].dn}/rsdestGroup"
  class_name = "snmpRsDestGroup"
  content = {
    tDn = "uni/fabric/snmpgroup-${each.value.destination_group}"
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
  for_each   = { for s in var.syslog_policies : s.name => s if s.destination_group != "" }
  dn         = "${aci_rest_managed.syslogSrc[each.value.name].dn}/rsdestGroup"
  class_name = "syslogRsDestGroup"
  content = {
    tDn = "uni/fabric/slgroup-${each.value.destination_group}"
  }
}

resource "aci_rest_managed" "tacacsSrc" {
  for_each   = { for s in var.tacacs_policies : s.name => s }
  dn         = "uni/fabric/moncommon/tacacssrc-${each.value.name}"
  class_name = "tacacsSrc"
  content = {
    name        = each.value.name
    switchAudit = each.value.audit == true ? "enabled" : null
  }
}

resource "aci_rest_managed" "tacacsRsDestGroup" {
  for_each   = { for s in var.tacacs_policies : s.name => s if s.destination_group != "" }
  dn         = "${aci_rest_managed.tacacsSrc[each.value.name].dn}/rsdestGroup"
  class_name = "tacacsRsDestGroup"
  content = {
    tDn = "uni/fabric/tacacsgroup-${each.value.destination_group}"
  }
}

resource "aci_rest_managed" "syslogSystemMsgP" {
  count      = var.syslog_message_policy != null ? 1 : 0
  dn         = "uni/fabric/moncommon/sysmsgp"
  class_name = "syslogSystemMsgP"
  content = {
    descr              = var.syslog_message_policy.description
    systemSyslogMsgHdl = var.syslog_message_policy.legacy_message_handling
  }
  content_on_destroy = {
    descr = ""
  }
}

resource "aci_rest_managed" "syslogFacilityFilter" {
  for_each   = { for filter in try(var.syslog_message_policy.facility_filters, []) : filter.facility => filter }
  dn         = "${aci_rest_managed.syslogSystemMsgP[0].dn}/ff-${each.value.facility}"
  class_name = "syslogFacilityFilter"
  content = {
    facility = each.value.facility
    minSev   = each.value.minimum_severity
  }
  content_on_destroy = {
    facility = each.value.facility
    minSev   = lookup(local.syslog_facility_filter_defaults, each.value.facility, "alerts")
  }
}
