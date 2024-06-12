resource "aci_rest_managed" "maintMaintP" {
  dn         = "uni/fabric/maintpol-${var.name}"
  class_name = "maintMaintP"
  content = {
    name      = var.name
    adminSt   = "untriggered"
    graceful  = "no"
    notifCond = "notifyOnlyOnFailures"
    runMode   = "pauseOnlyOnFailures"
    version   = var.target_version != "" ? var.target_version : null
  }
}

resource "aci_rest_managed" "maintRsPolScheduler" {
  dn         = "${aci_rest_managed.maintMaintP.dn}/rspolScheduler"
  class_name = "maintRsPolScheduler"
  content = {
    tnTrigSchedPName = "default"
  }
}

resource "aci_rest_managed" "maintMaintGrp" {
  dn         = "uni/fabric/maintgrp-${var.name}"
  class_name = "maintMaintGrp"
  content = {
    name = var.name
    type = "range"
  }
}

resource "aci_rest_managed" "maintRsMgrpp" {
  dn         = "${aci_rest_managed.maintMaintGrp.dn}/rsmgrpp"
  class_name = "maintRsMgrpp"
  content = {
    tnMaintMaintPName = var.name
  }
}

resource "aci_rest_managed" "fabricNodeBlk" {
  for_each   = toset([for id in var.node_ids : tostring(id)])
  dn         = "${aci_rest_managed.maintMaintGrp.dn}/nodeblk-blk${each.value}-${each.value}"
  class_name = "fabricNodeBlk"
  content = {
    name  = "blk${each.value}-${each.value}"
    from_ = each.value
    to_   = each.value
  }
}
