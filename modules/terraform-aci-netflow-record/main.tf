resource "aci_rest_managed" "netflowRecordPol" {
  dn         = "uni/infra/recordpol-${var.name}"
  class_name = "netflowRecordPol"
  content = {
    name  = var.name
    descr = var.description
    match = join(",", sort(var.match_parameters))
  }
}