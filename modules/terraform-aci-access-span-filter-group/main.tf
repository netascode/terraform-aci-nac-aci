resource "aci_rest_managed" "spanFilterGrp" {
  dn         = "uni/infra/filtergrp-${var.name}"
  class_name = "spanFilterGrp"
  content = {
    name  = var.name
    descr = var.description
  }
}

resource "aci_rest_managed" "spanFilterEntry" {
  for_each   = { for entry in var.entries : entry.name => entry }
  dn         = "${aci_rest_managed.spanFilterGrp.dn}/proto-${each.value.ip_protocol}-src-[${each.value.source_ip}]-dst-[${each.value.destination_ip}]-srcPortFrom-${each.value.source_from_port}-srcPortTo-${each.value.source_to_port != null ? each.value.source_to_port : each.value.source_from_port}-dstPortFrom-${each.value.destination_from_port}-dstPortTo-${each.value.destination_to_port != null ? each.value.destination_to_port : each.value.destination_from_port}"
  class_name = "spanFilterEntry"
  content = {
    name        = each.value.name
    descr       = each.value.description
    dstAddr     = each.value.destination_ip
    dstPortFrom = each.value.destination_from_port == "20" ? "ftpData" : each.value.destination_from_port == "22" ? "ssh" : each.value.destination_from_port == "25" ? "smtp" : each.value.destination_from_port == "53" ? "dns" : each.value.destination_from_port == "80" ? "http" : each.value.destination_from_port == "110" ? "pop3" : each.value.destination_from_port == "443" ? "https" : each.value.destination_from_port == "554" ? "rtsp" : each.value.destination_from_port
    dstPortTo   = each.value.destination_to_port != null ? (each.value.destination_to_port == "20" ? "ftpData" : each.value.destination_to_port == "22" ? "ssh" : each.value.destination_to_port == "25" ? "smtp" : each.value.destination_to_port == "53" ? "dns" : each.value.destination_to_port == "80" ? "http" : each.value.destination_to_port == "110" ? "pop3" : each.value.destination_to_port == "443" ? "https" : each.value.destination_to_port == "554" ? "rtsp" : each.value.destination_to_port) : each.value.destination_from_port
    ipProto     = each.value.ip_protocol == "1" ? "icmp" : each.value.ip_protocol == "2" ? "igmp" : each.value.ip_protocol == "6" ? "tcp" : each.value.ip_protocol == "8" ? "egp" : each.value.ip_protocol == "9" ? "igp" : each.value.ip_protocol == "17" ? "udp" : each.value.ip_protocol == "58" ? "icmpv6" : each.value.ip_protocol == "88" ? "eigrp" : each.value.ip_protocol == "89" ? "ospfigp" : each.value.ip_protocol == "103" ? "pim" : each.value.ip_protocol == "115" ? "l2tp" : each.value.ip_protocol
    srcAddr     = each.value.source_ip
    srcPortFrom = each.value.source_from_port == "20" ? "ftpData" : each.value.source_from_port == "22" ? "ssh" : each.value.source_from_port == "25" ? "smtp" : each.value.source_from_port == "53" ? "dns" : each.value.source_from_port == "80" ? "http" : each.value.source_from_port == "110" ? "pop3" : each.value.source_from_port == "443" ? "https" : each.value.source_from_port == "554" ? "rtsp" : each.value.source_from_port
    srcPortTo   = each.value.source_to_port != null ? (each.value.source_to_port == "20" ? "ftpData" : each.value.source_to_port == "22" ? "ssh" : each.value.source_to_port == "25" ? "smtp" : each.value.source_to_port == "53" ? "dns" : each.value.source_to_port == "80" ? "http" : each.value.source_to_port == "110" ? "pop3" : each.value.source_to_port == "443" ? "https" : each.value.source_to_port == "554" ? "rtsp" : each.value.source_to_port) : each.value.source_from_port
  }
}
