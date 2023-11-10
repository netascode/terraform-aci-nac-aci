resource "aci_rest_managed" "fvAp" {
  dn         = "uni/tn-${var.tenant}/ap-${var.name}"
  class_name = "fvAp"
  content = {
    name      = var.name
    nameAlias = var.alias
    descr     = var.description
  }
}
