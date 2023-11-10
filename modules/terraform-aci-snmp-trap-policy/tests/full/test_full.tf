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

  name        = "TRAP1"
  description = "My Description"
  destinations = [{
    hostname_ip   = "1.1.1.1"
    port          = 1162
    community     = "COM1"
    security      = "priv"
    version       = "v3"
    mgmt_epg_type = "oob"
    mgmt_epg_name = "OOB1"
  }]
}

data "aci_rest_managed" "snmpGroup" {
  dn = "uni/fabric/snmpgroup-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "snmpGroup" {
  component = "snmpGroup"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.snmpGroup.content.name
    want        = module.main.name
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.snmpGroup.content.descr
    want        = "My Description"
  }
}

data "aci_rest_managed" "snmpTrapDest" {
  dn = "${data.aci_rest_managed.snmpGroup.id}/trapdest-1.1.1.1-port-1162"

  depends_on = [module.main]
}

resource "test_assertions" "snmpTrapDest" {
  component = "snmpTrapDest"

  equal "host" {
    description = "host"
    got         = data.aci_rest_managed.snmpTrapDest.content.host
    want        = "1.1.1.1"
  }

  equal "port" {
    description = "port"
    got         = data.aci_rest_managed.snmpTrapDest.content.port
    want        = "1162"
  }

  equal "secName" {
    description = "secName"
    got         = data.aci_rest_managed.snmpTrapDest.content.secName
    want        = "COM1"
  }

  equal "v3SecLvl" {
    description = "v3SecLvl"
    got         = data.aci_rest_managed.snmpTrapDest.content.v3SecLvl
    want        = "priv"
  }

  equal "ver" {
    description = "ver"
    got         = data.aci_rest_managed.snmpTrapDest.content.ver
    want        = "v3"
  }
}

data "aci_rest_managed" "fileRsARemoteHostToEpg" {
  dn = "${data.aci_rest_managed.snmpTrapDest.id}/rsARemoteHostToEpg"

  depends_on = [module.main]
}

resource "test_assertions" "fileRsARemoteHostToEpg" {
  component = "fileRsARemoteHostToEpg"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.fileRsARemoteHostToEpg.content.tDn
    want        = "uni/tn-mgmt/mgmtp-default/oob-OOB1"
  }
}
