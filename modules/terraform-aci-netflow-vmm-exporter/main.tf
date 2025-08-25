resource "aci_rest_managed" "netflowVmmExporterPol" {
  dn         = "uni/infra/vmmexporterpol-${var.name}"
  class_name = "netflowVmmExporterPol"
  content = {
    name    = var.name
    descr   = var.description
    dstAddr = var.destination_ip
    dstPort = var.destination_port
    srcAddr = var.source_ip
    ver     = "v9"
  }
}
