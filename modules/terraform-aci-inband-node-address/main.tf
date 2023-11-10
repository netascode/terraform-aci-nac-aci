# Workaround to create inband EPG in case it does not exist yet, but avoid deleting it when the module is destroyed
resource "aci_rest" "mgmtInB" {
  path    = "/api/mo/uni/tn-mgmt/mgmtp-default.json"
  payload = <<EOF
    {
      "mgmtMgmtP": {
        "attributes": {},
        "children": [
          {
            "mgmtInB": {
              "attributes": {
                "name": "${var.endpoint_group}",
                "encap": "vlan-${var.endpoint_group_vlan}"
              }
            }
          }
        ]
      }
    }
  EOF
}

resource "aci_rest_managed" "mgmtRsInBStNode" {
  dn         = "uni/tn-mgmt/mgmtp-default/inb-${var.endpoint_group}/rsinBStNode-[topology/pod-${var.pod_id}/node-${var.node_id}]"
  class_name = "mgmtRsInBStNode"
  content = {
    addr   = var.ip
    gw     = var.gateway
    v6Addr = var.v6_ip
    v6Gw   = var.v6_gateway
    tDn    = "topology/pod-${var.pod_id}/node-${var.node_id}"
  }

  depends_on = [aci_rest.mgmtInB]
}
