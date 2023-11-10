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

  name          = "INB1"
  vlan          = 10
  bridge_domain = "INB1"
}

data "aci_rest_managed" "mgmtInB" {
  dn = "uni/tn-mgmt/mgmtp-default/inb-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "mgmtInB" {
  component = "mgmtInB"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.mgmtInB.content.name
    want        = module.main.name
  }

  equal "encap" {
    description = "encap"
    got         = data.aci_rest_managed.mgmtInB.content.encap
    want        = "vlan-10"
  }
}

data "aci_rest_managed" "mgmtRsMgmtBD" {
  dn = "${data.aci_rest_managed.mgmtInB.id}/rsmgmtBD"

  depends_on = [module.main]
}

resource "test_assertions" "mgmtRsMgmtBD" {
  component = "mgmtRsMgmtBD"

  equal "tnFvBDName" {
    description = "tnFvBDName"
    got         = data.aci_rest_managed.mgmtRsMgmtBD.content.tnFvBDName
    want        = "INB1"
  }
}
