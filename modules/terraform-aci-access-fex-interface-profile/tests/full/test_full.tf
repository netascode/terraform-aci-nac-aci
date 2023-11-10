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

  name = "FEX1"
}

data "aci_rest_managed" "infraFexP" {
  dn = "uni/infra/fexprof-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "infraFexP" {
  component = "infraFexP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.infraFexP.content.name
    want        = module.main.name
  }
}

data "aci_rest_managed" "infraFexBndlGrp" {
  dn = "${data.aci_rest_managed.infraFexP.id}/fexbundle-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "infraFexBndlGrp" {
  component = "infraFexBndlGrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.infraFexBndlGrp.content.name
    want        = module.main.name
  }
}
