resource "aci_rest_managed" "fabricRsOosPath" {
  dn         = var.fex_id != 0 ? "uni/fabric/outofsvc/rsoosPath-[topology/pod-${var.pod_id}/paths-${var.node_id}/extpaths-${var.fex_id}/pathep-[eth${var.module}/${var.port}]]" : (var.sub_port != 0 ? "uni/fabric/outofsvc/rsoosPath-[topology/pod-${var.pod_id}/paths-${var.node_id}/pathep-[eth${var.module}/${var.port}/${var.sub_port}]]" : "uni/fabric/outofsvc/rsoosPath-[topology/pod-${var.pod_id}/paths-${var.node_id}/pathep-[eth${var.module}/${var.port}]]")
  class_name = "fabricRsOosPath"
  content = {
    lc = "blacklist"
  }
}
