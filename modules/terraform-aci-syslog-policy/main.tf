resource "aci_rest_managed" "syslogGroup" {
  dn         = "uni/fabric/slgroup-${var.name}"
  class_name = "syslogGroup"
  content = {
    name                = var.name
    descr               = var.description
    format              = var.format == "enhanced-log" ? "rfc5424-ts" : var.format
    includeMilliSeconds = var.show_millisecond == true ? "yes" : "no"
    includeTimeZone     = var.show_timezone ? "yes" : "no"
  }
}

resource "aci_rest_managed" "syslogRemoteDest" {
  for_each   = { for dest in var.destinations : dest.hostname_ip => dest }
  dn         = "${aci_rest_managed.syslogGroup.dn}/rdst-${each.value.hostname_ip}"
  class_name = "syslogRemoteDest"
  content = {
    name               = each.value.name
    host               = each.value.hostname_ip
    protocol           = each.value.protocol
    port               = each.value.port
    adminState         = each.value.admin_state == true ? "enabled" : "disabled"
    format             = each.value.format == "enhanced-log" ? "rfc5424-ts" : each.value.format
    forwardingFacility = each.value.facility
    severity           = each.value.severity
  }
}

resource "aci_rest_managed" "fileRsARemoteHostToEpg" {
  for_each   = { for dest in var.destinations : dest.hostname_ip => dest if dest.mgmt_epg_name != null }
  dn         = "${aci_rest_managed.syslogRemoteDest[each.value.hostname_ip].dn}/rsARemoteHostToEpg"
  class_name = "fileRsARemoteHostToEpg"
  content = {
    tDn = each.value.mgmt_epg_type == "oob" ? "uni/tn-mgmt/mgmtp-default/oob-${each.value.mgmt_epg_name}" : "uni/tn-mgmt/mgmtp-default/inb-${each.value.mgmt_epg_name}"
  }
}

resource "aci_rest_managed" "syslogProf" {
  dn         = "${aci_rest_managed.syslogGroup.dn}/prof"
  class_name = "syslogProf"
  content = {
    adminState = var.admin_state == true ? "enabled" : "disabled"
    name       = "syslog"
  }
}

resource "aci_rest_managed" "syslogFile" {
  dn         = "${aci_rest_managed.syslogGroup.dn}/file"
  class_name = "syslogFile"
  content = {
    adminState = var.local_admin_state == true ? "enabled" : "disabled"
    format     = var.format == "enhanced-log" ? "rfc5424-ts" : var.format
    severity   = var.local_severity
  }
}

resource "aci_rest_managed" "syslogConsole" {
  dn         = "${aci_rest_managed.syslogGroup.dn}/console"
  class_name = "syslogConsole"
  content = {
    adminState = var.console_admin_state == true ? "enabled" : "disabled"
    format     = var.format == "enhanced-log" ? "rfc5424-ts" : var.format
    severity   = var.console_severity
  }
}
