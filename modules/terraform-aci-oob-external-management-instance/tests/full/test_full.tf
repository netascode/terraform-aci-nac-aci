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

  name                   = "INST1"
  subnets                = ["0.0.0.0/0"]
  oob_contract_consumers = ["CON1"]
}

data "aci_rest_managed" "mgmtInstP" {
  dn = "uni/tn-mgmt/extmgmt-default/instp-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "mgmtInstP" {
  component = "mgmtInstP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.mgmtInstP.content.name
    want        = module.main.name
  }
}

data "aci_rest_managed" "mgmtSubnet" {
  dn = "${data.aci_rest_managed.mgmtInstP.id}/subnet-[0.0.0.0/0]"

  depends_on = [module.main]
}

resource "test_assertions" "mgmtSubnet" {
  component = "mgmtSubnet"

  equal "ip" {
    description = "ip"
    got         = data.aci_rest_managed.mgmtSubnet.content.ip
    want        = "0.0.0.0/0"
  }
}

data "aci_rest_managed" "mgmtRsOoBCons" {
  dn = "${data.aci_rest_managed.mgmtInstP.id}/rsooBCons-CON1"

  depends_on = [module.main]
}

resource "test_assertions" "mgmtRsOoBCons" {
  component = "mgmtRsOoBCons"

  equal "tnVzOOBBrCPName" {
    description = "tnVzOOBBrCPName"
    got         = data.aci_rest_managed.mgmtRsOoBCons.content.tnVzOOBBrCPName
    want        = "CON1"
  }
}
