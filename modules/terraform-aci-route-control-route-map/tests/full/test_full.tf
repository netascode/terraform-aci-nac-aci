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

resource "aci_rest_managed" "fvTenant" {
  dn         = "uni/tn-TF"
  class_name = "fvTenant"
}

module "main" {
  source      = "../.."
  name        = "RCRM_FULL"
  description = "My Route Control Route Map"
  tenant      = aci_rest_managed.fvTenant.content.name
  contexts = [
    {
      name        = "CTX1"
      description = "My Context 1"
      action      = "deny"
      order       = 1
      set_rule    = "SET1"
      match_rules = ["MATCH1"]
    }
  ]
}

data "aci_rest_managed" "rtctrlProfile" {
  dn = "uni/tn-${aci_rest_managed.fvTenant.content.name}/prof-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlProfile" {
  component = "rtctrlProfile"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.rtctrlProfile.content.name
    want        = "RCRM_FULL"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.rtctrlProfile.content.descr
    want        = "My Route Control Route Map"
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.rtctrlProfile.content.type
    want        = "combinable"
  }
}

data "aci_rest_managed" "rtctrlCtxP" {
  dn = "${data.aci_rest_managed.rtctrlProfile.id}/ctx-CTX1"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlCtxP" {
  component = "rtctrlCtxP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.rtctrlCtxP.content.name
    want        = "CTX1"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.rtctrlCtxP.content.descr
    want        = "My Context 1"
  }

  equal "action" {
    description = "action"
    got         = data.aci_rest_managed.rtctrlCtxP.content.action
    want        = "deny"
  }

  equal "order" {
    description = "order"
    got         = data.aci_rest_managed.rtctrlCtxP.content.order
    want        = "1"
  }
}

data "aci_rest_managed" "rtctrlScope" {
  dn = "${data.aci_rest_managed.rtctrlCtxP.id}/scp"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlScope" {
  component = "rtctrlScope"

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.rtctrlScope.content.descr
    want        = ""
  }
}

data "aci_rest_managed" "rtctrlRsScopeToAttrP" {
  dn = "${data.aci_rest_managed.rtctrlScope.id}/rsScopeToAttrP"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlRsScopeToAttrP" {
  component = "rtctrlRsScopeToAttrP"

  equal "tnRtctrlAttrPName" {
    description = "tnRtctrlAttrPName"
    got         = data.aci_rest_managed.rtctrlRsScopeToAttrP.content.tnRtctrlAttrPName
    want        = "SET1"
  }
}

data "aci_rest_managed" "rtctrlRsCtxPToSubjP" {
  dn = "${data.aci_rest_managed.rtctrlCtxP.id}/rsctxPToSubjP-MATCH1"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlRsCtxPToSubjP" {
  component = "rtctrlRsCtxPToSubjP"

  equal "tnRtctrlSubjPName" {
    description = "tnRtctrlSubjPName"
    got         = data.aci_rest_managed.rtctrlRsCtxPToSubjP.content.tnRtctrlSubjPName
    want        = "MATCH1"
  }
}