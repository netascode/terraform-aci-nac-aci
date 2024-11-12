resource "aci_rest_managed" "fvTenant" {
  dn         = "uni/tn-${var.name}"
  class_name = "fvTenant"
  annotation = var.annotation
  content = {
    name      = var.name
    nameAlias = var.alias
    descr     = var.description
  }
}

resource "aci_rest_managed" "aaaDomainRef" {
  for_each   = toset(var.security_domains)
  dn         = "${aci_rest_managed.fvTenant.dn}/domain-${each.value}"
  class_name = "aaaDomainRef"
  content = {
    name = each.value
  }
}

resource "aci_rest_managed" "fvRsTenantMonPol" {
  count      = var.monitoring_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.fvTenant.dn}/rsTenantMonPol"
  class_name = "fvRsTenantMonPol"

  content = {
    tnMonEPGPolName = var.monitoring_policy
  }
}