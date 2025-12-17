resource "aci_rest_managed" "hsrpGroupPol" {
  dn         = "uni/tn-${var.tenant}/hsrpGroupPol-${var.name}"
  class_name = "hsrpGroupPol"
  content = {
    name               = var.name
    descr              = var.description
    ctrl               = var.preempt ? "preempt" : ""
    helloIntvl         = var.hello_interval
    holdIntvl          = var.hold_interval
    key                = var.key
    preemptDelayMin    = var.preempt_delay_min
    preemptDelayReload = var.preempt_delay_reload
    preemptDelaySync   = var.preempt_delay_sync
    prio               = var.priority
    timeout            = var.timeout
    type               = var.hsrp_type
  }

  lifecycle {
    ignore_changes = [content["key"]]
  }
}