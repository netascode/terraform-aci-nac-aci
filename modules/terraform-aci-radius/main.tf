resource "aci_rest_managed" "aaaRadiusProvider" {
  dn         = "uni/userext/radiusext/radiusprovider-${var.hostname_ip}"
  class_name = "aaaRadiusProvider"
  content = {
    name               = var.hostname_ip
    descr              = var.description
    authProtocol       = var.protocol
    monitorServer      = var.monitoring == true ? "enabled" : "disabled"
    monitoringUser     = var.monitoring == true ? var.monitoring_username : null
    monitoringPassword = var.monitoring == true ? var.monitoring_password : null
    key                = var.key
    authPort           = var.port
    retries            = var.retries
    timeout            = var.timeout
  }

  lifecycle {
    ignore_changes = [content["key"], content["monitoringPassword"]]
  }
}

resource "aci_rest_managed" "aaaRsSecProvToEpg" {
  count      = var.mgmt_epg_name != "" ? 1 : 0
  dn         = "${aci_rest_managed.aaaRadiusProvider.dn}/rsSecProvToEpg"
  class_name = "aaaRsSecProvToEpg"
  content = {
    tDn = var.mgmt_epg_type == "oob" ? "uni/tn-mgmt/mgmtp-default/oob-${var.mgmt_epg_name}" : "uni/tn-mgmt/mgmtp-default/inb-${var.mgmt_epg_name}"
  }
}
