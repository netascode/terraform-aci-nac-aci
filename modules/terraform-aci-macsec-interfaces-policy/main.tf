resource "aci_rest_managed" "macsecIfPol" {
  dn         = "uni/infra/macsecifp-${var.name}"
  class_name = "macsecIfPol"

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
    tDn = "uni/infra/macsecpcont/keychainp-${var.macsec_keychain_policy}"
  }
}

resource "aci_rest_managed" "macsecRsToParamPol" {
  dn         = "${aci_rest_managed.macsecIfPol.dn}/rsToParamPol"
  class_name = "macsecRsToParamPol"

  content = {
    tDn = "uni/infra/macsecpcont/paramp-${var.macsec_parameters_policy}"
  }
}