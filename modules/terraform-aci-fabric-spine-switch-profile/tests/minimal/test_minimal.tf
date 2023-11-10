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

data "aci_rest_managed" "fabricSpineP" {
  dn = "uni/fabric/spprof-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "fabricSpineP" {
  component = "fabricSpineP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fabricSpineP.content.name
    want        = module.main.name
  }
}
