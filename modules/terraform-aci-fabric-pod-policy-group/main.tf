resource "aci_rest_managed" "fabricPodPGrp" {
  dn         = "uni/fabric/funcprof/podpgrp-${var.name}"
  class_name = "fabricPodPGrp"
  content = {
    name  = var.name
    descr = var.description
  }
}

resource "aci_rest_managed" "fabricRsSnmpPol" {
  dn         = "${aci_rest_managed.fabricPodPGrp.dn}/rssnmpPol"
  class_name = "fabricRsSnmpPol"
  content = {
    tnSnmpPolName = var.snmp_policy
  }
}

resource "aci_rest_managed" "fabricRsTimePol" {
  dn         = "${aci_rest_managed.fabricPodPGrp.dn}/rsTimePol"
  class_name = "fabricRsTimePol"
  content = {
    tnDatetimePolName = var.date_time_policy
  }
}

resource "aci_rest_managed" "fabricRsCommPol" {
  dn         = "${aci_rest_managed.fabricPodPGrp.dn}/rsCommPol"
  class_name = "fabricRsCommPol"
  content = {
    tnCommPolName = var.management_access_policy
  }
}

resource "aci_rest_managed" "fabricRsPodPGrpBGPRRP" {
  dn         = "${aci_rest_managed.fabricPodPGrp.dn}/rspodPGrpBGPRRP"
  class_name = "fabricRsPodPGrpBGPRRP"
  content = {
    tnBgpInstPolName = var.route_reflector_policy
  }
}

resource "aci_rest_managed" "fabricRsPodPGrpCoopP" {
  dn         = "${aci_rest_managed.fabricPodPGrp.dn}/rspodPGrpCoopP"
  class_name = "fabricRsPodPGrpCoopP"
  content = {
    tnCoopPolName = var.coop_group_policy
  }
}

resource "aci_rest_managed" "fabricRsPodPGrpIsisDomP" {
  dn         = "${aci_rest_managed.fabricPodPGrp.dn}/rspodPGrpIsisDomP"
  class_name = "fabricRsPodPGrpIsisDomP"
  content = {
    tnIsisDomPolName = var.isis_policy
  }
}

resource "aci_rest_managed" "fabricRsMacsecPol" {
  dn         = "${aci_rest_managed.fabricPodPGrp.dn}/rsmacsecPol"
  class_name = "fabricRsMacsecPol"
  content = {
    tnMacsecFabIfPolName = var.macsec_policy
  }
}
