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

  name = "LEAF101"
}

data "aci_rest_managed" "infraNodeP" {
  dn = "uni/infra/nprof-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "infraNodeP" {
  component = "infraNodeP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.infraNodeP.content.name
    want        = module.main.name
  }
}
