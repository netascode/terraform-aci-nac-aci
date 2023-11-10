resource "aci_rest_managed" "infraFexP" {
  dn         = "uni/infra/fexprof-${var.name}"
  class_name = "infraFexP"
  content = {
    name = var.name
  }
}

resource "aci_rest_managed" "infraFexBndlGrp" {
  dn         = "${aci_rest_managed.infraFexP.dn}/fexbundle-${var.name}"
  class_name = "infraFexBndlGrp"
  content = {
    name = var.name
  }
}
