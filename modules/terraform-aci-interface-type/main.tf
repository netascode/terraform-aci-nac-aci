resource "aci_rest_managed" "infraRsPortDirection" {
  dn         = "uni/infra/prtdirec/rsportDirection-[topology/pod-${var.pod_id}/paths-${var.node_id}/pathep-[eth${var.module}/${var.port}]]"
  class_name = "infraRsPortDirection"
  content = {
    tDn   = "topology/pod-${var.pod_id}/paths-${var.node_id}/pathep-[eth${var.module}/${var.port}]"
    direc = var.type == "uplink" ? "UpLink" : "DownLink"
  }
}
