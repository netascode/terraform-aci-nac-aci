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

  mode               = "smart-licensing"
  registration_token = "ABCDEFG"
}

data "aci_rest_managed" "licenseLicPolicy" {
  dn = "uni/fabric/licensepol"

  depends_on = [module.main]
}

resource "test_assertions" "licenseLicPolicy" {
  component = "licenseLicPolicy"

  equal "mode" {
    description = "mode"
    got         = data.aci_rest_managed.licenseLicPolicy.content.mode
    want        = "smart-licensing"
  }
}
