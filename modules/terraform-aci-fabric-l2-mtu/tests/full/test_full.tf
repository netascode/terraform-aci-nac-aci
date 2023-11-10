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

  l2_port_mtu = 1500
}

data "aci_rest_managed" "l2InstPol" {
  dn = "uni/fabric/l2pol-default"

  depends_on = [module.main]
}

resource "test_assertions" "l2InstPol" {
  component = "l2InstPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.l2InstPol.content.name
    want        = "default"
  }

  equal "fabricMtu" {
    description = "fabricMtu"
    got         = data.aci_rest_managed.l2InstPol.content.fabricMtu
    want        = "1500"
  }

}
