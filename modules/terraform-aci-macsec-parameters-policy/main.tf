resource "aci_rest_managed" "macsecParamPol" {
  dn         = var.type == "access" ? "uni/infra/macsecpcont/paramp-${var.name}" : "uni/fabric/macsecpcontfab/fabparamp-${var.name}"
  class_name = var.type == "access" ? "macsecParamPol" : "macsecFabParamPol"
  content = {
    name          = var.name
    descr         = var.description
    confOffset    = var.type == "access" ? var.confidentiality_offset : null
    keySvrPrio    = var.type == "access" ? var.key_server_priority : null
    cipherSuite   = var.cipher_suite
    replayWindow  = var.window_size
    sakExpiryTime = var.key_expiry_time == 0 ? "disabled" : var.key_expiry_time
    secPolicy     = var.security_policy
  }
}
