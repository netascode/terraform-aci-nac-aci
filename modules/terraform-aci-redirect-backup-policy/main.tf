resource "aci_rest_managed" "vnsBackupPol" {
  dn         = "uni/tn-${var.tenant}/svcCont/backupPol-${var.name}"
  class_name = "vnsBackupPol"
  content = {
    name  = var.name
    descr = var.description
  }
}

resource "aci_rest_managed" "vnsRedirectDest" {
  for_each   = { for destination in var.l3_destinations : destination.ip => destination }
  dn         = "${aci_rest_managed.vnsBackupPol.dn}/RedirectDest_ip-[${each.value.ip}]"
  class_name = "vnsRedirectDest"
  content = {
    destName = each.value.name
    descr    = each.value.description
    ip       = each.value.ip
    ip2      = each.value.ip_2 != null ? each.value.ip_2 : "0.0.0.0"
    mac      = each.value.mac
  }
}

resource "aci_rest_managed" "vnsRsRedirectHealthGroup" {
  for_each   = { for destination in var.l3_destinations : destination.ip => destination if destination.redirect_health_group != "" }
  dn         = "${aci_rest_managed.vnsRedirectDest[each.value.ip].dn}/rsRedirectHealthGroup"
  class_name = "vnsRsRedirectHealthGroup"
  content = {
    "tDn" = "uni/tn-${var.tenant}/svcCont/redirectHealthGroup-${each.value.redirect_health_group}"
  }
}
