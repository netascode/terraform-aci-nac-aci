resource "aci_rest_managed" "tacacsGroup" {
  dn         = "uni/fabric/tacacsgroup-${var.name}"
  class_name = "tacacsGroup"
  content = {
    name  = var.name
    descr = var.description
  }
}

resource "aci_rest_managed" "tacacsTacacsDest" {
  for_each    = { for dest in var.destinations : "${dest.host}-${dest.port}" => dest }
  dn          = "${aci_rest_managed.tacacsGroup.dn}/tacacsdest-${each.value.host}-port-${each.value.port}"
  class_name  = "tacacsTacacsDest"
  escape_html = false
  content = {
    name            = each.value.name
    host            = each.value.host
    port            = each.value.port
    authProtocol    = each.value.auth_protocol
    populateCmdArgs = each.value.populate_cmd_args == null ? null : (each.value.populate_cmd_args == true ? "yes" : "no")
    key             = each.value.key
    descr           = each.value.description
  }

  lifecycle {
    ignore_changes = [content["key"]]
  }
}

resource "aci_rest_managed" "fileRsARemoteHostToEpg" {
  for_each   = { for dest in var.destinations : "${dest.host}-${dest.port}" => dest if dest.mgmt_epg_name != null }
  dn         = "${aci_rest_managed.tacacsTacacsDest[each.key].dn}/rsARemoteHostToEpg"
  class_name = "fileRsARemoteHostToEpg"
  content = {
    tDn = each.value.mgmt_epg_type == "oob" ? "uni/tn-mgmt/mgmtp-default/oob-${each.value.mgmt_epg_name}" : "uni/tn-mgmt/mgmtp-default/inb-${each.value.mgmt_epg_name}"
  }
}
