resource "aci_rest_managed" "vxlanRemoteFabric" {
  dn         = "uni/tn-infra/vxlanremotefabric-${var.name}"
  class_name = "vxlanRemoteFabric"
  content = {
    name = var.name
  }
}

resource "aci_rest_managed" "vxlanRsRemoteFabricToBgwSet" {
  dn         = "${aci_rest_managed.vxlanRemoteFabric.dn}/rsremoteFabricToBgwSet-[uni/tn-infra/vxlanbgwset-${var.border_gateway_set}]"
  class_name = "vxlanRsRemoteFabricToBgwSet"
  content = {
    tDn = "uni/tn-infra/vxlanbgwset-${var.border_gateway_set}"
  }
}

resource "aci_rest_managed" "bgpInfraPeerP" {
  for_each    = { for peer in var.remote_evpn_peers : peer.ip => peer }
  dn          = "${aci_rest_managed.vxlanRemoteFabric.dn}/infraPeerP-[${each.value.ip}]"
  class_name  = "bgpInfraPeerP"
  escape_html = false
  content = {
    addr     = each.value.ip
    descr    = each.value.description
    ctrl     = join(",", concat(each.value.allow_self_as == true ? ["allow-self-as"] : [], each.value.disable_peer_as_check == true ? ["dis-peer-as-check"] : [], ["send-com"], ["send-ext-com"]))
    password = sensitive(each.value.password)
    peerT    = "vxlan-bgw"
    ttl      = each.value.ttl
    adminSt  = each.value.admin_state == true ? "enabled" : "disabled"
  }

  lifecycle {
    ignore_changes = [content["password"]]
  }
}

resource "aci_rest_managed" "bgpAsP" {
  for_each   = { for peer in var.remote_evpn_peers : peer.ip => peer }
  dn         = "${aci_rest_managed.bgpInfraPeerP[each.key].dn}/as"
  class_name = "bgpAsP"
  content = {
    asn = each.value.remote_as
  }
}

resource "aci_rest_managed" "bgpLocalAsnP" {
  for_each   = { for peer in var.remote_evpn_peers : peer.ip => peer if peer.local_as != null }
  dn         = "${aci_rest_managed.bgpInfraPeerP[each.key].dn}/localasn"
  class_name = "bgpLocalAsnP"
  content = {
    localAsn     = each.value.local_as
    asnPropagate = each.value.as_propagate
  }
}

resource "aci_rest_managed" "bgpRsPeerPfxPol" {
  for_each   = { for peer in var.remote_evpn_peers : peer.ip => peer if peer.peer_prefix_policy != null }
  dn         = "${aci_rest_managed.bgpInfraPeerP[each.key].dn}/rspeerPfxPol"
  class_name = "bgpRsPeerPfxPol"
  content = {
    tnBgpPeerPfxPolName = each.value.peer_prefix_policy
  }
}
