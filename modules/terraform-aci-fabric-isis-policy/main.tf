resource "aci_rest_managed" "isisDomPol" {
  dn         = "uni/fabric/isisDomP-default"
  class_name = "isisDomPol"
  content = {
    redistribMetric = var.redistribute_metric
  }
}
