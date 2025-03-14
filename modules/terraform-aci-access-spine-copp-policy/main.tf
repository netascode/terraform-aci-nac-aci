resource "aci_rest_managed" "coppSpineProfile" {
  dn         = "uni/infra/coppspinep-${var.name}"
  class_name = "coppSpineProfile"

  content = {
    name  = var.name
    descr = var.description
    type  = var.type
  }

  dynamic "child" {
    for_each = var.type == "custom" ? [0] : []
    content {
      class_name = "coppSpineGen1CustomValues"
      rn         = "spinegen1customvalues"
      content = {
        dn              = "uni/infra/coppspinep-${var.name}/spinegen1customvalues"
        arpRate         = var.custom_values.arp_rate == "default" ? 1360 : var.custom_values.arp_rate
        arpBurst        = var.custom_values.arp_burst == "default" ? 340 : var.custom_values.arp_burst
        bgpRate         = var.custom_values.bgp_rate == "default" ? 5000 : var.custom_values.bgp_rate
        bgpBurst        = var.custom_values.bgp_burst == "default" ? 5000 : var.custom_values.bgp_burst
        cdpRate         = var.custom_values.cdp_rate == "default" ? 1000 : var.custom_values.cdp_rate
        cdpBurst        = var.custom_values.cdp_burst == "default" ? 1000 : var.custom_values.cdp_burst
        coopRate        = var.custom_values.coop_rate == "default" ? 5000 : var.custom_values.coop_rate
        coopBurst       = var.custom_values.coop_burst == "default" ? 5000 : var.custom_values.coop_burst
        dhcpRate        = var.custom_values.dhcp_rate == "default" ? 1360 : var.custom_values.dhcp_rate
        dhcpBurst       = var.custom_values.dhcp_burst == "default" ? 340 : var.custom_values.dhcp_burst
        gleanRate       = var.custom_values.glean_rate == "default" ? 100 : var.custom_values.glean_rate
        gleanBurst      = var.custom_values.glean_burst == "default" ? 100 : var.custom_values.glean_burst
        ifcRate         = var.custom_values.ifc_rate == "default" ? 10000 : var.custom_values.ifc_rate
        ifcBurst        = var.custom_values.ifc_burst == "default" ? 10000 : var.custom_values.ifc_burst
        ifcOtherRate    = var.custom_values.ifc_other_rate == "default" ? 332800 : var.custom_values.ifc_other_rate
        ifcOtherBurst   = var.custom_values.ifc_other_burst == "default" ? 5000 : var.custom_values.ifc_other_burst
        ifcSpanRate     = var.custom_values.ifc_span_rate == "default" ? 2000 : var.custom_values.ifc_span_rate
        ifcSpanBurst    = var.custom_values.ifc_span_burst == "default" ? 2000 : var.custom_values.ifc_span_burst
        igmpRate        = var.custom_values.igmp_rate == "default" ? 1500 : var.custom_values.igmp_rate
        igmpBurst       = var.custom_values.igmp_burst == "default" ? 1500 : var.custom_values.igmp_burst
        infraArpRate    = var.custom_values.infra_arp_rate == "default" ? 300 : var.custom_values.infra_arp_rate
        infraArpBurst   = var.custom_values.infra_arp_burst == "default" ? 300 : var.custom_values.infra_arp_burst
        isisRate        = var.custom_values.isis_rate == "default" ? 1500 : var.custom_values.isis_rate
        isisBurst       = var.custom_values.isis_burst == "default" ? 5000 : var.custom_values.isis_burst
        lldpRate        = var.custom_values.lldp_rate == "default" ? 1000 : var.custom_values.lldp_rate
        lldpBurst       = var.custom_values.lldp_burst == "default" ? 1000 : var.custom_values.lldp_burst
        ospfRate        = var.custom_values.ospf_rate == "default" ? 2000 : var.custom_values.ospf_rate
        ospfBurst       = var.custom_values.ospf_burst == "default" ? 2000 : var.custom_values.ospf_burst
        torGleanRate    = var.custom_values.tor_glean_rate == "default" ? 100 : var.custom_values.tor_glean_rate
        torGleanBurst   = var.custom_values.tor_glean_burst == "default" ? 100 : var.custom_values.tor_glean_burst
        tracerouteRate  = var.custom_values.traceroute_rate == "default" ? 500 : var.custom_values.traceroute_rate
        tracerouteBurst = var.custom_values.traceroute_burst == "default" ? 500 : var.custom_values.traceroute_burst
      }
    }
  }
}
