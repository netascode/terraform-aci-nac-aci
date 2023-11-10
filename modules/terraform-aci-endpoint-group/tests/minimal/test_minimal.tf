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

resource "aci_rest_managed" "fvTenant" {
  dn         = "uni/tn-TF"
  class_name = "fvTenant"
}

resource "aci_rest_managed" "fvAp" {
  dn         = "${aci_rest_managed.fvTenant.id}/ap-AP1"
  class_name = "fvAp"
}

module "main" {
  source = "../.."

  tenant              = aci_rest_managed.fvTenant.content.name
  application_profile = aci_rest_managed.fvAp.content.name
  name                = "EPG1"
  bridge_domain       = "BD1"
}

data "aci_rest_managed" "fvAEPg" {
  dn = "${aci_rest_managed.fvAp.id}/epg-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "fvAEPg" {
  component = "fvAEPg"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fvAEPg.content.name
    want        = module.main.name
  }
}

data "aci_rest_managed" "fvRsBd" {
  dn = "${data.aci_rest_managed.fvAEPg.id}/rsbd"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsBd" {
  component = "fvRsBd"

  equal "tnFvBDName" {
    description = "tnFvBDName"
    got         = data.aci_rest_managed.fvRsBd.content.tnFvBDName
    want        = "BD1"
  }
}
