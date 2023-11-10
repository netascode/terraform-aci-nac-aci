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

  name                   = "OOB1"
  oob_contract_providers = ["OOB-CON1"]
}

data "aci_rest_managed" "mgmtOoB" {
  dn = "uni/tn-mgmt/mgmtp-default/oob-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "mgmtOoB" {
  component = "mgmtOoB"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.mgmtOoB.content.name
    want        = module.main.name
  }
}

data "aci_rest_managed" "mgmtRsOoBProv" {
  dn = "${data.aci_rest_managed.mgmtOoB.id}/rsooBProv-OOB-CON1"

  depends_on = [module.main]
}

resource "test_assertions" "mgmtRsOoBProv" {
  component = "mgmtRsOoBProv"

  equal "tnVzOOBBrCPName" {
    description = "tnVzOOBBrCPName"
    got         = data.aci_rest_managed.mgmtRsOoBProv.content.tnVzOOBBrCPName
    want        = "OOB-CON1"
  }
}
