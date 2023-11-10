resource "aci_rest_managed" "vnsSvcRedirectPol" {
  dn         = "uni/tn-${var.tenant}/svcCont/svcRedirectPol-${var.name}"
  class_name = "vnsSvcRedirectPol"
  content = {
    name                 = var.name
    nameAlias            = var.alias
    descr                = var.description
    AnycastEnabled       = var.anycast == true ? "yes" : "no"
    destType             = var.type
    hashingAlgorithm     = var.hashing
    thresholdEnable      = var.threshold == true ? "yes" : "no"
    maxThresholdPercent  = var.max_threshold
    minThresholdPercent  = var.min_threshold
    programLocalPodOnly  = var.pod_aware == true ? "yes" : "no"
    resilientHashEnabled = var.resilient_hashing == true ? "yes" : "no"
    thresholdDownAction  = var.threshold_down_action
  }
}

resource "aci_rest_managed" "vnsRsIPSLAMonitoringPol" {
  count      = var.ip_sla_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.vnsSvcRedirectPol.dn}/rsIPSLAMonitoringPol"
  class_name = "vnsRsIPSLAMonitoringPol"
  content = {
    "tDn" = "uni/tn-${var.tenant}/ipslaMonitoringPol-${var.ip_sla_policy}"
  }
}

resource "aci_rest_managed" "vnsRsBackupPol" {
  count      = var.resilient_hashing == true && var.redirect_backup_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.vnsSvcRedirectPol.dn}/rsBackupPol"
  class_name = "vnsRsBackupPol"
  content = {
    "tDn" = "uni/tn-${var.tenant}/svcCont/backupPol-${var.redirect_backup_policy}"
  }
}

resource "aci_rest_managed" "vnsRedirectDest" {
  for_each   = { for destination in var.l3_destinations : destination.ip => destination }
  dn         = "${aci_rest_managed.vnsSvcRedirectPol.dn}/RedirectDest_ip-[${each.value.ip}]"
  class_name = "vnsRedirectDest"
  content = {
    descr = each.value.description
    ip    = each.value.ip
    ip2   = each.value.ip_2 != null ? each.value.ip_2 : "0.0.0.0"
    mac   = each.value.mac
    podId = each.value.pod_id
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
