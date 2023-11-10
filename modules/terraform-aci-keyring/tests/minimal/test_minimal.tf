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

  name = "KEYRING1"
}

data "aci_rest_managed" "pkiKeyRing" {
  dn = "uni/userext/pkiext/keyring-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "pkiKeyRing" {
  component = "pkiKeyRing"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.pkiKeyRing.content.name
    want        = module.main.name
  }
}
