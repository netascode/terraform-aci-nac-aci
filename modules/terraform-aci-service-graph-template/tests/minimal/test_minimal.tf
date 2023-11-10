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

resource "aci_rest_managed" "fvTenant" {
  dn         = "uni/tn-TF"
  class_name = "fvTenant"
}

module "main" {
  source = "../.."

  tenant      = aci_rest_managed.fvTenant.content.name
  name        = "SGT1"
  device_name = "DEV1"
}

data "aci_rest_managed" "vnsAbsGraph" {
  dn = "uni/tn-${aci_rest_managed.fvTenant.content.name}/AbsGraph-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "vnsAbsGraph" {
  component = "vnsAbsGraph"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vnsAbsGraph.content.name
    want        = module.main.name
  }
}

data "aci_rest_managed" "vnsRsNodeToLDev" {
  dn = "${data.aci_rest_managed.vnsAbsGraph.id}/AbsNode-N1/rsNodeToLDev"

  depends_on = [module.main]
}

resource "test_assertions" "vnsRsNodeToLDev" {
  component = "vnsRsNodeToLDev"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.vnsRsNodeToLDev.content.tDn
    want        = "uni/tn-TF/lDevVip-DEV1"
  }
}
