resource "aci_rest_managed" "eigrpIfPol" {
  dn         = "uni/tn-${var.tenant}/eigrpIfPol-${var.name}"
  class_name = "eigrpIfPol"
  content = {
    name       = var.name
    descr      = var.description
    helloIntvl = var.hello_interval
    holdIntvl  = var.hold_interval
    bw         = var.bandwidth
    delay      = var.delay
    delayUnit  = var.delay_unit
    ctrl       = join(",", concat(var.self_nexthop == true ? ["nh-self"] : [], var.bfd == true ? ["bfd"] : [], var.split_horizon == true ? ["split-horizon"] : [], var.passive_interface == true ? ["passive"] : []))
  }
}