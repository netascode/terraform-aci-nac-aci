resource "aci_rest_managed" "bgpAsP" {
  dn         = "uni/fabric/bgpInstP-default/as"
  class_name = "bgpAsP"
  content = {
    asn = var.fabric_bgp_as
  }
}

resource "aci_rest_managed" "bgpRRNodePEp" {
  for_each   = { for rr in var.fabric_bgp_rr : rr.node_id => rr }
  dn         = "uni/fabric/bgpInstP-default/rr/node-${each.value.node_id}"
  class_name = "bgpRRNodePEp"
  content = {
    id    = each.value.node_id
    podId = each.value.pod_id
  }
}

resource "aci_rest_managed" "bgpRRNodePEp-Ext" {
  for_each   = { for rr in var.fabric_bgp_external_rr : rr.node_id => rr }
  dn         = "uni/fabric/bgpInstP-default/extrr/node-${each.value.node_id}"
  class_name = "bgpRRNodePEp"
  content = {
    id    = each.value.node_id
    podId = each.value.pod_id
  }
}
