resource "aci_rest_managed" "fabricNodeControl" {
  dn         = "uni/fabric/nodecontrol-${var.name}"
  class_name = "fabricNodeControl"
  content = {
    name       = var.name
    control    = var.dom == true ? "Dom" : ""
    featureSel = var.telemetry
  }
}
