terraform {
  required_version = ">= 1.0.0"

  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "CiscoDevNet/aci"
      version = ">=2.0.0"
    }
  }
}

module "main" {
  source = "../.."

  name                     = "POD1"
  snmp_policy              = "SNMP1"
  date_time_policy         = "DATE1"
  management_access_policy = "MAP1"
}

data "aci_rest_managed" "fabricPodPGrp" {
  dn = "uni/fabric/funcprof/podpgrp-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "fabricPodPGrp" {
  component = "fabricPodPGrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fabricPodPGrp.content.name
    want        = module.main.name
  }
}

data "aci_rest_managed" "fabricRsSnmpPol" {
  dn = "${data.aci_rest_managed.fabricPodPGrp.id}/rssnmpPol"

  depends_on = [module.main]
}

resource "test_assertions" "fabricRsSnmpPol" {
  component = "fabricRsSnmpPol"

  equal "tnSnmpPolName" {
    description = "tnSnmpPolName"
    got         = data.aci_rest_managed.fabricRsSnmpPol.content.tnSnmpPolName
    want        = "SNMP1"
  }
}

data "aci_rest_managed" "fabricRsTimePol" {
  dn = "${data.aci_rest_managed.fabricPodPGrp.id}/rsTimePol"

  depends_on = [module.main]
}

resource "test_assertions" "fabricRsTimePol" {
  component = "fabricRsTimePol"

  equal "tnDatetimePolName" {
    description = "tnDatetimePolName"
    got         = data.aci_rest_managed.fabricRsTimePol.content.tnDatetimePolName
    want        = "DATE1"
  }
}

data "aci_rest_managed" "fabricRsCommPol" {
  dn = "${data.aci_rest_managed.fabricPodPGrp.id}/rsCommPol"

  depends_on = [module.main]
}

resource "test_assertions" "fabricRsCommPol" {
  component = "fabricRsCommPol"

  equal "tnCommPolName" {
    description = "tnCommPolName"
    got         = data.aci_rest_managed.fabricRsCommPol.content.tnCommPolName
    want        = "MAP1"
  }
}
