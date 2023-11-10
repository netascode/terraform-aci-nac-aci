resource "aci_rest_managed" "configExportP" {
  dn         = "uni/fabric/configexp-${var.name}"
  class_name = "configExportP"
  content = {
    name     = var.name
    descr    = var.description
    format   = var.format
    snapshot = var.snapshot ? "yes" : "no"
  }
}

resource "aci_rest_managed" "configRsRemotePath" {
  dn         = "${aci_rest_managed.configExportP.dn}/rsRemotePath"
  class_name = "configRsRemotePath"
  content = {
    tnFileRemotePathName = var.remote_location
  }
}

resource "aci_rest_managed" "configRsExportScheduler" {
  dn         = "${aci_rest_managed.configExportP.dn}/rsExportScheduler"
  class_name = "configRsExportScheduler"
  content = {
    tnTrigSchedPName = var.scheduler
  }
}
