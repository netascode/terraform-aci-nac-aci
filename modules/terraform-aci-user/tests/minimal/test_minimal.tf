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

  username = "USER1"
  password = "PASSWORD1"
}

data "aci_rest_managed" "aaaUser" {
  dn = "uni/userext/user-USER1"

  depends_on = [module.main]
}

resource "test_assertions" "aaaUser" {
  component = "aaaUser"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.aaaUser.content.name
    want        = "USER1"
  }
}
