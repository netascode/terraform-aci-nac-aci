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

  name = "SYSLOG1"
}

data "aci_rest_managed" "syslogGroup" {
  dn = "uni/fabric/slgroup-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "syslogGroup" {
  component = "syslogGroup"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.syslogGroup.content.name
    want        = module.main.name
  }
}
