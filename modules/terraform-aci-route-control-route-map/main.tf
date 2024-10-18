locals {
  context_match_rules = flatten([
    for ctx in var.contexts : [
      for match in ctx.match_rules : {
        ctx        = ctx.name
        match_rule = match
      }
    ]
  ])
}

resource "aci_rest_managed" "rtctrlProfile" {
  dn         = "uni/tn-${var.tenant}/prof-${var.name}"
  class_name = "rtctrlProfile"
  content = {
    name  = var.name
    descr = var.description
    type  = var.type
  }
}


resource "aci_rest_managed" "rtctrlCtxP" {
  for_each   = { for ctx in var.contexts : ctx.name => ctx }
  dn         = "${aci_rest_managed.rtctrlProfile.dn}/ctx-${each.value.name}"
  class_name = "rtctrlCtxP"
  content = {
    name   = each.value.name
    descr  = each.value.description
    action = each.value.action
    order  = each.value.order
  }
}

resource "aci_rest_managed" "rtctrlScope" {
  for_each   = { for ctx in var.contexts : ctx.name => ctx if ctx.set_rule != "" }
  dn         = "${aci_rest_managed.rtctrlCtxP[each.value.name].dn}/scp"
  class_name = "rtctrlScope"
  content = {
    descr = ""
  }
}

resource "aci_rest_managed" "rtctrlRsScopeToAttrP" {
  for_each   = { for ctx in var.contexts : ctx.name => ctx if ctx.set_rule != "" }
  dn         = "${aci_rest_managed.rtctrlScope[each.value.name].dn}/rsScopeToAttrP"
  class_name = "rtctrlRsScopeToAttrP"
  content = {
    tnRtctrlAttrPName = each.value.set_rule
  }
}

resource "aci_rest_managed" "rtctrlRsCtxPToSubjP" {
  for_each   = { for match in local.context_match_rules : match.match_rule => match }
  dn         = "${aci_rest_managed.rtctrlCtxP[each.value.ctx].dn}/rsctxPToSubjP-${each.value.match_rule}"
  class_name = "rtctrlRsCtxPToSubjP"
  content = {
    tnRtctrlSubjPName = each.value.match_rule
  }
}
