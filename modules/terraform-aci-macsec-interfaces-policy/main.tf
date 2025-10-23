resource "aci_rest_managed" "macsecIfPol" {
  dn         = var.type == "access" ? "uni/infra/macsecifp-${var.name}" : "uni/fabric/macsecfabifp-${var.name}"
  class_name = var.type == "access" ? "macsecIfPol" : "macsecFabIfPol"

  content = {
    name    = var.name
    adminSt = var.admin_state ? "enabled" : "disabled"
    descr   = var.description
  }
}

resource "aci_rest_managed" "macsecRsToKeyChainPol" {
  dn         = "${aci_rest_managed.macsecIfPol.dn}/rsToKeyChainPol"
  class_name = "macsecRsToKeyChainPol"

  content = {
    tDn = var.type == "access" ? "uni/infra/macsecpcont/keychainp-${var.macsec_keychain_policy}" : "uni/fabric/macsecpcontfab/keychainp-${var.macsec_keychain_policy}"
  }
}

resource "aci_rest_managed" "macsecRsToParamPol" {
  dn         = "${aci_rest_managed.macsecIfPol.dn}/rsToParamPol"
  class_name = "macsecRsToParamPol"

  content = {
    tDn = var.type == "access" ? "uni/infra/macsecpcont/paramp-${var.macsec_parameters_policy}" : "uni/fabric/macsecpcontfab/fabparamp-${var.macsec_parameters_policy}"
  }
}
