resource "aci_rest_managed" "fvEpIpTag" {
  dn         = "uni/tn-${var.tenant}/eptags/epiptag-[${var.ip}]-${var.vrf}"
  class_name = "fvEpIpTag"

  content = {
    ip      = var.ip
    ctxName = var.vrf
  }
}

resource "aci_rest_managed" "tagTag" {
  for_each   = { for tag in var.tags : "${tag.key}/${tag.value}" => tag }
  dn         = "${aci_rest_managed.fvEpIpTag.dn}/tagKey-${each.value.key}"
  class_name = "tagTag"
  content = {
    key   = each.value.key
    value = each.value.value
  }
}
