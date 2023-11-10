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

  name = "POD1-2"
}

data "aci_rest_managed" "fabricPodP" {
  dn = "uni/fabric/podprof-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "fabricPodP" {
  component = "fabricPodP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fabricPodP.content.name
    want        = module.main.name
  }
}
