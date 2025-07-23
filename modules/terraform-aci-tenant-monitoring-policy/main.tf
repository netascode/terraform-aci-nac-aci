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

resource "aci_rest_managed" "monEPGPol" {
  dn         = "uni/tn-${var.tenant}/monepg-${var.name}"
  class_name = "monEPGPol"
  content = {
    name  = var.name
    descr = var.description
  }
}

resource "aci_rest_managed" "snmpSrc" {
  for_each   = { for snmp in var.snmp_trap_policies : snmp.name => snmp }
  dn         = "${aci_rest_managed.monEPGPol.dn}/snmpsrc-${each.value.name}"
  class_name = "snmpSrc"
  content = {
    name = each.value.name
  }
}

resource "aci_rest_managed" "snmpRsDestGroup" {
  for_each   = { for snmp in var.snmp_trap_policies : snmp.name => snmp if snmp.destination_group != null }
  dn         = "${aci_rest_managed.snmpSrc[each.value.name].dn}/rsdestGroup"
  class_name = "snmpRsDestGroup"
  content = {
    tDn = "uni/fabric/snmpgroup-${each.value.destination_group}"
  }
}

resource "aci_rest_managed" "syslogSrc" {
  for_each   = { for snmp in var.syslog_policies : snmp.name => snmp }
  dn         = "${aci_rest_managed.monEPGPol.dn}/slsrc-${each.value.name}"
  class_name = "syslogSrc"
  content = {
    name   = each.value.name
    incl   = join(",", concat(each.value.audit == true && each.value.events == true && each.value.faults == true && each.value.session == true ? ["all"] : [], each.value.audit == true ? ["audit"] : [], each.value.events == true ? ["events"] : [], each.value.faults == true ? ["faults"] : [], each.value.session == true ? ["session"] : []))
    minSev = each.value.minimum_severity
  }
}

resource "aci_rest_managed" "syslogRsDestGroup" {
  for_each   = { for syslog in var.syslog_policies : syslog.name => syslog if syslog.destination_group != null }
  dn         = "${aci_rest_managed.syslogSrc[each.value.name].dn}/rsdestGroup"
  class_name = "syslogRsDestGroup"
  content = {
    tDn = "uni/fabric/slgroup-${each.value.destination_group}"
  }
}

resource "aci_rest_managed" "monEPGTarget" {
  for_each   = { for fsp in var.fault_severity_policies : fsp.class => fsp }
  dn         = "${aci_rest_managed.monEPGPol.dn}/tarepg-${each.value.class}"
  class_name = "monEPGTarget"
  content = {
    scope = each.value.class
  }
}

resource "aci_rest_managed" "faultSevAsnP" {
  for_each   = { for f in local.faults : f.fault_id => f }
  dn         = "${aci_rest_managed.monEPGTarget[each.value.class].dn}/fsevp-${each.value.fault_id}"
  class_name = "faultSevAsnP"
  content = {
    code    = each.value.fault_id
    initial = each.value.initial_severity
    target  = each.value.target_severity
    descr   = each.value.description
  }
}
