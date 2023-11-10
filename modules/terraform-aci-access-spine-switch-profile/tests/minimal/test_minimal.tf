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

  name = "SPINE1001"
}

data "aci_rest_managed" "infraSpineP" {
  dn = "uni/infra/spprof-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "infraSpineP" {
  component = "infraSpineP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.infraSpineP.content.name
    want        = module.main.name
  }
}
