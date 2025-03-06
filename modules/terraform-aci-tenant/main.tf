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
