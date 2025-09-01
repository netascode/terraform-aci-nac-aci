resource "aci_rest_managed" "qosDppPol" {
  dn         = try(var.tenant != null, false) ? "uni/tn-${var.tenant}/qosdpppol-${var.name}" : "uni/infra/qosdpppol-${var.name}"
  class_name = "qosDppPol"
  content = {
    name            = var.name
    adminSt         = var.admin_state ? "enabled" : "disabled"
    mode            = var.mode
    type            = var.type
    sharingMode     = var.sharing_mode
    conformAction   = var.conform_action
    conformMarkCos  = var.conform_mark_cos
    conformMarkDscp = var.conform_mark_dscp
    exceedAction    = var.exceed_action
    exceedMarkCos   = var.exceed_mark_cos
    exceedMarkDscp  = var.exceed_mark_dscp
    violateAction   = var.violate_action
    violateMarkCos  = var.violate_mark_cos
    violateMarkDscp = var.violate_mark_dscp
    rate            = var.rate
    rateUnit        = var.rate_unit
    burst           = var.burst
    burstUnit       = var.burst_unit
    pir             = var.peak_rate
    pirUnit         = var.peak_rate_unit
    be              = var.burst_excessive
    beUnit          = var.burst_excessive_unit
  }
}