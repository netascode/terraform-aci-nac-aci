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

  hostname_ip = "1.1.1.1"
}

data "aci_rest_managed" "aaaTacacsPlusProvider" {
  dn = "uni/userext/tacacsext/tacacsplusprovider-1.1.1.1"

  depends_on = [module.main]
}

resource "test_assertions" "aaaTacacsPlusProvider" {
  component = "aaaTacacsPlusProvider"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.aaaTacacsPlusProvider.content.name
    want        = "1.1.1.1"
  }
}
