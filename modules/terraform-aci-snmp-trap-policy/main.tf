resource "aci_rest_managed" "snmpGroup" {
  dn         = "uni/fabric/snmpgroup-${var.name}"
  class_name = "snmpGroup"
  content = {
    name  = var.name
    descr = var.description
  }
}

resource "aci_rest_managed" "snmpTrapDest" {
  for_each   = { for dest in var.destinations : dest.hostname_ip => dest }
  dn         = "${aci_rest_managed.snmpGroup.dn}/trapdest-${each.value.hostname_ip}-port-${each.value.port}"
  class_name = "snmpTrapDest"
  content = {
    host     = each.value.hostname_ip
    port     = each.value.port
    secName  = sensitive(each.value.community)
    v3SecLvl = each.value.security
    ver      = each.value.version
  }
}

resource "aci_rest_managed" "fileRsARemoteHostToEpg" {
  for_each   = { for dest in var.destinations : dest.hostname_ip => dest if dest.mgmt_epg_name != null }
  dn         = "${aci_rest_managed.snmpTrapDest[each.value.hostname_ip].dn}/rsARemoteHostToEpg"
  class_name = "fileRsARemoteHostToEpg"
  content = {
    tDn = each.value.mgmt_epg_type == "oob" ? "uni/tn-mgmt/mgmtp-default/oob-${each.value.mgmt_epg_name}" : "uni/tn-mgmt/mgmtp-default/inb-${each.value.mgmt_epg_name}"
  }
}
