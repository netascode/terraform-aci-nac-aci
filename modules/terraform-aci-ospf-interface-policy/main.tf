resource "aci_rest_managed" "ospfIfPol" {
  dn         = "uni/tn-${var.tenant}/ospfIfPol-${var.name}"
  class_name = "ospfIfPol"
  content = {
    name        = var.name
    descr       = var.description
    cost        = var.cost
    deadIntvl   = var.dead_interval
    helloIntvl  = var.hello_interval
    nwT         = var.network_type
    prio        = var.priority
    rexmitIntvl = var.lsa_retransmit_interval
    xmitDelay   = var.lsa_transmit_delay
    ctrl        = join(",", concat(var.advertise_subnet == true ? ["advert-subnet"] : [], var.bfd == true ? ["bfd"] : [], var.mtu_ignore == true ? ["mtu-ignore"] : [], var.passive_interface == true ? ["passive"] : []))
  }
}
