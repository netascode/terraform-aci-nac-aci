locals {
  auto = var.auto == "true" ? "on" : var.auto == "false" ? "off" : var.auto
}

resource "aci_rest_managed" "fabricHIfPol" {
  dn         = "uni/infra/hintfpol-${var.name}"
  class_name = "fabricHIfPol"
  content = {
    name             = var.name
    speed            = var.speed
    dfeDelayMs       = var.link_delay_interval
    linkDebounce     = var.link_debounce_interval
    autoNeg          = local.auto
    fecMode          = var.fec_mode
    portPhyMediaType = try(var.physical_media_type, null) != null ? var.physical_media_type : null
  }
}

