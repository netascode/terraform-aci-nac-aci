terraform {
  required_version = ">= 1.3.0"

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

  snmp_trap_policies = ["SNMP1"]
  syslog_policies = [{
    name             = "SYSLOG1"
    audit            = false
    events           = false
    faults           = false
    session          = true
    minimum_severity = "alerts"
  }]
}

data "aci_rest_managed" "snmpSrc" {
  dn = "uni/fabric/moncommon/snmpsrc-SNMP1"

  depends_on = [module.main]
}

resource "test_assertions" "snmpSrc" {
  component = "snmpSrc"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.snmpSrc.content.name
    want        = "SNMP1"
  }
}

data "aci_rest_managed" "snmpRsDestGroup" {
  dn = "${data.aci_rest_managed.snmpSrc.id}/rsdestGroup"

  depends_on = [module.main]
}

resource "test_assertions" "snmpRsDestGroup" {
  component = "snmpRsDestGroup"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.snmpRsDestGroup.content.tDn
    want        = "uni/fabric/snmpgroup-SNMP1"
  }
}

data "aci_rest_managed" "syslogSrc" {
  dn = "uni/fabric/moncommon/slsrc-SYSLOG1"

  depends_on = [module.main]
}

resource "test_assertions" "syslogSrc" {
  component = "syslogSrc"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.syslogSrc.content.name
    want        = "SYSLOG1"
  }

  equal "incl" {
    description = "incl"
    got         = data.aci_rest_managed.syslogSrc.content.incl
    want        = "session"
  }

  equal "minSev" {
    description = "minSev"
    got         = data.aci_rest_managed.syslogSrc.content.minSev
    want        = "alerts"
  }
}

data "aci_rest_managed" "syslogRsDestGroup" {
  dn = "${data.aci_rest_managed.syslogSrc.id}/rsdestGroup"

  depends_on = [module.main]
}

resource "test_assertions" "syslogRsDestGroup" {
  component = "syslogRsDestGroup"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.syslogRsDestGroup.content.tDn
    want        = "uni/fabric/slgroup-SYSLOG1"
  }
}
