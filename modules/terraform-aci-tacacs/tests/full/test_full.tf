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

  hostname_ip         = "1.1.1.1"
  description         = "My Description"
  protocol            = "chap"
  monitoring          = true
  monitoring_username = "USER1"
  monitoring_password = "PASSWORD1"
  key                 = "ABCDEFGH"
  port                = 149
  retries             = 3
  timeout             = 10
  mgmt_epg_type       = "oob"
  mgmt_epg_name       = "OOB1"
}

data "aci_rest_managed" "aaaTacacsPlusProvider" {
  dn = "uni/userext/tacacsext/tacacsplusprovider-1.1.1.1"

  depends_on = [module.main]
}

resource "test_assertions" "aaaTacacsPlusProvider" {
  component = "aaaTacacsPlusProvider"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.aaaTacacsPlusProvider.content.name
    want        = "1.1.1.1"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.aaaTacacsPlusProvider.content.descr
    want        = "My Description"
  }

  equal "authProtocol" {
    description = "authProtocol"
    got         = data.aci_rest_managed.aaaTacacsPlusProvider.content.authProtocol
    want        = "chap"
  }

  equal "monitorServer" {
    description = "monitorServer"
    got         = data.aci_rest_managed.aaaTacacsPlusProvider.content.monitorServer
    want        = "enabled"
  }

  equal "monitoringUser" {
    description = "monitoringUser"
    got         = data.aci_rest_managed.aaaTacacsPlusProvider.content.monitoringUser
    want        = "USER1"
  }

  equal "port" {
    description = "port"
    got         = data.aci_rest_managed.aaaTacacsPlusProvider.content.port
    want        = "149"
  }

  equal "retries" {
    description = "retries"
    got         = data.aci_rest_managed.aaaTacacsPlusProvider.content.retries
    want        = "3"
  }

  equal "timeout" {
    description = "timeout"
    got         = data.aci_rest_managed.aaaTacacsPlusProvider.content.timeout
    want        = "10"
  }
}

data "aci_rest_managed" "aaaRsSecProvToEpg" {
  dn = "${data.aci_rest_managed.aaaTacacsPlusProvider.id}/rsSecProvToEpg"

  depends_on = [module.main]
}

resource "test_assertions" "aaaRsSecProvToEpg" {
  component = "aaaRsSecProvToEpg"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.aaaRsSecProvToEpg.content.tDn
    want        = "uni/tn-mgmt/mgmtp-default/oob-OOB1"
  }
}
