resource "aci_rest_managed" "vzFilter" {
  dn         = "uni/tn-${var.tenant}/flt-${var.name}"
  class_name = "vzFilter"
  content = {
    name      = var.name
    nameAlias = var.alias
    descr     = var.description
  }
}

resource "aci_rest_managed" "vzEntry" {
  for_each   = { for entry in var.entries : entry.name => entry }
  dn         = "${aci_rest_managed.vzFilter.dn}/e-${each.value.name}"
  class_name = "vzEntry"
  content = {
    name      = each.value.name
    nameAlias = each.value.alias
    descr     = each.value.description
    etherT    = each.value.ethertype
    prot      = contains(["ip", "ipv4", "ipv6", null], each.value.ethertype) ? (each.value.protocol == "1" ? "icmp" : each.value.protocol == "2" ? "igmp" : each.value.protocol == "6" ? "tcp" : each.value.protocol == "8" ? "egp" : each.value.protocol == "9" ? "igp" : each.value.protocol == "17" ? "udp" : each.value.protocol == "58" ? "icmpv6" : each.value.protocol == "88" ? "eigrp" : each.value.protocol == "89" ? "ospfigp" : each.value.protocol == "103" ? "pim" : each.value.protocol == "115" ? "l2tp" : each.value.protocol) : null
    sFromPort = each.value.source_from_port == "20" ? "ftpData" : each.value.source_from_port == "22" ? "ssh" : each.value.source_from_port == "25" ? "smtp" : each.value.source_from_port == "53" ? "dns" : each.value.source_from_port == "80" ? "http" : each.value.source_from_port == "110" ? "pop3" : each.value.source_from_port == "443" ? "https" : each.value.source_from_port == "554" ? "rtsp" : each.value.source_from_port
    sToPort   = each.value.source_to_port == "20" ? "ftpData" : each.value.source_to_port == "22" ? "ssh" : each.value.source_to_port == "25" ? "smtp" : each.value.source_to_port == "53" ? "dns" : each.value.source_to_port == "80" ? "http" : each.value.source_to_port == "110" ? "pop3" : each.value.source_to_port == "443" ? "https" : each.value.source_to_port == "554" ? "rtsp" : each.value.source_to_port
    dFromPort = each.value.destination_from_port == "20" ? "ftpData" : each.value.destination_from_port == "22" ? "ssh" : each.value.destination_from_port == "25" ? "smtp" : each.value.destination_from_port == "53" ? "dns" : each.value.destination_from_port == "80" ? "http" : each.value.destination_from_port == "110" ? "pop3" : each.value.destination_from_port == "443" ? "https" : each.value.destination_from_port == "554" ? "rtsp" : each.value.destination_from_port
    dToPort   = each.value.destination_to_port == "20" ? "ftpData" : each.value.destination_to_port == "22" ? "ssh" : each.value.destination_to_port == "25" ? "smtp" : each.value.destination_to_port == "53" ? "dns" : each.value.destination_to_port == "80" ? "http" : each.value.destination_to_port == "110" ? "pop3" : each.value.destination_to_port == "443" ? "https" : each.value.destination_to_port == "554" ? "rtsp" : each.value.destination_to_port
    stateful  = each.value.stateful == true ? "yes" : "no"
  }
}

