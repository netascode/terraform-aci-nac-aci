resource "aci_rest_managed" "bfdMhNodePol" {
  dn         = "uni/tn-${var.tenant}/bfdMhNodePol-${var.name}"
  class_name = "bfdMhNodePol"
  content = {
    name       = var.name
    descr      = var.description
    detectMult = var.detection_multiplier
    minRxIntvl = var.min_rx_interval
    minTxIntvl = var.min_tx_interval
  }
}
