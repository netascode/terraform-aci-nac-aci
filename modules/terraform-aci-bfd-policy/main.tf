resource "aci_rest_managed" "bfdInstPol" {
  dn         = var.type == "ipv4" ? "uni/infra/bfdIpv4Inst-${var.name}" : "uni/infra/bfdIpv6Inst-${var.name}"
  class_name = var.type == "ipv4" ? "bfdIpv4InstPol" : "bfdIpv6InstPol"

  content = {
    name         = var.name
    descr        = var.description
    detectMult   = var.detection_multiplier
    minTxIntvl   = var.min_tx_interval
    minRxIntvl   = var.min_rx_interval
    slowIntvl    = var.slow_timer_interval
    startupIntvl = var.startup_timer_interval
    echoRxIntvl  = var.echo_rx_interval
    echoSrcAddr  = var.echo_frame_source_address
  }
}
