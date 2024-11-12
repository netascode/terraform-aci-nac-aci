resource "aci_rest_managed" "fvAp" {
  dn         = "uni/tn-${var.tenant}/ap-${var.name}"
  class_name = "fvAp"
  annotation = var.annotation
  content = {
    name      = var.name
    nameAlias = var.alias
    descr     = var.description
  }
}

resource "aci_rest_managed" "fvRsApMonPol" {
  count      = var.monitoring_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.fvAp.dn}/rsApMonPol"
  class_name = "fvRsApMonPol"

  content = {
    tnMonEPGPolName = var.monitoring_policy
  }
}