resource "aci_rest_managed" "fabricPodPGrp" {
  dn         = "uni/fabric/funcprof/podpgrp-${var.name}"
  class_name = "fabricPodPGrp"
  content = {
    name = var.name
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
