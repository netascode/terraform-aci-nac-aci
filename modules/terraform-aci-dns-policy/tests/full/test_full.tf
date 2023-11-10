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

  name          = "DNS1"
  mgmt_epg_type = "oob"
  mgmt_epg_name = "OOB1"
  providers_ = [{
    ip        = "10.1.1.1"
    preferred = true
  }]
  domains = [{
    name    = "cisco.com"
    default = true
  }]
}

data "aci_rest_managed" "dnsProfile" {
  dn = "uni/fabric/dnsp-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "dnsProfile" {
  component = "dnsProfile"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.dnsProfile.content.name
    want        = module.main.name
  }
}

data "aci_rest_managed" "dnsRsProfileToEpg" {
  dn = "${data.aci_rest_managed.dnsProfile.id}/rsProfileToEpg"

  depends_on = [module.main]
}

resource "test_assertions" "dnsRsProfileToEpg" {
  component = "dnsRsProfileToEpg"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.dnsRsProfileToEpg.content.tDn
    want        = "uni/tn-mgmt/mgmtp-default/oob-OOB1"
  }
}

data "aci_rest_managed" "dnsProv" {
  dn = "${data.aci_rest_managed.dnsProfile.id}/prov-[10.1.1.1]"

  depends_on = [module.main]
}

resource "test_assertions" "dnsProv" {
  component = "dnsProv"

  equal "addr" {
    description = "addr"
    got         = data.aci_rest_managed.dnsProv.content.addr
    want        = "10.1.1.1"
  }

  equal "preferred" {
    description = "preferred"
    got         = data.aci_rest_managed.dnsProv.content.preferred
    want        = "yes"
  }
}

data "aci_rest_managed" "dnsDomain" {
  dn = "${data.aci_rest_managed.dnsProfile.id}/dom-cisco.com"

  depends_on = [module.main]
}

resource "test_assertions" "dnsDomain" {
  component = "dnsDomain"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.dnsDomain.content.name
    want        = "cisco.com"
  }

  equal "isDefault" {
    description = "isDefault"
    got         = data.aci_rest_managed.dnsDomain.content.isDefault
    want        = "yes"
  }
}
