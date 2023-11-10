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

  name = "DNS1"
}

data "aci_rest_managed" "dnsProfile" {
  dn = "uni/fabric/dnsp-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "dnsProfile" {
  component = "dnsProfile"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.dnsProfile.content.name
    want        = module.main.name
  }
}
