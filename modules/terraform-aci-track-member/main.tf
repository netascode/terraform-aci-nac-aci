resource "aci_rest_managed" "fvTrackMember" {
  dn         = "uni/tn-${var.tenant}/trackmember-${var.name}"
  class_name = "fvTrackMember"
  content = {
    name      = var.name
    descr     = var.description
    dstIpAddr = var.destination_ip
    scopeDn   = var.scope_type == "l3out" ? "uni/tn-${var.tenant}/out-${var.scope}" : "uni/tn-${var.tenant}/BD-${var.scope}"
  }
}

resource "aci_rest_managed" "fvRsIpslaMonPol" {
  dn         = "${aci_rest_managed.fvTrackMember.dn}/rsIpslaMonPol"
  class_name = "fvRsIpslaMonPol"
  content = {
    tDn = "uni/tn-${var.ip_sla_policy_tenant}/ipslaMonitoringPol-${var.ip_sla_policy}"
  }
}

