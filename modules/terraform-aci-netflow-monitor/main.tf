resource "aci_rest_managed" "netflowMonitorPol" {
  dn         = "uni/infra/monitorpol-${var.name}"
  class_name = "netflowMonitorPol"
  content = {
    name  = var.name
    descr = var.description
  }
}

resource "aci_rest_managed" "netflowRsMonitorToRecord" {
  count      = var.flow_record != "" ? 1 : 0
  dn         = "${aci_rest_managed.netflowMonitorPol.dn}/rsmonitorToRecord"
  class_name = "netflowRsMonitorToRecord"
  content = {
    tnNetflowRecordPolName = var.flow_record
  }
}

resource "aci_rest_managed" "netflowRsMonitorToExporter" {
  for_each   = toset(var.flow_exporters)
  dn         = "${aci_rest_managed.netflowMonitorPol.dn}/rsmonitorToExporter-${each.value}"
  class_name = "netflowRsMonitorToExporter"
  content = {
    tnNetflowExporterPolName = each.value
  }
}
