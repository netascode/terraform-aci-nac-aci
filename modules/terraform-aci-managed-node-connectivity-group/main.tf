resource "aci_rest_managed" "mgmtGrp" {
  dn         = "uni/infra/funcprof/grp-${var.name}"
  class_name = "mgmtGrp"
  content = {
    name = var.name
  }
}

resource "aci_rest_managed" "mgmtOoBZone" {
  count      = var.oob_mgmt_epg != "" || var.oob_ip_address_pool != "" ? 1 : 0
  dn         = "${aci_rest_managed.mgmtGrp.dn}/oobzone"
  class_name = "mgmtOoBZone"
  content    = {}
}

resource "aci_rest_managed" "mgmtRsAddrInst_oob" {
  count      = var.oob_ip_address_pool != "" ? 1 : 0
  dn         = "${aci_rest_managed.mgmtOoBZone[0].dn}/rsaddrInst"
  class_name = "mgmtRsAddrInst"
  content = {
    tDn = "uni/tn-mgmt/addrinst-${var.oob_ip_address_pool}"
  }
}

resource "aci_rest_managed" "mgmtRsOoB" {
  count      = var.oob_mgmt_epg != "" ? 1 : 0
  dn         = "${aci_rest_managed.mgmtOoBZone[0].dn}/rsooB"
  class_name = "mgmtRsOoB"
  content = {
    tDn = "uni/tn-mgmt/mgmtp-default/oob-${var.oob_mgmt_epg}"
  }
}

resource "aci_rest_managed" "mgmtInBZone" {
  count      = var.inb_mgmt_epg != "" || var.inb_ip_address_pool != "" ? 1 : 0
  dn         = "${aci_rest_managed.mgmtGrp.dn}/inbzone"
  class_name = "mgmtInBZone"
  content    = {}
}

resource "aci_rest_managed" "mgmtRsAddrInst_inb" {
  count      = var.inb_ip_address_pool != "" ? 1 : 0
  dn         = "${aci_rest_managed.mgmtInBZone[0].dn}/rsaddrInst"
  class_name = "mgmtRsAddrInst"
  content = {
    tDn = "uni/tn-mgmt/addrinst-${var.inb_ip_address_pool}"
  }
}

resource "aci_rest_managed" "mgmtRsInB" {
  count      = var.inb_mgmt_epg != "" ? 1 : 0
  dn         = "${aci_rest_managed.mgmtInBZone[0].dn}/rsinB"
  class_name = "mgmtRsInB"
  content = {
    tDn = "uni/tn-mgmt/mgmtp-default/inb-${var.inb_mgmt_epg}"
  }
}
