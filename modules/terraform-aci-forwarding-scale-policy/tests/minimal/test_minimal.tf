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

  name = "DUAL-STACK"
}

data "aci_rest_managed" "topoctrlFwdScaleProfilePol" {
  dn = "uni/infra/fwdscalepol-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "topoctrlFwdScaleProfilePol" {
  component = "topoctrlFwdScaleProfilePol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.topoctrlFwdScaleProfilePol.content.name
    want        = module.main.name
  }

  equal "profType" {
    description = "profType"
    got         = data.aci_rest_managed.topoctrlFwdScaleProfilePol.content.profType
    want        = "dual-stack"
  }
}
