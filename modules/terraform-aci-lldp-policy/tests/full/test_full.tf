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

  name           = "LLDP-ON"
  admin_rx_state = true
  admin_tx_state = true
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

  equal "adminRxSt" {
    description = "adminRxSt"
    got         = data.aci_rest_managed.lldpIfPol.content.adminRxSt
    want        = "enabled"
  }

  equal "adminTxSt" {
    description = "adminTxSt"
    got         = data.aci_rest_managed.lldpIfPol.content.adminTxSt
    want        = "enabled"
  }
}
