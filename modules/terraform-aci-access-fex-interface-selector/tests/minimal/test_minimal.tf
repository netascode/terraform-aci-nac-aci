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

resource "aci_rest_managed" "infraFexP" {
  dn         = "uni/infra/fexprof-FEX101"
  class_name = "infraFexP"
}

module "main" {
  source = "../.."

  interface_profile = aci_rest_managed.infraFexP.content.name
  name              = "1-1"
}

data "aci_rest_managed" "infraHPortS" {
  dn = "uni/infra/fexprof-FEX101/hports-${module.main.name}-typ-range"

  depends_on = [module.main]
}

resource "test_assertions" "infraHPortS" {
  component = "infraHPortS"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.infraHPortS.content.name
    want        = module.main.name
  }
}
