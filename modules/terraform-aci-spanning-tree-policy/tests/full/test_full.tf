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

  name        = "ABC"
  bpdu_filter = true
  bpdu_guard  = true
}

data "aci_rest_managed" "stpIfPol" {
  dn = "uni/infra/ifPol-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "stpIfPol" {
  component = "stpIfPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.stpIfPol.content.name
    want        = module.main.name
  }

  equal "ctrl" {
    description = "ctrl"
    got         = data.aci_rest_managed.stpIfPol.content.ctrl
    want        = "bpdu-filter,bpdu-guard"
  }
}
