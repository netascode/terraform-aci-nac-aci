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

  name                        = "INB1"
  vlan                        = 10
  bridge_domain               = "INB1"
  contract_consumers          = ["CON1"]
  contract_providers          = ["CON1"]
  contract_imported_consumers = ["I_CON1"]
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

data "aci_rest_managed" "fvRsProv" {
  dn = "${data.aci_rest_managed.mgmtInB.id}/rsprov-CON1"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsProv" {
  component = "fvRsProv"

  equal "tnVzBrCPName" {
    description = "tnVzBrCPName"
    got         = data.aci_rest_managed.fvRsProv.content.tnVzBrCPName
    want        = "CON1"
  }
}

data "aci_rest_managed" "fvRsCons" {
  dn = "${data.aci_rest_managed.mgmtInB.id}/rscons-CON1"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsCons" {
  component = "fvRsCons"

  equal "tnVzBrCPName" {
    description = "tnVzBrCPName"
    got         = data.aci_rest_managed.fvRsCons.content.tnVzBrCPName
    want        = "CON1"
  }
}

data "aci_rest_managed" "fvRsConsIf" {
  dn = "${data.aci_rest_managed.mgmtInB.id}/rsconsIf-I_CON1"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsConsIf" {
  component = "fvRsConsIf"

  equal "tnVzCPIfName" {
    description = "tnVzCPIfName"
    got         = data.aci_rest_managed.fvRsConsIf.content.tnVzCPIfName
    want        = "I_CON1"
  }
}
