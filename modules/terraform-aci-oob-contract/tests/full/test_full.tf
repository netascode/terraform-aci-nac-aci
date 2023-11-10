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

module "main" {
  source = "../.."

  name        = "OOB1"
  alias       = "OOB1-ALIAS"
  description = "My Description"
  scope       = "global"
  subjects = [{
    name        = "SUB1"
    alias       = "SUB1-ALIAS"
    description = "Subject Description"
    filters = [{
      filter = "FILTER1"
    }]
  }]
}

data "aci_rest_managed" "vzOOBBrCP" {
  dn = "uni/tn-mgmt/oobbrc-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "vzOOBBrCP" {
  component = "vzOOBBrCP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vzOOBBrCP.content.name
    want        = module.main.name
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest_managed.vzOOBBrCP.content.nameAlias
    want        = "OOB1-ALIAS"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.vzOOBBrCP.content.descr
    want        = "My Description"
  }

  equal "scope" {
    description = "scope"
    got         = data.aci_rest_managed.vzOOBBrCP.content.scope
    want        = "global"
  }
}

data "aci_rest_managed" "vzSubj" {
  dn = "${data.aci_rest_managed.vzOOBBrCP.id}/subj-SUB1"

  depends_on = [module.main]
}

resource "test_assertions" "vzSubj" {
  component = "vzSubj"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vzSubj.content.name
    want        = "SUB1"
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest_managed.vzSubj.content.nameAlias
    want        = "SUB1-ALIAS"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.vzSubj.content.descr
    want        = "Subject Description"
  }
}

data "aci_rest_managed" "vzRsSubjFiltAtt" {
  dn = "${data.aci_rest_managed.vzSubj.id}/rssubjFiltAtt-FILTER1"

  depends_on = [module.main]
}

resource "test_assertions" "vzRsSubjFiltAtt" {
  component = "vzRsSubjFiltAtt"

  equal "tnVzFilterName" {
    description = "tnVzFilterName"
    got         = data.aci_rest_managed.vzRsSubjFiltAtt.content.tnVzFilterName
    want        = "FILTER1"
  }

  equal "action" {
    description = "action"
    got         = data.aci_rest_managed.vzRsSubjFiltAtt.content.action
    want        = "permit"
  }
}
