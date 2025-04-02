resource "aci_rest_managed" "datetimePol" {
  dn         = "uni/fabric/time-${var.name}"
  class_name = "datetimePol"
  content = {
    StratumValue = var.apic_ntp_server_master_stratum
    adminSt      = var.ntp_admin_state == true ? "enabled" : "disabled"
    authSt       = var.ntp_auth_state == true ? "enabled" : "disabled"
    masterMode   = var.apic_ntp_server_master_mode == true ? "enabled" : "disabled"
    serverState  = var.apic_ntp_server_state == true ? "enabled" : "disabled"
    name         = var.name
  }
}

resource "aci_rest_managed" "datetimeNtpProv" {
  for_each   = { for server in var.ntp_servers : server.hostname_ip => server }
  dn         = "${aci_rest_managed.datetimePol.dn}/ntpprov-${each.value.hostname_ip}"
  class_name = "datetimeNtpProv"
  content = {
    name      = each.value.hostname_ip
    preferred = each.value.preferred == true ? "yes" : "no"
  }
}

resource "aci_rest_managed" "datetimeRsNtpProvToEpg" {
  for_each   = { for server in var.ntp_servers : server.hostname_ip => server if server.mgmt_epg_name != null }
  dn         = "${aci_rest_managed.datetimeNtpProv[each.value.hostname_ip].dn}/rsNtpProvToEpg"
  class_name = "datetimeRsNtpProvToEpg"
  content = {
    tDn = each.value.mgmt_epg_type == "oob" ? "uni/tn-mgmt/mgmtp-default/oob-${each.value.mgmt_epg_name}" : "uni/tn-mgmt/mgmtp-default/inb-${each.value.mgmt_epg_name}"
  }
}

resource "aci_rest_managed" "datetimeRsNtpProvToNtpAuthKey" {
  for_each   = { for server in var.ntp_servers : server.hostname_ip => server if server.auth_key_id != null }
  dn         = "${aci_rest_managed.datetimeNtpProv[each.value.hostname_ip].dn}/rsntpProvToNtpAuthKey-${each.value.auth_key_id}"
  class_name = "datetimeRsNtpProvToNtpAuthKey"
  content = {
    tnDatetimeNtpAuthKeyId = each.value.auth_key_id
  }
}

resource "aci_rest_managed" "datetimeNtpAuthKey" {
  for_each    = { for key in var.ntp_keys : key.id => key }
  dn          = "${aci_rest_managed.datetimePol.dn}/ntpauth-${each.value.id}"
  class_name  = "datetimeNtpAuthKey"
  escape_html = false
  content = {
    id      = each.value.id
    key     = sensitive(each.value.key)
    keyType = each.value.auth_type
    trusted = each.value.trusted == true ? "yes" : "no"
  }

  lifecycle {
    ignore_changes = [content["key"]]
  }
}
