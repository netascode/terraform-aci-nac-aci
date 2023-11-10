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

  name = "VP1"
}

data "aci_rest_managed" "fvnsVlanInstP" {
  dn = "uni/infra/vlanns-[${module.main.name}]-static"

  depends_on = [module.main]
}

resource "test_assertions" "fvnsVlanInstP" {
  component = "fvnsVlanInstP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fvnsVlanInstP.content.name
    want        = module.main.name
  }
}
