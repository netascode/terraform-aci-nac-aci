resource "aci_rest_managed" "fhsTrustCtrlPol" {
  dn         = "uni/tn-${var.tenant}/trustctrlpol-${var.name}"
  class_name = "fhsTrustCtrlPol"
  content = {
    name            = var.name
    descr           = var.description
    hasDhcpv4Server = var.dhcp_v4_server == true ? "yes" : "no"
    hasDhcpv6Server = var.dhcp_v6_server == true ? "yes" : "no"
    hasIpv6Router   = var.ipv6_router == true ? "yes" : "no"
    trustArp        = var.arp == true ? "yes" : "no"
    trustNd         = var.nd == true ? "yes" : "no"
    trustRa         = var.ra == true ? "yes" : "no"
  }
}
