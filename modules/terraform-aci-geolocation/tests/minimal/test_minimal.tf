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

  name = "SITE1"
}

data "aci_rest_managed" "geoSite" {
  dn = "uni/fabric/site-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "geoSite" {
  component = "geoSite"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.geoSite.content.name
    want        = module.main.name
  }
}
