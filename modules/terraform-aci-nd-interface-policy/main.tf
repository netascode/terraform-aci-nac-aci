resource "aci_rest_managed" "ndIfPol" {
  dn         = "uni/tn-${var.tenant}/ndifpol-${var.name}"
  class_name = "ndIfPol"
  content = {
    name                = var.name
    descr               = var.description
    ctrl                = join(",", var.controller_state)
    hopLimit            = var.hop_limit
    nsIntvl             = var.ns_tx_interval
    mtu                 = var.mtu
    nsRetries           = var.retransmit_retry_count
    nudRetryBase        = var.nud_retransmit_base
    nudRetryInterval    = var.nud_retransmit_interval
    nudRetryMaxAttempts = var.nud_retransmit_count
    raIntvl             = var.route_advertise_interval
    raLifetime          = var.router_lifetime
    reachableTime       = var.reachable_time
    retransTimer        = var.retransmit_timer
  }
}