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

  admin_state = true
}

data "aci_rest_managed" "l3IfPol" {
  dn = "uni/fabric/l3IfP-default"

  depends_on = [module.main]
}

resource "test_assertions" "l3IfPol" {
  component = "l3IfPol"

  equal "bfdIsis" {
    description = "bfdIsis"
    got         = data.aci_rest_managed.l3IfPol.content.bfdIsis
    want        = "enabled"
  }
}
