resource "aci_rest_managed" "fvEpMacTag" {
  dn         = "uni/tn-${var.tenant}/eptags/epmactag-${var.mac}-[${var.bridge_domain == "all" ? "*" : var.bridge_domain}]"
  class_name = "fvEpMacTag"
  content = {
    mac     = var.mac
    bdName  = var.bridge_domain == "all" ? "*" : var.bridge_domain
    ctxName = var.bridge_domain == "all" ? var.vrf : null
  }
}

resource "aci_rest_managed" "tagTag" {
  for_each   = { for tag in var.tags : "${tag.key}/${tag.value}" => tag }
  dn         = "${aci_rest_managed.fvEpMacTag.dn}/tagKey-${each.value.key}"
  class_name = "tagTag"
  content = {
    key   = each.value.key
    value = each.value.value
  }
}
