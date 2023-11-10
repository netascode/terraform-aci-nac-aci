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

  redistribute_metric = 60
}

data "aci_rest_managed" "isisDomPol" {
  dn = "uni/fabric/isisDomP-default"

  depends_on = [module.main]
}

resource "test_assertions" "isisDomPol" {
  component = "isisDomPol"

  equal "redistribMetric" {
    description = "redistribMetric"
    got         = data.aci_rest_managed.isisDomPol.content.redistribMetric
    want        = "60"
  }
}
