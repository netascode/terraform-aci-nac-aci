locals {
  factors = flatten([
    for c in var.community_terms : [
      for f in coalesce(c.factors, []) : {
        key = "${c.name}/${f.community}"
        value = {
          community_term_name = c.name
          community           = f.community
          description         = f.description
          scope               = f.scope
        }
      }
    ]
  ])
}

resource "aci_rest_managed" "rtctrlSubjP" {
  dn         = "uni/tn-${var.tenant}/subj-${var.name}"
  class_name = "rtctrlSubjP"
  content = {
    name  = var.name
    descr = var.description
  }
}

resource "aci_rest_managed" "rtctrlMatchCommRegexTerm" {
  for_each   = { for r in var.regex_community_terms : r.name => r }
  dn         = "${aci_rest_managed.rtctrlSubjP.dn}/commrxtrm-${each.value.type}"
  class_name = "rtctrlMatchCommRegexTerm"
  content = {
    name     = each.value.name
    regex    = each.value.regex
    commType = each.value.type
    descr    = each.value.description
  }
}

resource "aci_rest_managed" "rtctrlMatchCommTerm" {
  for_each   = { for c in var.community_terms : c.name => c }
  dn         = "${aci_rest_managed.rtctrlSubjP.dn}/commtrm-${each.value.name}"
  class_name = "rtctrlMatchCommTerm"
  content = {
    name  = each.value.name
    descr = each.value.description
  }
}

resource "aci_rest_managed" "rtctrlMatchCommFactor" {
  for_each   = { for f in local.factors : f.key => f.value }
  dn         = "${aci_rest_managed.rtctrlMatchCommTerm[each.value.community_term_name].dn}/commfct-${each.value.community}"
  class_name = "rtctrlMatchCommFactor"
  content = {
    community = each.value.community
    descr     = each.value.description
    scope     = each.value.scope
  }
}

resource "aci_rest_managed" "rtctrlMatchRtDest" {
  for_each   = { for prefix in var.prefixes : prefix.ip => prefix }
  dn         = "${aci_rest_managed.rtctrlSubjP.dn}/dest-[${each.value.ip}]"
  class_name = "rtctrlMatchRtDest"
  content = {
    ip         = each.value.ip
    aggregate  = each.value.aggregate == true ? "yes" : "no"
    descr      = each.value.description
    fromPfxLen = each.value.from_length
    toPfxLen   = each.value.to_length
  }
}
