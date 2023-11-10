resource "aci_rest_managed" "bfdIfPol" {
  dn         = "uni/tn-${var.tenant}/bfdIfPol-${var.name}"
  class_name = "bfdIfPol"
  content = {
    name        = var.name
    descr       = var.description
    ctrl        = var.subinterface_optimization == true ? "opt-subif" : ""
    detectMult  = var.detection_multiplier
    echoAdminSt = var.echo_admin_state == true ? "enabled" : "disabled"
    echoRxIntvl = var.echo_rx_interval
    minRxIntvl  = var.min_rx_interval
    minTxIntvl  = var.min_tx_interval
  }
}
