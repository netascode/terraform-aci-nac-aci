resource "aci_rest_managed" "stpIfPol" {
  dn         = "uni/infra/ifPol-${var.name}"
  class_name = "stpIfPol"
  content = {
    name = var.name
    ctrl = join(",", concat(var.bpdu_filter == true ? ["bpdu-filter"] : [], var.bpdu_guard == true ? ["bpdu-guard"] : []))
  }
}
