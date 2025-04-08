resource "aci_rest_managed" "qosDppPol" {
  dn         = try(var.tenant != null, false) ? "uni/tn-${var.tenant}/qosdpppol-${var.name}" : "uni/infra/qosdpppol-${var.name}"
  class_name = "qosDppPol"

  content = {
    name            = var.name
    adminSt         = var.admin_state ? "enabled" : "disabled"
    type            = var.type
    mode            = var.mode
    sharingMode     = var.sharing_mode
    pir             = var.type == "2R3C" ? var.peak_rate : null
    pirUnit         = var.type == "2R3C" ? var.peak_rate_unit : null
    rate            = var.rate
    rateUnit        = var.rate_unit
    be              = var.type == "2R3C" ? var.burst_excessive : null
    beUnit          = var.type == "2R3C" ? var.burst_excessive_unit : null
    burst           = var.burst
    burstUnit       = var.burst_unit
    conformAction   = var.conform_action
    conformMarkCos  = var.conform_action == "mark" ? var.conform_mark_cos : null
    conformMarkDscp = var.conform_action == "mark" ? var.conform_mark_dscp : null
    exceedAction    = var.exceed_action
    exceedMarkCos   = var.exceed_action == "mark" ? var.exceed_mark_cos : null
    exceedMarkDscp  = var.exceed_action == "mark" ? var.exceed_mark_dscp : null
    violateAction   = var.violate_action
    violateMarkCos  = var.violate_action == "mark" ? var.violate_mark_cos : null
    violateMarkDscp = var.violate_action == "mark" ? var.violate_mark_dscp : null
  }
}