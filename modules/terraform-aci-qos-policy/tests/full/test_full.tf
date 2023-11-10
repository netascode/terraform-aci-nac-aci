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
  name        = "FULL_POL"
  tenant      = aci_rest_managed.fvTenant.content.name
  description = "My Custom Policy"
  alias       = "MyAlias"
  dscp_priority_maps = [
    {
      dscp_from   = "AF12"
      dscp_to     = "AF13"
      priority    = "level5"
      dscp_target = "CS0"
      cos_target  = 5
    }
  ]
  dot1p_classifiers = [
    {
      dot1p_from  = 3
      dot1p_to    = 4
      priority    = "level5"
      dscp_target = 32
      cos_target  = 5
    }
  ]
}

data "aci_rest_managed" "qosCustomPol" {
  dn = "uni/tn-${aci_rest_managed.fvTenant.content.name}/qoscustom-FULL_POL"

  depends_on = [module.main]
}

resource "test_assertions" "qosCustomPol" {
  component = "qosCustomPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.qosCustomPol.content.name
    want        = "FULL_POL"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.qosCustomPol.content.descr
    want        = "My Custom Policy"
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest_managed.qosCustomPol.content.nameAlias
    want        = "MyAlias"
  }
}


data "aci_rest_managed" "qosDscpClass" {
  dn         = "${data.aci_rest_managed.qosCustomPol.id}/dcsp-AF12-AF13"
  depends_on = [module.main]
}

resource "test_assertions" "qosDscpClass" {
  component = "qosDscpClass"

  equal "from" {
    description = "from"
    got         = data.aci_rest_managed.qosDscpClass.content.from
    want        = "AF12"
  }

  equal "to" {
    description = "to"
    got         = data.aci_rest_managed.qosDscpClass.content.to
    want        = "AF13"
  }

  equal "target" {
    description = "target"
    got         = data.aci_rest_managed.qosDscpClass.content.target
    want        = "CS0"
  }

  equal "targetCos" {
    description = "targetCos"
    got         = data.aci_rest_managed.qosDscpClass.content.targetCos
    want        = "5"
  }

  equal "prio" {
    description = "prio"
    got         = data.aci_rest_managed.qosDscpClass.content.prio
    want        = "level5"
  }
}


data "aci_rest_managed" "qosDot1PClass" {
  dn         = "${data.aci_rest_managed.qosCustomPol.id}/dot1P-3-4"
  depends_on = [module.main]
}

resource "test_assertions" "qosDot1PClass" {
  component = "qosDot1PClass"

  equal "from" {
    description = "from"
    got         = data.aci_rest_managed.qosDot1PClass.content.from
    want        = "3"
  }

  equal "to" {
    description = "to"
    got         = data.aci_rest_managed.qosDot1PClass.content.to
    want        = "4"
  }

  equal "target" {
    description = "target"
    got         = data.aci_rest_managed.qosDot1PClass.content.target
    want        = "CS4"
  }

  equal "targetCos" {
    description = "targetCos"
    got         = data.aci_rest_managed.qosDot1PClass.content.targetCos
    want        = "5"
  }

  equal "prio" {
    description = "prio"
    got         = data.aci_rest_managed.qosDot1PClass.content.prio
    want        = "level5"
  }
}

