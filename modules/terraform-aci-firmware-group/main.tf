resource "aci_rest_managed" "firmwareFwP" {
  dn         = "uni/fabric/fwpol-${var.name}"
  class_name = "firmwareFwP"
  content = {
    name = var.name
  }
}

resource "aci_rest_managed" "firmwareFwGrp" {
  dn         = "uni/fabric/fwgrp-${var.name}"
  class_name = "firmwareFwGrp"
  content = {
    name = var.name
    type = "range"
  }
}

resource "aci_rest_managed" "firmwareRsFwgrpp" {
  dn         = "${aci_rest_managed.firmwareFwGrp.dn}/rsfwgrpp"
  class_name = "firmwareRsFwgrpp"
  content = {
    tnFirmwareFwPName = var.name
  }
}

resource "aci_rest_managed" "fabricNodeBlk" {
  for_each   = toset([for id in var.node_ids : tostring(id)])
  dn         = "${aci_rest_managed.firmwareFwGrp.dn}/nodeblk-blk${each.value}-${each.value}"
  class_name = "fabricNodeBlk"
  content = {
    name  = "blk${each.value}-${each.value}"
    from_ = each.value
    to_   = each.value
  }
}
