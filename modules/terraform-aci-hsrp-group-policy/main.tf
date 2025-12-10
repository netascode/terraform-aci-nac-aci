resource "aci_rest_managed" "hsrpGroupPol" {
  dn         = "uni/tn-${var.tenant}/hsrpGroupPol-${var.name}"
  class_name = "hsrpGroupPol"
  annotation = var.annotation != "" ? var.annotation : "orchestrator:terraform"
  content = {
    name               = var.name
    descr              = var.description
    ctrl               = var.preempt ? "preempt" : ""
    helloIntvl         = var.hello_interval
    holdIntvl          = var.hold_interval
    key                = var.key
    nameAlias          = var.alias
    ownerKey           = var.owner_key
    ownerTag           = var.owner_tag
    preemptDelayMin    = var.preempt_delay_min
    preemptDelayReload = var.preempt_delay_reload
    preemptDelaySync   = var.preempt_delay_sync
    prio               = var.priority
    timeout            = var.timeout
    type               = var.hsrp_type
  }
}