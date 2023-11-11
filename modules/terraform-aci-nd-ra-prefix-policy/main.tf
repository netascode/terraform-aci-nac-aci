resource "aci_rest_managed" "ndPfxPol" {
  dn         = "uni/tn-${var.tenant}/ndpfxpol-${var.name}"
  class_name = "ndPfxPol"
  content = {
    name         = var.name
    descr        = var.description
    ctrl         = join(",", concat(var.auto_configuration == true ? ["auto-cfg"] : [], var.on_link == true ? ["on-link"] : [], var.router_address == true ? ["router-address"] : []))
    lifetime     = var.valid_lifetime
    prefLifetime = var.preferred_lifetime
  }
}
