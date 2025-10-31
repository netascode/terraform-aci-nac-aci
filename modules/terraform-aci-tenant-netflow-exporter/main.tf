resource "aci_rest_managed" "netflowExporterPol" {
  dn         = "uni/tn-${var.tenant}/exporterpol-${var.name}"
  class_name = "netflowExporterPol"
  content = {
    name         = var.name
    descr        = var.description
    dscp         = var.dscp
    dstAddr      = var.destination_ip
    dstPort      = var.destination_port
    sourceIpType = var.source_type
    srcAddr      = var.source_ip
    ver          = "v9"
  }
}

resource "aci_rest_managed" "netflowRsExporterToEPg" {
  count      = var.epg_type != "" ? 1 : 0
  dn         = "${aci_rest_managed.netflowExporterPol.dn}/rsexporterToEPg"
  class_name = "netflowRsExporterToEPg"
  content = {
    tDn = var.epg_type == "epg" ? "uni/tn-${var.tenant}/ap-${var.application_profile}/epg-${var.endpoint_group}" : "uni/tn-${var.tenant}/out-${var.l3out}/instP-${var.external_endpoint_group}"

  }
}

resource "aci_rest_managed" "netflowRsExporterToCtx" {
  count      = var.vrf != "" ? 1 : 0
  dn         = "${aci_rest_managed.netflowExporterPol.dn}/rsexporterToCtx"
  class_name = "netflowRsExporterToCtx"
  content = {
    tDn = "uni/tn-${var.tenant}/ctx-${var.vrf}"
  }
}
