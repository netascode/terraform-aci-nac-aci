resource "aci_rest_managed" "fabricHIfPol" {
  count      = var.physical_media_type == "auto" ? 1 : 0
  dn         = "uni/infra/hintfpol-${var.name}"
  class_name = "fabricHIfPol"
  content = {
    name    = var.name
    speed   = var.speed
    autoNeg = var.auto == true ? "on" : "off"
    fecMode = var.fec_mode
  }
}

resource "aci_rest_managed" "fabricHIfPol_sfp-10g-tx" {
  count      = var.physical_media_type == "sfp-10g-tx" ? 1 : 0
  dn         = "uni/infra/hintfpol-${var.name}"
  class_name = "fabricHIfPol"
  content = {
    name    = var.name
    speed   = var.speed
    autoNeg = var.auto == true ? "on" : "off"
    fecMode = var.fec_mode
    portPhyMediaType = var.physical_media_type
  }
}
