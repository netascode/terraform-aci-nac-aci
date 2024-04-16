resource "aci_rest_managed" "fvTrackList" {
  dn         = "uni/tn-${var.tenant}/tracklist-${var.name}"
  class_name = "fvTrackList"
  content = {
    name           = var.name
    descr          = var.description
    type           = var.type
    percentageDown = var.percentage_down
    percentageUp   = var.percentage_up
    weightDown     = var.weight_down
    weightUp       = var.weight_up
  }
}

resource "aci_rest_managed" "fvRsOtmListMember" {
  for_each   = toset(var.track_members)
  dn         = "${aci_rest_managed.fvTrackList.dn}/rsotmListMember-[uni/tn-${var.tenant}/trackmember-${each.value}]"
  class_name = "fvRsOtmListMember"
  content = {
    tDn = "uni/tn-${var.tenant}/trackmember-${each.value}"
  }
}