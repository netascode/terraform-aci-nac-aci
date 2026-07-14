resource "aci_rest_managed" "tacacsGroup" {
  dn         = "uni/fabric/tacacsgroup-${var.name}"
  class_name = "tacacsGroup"
  content = {
    name  = var.name
    descr = var.description
  }
}

resource "aci_rest_managed" "tacacsTacacsDest" {
  for_each    = { for dest in var.destinations : dest.hostname_ip => dest }
  dn          = "${aci_rest_managed.tacacsGroup.dn}/tacacsdest-${each.value.hostname_ip}-port-${each.value.port}"
  class_name  = "tacacsTacacsDest"
  escape_html = false
  content = {
    host         = each.value.hostname_ip
    port         = each.value.port
    authProtocol = each.value.protocol
    key          = each.value.key
  }

  lifecycle {
    ignore_changes = [content["key"]]
  }
}

resource "aci_rest_managed" "fileRsARemoteHostToEpg" {
  for_each   = { for dest in var.destinations : dest.hostname_ip => dest if dest.mgmt_epg_name != null }
  dn         = "${aci_rest_managed.tacacsTacacsDest[each.value.hostname_ip].dn}/rsARemoteHostToEpg"
  class_name = "fileRsARemoteHostToEpg"
  content = {
    tDn = each.value.mgmt_epg_type == "oob" ? "uni/tn-mgmt/mgmtp-default/oob-${each.value.mgmt_epg_name}" : "uni/tn-mgmt/mgmtp-default/inb-${each.value.mgmt_epg_name}"
  }
}
