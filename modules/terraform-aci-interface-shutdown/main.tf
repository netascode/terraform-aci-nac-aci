resource "aci_rest_managed" "fabricRsOosPath" {
  dn         = "uni/fabric/outofsvc/rsoosPath-[topology/pod-${var.pod_id}/paths-${var.node_id}/pathep-[eth${var.module}/${var.port}]]"
  class_name = "fabricRsOosPath"
  content = {
    lc = "blacklist"
  }
}