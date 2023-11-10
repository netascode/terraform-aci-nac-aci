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

  name = "LLDP-OFF"
}

data "aci_rest_managed" "lldpIfPol" {
  dn = "uni/infra/lldpIfP-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "lldpIfPol" {
  component = "lldpIfPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.lldpIfPol.content.name
    want        = module.main.name
  }
}
