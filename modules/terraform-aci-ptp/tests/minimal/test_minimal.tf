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

data "aci_rest_managed" "latencyPtpMode" {
  dn = "uni/fabric/ptpmode"

  depends_on = [module.main]
}

resource "test_assertions" "latencyPtpMode" {
  component = "latencyPtpMode"

  equal "state" {
    description = "state"
    got         = data.aci_rest_managed.latencyPtpMode.content.state
    want        = "enabled"
  }
}
